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
import { LogUtil, ResourceStringUtil } from '@ohos/hwstartupguide.common';

const TAG: string = 'ResourceStringUtilTest';

/**
 * ResourceStringUtil 工具类测试
 */
export default function ResourceStringUtilTest() {
  describe('ResourceStringUtilTest', () => {

    /**
     * @tc.number: ResourceStringUtilTest_001
     * @tc.name: ResourceStringUtilTest工具类测试
     */
    it('ResourceStringUtilTest_001', 0, async () => {
      LogUtil.info(TAG, `ResourceStringUtilTest_001 start`);
      let undef: undefined;
      expect(ResourceStringUtil.getStringSync(undef)).assertEqual('');
      LogUtil.info(TAG, `ResourceStringUtilTest_001 end`);
    });

    /**
     * @tc.number: ResourceStringUtilTest_002
     * @tc.name: ResourceStringUtilTest工具类测试
     */
    it('ResourceStringUtilTest_002', 0, async () => {
      LogUtil.info(TAG, `ResourceStringUtilTest_002 start`);
      expect(ResourceStringUtil.getStringSync('str')).assertInstanceOf('String');
      LogUtil.info(TAG, `ResourceStringUtilTest_002 end`);
    });

    /**
     * @tc.number: ResourceStringUtilTest_003
     * @tc.name: ResourceStringUtilTest工具类测试
     */
    it('ResourceStringUtilTest_003', 0, async () => {
      LogUtil.info(TAG, `ResourceStringUtilTest_003 start`);
     let ResourceStr: string = 'app.color.blue_default';
      expect(ResourceStringUtil.getStringSync(ResourceStr)).assertInstanceOf('String');
      LogUtil.info(TAG, `ResourceStringUtilTest_003 end`);
    });

    /**
     * @tc.number: ResourceStringUtilTest_004
     * @tc.name: ResourceStringUtilTest工具类测试
     */
    it('ResourceStringUtilTest_004', 0, async () => {
      LogUtil.info(TAG, `ResourceStringUtilTest_004 start`);
      let str1 = '%1$d===1,%2$d===2'
      expect(ResourceStringUtil.getStringOfNumFormat(str1, 1, 2)).assertInstanceOf('String');
      expect(ResourceStringUtil.getStringOfNumFormat(str1, 1, 2)).assertEqual('1===1,2===2');
      let str2 = 'string'
      expect(ResourceStringUtil.getStringOfNumFormat(str2, 1, 2)).assertEqual('string');
      LogUtil.info(TAG, `ResourceStringUtilTest_004 end`);
    });
  });
}
