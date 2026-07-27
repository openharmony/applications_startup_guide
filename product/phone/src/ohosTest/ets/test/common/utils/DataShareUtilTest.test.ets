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
import { DataShareUtil, LogUtil } from '@ohos/hwstartupguide.common';

const TAG: string = 'HwStartupGuide_DataShareUtilTest';

export default function DataShareUtilTest() {
  describe('DataShareUtilTest', () => {
    beforeAll(async () => {
      LogUtil.info(TAG, 'HwStartUp DataShareUtilTest');
    });

    /**
     * @tc.number: DataShareUtilTest_001
     * @tc.name: 测试
     */
    it('DataShareUtilTest_001', 0, async () => {
      LogUtil.info(TAG, 'DataShareUtilTest_001 start');
      let value: string = await DataShareUtil.getValueByDataShare("", "test", "");
      if (value === undefined) {
        expect(value).assertUndefined();
        LogUtil.info(TAG, 'DataShareUtilTest_001 value is undefined');
      } else {
        expect(value).assertEqual('test');
      }
      LogUtil.info(TAG, 'DataShareUtilTest_001 end');
    });

    /**
     * @tc.number: DataShareUtilTest_002
     * @tc.name: 测试
     */
    it('DataShareUtilTest_002', 0, async () => {
      LogUtil.info(TAG, 'DataShareUtilTest_002 start');
      await DataShareUtil.setValueByDataShare("testName", "testValue", "testTable");
      let value: string = await DataShareUtil.getValueByDataShare("testName", "defaultValue", "testTable");
      if (value === undefined) {
        expect(value).assertUndefined();
        LogUtil.info(TAG, 'DataShareUtilTest_002 value is undefined');
      } else {
        expect(value).assertEqual('testValue');
      }
      LogUtil.info(TAG, 'DataShareUtilTest_002 end');
    });
  });
}
