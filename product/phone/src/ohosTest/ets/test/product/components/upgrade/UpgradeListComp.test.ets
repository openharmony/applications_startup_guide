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
import { Driver } from '@ohos.UiTest';
import { describe, it, TestType, beforeAll, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import {
  AbilityUtil,
  CommonConstant,
  GlobalContext,
  LogUtil,
  SettingUtil } from '@ohos/hwstartupguide.common';

import common from '@ohos.app.ability.common';

const TAG: string = 'UpgradeListCompTest';
const DELEGATOR: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

export default function UpgradeGuideCompTest() {
  describe('UpgradeGuideCompTest', () => {
    let driver = Driver.create();
    beforeAll(async (done: Function) => {
      // 拉起主界面
      try {
        AbilityUtil.startAbilityByContext('com.ohos.startupguide', 'TestAbility');
        await driver.delayMs(300);
      }
      catch (exception) {
        LogUtil.error(TAG, 'start TestAbility failed');
      }
      done();
    })

  });
}