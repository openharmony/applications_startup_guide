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

import { ArgumentMatchers, describe, expect, it, MockKit, TestType, when } from '@ohos/hypium';
import { LogUtil } from '@ohos/hwstartupguide.common';
import { RegionSelectPageController, RegionSelectUtil } from '@ohos/hwstartupguide.regionselect';
import { PageOrderController } from '../../../../../../main/ets/controller/PageOrderController';

const TAG: string = 'RegionSelectPageControllerTest';

/**
 * RegionSelectPageController工具类测试
 */
export default function RegionSelectPageControllerTest() {
  describe('RegionSelectPageControllerTest', () => {
    let controller: RegionSelectPageController = new RegionSelectPageController(PageOrderController.getInstance());
    let mocker: MockKit = new MockKit();
    /*
     * @tc.number:RegionSelectPageControllerTest_001.
     * @tc.name: RegionSelectPageControllerTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: RegionSelectPageControllerTest工具类测试
     */
    it('RegionSelectPageControllerTest_001', 0, async () => {
      LogUtil.info(TAG, `RegionSelectPageControllerTest_001 start`);
      let isHasSelectRegionFromSPFunc: Function =
        mocker.mockFunc(RegionSelectUtil, RegionSelectUtil.isHasSelectRegionFromSP);
      when(isHasSelectRegionFromSPFunc)(ArgumentMatchers.any).afterReturn(true);
      controller.readSelectRegionAgreed();
      when(isHasSelectRegionFromSPFunc)(ArgumentMatchers.any).afterReturn(false);
      let handleAbilityResult = (): void => {
        controller.readSelectRegionAgreed();
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `RegionSelectPageControllerTest_001 end`);
    })

    /*
    * @tc.number:RegionSelectPageControllerTest_001
    * @tc.name: ServiceEntryDataSource工具类测试
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: RegionSelectPageController工具类测试
    */
    it('RegionSelectPageControllerTest_002', TestType.FUNCTION, async () => {
      LogUtil.info(TAG, `RegionSelectPageControllerTest_002 start`);
      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(RegionSelectUtil, RegionSelectUtil.isHasSelectRegionFromSP);
      let mockFunc1: Function = mockKit.mockFunc(RegionSelectUtil, RegionSelectUtil.readSelectRegionFromSP);
      let mockFunc2: Function = mockKit.mockFunc(RegionSelectUtil, RegionSelectUtil.readSelectRegionFromSettings);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('China');
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('America');
      let sp = await controller.readSelectRegionAgreed();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let handleAbilityResult = (): void => {
        controller.readSelectRegionAgreed();
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `RegionSelectPageControllerTest_002 end`);
    })
  })
}