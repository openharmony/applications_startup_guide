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
import { LogUtil } from '@ohos/hwstartupguide.common';
import { languageAndRegionModel } from '@ohos/hwstartupguide.languageselect';
import i18n from '@ohos.i18n';

const TAG: string = 'LanguageAndRegionModelTest';

/**
 * LanguageAndRegionModel工具类测试
 */
export default function LanguageAndRegionModelTest() {
  describe('LanguageAndRegionModelTest', () => {

    /**
     * @tc.number:LanguageAndRegionModelTest_001
     * @tc.name: LanguageAndRegionModelTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: LanguageAndRegionModelTest工具类测试
     */
    it('LanguageAndRegionModelTest_001', 0, async () => {
      LogUtil.info(TAG, `LanguageAndRegionModelTest_001 start`);
      let a = i18n.System.getSystemLanguage();
      expect(languageAndRegionModel.getSystemLanguage()).assertEqual(a);
      LogUtil.info(TAG, `LanguageAndRegionTest_001 end`);
    })

    /**
     * @tc.number:LanguageAndRegionModelTest_002
     * @tc.name: LanguageAndRegionModelTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: LanguageAndRegionModelTest工具类测试
     */
    it('LanguageAndRegionModelTest_002', 0, async () => {
      LogUtil.info(TAG, `LanguageAndRegionTest_002 start`);
      let index = languageAndRegionModel.getCurIndex();
      expect(index >= 0).assertEqual(true);
      LogUtil.info(TAG, `LanguageAndRegionTest_002 end`);
    })

    /**
     * @tc.number:LanguageAndRegionModelTest_003
     * @tc.name: LanguageAndRegionModelTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: LanguageAndRegionModelTest工具类测试
     */
    it('LanguageAndRegionModelTest_003', 0, async () => {
      LogUtil.info(TAG, `LanguageAndRegionTest_003 start`);
      let arr = languageAndRegionModel.getSystemLanguages();
      expect(arr?.length > 0).assertEqual(true);
      LogUtil.info(TAG, `LanguageAndRegionTest_003 end`);
    })
  })
}