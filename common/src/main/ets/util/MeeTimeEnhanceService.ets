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
import { LogUtil } from './LogUtil';

const TAG: string = 'MeeTimeEnhanceUtils';

/**
 * 畅连增强服务处理
 */
export class MeeTimeEnhanceService {
  public static async initProcessConditions(): Promise<void> {
    LogUtil.info(TAG, 'MeeTimeEnhanceService enter!');
    let want: Want = {
      bundleName: 'com.ohos.openharmony.meetimeservice',
      abilityName: 'AccountManagerServiceExtension',
      parameters: {
        isFromOOBE: true,
      },
    };
    try {
      LogUtil.info(TAG, 'connectServiceExtensionAbility.');
      let context = getContext() as common.UIAbilityContext;
      context.startServiceExtensionAbility(want).then(() => {
        LogUtil.info(TAG, 'startServiceExtensionAbility succeed.');
      });
    } catch (err) {
      // 处理入参错误异常
      LogUtil.error(TAG, `connectServiceExtensionAbility failed, code is ${err.code}, message is ${err.message}.`);
    }
  }
}