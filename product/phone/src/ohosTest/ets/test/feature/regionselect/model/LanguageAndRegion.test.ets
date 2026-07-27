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
import { LogUtil, ServiceEntity, GlobalContext } from '@ohos/hwstartupguide.common';
import { CountryAndRegion, LanguageAndRegion, RegionDataSource } from '@ohos/hwstartupguide.regionselect';
import i18n from '@ohos.i18n';

const TAG: string = 'LanguageAndRegionTest';

/**
 * LanguageAndRegion工具类测试
 */
export default function LanguageAndRegionTest() {
  describe('LanguageAndRegionTest', () => {

    /**
     * @tc.number:LanguageAndRegionTest_001
     * @tc.name: LanguageAndRegionTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: LanguageAndRegionTest工具类测试
     */
    it('LanguageAndRegionTest_001', 0, async () => {
      LogUtil.info(TAG, `LanguageAndRegionTest_001 start`);
      let a = i18n.System.getSystemRegion();
      expect(LanguageAndRegion.isSystemRegion(a)).assertEqual(true);
      expect(LanguageAndRegion.isSystemRegion('AA')).assertEqual(false);
      LogUtil.info(TAG, `LanguageAndRegionTest_001 end`);
    })

    /**
     * @tc.number:LanguageAndRegionTest_002
     * @tc.name: LanguageAndRegionTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: LanguageAndRegionTest工具类测试
     */
    it('LanguageAndRegionTest_002', 0, async () => {
      LogUtil.info(TAG, `LanguageAndRegionTest_002 start`);
      let a = i18n.System.getSystemLanguage();
      expect(LanguageAndRegion.isSystemLanguage(a)).assertEqual(true);
      expect(LanguageAndRegion.isSystemLanguage('AA')).assertEqual(false);
      LogUtil.info(TAG, `LanguageAndRegionTest_002 end`);
    })
  })
}