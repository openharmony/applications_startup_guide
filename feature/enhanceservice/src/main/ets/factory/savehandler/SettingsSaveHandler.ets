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

import settings from '@ohos.settings';
import { CommonConstant, LogUtil, SettingUtil } from '@ohos/hwstartupguide.common';
import { EnhanceServiceUtil } from '../../util/EnhanceServiceUtil';
import { EnhanceServiceConstant } from './EnhanceServiceConstant';
import { ISaveDataHandler } from './ISaveDataHandler';

const TAG: string = 'SettingsSaveHandler';

/**
 * settings数据存储处理器
 */
export class SettingsSaveHandler implements ISaveDataHandler {
  private static instance?: SettingsSaveHandler;
  /**
   * 构造函数
   */
  private constructor() {
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  public static getInstance(): SettingsSaveHandler {
    if (!SettingsSaveHandler.instance) {
      SettingsSaveHandler.instance = new SettingsSaveHandler();
    }
    return SettingsSaveHandler.instance;
  }

  /**
   * 存储数据
   * @param context 上下文
   * @param saveRuleStr 存储规则字串
   * @param checkStatus 勾选状态
   */
  saveData(context: Context, saveRuleStr: string, checkStatus: boolean): void {
    LogUtil.info(TAG, 'saveData');
    if (context === null) {
      LogUtil.error(TAG, 'saveData failed. context is null');
      return;
    }
    if (saveRuleStr === null || !saveRuleStr.startsWith(EnhanceServiceConstant.PREFIX)) {
      LogUtil.error(TAG, `saveData failed. saveRuleStr is invalid. saveRuleStr:${saveRuleStr}`);
      return;
    }
    const tableNameAndKey: [string, string] = EnhanceServiceUtil.getTableNameAndKey(saveRuleStr);
    let valueStr: string = checkStatus ? CommonConstant.STATUS_ON : CommonConstant.STATUS_OFF;
    SettingUtil.setValueSyncWithContextForService(context, tableNameAndKey[1], valueStr, tableNameAndKey[0]);
  }

  /**
   * 获取数据
   * @param context 上下文
   * @param queryRuleStr 查询规则字串
   */
  getData(context: Context, queryRuleStr: string): string | null {
    LogUtil.info(TAG, 'getData');
    if (context === null) {
      LogUtil.error(TAG, 'getData failed. context is null');
      return null;
    }
    if (queryRuleStr === null || !queryRuleStr.startsWith(EnhanceServiceConstant.PREFIX)) {
      LogUtil.error(TAG, `getData failed. queryRuleStr is invalid. queryRuleStr:${queryRuleStr}}`);
      return null;
    }
    let queryKey = queryRuleStr.replace(EnhanceServiceConstant.PREFIX, '');
    return SettingUtil.getValueSync(queryKey, CommonConstant.STATUS_OFF, settings.domainName.USER_SECURITY);
  }
}
