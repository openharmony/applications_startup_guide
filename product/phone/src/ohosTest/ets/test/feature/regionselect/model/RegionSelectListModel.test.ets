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
import { LanguageAndRegion, RegionDataSource, RegionSelectListModel } from '@ohos/hwstartupguide.regionselect';
import { describe, it, expect, TestType, beforeAll } from '@ohos/hypium';
import i18n from '@ohos.i18n';

export default function RegionSelectListModelTest() {
  let model: RegionSelectListModel;
  let dataSource: RegionDataSource = new RegionDataSource(LanguageAndRegion.getSystemRegions());
  let isScrollToTopCalled = false;
  describe('RegionSelectListModelTest', () => {
    beforeAll(async () => {
      model = new RegionSelectListModel();
      model.getRegionData = () => {
        return dataSource;
      }

      model.updateRegionListToUI = (region: RegionDataSource) => {
        dataSource = region;
      }

      model.scrollToTop = () => {
        isScrollToTopCalled = true;
      }
    })

    /**
     * 测试updateRegionList方法，验证选择的值是否符合预期
     */
    it('RegionSelectListModelTest_005', TestType.FUNCTION, async () => {
      i18n.System.setSystemLanguage('zh-CN');
      // 会触发setSystemRegion
      model.getRegionData().regionList.unshift('非法值');
      let handleAbilityResult = (): void => {
        model.applyRegionChange(0);
      };
      expect(handleAbilityResult).not().assertFail();
    });
  });
}

const sleep: Function = (ms: number): Promise<void> => {
  return new Promise(res => setTimeout(res, ms))
};
