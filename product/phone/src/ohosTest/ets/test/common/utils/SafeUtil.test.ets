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
import { LogUtil, SafeUtil } from '@ohos/hwstartupguide.common';
import { describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';

const TAG: string = 'SafeUtilTest';

/**
 * ResourceStringUtil 工具类测试
 */
export default function SafeUtilTest() {
  describe('SafeUtilTest', () => {
    /**
     * @tc.number: SafeUtilTest_001
     * @tc.name: SafeUtilTest工具类测试
     */
    it('SafeUtilTest_001', 0, async () => {
      LogUtil.info(TAG, `SafeUtilTest_001 start`);
      let str = '';
      expect(SafeUtil.replaceDeviceIdSensitive(str)).assertEqual('');
      str = 'x';
      expect(SafeUtil.replaceDeviceIdSensitive(str)).assertEqual('***');
      str = '999888777';
      expect(SafeUtil.replaceDeviceIdSensitive(str)).assertEqual('999*****777');
      LogUtil.info(TAG, `SafeUtilTest_001 end`);
    });
  });
}