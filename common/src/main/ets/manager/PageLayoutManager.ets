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

import configPolicy from '@ohos.configPolicy';
import fs from '@ohos.file.fs';
import { display } from '@kit.ArkUI';
import Window from '@ohos.window';
import { LogUtil } from '../util/LogUtil';
import { PageLayoutModel } from '../model/PageLayoutModel';
import { CommonUtils } from '../util/CommonUtils';
import { WindowManager } from './WindowManager';
import { Orientation } from '../constant/Orientation';

const TAG: string = 'PageLayoutManager';

/**
 * 页面边距配置管理类
 */
export class PageLayoutManager {
  private pageLayoutConfig: PageLayoutModel = new PageLayoutModel();
  private allPageConfig: Record<string, PageLayoutModel> = {};
  private static instance?: PageLayoutManager;
  private ccmConfigFilePath: string = 'etc/oobe/page_layout_config.json';
  private hasCcmConfig: boolean = false;

  private constructor() {
  }

  /**
   * 单例
   *
   * @returns instance
   */
  static getInstance(): PageLayoutManager {
    if (!PageLayoutManager.instance) {
      PageLayoutManager.instance = new PageLayoutManager();
    }
    return PageLayoutManager.instance;
  }

  /**
   * 初始化页面边距配置参数
   */
  public async initPageLayoutConfig(): Promise<void> {
    try {
      const filePath: string = configPolicy.getOneCfgFileSync(this.ccmConfigFilePath);
      let configStr = fs.readTextSync(filePath);
      LogUtil.info(TAG, `load page layout configStr:${configStr}`);
      if (configStr) {
        this.allPageConfig = JSON.parse(configStr);
        this.hasCcmConfig = true;
        this.updateByStatusChanged();
      } else {
        LogUtil.info(TAG, 'ccmConfigs is empty');
      }
    } catch (e) {
      LogUtil.error(TAG, 'Ccm page layout config load error.');
      this.pageLayoutConfig = new PageLayoutModel();
    }
  }

  /**
   * 获取页面边距配置参数
   *
   * @returns 页面边距配置参数
   */
  public getPageLayoutConfig(): PageLayoutModel {
    return this.pageLayoutConfig;
  }

  /**
   * 设置页面边距参数
   *
   * @param status 屏幕状态
   */
  public setPageLayoutConfig(status?: PageStatus): void {
    if (status) {
      this.pageLayoutConfig = CommonUtils.assign(this.pageLayoutConfig, this.allPageConfig[status]);
    } else {
      this.pageLayoutConfig = CommonUtils.assign(this.pageLayoutConfig, this.allPageConfig);
    }
    LogUtil.info(TAG,
      `btnWidth: ${this.pageLayoutConfig.btnWidth}, agreeBtnMarginBottom: ${this.pageLayoutConfig.agreeBtnMarginBottom}`);
  }

  /**
   * 设置不同状态配置参数
   */
  public updateByStatusChanged(): void {
    if (!this.hasCcmConfig) {
      LogUtil.warn(TAG, 'there is no CCM configuration, no changes are required.');
      return;
    }
    let isFolded: boolean = false;
    try {
      isFolded = display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_FOLDED;
    } catch (error) {
      LogUtil.error(TAG, `getFoldStatus error: ${error?.code}, ${error?.message}`);
    }
    AppStorage.setOrCreate('isFolded', isFolded);
    if (isFolded && CommonUtils.hasKey(this.allPageConfig, PageStatus.FOLD)) {
      this.setPageLayoutConfig(PageStatus.FOLD);
      return;
    }
    CommonUtils.hasKey(this.allPageConfig, PageStatus.STRAIGHT) ? this.setPageLayoutConfig(PageStatus.STRAIGHT) :
      this.setPageLayoutConfig();
  }

  /**
   * 根据ccm参数配置屏幕横竖屏旋转
   */
  public setOrientationByChange(): void {
    let orientation: Window.Orientation = Window.Orientation.PORTRAIT;
    if (this.pageLayoutConfig.screenState === Orientation.LANDSCAPE) {
      orientation = Window.Orientation.LANDSCAPE;
    } else if (this.pageLayoutConfig.screenState === Orientation.AUTO_ROTATION) {
      orientation = Window.Orientation.AUTO_ROTATION;
    }
    WindowManager.setWindowOrientation((AppStorage.get<Window.WindowStage>('windowStage') as Window.WindowStage),
      orientation);
    LogUtil.info(TAG, `orientation set to ${orientation}`);
  }
}

/**
 * 屏幕状态枚举
 */
export enum PageStatus {
  /**
   * 直屏状态
   */
  STRAIGHT = 'straight',

  /**
   * 折叠状态
   */
  FOLD = 'fold',

  /**
   * 横屏
   */
  LANDSCAPE = 'landscape',


  /**
   * 竖屏
   */
  PORTRAIT = 'portrait',
}

export const pageLayoutManager = PageLayoutManager.getInstance();