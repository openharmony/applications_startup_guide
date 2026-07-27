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

import { beforeAll, describe, expect, it } from '@ohos/hypium';
import {
  LogUtil,
} from '@ohos/hwstartupguide.common';
import { RegionSelectUtil } from '@ohos/hwstartupguide.regionselect';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { Context } from '@kit.AbilityKit';

const SELECT_REGION_STATE: string = 'select_region_state';

const TAG: string = 'RegionSelectUtilTest';

export default function RegionSelectUtilTest() {
  describe('RegionSelectUtilTest', () => {
    let context: Context;

    beforeAll(() => {
      context = abilityDelegatorRegistry.getAbilityDelegator().getAppContext();
    })

    /**
     * @tc.number:RegionSelectUtilTest_001
     * @tc.name: 地区选择工具类测试
     */
    it('RegionSelectUtilTest_001', 0, async () => {
      LogUtil.info(TAG, `RegionSelectUtilTest_001 start`);
      RegionSelectUtil.saveSelectRegionToSP(null, 'China');
      let saveSelectRegionToSP = (): void => {
        RegionSelectUtil.saveSelectRegionToSP(null, 'China');
      }
      expect(saveSelectRegionToSP).not().assertFail();
      let sp0 = await RegionSelectUtil.readSelectRegionFromSP(context);
      expect(sp0).assertEqual('');
      LogUtil.info(TAG, `RegionSelectUtilTest_001 end`);
    });

    /**
     * @tc.number:RegionSelectUtilTest_002
     * @tc.name: 地区选择工具类测试
     */
    it('RegionSelectUtilTest_002', 0, async () => {
      LogUtil.info(TAG, `RegionSelectUtilTest_002 start`);
      let result = await RegionSelectUtil.readSelectRegionFromSP(context);
      expect(result).assertEqual('');
      LogUtil.info(TAG, `RegionSelectUtilTest_002 end`);
    });

    /**
     * @tc.number:RegionSelectUtilTest_007
     * @tc.name: 地区选择工具类测试
     */
    it('RegionSelectUtilTest_005', 0, async () => {
      LogUtil.info(TAG, `RegionSelectUtilTest_005 start`);
      let result =
        await RegionSelectUtil.isHasSelectRegionFromSP(context);
      expect(result).assertFalse();
      LogUtil.info(TAG, `RegionSelectUtilTest_005 end`);
    });

    /**
     * @tc.number:RegionSelectUtilTest_008
     * @tc.name: 地区选择工具类测试
     */
    it('RegionSelectUtilTest_006', 0, async () => {
      LogUtil.info(TAG, `RegionSelectUtilTest_006 start`);
      let result = await RegionSelectUtil.isHasSelectRegionFromSP(null);
      expect(result).assertEqual(false);
      LogUtil.info(TAG, `RegionSelectUtilTest_006 end`);
    });

    /**
     * @tc.number:RegionSelectUtilTest_09
     * @tc.name: 地区选择工具类测试
     */
    it('RegionSelectUtilTest_07', 0, async () => {
      LogUtil.info(TAG, `RegionSelectUtilTest_07 start`);
      let saveSelectRegionToSetting = (): void => {
        RegionSelectUtil.saveSelectRegionToSetting('China');
      }
      expect(saveSelectRegionToSetting).not().assertFail();
      LogUtil.info(TAG, `RegionSelectUtilTest_07 end`);
    });

  });
}
