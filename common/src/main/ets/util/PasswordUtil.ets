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

import userAuth from '@ohos.userIAM.userAuth';
import { DeviceUtil } from './BaseUtils';
import { LogUtil } from './LogUtil';

const TAG = 'PasswordUtil';

const NOT_ENROLLED = 12500010;

/**
 * 工具类（密码相关）
 *
 * @since 2023-11-10
 */
export class PasswordUtil {

  /**
   * 调用用户认证接口 api 判断PIN是否有效
   *
   * @returns true--已录入密码，false--其他
   */
  static isPinAvailable(): boolean {
    try {
      userAuth.getAvailableStatus(userAuth.UserAuthType.PIN, userAuth.AuthTrustLevel.ATL1);
      LogUtil.info(TAG, 'current auth success');
      return true;
    } catch (error) {
      LogUtil.error(TAG, `current auth trust level is not supported`, error);
      return false;
    }
  }

  /**
   * 手机是否展示设备保护页
   *
   * @returns true-显示设备保护页 (支持密码或者人脸录入), false-显示设备保护页 (不支持密码和人脸录入)
   */
  static isDeviceProtectionPageShow(): boolean {
    return PasswordUtil.getAuthStatus(userAuth.UserAuthType.FACE) ||
    PasswordUtil.getAuthStatus(userAuth.UserAuthType.FINGERPRINT) ||
      (DeviceUtil.isDevicePc() ? false : PasswordUtil.getAuthStatus(userAuth.UserAuthType.PIN));
  }


  /**
   * PC是否展示设备保护页
   *
   * @returns true-显示设备保护页, false-不显示设备保护页
   */
  static isPCDeviceProtectionPageShow(): boolean {
    return PasswordUtil.isPinAvailable() && (PasswordUtil.getAuthStatus(userAuth.UserAuthType.FACE) ||
    PasswordUtil.getAuthStatus(userAuth.UserAuthType.FINGERPRINT) ||
    PasswordUtil.getAuthStatus(userAuth.UserAuthType.PIN));
  }


  /**
   * 获取认证支持状态
   *
   * @param type 认证类型
   * @returns
   */
  static getAuthStatus(type: userAuth.UserAuthType): boolean {
    try {
      userAuth.getAvailableStatus(type, userAuth.AuthTrustLevel.ATL1);
      LogUtil.info(TAG, `getAuthStatus auth ${type} success`);
      return true;
    } catch (error) {
      LogUtil.error(TAG, `The type of credential ${type} error = ${error.code}  ${error.message}`);
      if (error.code === NOT_ENROLLED) {
        return true;
      }
    }
    return false;
  }
}