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

import { LogUtil, StringUtil } from '@ohos/hwstartupguide.common';
import { EnhanceServiceConstant } from './savehandler/EnhanceServiceConstant';
import { ISaveDataHandler } from './savehandler/ISaveDataHandler';
import { SettingsSaveHandler } from './savehandler/SettingsSaveHandler';

const TAG: string = 'SaveDataFactory';

/**
 * 增强服务数据存储工厂
 */
export class SaveDataFactory {
  /**
   * 根据存储规则获取处理器
   * @param saveRuleStr 存储规则字串
   */
  public static getHandler(saveRuleStr: string | undefined): ISaveDataHandler | null {
    LogUtil.info(TAG, 'getHandler');
    if (StringUtil.isEmpty(saveRuleStr)) {
      LogUtil.error(TAG, 'getHandler error. saveRuleStr is empty');
      return null;
    }
    if (saveRuleStr?.startsWith(EnhanceServiceConstant.PREFIX)) {
      return SettingsSaveHandler.getInstance();
    }
    LogUtil.error(TAG, `getHandler error. do not support. saveRuleStr:${saveRuleStr}`);
    return null;
  }
}
