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
import { LogUtil, RouterUtils } from '@ohos/hwstartupguide.common';

const TAG: string = 'RouterUtilTest';

/**
 * RouterUtil 工具类测试
 */
export default function RouterUtilTest() {
  describe('RouterUtilTest', () => {

    /**
     * @tc.number: RouterUtilTest_001
     * @tc.name: RouterUtilTest工具类测试
     */
    it('RouterUtilTest_001', 0, async () => {
      LogUtil.info(TAG, `RouterUtilTest_001 start`);
      let back = (): void => {
        RouterUtils.back();
      };
      RouterUtils.back();
      expect(back).not().assertFail();
      LogUtil.info(TAG, `RouterUtilTest_001 end`);
    });

    /**
     * @tc.number: RouterUtilTest_001
     * @tc.name: RouterUtilTest工具类测试
     */
    it('RouterUtilTest_002', 0, async () => {
      LogUtil.info(TAG, `RouterUtilTest_002 start`);
      let handleAbilityResult = (): void => {
        RouterUtils.pushUrl({url:'test', params:''});
      };
      RouterUtils.pushUrl({url:'test', params:''})
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `RouterUtilTest_002 end`);
    });

    /**
     * @tc.number: RouterUtilTest_001
     * @tc.name: RouterUtilTest工具类测试
     */
    it('RouterUtilTest_003', 0, async () => {
      LogUtil.info(TAG, `RouterUtilTest_003 start`);
      let handleAbilityResult = (): void => {
        RouterUtils.back();
      };
      RouterUtils.back();
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `RouterUtilTest_003 end`);
    });
  });
}
