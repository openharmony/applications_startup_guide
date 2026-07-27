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
import { LogUtil, MeeTimeEnhanceService } from '@ohos/hwstartupguide.common';

const TAG: string = 'MeeTimeEnhanceUtilsTest';

/**
 * MeeTimeEnhanceUtils 畅连增强服务处理测试
 */
export default function MeeTimeEnhanceUtilsTest() {
  describe('MeeTimeEnhanceUtilsTest', () => {

    /**
     * @tc.number: MeeTimeEnhanceUtilsTest_001
     * @tc.name: MeeTimeEnhanceUtilsTest工具类测试
     */
    it('MeeTimeEnhanceUtilsTest_001', 0, async () => {
      LogUtil.info(TAG, `MeeTimeEnhanceUtilsTest_001 start`);
      expect(MeeTimeEnhanceService.initProcessConditions()).assertPromiseIsResolved();
      LogUtil.info(TAG, `MeeTimeEnhanceUtilsTest_001 end`);
    });
  });
}
