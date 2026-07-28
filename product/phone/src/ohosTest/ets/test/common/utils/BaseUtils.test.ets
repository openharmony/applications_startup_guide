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

import { describe, expect, it } from '@ohos/hypium';
import { DeviceUtil } from '@ohos/hwstartupguide.common';


const TAG: string = 'BaseUtilsTest';

/**
 * OtaUtil 工具类测试
 */
export default function BaseUtilsTest() {
  describe('BaseUtilsTest', () => {
    /**
     * @tc.number: BaseUtilsTest_001
     * @tc.name: BaseUtils工具类测试
     */
    it('BaseUtilsTest_001', 0, async () => {
      expect(DeviceUtil.isSupportFastClone()).assertTrue();
    });

    /**
     * @tc.number: BaseUtilsTest_002
     * @tc.name: BaseUtils工具类测试
     */
    it('BaseUtilsTest_002', 0, async () => {
      expect(DeviceUtil.isDevicePhone()).assertTrue();
      expect(DeviceUtil.isFoldExpanded()).assertFalse();
      expect(DeviceUtil.isFold()).assertFalse();
    });
  });
}
