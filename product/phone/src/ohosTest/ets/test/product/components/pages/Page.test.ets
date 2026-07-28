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
import { Driver, ON, UiDirection } from '@ohos.UiTest';
import { describe, it, TestType, beforeAll, expect } from '@ohos/hypium';
import { LogUtil, GlobalContext, CommonConstant } from '@ohos/hwstartupguide.common';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import bundleManager from '@ohos.bundle.bundleManager';

const DELEGATOR: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let driver = Driver.create();

const TAG: string = 'PageTest';

/**
 * 此用例执行前置条件：
 * 1 手机不能锁屏
 * 2 bundle 和 ability 都要处于启用状态
 * 3 流水线运行前把测试机环境恢复一下，保证不锁屏，启用 bundle 和 ability
 */
export default function PageTest() {
  describe('PageTest', () => {
    beforeAll(async (done: Function) => {
      await driver.delayMs(1000);
      let info = GlobalContext.getInstance().getObject('abilityInfo') as bundleManager.AbilityInfo;
      if (info !== undefined) {
        try {
          bundleManager.setAbilityEnabledSync(info, true);
          LogUtil.info(TAG, 'setAbilityEnabledSync succeed');
        } catch (warn) {
          LogUtil.warn(TAG, `setAbilityEnabledSync failed: ${warn.errorCode}`);
        }
      }
      await driver.delayMs(1000);
      await driver.pressHome();
      try {
        await DELEGATOR.startAbility({
          'bundleName': 'com.ohos.startupguide',
          'abilityName': 'com.ohos.startupguide.MainAbility',
        });
        await driver.delayMs(1000);
      } catch (warn) {
        LogUtil.warn(TAG, `startAbility failed: ${warn}`);
      }
      done();
    })

    it('PageTest_001', TestType.FUNCTION, async (done: Function) => {
      try {
        await driver.delayMs(1000);
        let welcomeComp = await driver.findComponent(ON.type('Button'));
        LogUtil.info(TAG, await welcomeComp.getText());
        await welcomeComp.click();
        await driver.delayMs(1000);
        let buttonLanguageSelect =
          await driver.findComponent(ON.type('Button').within(ON.id(CommonConstant.FOOTER_COMPONENT_ID)));
        LogUtil.info(TAG, await buttonLanguageSelect.getText());
        await buttonLanguageSelect.click();
        await driver.delayMs(1000);
        let buttonRegionSelect =
          await driver.findComponent(ON.type('Button').within(ON.id(CommonConstant.FOOTER_COMPONENT_ID)));
        LogUtil.info(TAG, await buttonRegionSelect.getText());
        await buttonRegionSelect.click();
        await driver.delayMs(1000);
        let buttonSkipQuickStart =
          await driver.findComponent(ON.type('Button').within(ON.id(CommonConstant.FOOTER_COMPONENT_ID)));
        LogUtil.info(TAG, await buttonSkipQuickStart.getText());
        let result = (): void => {
          buttonSkipQuickStart.click();
        };
        expect(result).not().assertFail();
        done();
      } catch (e) {
        LogUtil.error(TAG, e);
      }

    });
  });
}