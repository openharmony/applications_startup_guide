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
import { AccountUtil, LogUtil } from '@ohos/hwstartupguide.common';

const TAG: string = 'HwStartupGuide_AccountUtilTest';

export default function AccountUtilTest() {
  describe('AccountUtilTest', () => {
    beforeAll(async () => {
      LogUtil.info(TAG, 'HwStartUp AbilityStage onCreate1');
    });

    /*
    * @tc.number: AccountUtilTest_001
    * @tc.name: 测试
    */
    it('AccountUtilTest_001', 0, async () => {
      LogUtil.info(TAG, 'AccountUtilTest_001 start');
      expect(AccountUtil.hasEnterpriseAccount()).assertPromiseIsRejected;
      LogUtil.info(TAG, 'AccountUtilTest_001 end');
    });

    /**
     * @tc.number: AccountUtilTest_002
     * @tc.name: 测试
     */
    it('AccountUtilTest_002', 0, async () => {
      LogUtil.info(TAG, 'AccountUtilTest_002 start');
      expect(AccountUtil.hasEnterpriseAccount()).assertPromiseIsPending;
      LogUtil.info(TAG, 'AccountUtilTest_002 end');
    });

    /**
     * @tc.number: AccountUtilTest_003
     * @tc.name: 测试
     */
    it('AccountUtilTest_003', 0, async () => {
      LogUtil.info(TAG, 'AccountUtilTest_003 start');
      let result = await AccountUtil.hasEnterpriseAccount();
      expect(result).not().assertNull();
      LogUtil.info(TAG, 'AccountUtilTest_003 end');
    });

    /**
     * @tc.number: AccountUtilTest_004
     * @tc.name: 测试
     */
    it('AccountUtilTest_004', 0, async () => {
      LogUtil.info(TAG, 'AccountUtilTest_002 start');
      let result = await AccountUtil.hasEnterpriseAccount();
      expect(result).not().assertNull();
      LogUtil.info(TAG, 'AccountUtilTest_004 end');
    });
  });
}
