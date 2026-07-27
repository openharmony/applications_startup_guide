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

import { NumberUtils } from '@ohos/hwstartupguide.common';

import { describe, it, expect } from '@ohos/hypium'

/**
 * NumberUtils工具类测试
 */
export default function NumberUtilsTest() {
  describe('NumberUtilsTest', () => {
    /**
     * @tc.number: NumberUtilsTest_compare
     * @tc.name: NumberUtils工具类测试
     */
    it('NumberUtilsTest_compare', 0, () => {
      let isEqual: boolean = NumberUtils.compare(0.1, 0.1);
      expect(isEqual).assertTrue();
      let notEqual: boolean = NumberUtils.compare(0.01, 0.02);
      expect(notEqual).assertFalse();
    });

    /**
     * @tc.number: NumberUtilsTest_max
     * @tc.name: NumberUtils工具类测试
     */
    it('NumberUtilsTest_max', 0, () => {
      expect(NumberUtils.max(undefined, undefined)).assertEqual(undefined);
      expect(NumberUtils.max(undefined, 1)).assertEqual(1);
      expect(NumberUtils.max(2, undefined)).assertEqual(2);
      expect(NumberUtils.max(1, 2)).assertEqual(2);
    });
  });
}