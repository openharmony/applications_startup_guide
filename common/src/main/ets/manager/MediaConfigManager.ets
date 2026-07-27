/*
 * Copyright (c) Huawei Device Co., Ltd. 2026. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/* instrument ignore file */

import configPolicy from '@ohos.configPolicy';
import fs from '@ohos.file.fs';
import { LogUtil } from '../util/LogUtil';
import { RawFileUtil } from '../util/RawFileUtil';

const TAG: string = 'MediaConfigManager';

export class MediaConfigConstants {
  // 背景
  public static readonly BACKGROUND: string = 'background';
  // 横屏
  public static readonly LANDSCAPE_SCREEN: string = 'landscapeScreen';
  // 竖屏
  public static readonly PORTRAIT_SCREEN: string = 'portraitScreen';
  // 进入桌面
  public static readonly ENTER_HOME: string = 'enterHome';
  // 欢迎页背景第一段
  public static readonly FIRST_WELCOME_ONE : string = 'firstWelcomeOne'
  // 欢迎页背景第二段
  public static readonly FIRST_WELCOME_TWO : string = 'firstWelcomeTwo'
}

class MediaConfig {
  public static readonly RAWFILE_TYPE = 'rawfile';
  public static readonly CCM_TYPE = 'ccm';
  private mediaType: string;
  private mediaPath: string;

  constructor(mediaType: string, mediaPath: string) {
    this.mediaType = mediaType;
    this.mediaPath = mediaPath;
  }

  getMediaResource(): Resource | string {
    if (this.mediaType === MediaConfig.RAWFILE_TYPE) {
      return $rawfile(this.mediaPath);
    }
    return this.mediaPath;
  }
}
/**
 * 媒体资源管理
 */
export class MediaConfigManager {
  private static instance: MediaConfigManager;
  // 配置文件读取的数据
  private mediaConfigData: Map<string, MediaConfig> = new Map<string, MediaConfig>();
  // 本地配置文件路径
  private localConfigFilePath: string = 'media_configs.json';
  // ccm配置文件路径
  private ccmConfigFilePath: string = 'resource/hwstartupguide/media_configs.json';
  // cmm配置媒体数据的文件夹
  private ccmConfigFileDir: string = 'resource/hwstartupguide/';

  private constructor() {
  }

  static getInstance(): MediaConfigManager {
    if (!MediaConfigManager.instance) {
      MediaConfigManager.instance = new MediaConfigManager();
    }
    return MediaConfigManager.instance;
  }
  /**
   * 根据key获取相应的资源路径
   * @param mainKey 主key
   * @param subKey 副key
   * @returns 资源
   */
  public getMediaResource(mainKey: string, subKey: string): Resource | string {
    let mediaResource: Resource | string = '';
    const mKey = this.mergeKey(mainKey, subKey);
    if (this.mediaConfigData.has(mKey)) {
      mediaResource = this.mediaConfigData.get(mKey)?.getMediaResource() ?? '';
    }
    return mediaResource;
  }
  /**
   * 合并主副key
   */
  private mergeKey(mainKey: string, subKey: string): string {
    return `${mainKey}${subKey}`;
  }

  private addMediaConfig(data: object, mediaType: string) {
    Object.entries(data).forEach((mainKeyValue: [string, object]) => {
      const mainKey = mainKeyValue[0];
      Object.entries(mainKeyValue[1]).forEach((subKeyValue: [string, string]) => {
        const subKey = subKeyValue[0];
        let mediaPath = subKeyValue[1];
        const mKey = this.mergeKey(mainKey, subKey);
        if (mediaType === MediaConfig.RAWFILE_TYPE && this.mediaConfigData.has(mKey)) {
          LogUtil.info(TAG, `key: ${mKey}, mediaPath already exist.`);
          return;
        }
        if (mediaType === MediaConfig.CCM_TYPE) {
          mediaPath = `${this.ccmConfigFileDir}${mediaPath}`;
          if (!fs.accessSync(mediaPath)) {
            LogUtil.info(TAG, `key: ${mKey}, mediaPath does not exist.`);
            return;
          }
          mediaPath = 'file://' + mediaPath;
        }
        const mediaConfig = new MediaConfig(mediaType, mediaPath);
        this.mediaConfigData.set(mKey, mediaConfig);
        LogUtil.info(TAG, `key: ${mKey}, mediaType: ${mediaType}`);
      })
    });
  }

  private loadCcmMediaConfig() {
    try {
      const filePath = configPolicy.getOneCfgFileSync(this.ccmConfigFilePath);
      if (filePath) {
        this.ccmConfigFileDir = configPolicy.getOneCfgFileSync(this.ccmConfigFileDir);
        const dataStr = fs.readTextSync(filePath);
        const mediaConfigData: object = JSON.parse(dataStr);
        this.addMediaConfig(mediaConfigData, MediaConfig.CCM_TYPE);
      }
    } catch (e) {
      LogUtil.error(TAG, 'Ccm media config load error.');
    }
  }
  /**
   * 初始化配置
   */
  async initMediaConfig(): Promise<void> {

    return new Promise((resolve, reject) => {
      // 加载ccm媒体配置
      this.loadCcmMediaConfig();
      RawFileUtil.getStringByFile(this.localConfigFilePath).then((content: string) => {
        const mediaConfigData: object = JSON.parse(content);
        this.addMediaConfig(mediaConfigData, MediaConfig.RAWFILE_TYPE);
        LogUtil.info(TAG, 'Media configuration initialized successfully.');
        resolve();
      }).catch(()=>{
        LogUtil.error(TAG, 'Failed to parse the media configuration JSON file.');
        reject();
      });
    });
  }
}

export const mediaConfigManager = MediaConfigManager.getInstance();