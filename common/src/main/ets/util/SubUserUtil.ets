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

import account_osAccount from '@ohos.account.osAccount';
import { BusinessError } from '@ohos.base';
import { SceneTypeManager } from '../manager/SceneTypeManager';
import { LogUtil } from './LogUtil';

const TAG: string = 'SubUserUtil';

/**
 * 子用户场景相关工具类
 */
export class SubUserUtil {

  /**
   * 获取当前进程所属的系统帐号信息
   */
  public static async getCurrentAccountInfo(): Promise<account_osAccount.OsAccountInfo> {
    let accountManager = account_osAccount.getAccountManager();
    let accountInfo = await accountManager.getCurrentOsAccount();
    LogUtil.info(TAG, `getCurrentOsAccount, accountInfo: ${accountInfo?.localName}`);
    return accountInfo;
  }

  /**
   * 删除用户
   *
   * @param localId 用户localId
   */
  public static async removeAccount(localId: number) {
    LogUtil.info(TAG, `Remove system account, localId: ${localId}`);
    account_osAccount.getAccountManager().removeOsAccount(localId, (err: BusinessError) => {
      if (err) {
        LogUtil.error(TAG, `removeOsAccount failed, errMsg: ${err.code} ${err.message}`);
      } else {
        LogUtil.info(TAG, 'removeOsAccount successfully');
      }
    });
  }
}