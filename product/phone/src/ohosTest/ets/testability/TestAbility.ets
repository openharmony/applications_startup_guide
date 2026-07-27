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

import UIAbility from '@ohos.app.ability.UIAbility';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';
import { Hypium } from '@ohos/hypium';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import abilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry';
import { AbilityManager, GlobalContext, LogUtil } from '@ohos/hwstartupguide.common';
import testsuite from '../test/List.test';
import bundleManager from '@ohos.bundle.bundleManager';

const TAG: number = 0x0000;
const PATH: string = '/data/storage/el2/base/js_coverage.json';
const BASE_UID: number = 200000;
let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let abilityDelegatorArguments: AbilityDelegatorRegistry.AbilityDelegatorArgs = abilityDelegatorRegistry.getArguments();

export default class TestAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    hilog.info(TAG, 'testTag', '%{public}s', 'TestAbility onCreate');
    hilog.info(TAG, 'testTag', '%{public}s', 'start run testcase!!!');
    GlobalContext.getInstance().setObject('context', this.context);
    GlobalContext.getInstance().setObject('pageContext', this.context);
    AbilityManager.getInstance().setContext(this.context);
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
    GlobalContext.getInstance().setObject('guideHomeAbility', this);
    try {
      let info = await bundleManager.queryAbilityInfoSync({
        bundleName: 'com.ohos.startupguide',
        abilityName: 'com.ohos.startupguide.MainAbility'
      }, bundleManager.AbilityFlag.GET_ABILITY_INFO_WITH_APPLICATION, 100)[0];
      GlobalContext.getInstance().setObject('abilityInfo', info);
    } catch (warn) {
      hilog.warn(TAG, 'testTag', '%{public}s', `queryAbilityInfoSync failed ${warn.errorCode}`);
    }
  }

  onDestroy(): void {
    hilog.info(TAG, 'testTag', '%{public}s', 'TestAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(TAG, 'testTag', '%{public}s', 'TestAbility onWindowStageCreate');
    windowStage.loadContent('testability/pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(TAG, 'testTag', 'Failed to load the content. Cause: %{public}s', err?.message ?? '');
        return;
      }
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(TAG, 'testTag', '%{public}s', 'TestAbility onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(TAG, 'testTag', '%{public}s', 'TestAbility onForeground');
  }

  onBackground(): void {
    hilog.info(TAG, 'testTag', '%{public}s', 'TestAbility onBackground');
  }
}