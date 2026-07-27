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

import { describe, expect, it, beforeAll } from '@ohos/hypium';
import { LogUtil, GlobalContext } from '@ohos/hwstartupguide.common';
import { BasePreferences } from '@ohos/hwstartupguide.common/src/main/ets/preferences/BasePreferences';

const TAG: string = 'BasePreferencesTest';

/**
 * BasePreferences工具类测试
 */
export default function BasePreferencesTest() {
  let basePrefer: BasePreferences;
  describe('BasePreferencesTest', () => {
    beforeAll(() => {
      class ChildBasePreferences extends BasePreferences {
        getTag(): string {
          return 'ChildBasePreferences';
        };
        constructor(fileName: string) {
          super(fileName);
        };
      }
      basePrefer = new ChildBasePreferences('');
    });

    /*
     * @tc.number:BasePreferencesTest_001
     * @tc.name: BasePreferences工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: BasePreferencesTests抽象类测试
     */
    it('BasePreferencesTest_001', 0, async () => {
      LogUtil.info(TAG, 'BasePreferencesTest_001 start');
      expect(basePrefer.setValue('', 0)).assertPromiseIsRejected();
      LogUtil.info(TAG, 'BasePreferencesTest_001 end');
    });
  })
}