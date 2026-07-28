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
import common from '@ohos.app.ability.common';
import { LogUtil, GlobalContext } from '@ohos/hwstartupguide.common';
import { SharePreferences } from '@ohos/hwstartupguide.common/src/main/ets/preferences/SharePreferences';

const TAG: string = 'SharePreferencesTest';

/**
 * SharePreferences工具类测试
 */
export default function SharePreferencesTest() {
  describe('SharePreferencesTest', () => {

    /*
       * @tc.number:SharePreferencesTest_001
       * @tc.name: SharePreferences工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: SharePreferences工具类测试
       */
    it('SharePreferencesTest_001', 0, async () => {
      LogUtil.info(TAG, 'SharePreferencesTest_001 start');
      let emptyKey = await SharePreferences.getInstance().hasValue('');
      expect(emptyKey).assertFalse();
      let testKey = await SharePreferences.getInstance().hasValue('test_key');
      expect(testKey).assertFalse();
      LogUtil.info(TAG, 'SharePreferencesTest_001 end');
    });

    /*
   * @tc.number:SharePreferencesTest_002
   * @tc.name: SharePreferences工具类测试
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: SharePreferences工具类测试 isMapEmpty isMapNotEmpty
   */
    it('SharePreferencesTest_002', 0, async () => {
      LogUtil.info(TAG, 'SharePreferencesTest_002 start');
      let emptyKey = await SharePreferences.getInstance().getValue('', null);
      expect(emptyKey).assertEqual(null);
      let testKey = await SharePreferences.getInstance().hasValue('test_key');
      expect(testKey).assertFalse();
      LogUtil.info(TAG, 'SharePreferencesTest_002 end');
    });

    /**
     * @tc.number:SharePreferencesTest_003
     * @tc.name: SharePreferences工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: SharePreferences工具类测试
     */
    it('SharePreferencesTest_003', 0, async () => {
      LogUtil.info(TAG, 'SharePreferencesTest_003 start');
      let testKeyValue = await SharePreferences.getInstance().hasValue('test_key');
      expect(testKeyValue).assertFalse();
      LogUtil.info(TAG, 'SharePreferencesTest_003 end');
    });

  });
}
