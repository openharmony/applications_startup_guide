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
import { BusinessError } from '@ohos.base';
import fs from '@ohos.file.fs';
import { LogUtil } from './LogUtil';
import { PageConfig } from '../model/config/PageConfig';
import { RawFileUtil } from './RawFileUtil';
import { ArrayUtil } from './ArrayUtil';

/**
 * 配置解析工具类
 *
 * @since 2023-04-06
 */

export class ConfigParseUtil {
  private static tag: string = 'ConfigParseUtil';
  private static ccmPage: string = 'etc/oobe/oobe_page.json';
  private static localPage: string = 'page_configs.json';
  private static ccmTempPage: string = 'oobe_page.json';

  /**
   * 读取页面配置项
   */
  public static async parseLocalPageConfigs(configs: Map<string, PageConfig>): Promise<Map<string, PageConfig>> {
    LogUtil.info(ConfigParseUtil.tag, 'start to parseLocalPageConfigs');
    return new Promise((resolve, reject) => {
      RawFileUtil.getStringByFile(ConfigParseUtil.localPage).then((content: string) => {
        let jsonArray: Object[] = JSON.parse(content);
        for (let jsonObj of jsonArray) {
          let config: PageConfig = new PageConfig(jsonObj);
          LogUtil.info(ConfigParseUtil.tag, `jsonArray:${config?.getKey()}`);
          configs.set(config.getKey(), config);
        }
        ArrayUtil.sortPageConfigs(configs);
        LogUtil.info(ConfigParseUtil.tag, `parseLocalPageConfigs size:${configs.size}`);
        resolve(configs);
      })
        .catch((err: BusinessError) => {
          LogUtil.error(ConfigParseUtil.tag, `parseLocalPageConfigs exception:${err?.message}`);
          reject(err);
        });
    });
  }

  /**
   * 读取CCM配置
   */
  public static async loadCcmConfigs(): Promise<Map<string, PageConfig>> {
    LogUtil.info(ConfigParseUtil.tag, 'loadCcmConfigs start');
    let configs: Map<string, PageConfig> = new Map<string, PageConfig>();
    try {
      let filePath: string = await configPolicy.getOneCfgFile(ConfigParseUtil.ccmPage);
      let configStr = fs.readTextSync(filePath);
      LogUtil.debug(ConfigParseUtil.tag, `configStr:${configStr}`);
      if (configStr) {
        let jsonArray: Object[] = JSON.parse(configStr);
        LogUtil.info(ConfigParseUtil.tag, `jsonArray:${jsonArray}`);
        for (let jsonObj of jsonArray) {
          let config: PageConfig = new PageConfig(jsonObj);
          configs.set(config.getKey(), config);
        }
      } else {
        LogUtil.info(ConfigParseUtil.tag, 'ccmConfigs is empty');
      }
      LogUtil.info(ConfigParseUtil.tag, `loadCcmConfigs:,size:${configs.size}`);
    } catch (e) {
      LogUtil.error(ConfigParseUtil.tag, `loadCcmConfigs exception:${e?.code}  ${e?.message}`);
      return configs;
    }
    LogUtil.info(ConfigParseUtil.tag, 'loadCcmConfigs end');
    return configs;
  }

  /**
   * 读取页面配置项
   */
  public static async parseCcmConfigsTemp(): Promise<Map<string, PageConfig>> {
    LogUtil.info(ConfigParseUtil.tag, 'start to parseCcmConfigsTemp');
    return new Promise((resolve, reject) => {
      RawFileUtil.getStringByFile(ConfigParseUtil.ccmTempPage).then((content: string) => {
        let jsonArray: Object[] = JSON.parse(content);
        LogUtil.info(ConfigParseUtil.tag, `content:${content}`);
        let configs: Map<string, PageConfig> = new Map<string, PageConfig>();
        for (let jsonObj of jsonArray) {
          let config: PageConfig = new PageConfig(jsonObj);
          configs.set(config.getKey(), config);
        }
        LogUtil.info(ConfigParseUtil.tag, `parseCcmConfigsTemp size:${configs.size}`);
        resolve(configs);
      })
        .catch((err: BusinessError) => {
          LogUtil.error(ConfigParseUtil.tag, `parseCcmConfigsTemp exception:${err?.message}`);
          reject(err);
        });
    });
  }
}
