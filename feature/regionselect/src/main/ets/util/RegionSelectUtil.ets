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

import { BusinessError } from '@ohos.base';
import {
  CommonConstant,
  HiSysEventUtil,
  LogUtil,
  SettingUtil,
  SharePreferences
} from '@ohos/hwstartupguide.common';

const TAG: string = 'RegionSelectUtil';
const SELECT_REGION_STATE: string = 'select_region_state';

/**
 * 基础服务声明工具类
 */
export class RegionSelectUtil {
  /**
   * 存储选择地区(存储到Preferences中)
   * @param context context
   * @param region 选择的地区
   */
  public static saveSelectRegionToSP(context: Context | null, region: string): void {
    if (context === null) {
      LogUtil.error(TAG, 'saveSelectRegionToSP error. context is null.');
      return;
    }
    SharePreferences.getInstance()
      .setValue(SELECT_REGION_STATE, region)
      .catch((err: BusinessError) => {
        HiSysEventUtil.reportErrorEvent(CommonConstant.BS_OPERATION_FAILED,
          `preference set value err. errMsg: ${err.code}  ${err.message}`);
      });
    LogUtil.info(TAG, `save selectRegion:${region} to SharePreferences.`);
  }

  /**
   * 读取选择地区状态（Preferences存储）
   * @param context context
   */
  public static async readSelectRegionFromSP(context: Context | null): Promise<string> {
    if (context === null) {
      LogUtil.error(TAG, 'saveSelectRegionToSP error. context is null.');
      HiSysEventUtil.reportErrorEvent(CommonConstant.REGION_SELECT_OPERATION_FAILED,
        'preference get value err: context is null.');
      return '';
    }
    let value = await SharePreferences.getInstance()
      .getValue(SELECT_REGION_STATE, '')
      .catch((err: BusinessError) => {
        HiSysEventUtil.reportErrorEvent(CommonConstant.REGION_SELECT_OPERATION_FAILED,
          `preference get value err. errMsg: ${err.code}  ${err.message}`);
      });
    LogUtil.info(TAG, `readSelectRegionFromSP. value:${value}`);
    return value as string;
  }

  /**
   * 判断地区选择是否存在（Preferences存储）
   * @param context context
   */
  public static async isHasSelectRegionFromSP(context: Context | null): Promise<boolean> {
    if (context === null) {
      LogUtil.error(TAG, 'isHasAgreedFromSP error. context is null.');
      HiSysEventUtil.reportErrorEvent(CommonConstant.REGION_SELECT_OPERATION_FAILED,
        'preference is has agree value  err: context is null.');
      return false;
    }
    let value: boolean = await SharePreferences.getInstance()
      .hasValue(SELECT_REGION_STATE);
    LogUtil.info(TAG, `isHasAgreedFromSP. value:${value}`);
    return value === true;
  }

  /**
   * 存储选择地区（存储到Settings表中）
   * @param region 选择的地区
   */
  public static saveSelectRegionToSetting(region: string): void {
    SettingUtil.setValueSync(SELECT_REGION_STATE, region);
  }

  /**
   * 读取选择地区状态（Settings存储）
   */
  public static readSelectRegionFromSettings(): string {
    let region: string = SettingUtil.getValueSync(SELECT_REGION_STATE, '');
    return region;
  }

  /**
   * 判断地区选择是否存在（Settings存储）
   */
  public static isAgreedFromSettings(): boolean {
    let isAgreed = SettingUtil.getValueSync(SELECT_REGION_STATE, '');
    return isAgreed !=='';
  }
}
