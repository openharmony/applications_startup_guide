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
import { LogUtil } from '@ohos/hwstartupguide.common';
import { describe, expect, it } from '@ohos/hypium';
import { CountryAndRegion } from '@ohos/hwstartupguide.regionselect/src/main/ets/model/CountryAndRegion';

const TAG = 'CountryAndRegionTag';
export default function CountryAndRegionTest() {
  describe('CountryAndRegionTest', () => {
    /**
     * @tc.number:CountryAndRegion_001
     * @tc.name: getCountry方法校验
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 输出string
     */
    it('CountryAndRegion_001', 0, async () => {
      LogUtil.info(TAG, 'CountryAndRegion_001 start');
      const countryAndRegion = new CountryAndRegion('china','china');
      let result = countryAndRegion.getCountry();
      let expectResult = 'china';
      expect(result).assertEqual(expectResult);
      LogUtil.info(TAG, 'CountryAndRegion_001 end');
    });

    /**
     * @tc.number:CountryAndRegion_002
     * @tc.name: getRegion方法校验
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 输出string
     */
    it('CountryAndRegion_002', 0, async () => {
      LogUtil.info(TAG, 'CountryAndRegion_002 start');
      const countryAndRegion = new CountryAndRegion('china','taiwan');
      let result = countryAndRegion.getRegion();
      let expectResult = 'taiwan';
      expect(result).assertEqual(expectResult);
      LogUtil.info(TAG, 'CountryAndRegion_002_end');
    });

  });
}