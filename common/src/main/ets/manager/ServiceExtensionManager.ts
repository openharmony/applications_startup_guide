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

import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { LogUtil } from '../util/LogUtil';

const TAG: string = 'ServiceExtensionManager';

export class ServiceExtensionManager {
  /**
   * 单个拉起外部应用
   * @param want 待拉起的want
   */
  public static async startServiceExtensionAbility(want: Want): Promise<void> {
    try {
      let context = getContext() as common.UIAbilityContext;
      await context.startServiceExtensionAbility(want);
      LogUtil.info(TAG, `startServiceExtension, budleName:${want?.bundleName},
        abilityName:${want?.abilityName} succeed.`);
    } catch (err) {
      LogUtil.error(TAG, `startServiceExtension failed, code is ${err.code}, message is ${err.message}.`);
    }
  }

  /**
   * 批量拉起外部应用
   * @param wants 待拉起的wants
   */
  public static async startServiceExtensionAbilities(wants: Want[]): Promise<void> {
    wants.forEach(async (want: Want) => {
      LogUtil.info(TAG, `startServiceExtension, budleName:${want?.bundleName}`);
      await ServiceExtensionManager.startServiceExtensionAbility(want);
    });
  }
}