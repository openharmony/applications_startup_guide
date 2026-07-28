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

import {
  CommonConstant,
  LogUtil,
  ServiceEntity,
  SharePreferences,
  EMPTY_IDENTIFY
} from '@ohos/hwstartupguide.common';

const TAG: string = 'ServiceChangeUtil: ';

export class ServiceStatementUtil {
  // 对比是否存储了版本信息、版本信息是否不匹配
  public static async getVersionFromSP(serviceEntity: ServiceEntity | null): Promise<string | null> {
    if (serviceEntity === null) {
      LogUtil.error(TAG, `getVersionFromSP error, serviceEntity is null`);
      return null;
    }

    let key = `${serviceEntity.getServiceName()}${CommonConstant.VERSION_SUFFIX}`;
    let value = await SharePreferences.getInstance().getValue(key, EMPTY_IDENTIFY);
    if (value.toString() === EMPTY_IDENTIFY) {
      LogUtil.error(TAG, `getVersionFromSP, ${key} is not existed`);
      return null;
    }
    LogUtil.info(TAG, `getVersionFromSP, service key: ${key}, version:${value}`);
    return value.toString();
  }

  // 更新底层版本信息，
  public static updateVersionToSP(serviceEntity: ServiceEntity | null, context?: Context): void {
    if (serviceEntity === null) {
      LogUtil.error(TAG, `saveVersionToSP error, serviceEntity is null`);
      return;
    }
    let key = `${serviceEntity.getServiceName()}${CommonConstant.VERSION_SUFFIX}`;
    SharePreferences.getInstance().setValue(key, serviceEntity.getVersion(), context).then(() => {
      LogUtil.info(TAG, `saveVersionToSP. service key: ${key}, version:${serviceEntity.getVersion()}`);
    });
  }
}
