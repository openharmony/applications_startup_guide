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
import { LogUtil, HiViewXUtil, SystemParameterUtil } from '@ohos/hwstartupguide.common';

const TAG: string = 'HiViewXUtilTest';

const CONST_BUILD_HIDE: string = 'const.product.hide';
const RETAIL_VERSION_HIDE: string = 'const.dfx.enable_retail';

/**
 * HiViewXUtil 工具类测试
 */
export default function HiViewXUtilTest() {
  describe('HiViewXUtilTest', () => {

    /**
     * @tc.number: HiViewXUtilTest_001
     * @tc.name: HiViewXUtilTest工具类测试
     */
    it('HiViewXUtilTest_001', 0, async () => {
      LogUtil.info(TAG, `HiViewXUtilTest_001 start`);
      let startExtensionAbility = (): void => {
        HiViewXUtil.startExtensionAbility();
      };
      expect(startExtensionAbility).not().assertFail();
      LogUtil.info(TAG, `HiViewXUtilTest_001 end`);
    });

    /**
     * @tc.number: HiViewXUtilTest_002
     * @tc.name: HiViewXUtilTest工具类测试
     */
    it('HiViewXUtilTest_002', 0, async () => {
      LogUtil.info(TAG, `HiViewXUtilTest_002 start`);
      const buildHideConfig: string = SystemParameterUtil.getSync(CONST_BUILD_HIDE, '');
      const retailVersionHide: string = SystemParameterUtil.getSync(RETAIL_VERSION_HIDE, '');
      const isDisabled = buildHideConfig === 'true' || retailVersionHide === 'true';
      expect(HiViewXUtil.isSwitchDisabled()).assertEqual(isDisabled);
      LogUtil.info(TAG, `HiViewXUtilTest_002 end`);
    });

    /**
     * @tc.number: HiViewXUtilTest_003
     * @tc.name: HiViewXUtilTest工具类测试
     */
    it('HiViewXUtilTest_003', 0, async () => {
      LogUtil.info(TAG, `HiViewXUtilTest_003 start`);
      const registerDataShareListener = (): void => {
        HiViewXUtil.registerDataShareListener();
      }
      expect(registerDataShareListener).not().assertFail();
      LogUtil.info(TAG, `HiViewXUtilTest_003 end`);
    });
  });
}