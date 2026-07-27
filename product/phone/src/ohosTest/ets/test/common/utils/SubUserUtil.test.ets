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
import settings from '@ohos.settings';
import { CommonConstant, LogUtil, SettingUtil, SubUserUtil } from '@ohos/hwstartupguide.common';

const TAG: string = 'SubUserUtilTest';

/**
 * SubUserUtil工具类测试
 */
export default function SubUserUtilTest() {
  describe('SubUserUtilTest', () => {

    /*
    * @tc.number:SubUserUtilTest_005
    * @tc.name: SubUserUtilTest工具类测试
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: SubUserUtilTest工具类测试
    */
    it('SubUserUtilTest_005', 0, async () => {
      LogUtil.info(TAG, `SubUserUtilTest_005 start`);
      expect(SubUserUtil.getCurrentAccountInfo()).assertPromiseIsPending();
      LogUtil.info(TAG, `StringUtilTest_005 end`);
    })

    /*
    * @tc.number:SubUserUtilTest_007
    * @tc.name: SubUserUtilTest工具类测试
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: SubUserUtilTest工具类测试
    */
    it('SubUserUtilTest_007', 0, async () => {
      LogUtil.info(TAG, `SubUserUtilTest_007 start`);
      expect(SubUserUtil.removeAccount(100)).assertPromiseIsResolved();
      LogUtil.info(TAG, `StringUtilTest_007 end`);
    })

  })
}
