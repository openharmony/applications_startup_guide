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

import { describe, expect, it, MockKit, when } from '@ohos/hypium';
import { LogUtil, PasswordUtil } from '@ohos/hwstartupguide.common';

const TAG: string = 'PasswordUtilTest';

/**
 * PasswordUtil 工具类测试
 */
export default function PasswordUtilTest() {
  describe('PasswordUtilTest', () => {
    /**
     * @tc.number: PasswordUtilTest_001
     * @tc.name: PasswordUtilTest工具类测试
     */
    it('PasswordUtilTest_001', 0, async () => {
      LogUtil.info(TAG, `PasswordUtilTest_001 start`);
      expect(PasswordUtil.isDeviceProtectionPageShow()).assertEqual(true);
      LogUtil.info(TAG, `PasswordUtilTest_001 end`);
    });
  });
}
