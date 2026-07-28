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
import account_osAccount from '@ohos.account.osAccount';
import { LogUtil } from './LogUtil';
import { StringUtil } from './StringUtil';

const TAG: string = 'AccountUtil';
const DEFAULT_USER_ID: number = 100;
/**
 * 账号工具类
 *
 * @since 2023-04-06
 */
export class AccountUtil {
  /**
   * 判断当前用户账号是否是企业账号
   */
  public static hasEnterpriseAccount(): Promise<boolean> {
    LogUtil.info(TAG, 'getCurrentOsAccount start');
    return new Promise((resolve, reject) => {
      try {
        let accountManager = account_osAccount.getAccountManager();
        accountManager.getCurrentOsAccount((err, curAccountInfo) => {
          if (err) {
            LogUtil.error(TAG, `getCurrentOsAccount err:${err.message} ${err.code}`);
            reject(err);
            return;
          }
          LogUtil.debug(TAG, `accountId:${curAccountInfo?.domainInfo?.accountId}, domain:${curAccountInfo?.domainInfo?.domain}`);
          LogUtil.info(TAG, 'getCurrentOsAccount success');
          if (StringUtil.isNotEmpty(curAccountInfo?.domainInfo?.domain) &&
          StringUtil.isNotEmpty(curAccountInfo?.domainInfo?.accountId)) {
            resolve(true);
          } else {
            resolve(false);
          }
        });
      } catch (e) {
        LogUtil.error(TAG, `getCurrentOsAccount exception:${e?.code} ${e?.message}`);
        reject(e);
      }
    });
  }

  public static async getInitUserId(): Promise<number> {
    let accountManager: account_osAccount.AccountManager = account_osAccount.getAccountManager();
    if (accountManager === null) {
      LogUtil.error(TAG, 'getAccountManager fail');
      return DEFAULT_USER_ID;
    }
    try {
      return await accountManager.getOsAccountLocalId();
    } catch (err) {
      LogUtil.error(TAG, `getOsAccountLocalId exception: ${err?.message}`);
    }
    return DEFAULT_USER_ID;
  }

  public static async getForegroundUserId(): Promise<number> {
    let accountManager: account_osAccount.AccountManager = account_osAccount.getAccountManager();
    if (accountManager === null) {
      LogUtil.error(TAG, 'getAccountManager fail');
      return DEFAULT_USER_ID;
    }
    try {
      return await accountManager.getForegroundOsAccountLocalId();
    } catch (err) {
      LogUtil.info(TAG, `getForegroundOsAccountLocalId exception: ${err?.message}`);
    }
    return DEFAULT_USER_ID;
  }
}
