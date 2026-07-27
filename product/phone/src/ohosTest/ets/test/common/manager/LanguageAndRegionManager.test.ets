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
import { LanguageAndRegionManager } from '@ohos/hwstartupguide.common';

import { describe, expect, it, TestType } from '@ohos/hypium';

const TAG: string = 'LanguageAndRegionManagerTest';

export default function LanguageAndRegionManagerTest() {
  describe('LanguageAndRegionManagerTest', () => {

    it('LanguageAndRegionManagerTest_001', TestType.FUNCTION, async (done: Function) => {
      let language: string = LanguageAndRegionManager.getInstance().getSystemLanguage();
      let region: string = LanguageAndRegionManager.getInstance().getSystemRegion();
      await LanguageAndRegionManager.getInstance().setLanguageAndRegion(language, region);
      expect(LanguageAndRegionManager.getInstance().getSystemLanguage()).assertEqual(language);
      expect(LanguageAndRegionManager.getInstance().getSystemRegion()).assertEqual(region);
      done();
    });

    it('LanguageAndRegionManagerTest_002', TestType.FUNCTION, async (done: Function) => {
      let language: string = LanguageAndRegionManager.getInstance().getSystemLanguage();
      await LanguageAndRegionManager.getInstance().setSystemLanguage(language);
      expect(LanguageAndRegionManager.getInstance().getSystemLanguage()).assertEqual(language);
      done();
    });

    it('LanguageAndRegionManagerTest_003', TestType.FUNCTION, async (done: Function) => {
      let region: string = LanguageAndRegionManager.getInstance().getSystemRegion();
      await LanguageAndRegionManager.getInstance().setSystemRegion(region);
      expect(LanguageAndRegionManager.getInstance().getSystemRegion()).assertEqual(region);
      done();
    });

    it('LanguageAndRegionManagerTest_004', TestType.FUNCTION, async (done: Function) => {
      let language: string = LanguageAndRegionManager.getInstance().getSystemLanguage();
      let region: string = LanguageAndRegionManager.getInstance().getSystemRegion();
      await LanguageAndRegionManager.getInstance().setLanguageAndRegion(language, null);
      expect(LanguageAndRegionManager.getInstance().getSystemLanguage()).assertEqual(language);
      expect(LanguageAndRegionManager.getInstance().getSystemRegion()).assertEqual(region);
      done();
    });

    it('LanguageAndRegionManagerTest_005', TestType.FUNCTION, async (done: Function) => {
      let language: string = LanguageAndRegionManager.getInstance().getSystemLanguage();
      let region: string = LanguageAndRegionManager.getInstance().getSystemRegion();
      await LanguageAndRegionManager.getInstance().setLanguageAndRegion(null, region);
      expect(LanguageAndRegionManager.getInstance().getSystemLanguage()).assertEqual(language);
      expect(LanguageAndRegionManager.getInstance().getSystemRegion()).assertEqual(region);
      done();
    });

    it('LanguageAndRegionManagerTest_006', TestType.FUNCTION, async (done: Function) => {
      let language: string = LanguageAndRegionManager.getInstance().getSystemLanguage();
      let region: string = LanguageAndRegionManager.getInstance().getSystemRegion();
      await LanguageAndRegionManager.getInstance().setLanguageAndRegion(null, null);
      expect(LanguageAndRegionManager.getInstance().getSystemLanguage()).assertEqual(language);
      expect(LanguageAndRegionManager.getInstance().getSystemRegion()).assertEqual(region);
      done();
    });


  })
}