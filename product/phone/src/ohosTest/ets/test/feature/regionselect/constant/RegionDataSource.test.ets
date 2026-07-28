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
import { CountryAndRegion, RegionDataSource } from '@ohos/hwstartupguide.regionselect';
import { SimpleServiceEntity } from '../../../SimpleServiceEntity.test';

const TAG: string = 'RegionDataSourceTest';

/**
 * RegionDataSource工具类测试
 */
export default function RegionDataSourceTest() {
  describe('RegionDataSourceTest', () => {

    /*
     * @tc.number:RegionDataSourceTest_001.
     * @tc.name: RegionDataSourceTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: RegionDataSourceTest工具类测试
     */
    it('RegionDataSourceTest_001', 0, async () => {
      LogUtil.info(TAG, `ServiceEntryDataSourceTest_001 start`);
      let data: RegionDataSource = new RegionDataSource([]);
      expect(data.totalCount()).assertEqual(0);
      let countryAndRegion = new CountryAndRegion('CH','china');
      let data1: RegionDataSource = new RegionDataSource([countryAndRegion]);
      expect(data1.totalCount()).assertEqual(1);
      LogUtil.info(TAG, `RegionDataSourceTest_001 end`);
    })

    /*
     * @tc.number:RegionDataSourceTest_002
     * @tc.name: RegionDataSourceTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: RegionDataSourceTest工具类测试
     */
    it('RegionDataSourceTest_002', 0, async () => {
      LogUtil.info(TAG, `ServiceEntryDataSourceTest_002 start`);
      let data: RegionDataSource = new RegionDataSource([]);
      expect(data.getData(0)).assertEqual('');
      expect(data.getData(-1)).assertEqual('');
      expect(data.getData(10)).assertEqual('');
      let countryAndRegion = new CountryAndRegion('CH','china');
      let data1: RegionDataSource = new RegionDataSource([countryAndRegion]);
      expect(data1.getData(0)).assertEqual('china');
      LogUtil.info(TAG, `RegionDataSourceTest_002 end`);
    })

    /*
     * @tc.number:RegionDataSourceTest_003
     * @tc.name: RegionDataSourceTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: RegionDataSourceTest工具类测试.
     */
    it('RegionDataSourceTest_003', 0, async () => {
      LogUtil.info(TAG, `ServiceEntryDataSourceTest_003 start`);
      let data: RegionDataSource = new RegionDataSource([]);
      expect(data.getCountry('China')).assertEqual('');
      let countryAndRegion = new CountryAndRegion('CH','China');
      let countryAndRegion1 = new CountryAndRegion('UE','United Arab Emirates');
      let data1: RegionDataSource = new RegionDataSource([countryAndRegion,countryAndRegion1]);
      expect(data1.getCountry('China')).assertEqual('CH');
      expect(data1.getCountry('America')).assertEqual('');
      LogUtil.info(TAG, `RegionDataSourceTest_003 end`);
    })

    /*
     * @tc.number:RegionDataSourceTest_004
     * @tc.name: RegionDataSourceTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: RegionDataSourceTest工具类测试
     */
    it('RegionDataSourceTest_004', 0, async () => {
      LogUtil.info(TAG, `ServiceEntryDataSourceTest_004 start`);
      let data: RegionDataSource = new RegionDataSource([]);
      let countryAndRegion = new CountryAndRegion('CH','china');
      let countryAndRegion1 = new CountryAndRegion('UE','United Arab Emirates');
      let data1: RegionDataSource = new RegionDataSource([countryAndRegion,countryAndRegion1]);
      let removeData = (): void => {
        data1.removeData('China');
      }
      expect(removeData).not().assertFail();
      LogUtil.info(TAG, `RegionDataSourceTest_004 end`);
    })

    /*
     * @tc.number:RegionDataSourceTest_004
     * @tc.name: RegionDataSourceTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: RegionDataSourceTest工具类测试
     */
    it('RegionDataSourceTest_005', 0, async () => {
      LogUtil.info(TAG, `ServiceEntryDataSourceTest_005 start`);
      let data: RegionDataSource = new RegionDataSource([]);
      let countryAndRegion = new CountryAndRegion('CH','china');
      let countryAndRegion1 = new CountryAndRegion('UE','United Arab Emirates');
      let countryAndRegion2 = new CountryAndRegion('A','test');
      let data1: RegionDataSource = new RegionDataSource([countryAndRegion,countryAndRegion1,countryAndRegion2]);
      let removeData = (): void => {
        data1.removeData('China');
      }
      expect(removeData).not().assertFail();
      LogUtil.info(TAG, `RegionDataSourceTest_005 end`);
    })
  })
}