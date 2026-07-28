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

import systemParameterEnhance from '@ohos.systemParameterEnhance';
import systemParameter from '@ohos.systemparameter';
import { LogUtil } from './LogUtil';

const TAG: string = 'SystemParameterUtil';

/**
 * 系统参数工具类
 */
export class SystemParameterUtil {
  /**
   * 获取系统参数
   */
  public static getSync(key: string, def: string = ''): string {
    let value: string = def;
    try {
      value = systemParameterEnhance.getSync(key, def);
      LogUtil.info(TAG, `systemParameterEnhance getSync key: ${key} value: ${value}`);
    } catch (err) {
      LogUtil.error(TAG, `systemParameterEnhance getSync key: ${key} error: ${err?.code}, ${err?.message}`);
    }
    return value;
  }

  /**
   * 异步设置系统参数
   *
   * @param key 系统参数key
   * @param value 系统参数value
   */
  public static setAsync(key: string, value: string): void {
    try {
      systemParameterEnhance.set(key, value).catch((error) => {
        LogUtil.error(TAG, `systemParameterEnhance getSync key: ${key} error: ${error?.code}, ${error?.message}`);
      });
      LogUtil.info(TAG, `systemParameterEnhance setSync key: ${key} value: ${value}`);
    } catch (err) {
      LogUtil.error(TAG, `systemParameterEnhance getSync key: ${key} error: ${err?.code}, ${err?.message}`);
    }
  }
}

