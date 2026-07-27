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

import { ShipModeManager, LogUtil, SharePreferences, AbilityManager } from '@ohos/hwstartupguide.common';
import { describe, expect, it } from '@ohos/hypium';
import systemParameterEnhance from '@ohos.systemParameterEnhance';

const TAG: string = 'ShipModeManagerTest';
const OHOS_BOOT_SHIPMODE: string = 'ohos.boot.shipmode';
const OOBE_SHIP_MODE_TIMES_KEY: string = 'oobe_ship_mode_times_key';

/**
 * ShipModeManager工具类测试
 */
export default function ShipModeManagerTest() {
  describe('ShipModeManagerTest', () => {

    /**
     * @tc.number: ShipModeManagerTest_001
     * @tc.name: ShipModeManager工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: ShipModeManager工具类测试
     */
    it('ShipModeManagerTest_001', 0, async () => {
      LogUtil.info(TAG, `ShipModeManagerTest_001 start`);
      expect(ShipModeManager.getInstance().enter()).assertTrue();
      LogUtil.info(TAG, `ShipModeManagerTest_001 end`);
    });

    /**
     * @tc.number: ShipModeManagerTest_002
     * @tc.name: ShipModeManager工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: ShipModeManager工具类测试
     */
    it('ShipModeManagerTest_002', 0, async () => {
      LogUtil.info(TAG, `ShipModeManagerTest_002 start`);
      expect(ShipModeManager.getInstance().leave()).assertTrue();
      LogUtil.info(TAG, `ShipModeManagerTest_002s end`);
    });

    it('ShipModeManagerTest_003', 0, async () => {
      ShipModeManager.getInstance().leave();
      let handleAbilityResult = (): void => {
        ShipModeManager.getInstance().mayShipMode();
      };
      expect(handleAbilityResult).not().assertFail();
    });

    it('ShipModeManagerTest_004', 0, async () => {
      ShipModeManager.getInstance().enter();
      ShipModeManager.getInstance().setChargingForDT(true);
      let handleAbilityResult = (): void => {
        ShipModeManager.getInstance().mayShipMode();
      };
      expect(handleAbilityResult).not().assertFail();
    });

    it('ShipModeManagerTest_005', 0, async () => {
      ShipModeManager.getInstance().enter();
      ShipModeManager.getInstance().setChargingForDT(false);
      systemParameterEnhance.set(OHOS_BOOT_SHIPMODE, '0');
      let handleAbilityResult = (): void => {
        ShipModeManager.getInstance().mayShipMode();
      };
      expect(handleAbilityResult).not().assertFail();
    });

    it('ShipModeManagerTest_006', 0, async () => {
      ShipModeManager.getInstance().enter();
      ShipModeManager.getInstance().setChargingForDT(false);
      systemParameterEnhance.set(OHOS_BOOT_SHIPMODE, '1');
      let handleAbilityResult = (): void => {
        ShipModeManager.getInstance().mayShipMode();
      };
      expect(handleAbilityResult).not().assertFail();
    });

    it('ShipModeManagerTest_007', 0, async () => {
      ShipModeManager.getInstance().enter();
      ShipModeManager.getInstance().setChargingForDT(false);
      systemParameterEnhance.set(OHOS_BOOT_SHIPMODE, '1');
      await SharePreferences.getInstance().setValue(OOBE_SHIP_MODE_TIMES_KEY, 4);
      let handleAbilityResult = (): void => {
        ShipModeManager.getInstance().mayShipMode();
      };
      expect(handleAbilityResult).not().assertFail();
    });

    it('ShipModeManagerTest_008', 0, async (done:Function) => {
      ShipModeManager.getInstance().enter();
      ShipModeManager.getInstance().setChargingForDT(false);
      systemParameterEnhance.set(OHOS_BOOT_SHIPMODE, '1');
      await SharePreferences.getInstance().setValue(OOBE_SHIP_MODE_TIMES_KEY, 1);
      let handleAbilityResult = (): void => {
        ShipModeManager.getInstance().mayShipMode();
      };
      expect(handleAbilityResult).not().assertFail();
      sleep(15*1000);
      done();
    });
  })

  const sleep: Function = (ms: number): Promise<void> => {
    return new Promise(res => setTimeout(res, ms))
  };
}