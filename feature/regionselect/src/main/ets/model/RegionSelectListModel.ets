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
/* instrument ignore file */
import i18n from '@ohos.i18n';
import {
  CommonConstant,
  HiSysEventUtil,
  LogUtil,
} from '@ohos/hwstartupguide.common';
import { RegionDataSource } from '../constant/RegionDataSource';
import { CountryAndRegion } from './CountryAndRegion';
import { LanguageAndRegion } from './LanguageAndRegion';

const TAG: string = 'RegionSelectListModel';
const NOT_FOUND: number = -1;

export class RegionSelectListModel {
  /**
   * 声明一个获取地区数据的接口，并由RegionListComp来实现
   */
  public getRegionData: () => RegionDataSource = () => {
    LogUtil.warn(TAG, `RegionSelectListComp should implement getRegionData()`);
    return new RegionDataSource([]);
  };
  /**
   * 声明一个更新地区数据列表的接口，并由RegionSelectListComp来实现
   */
  public updateRegionListToUI: (regionData: RegionDataSource) => void = () => {
    LogUtil.warn(TAG, `RegionSelectListComp should implement updateRegionDataToUI()`);
  };
  /**
   * 声明滑动滚动条到顶部的接口，并由RegionListComp来实现
   * 当用户点击选择地区时，地区列表滚动条要滚动到顶部，以
   * 使用户能够看到选择的值发生变化
   */
  public scrollToTop: () => void = () => {
    LogUtil.warn(TAG, `RegionSelectListComp should implement scrollToTop()`);
  };

  public init() {
    let regions: CountryAndRegion[] = LanguageAndRegion.getSystemRegions();
    if (regions.length === 0) {
      LogUtil.error(TAG, 'init fail, system regions is empty');
      return;
    }
    const dataSource: RegionDataSource = new RegionDataSource(regions);
    this.updateRegionListToUI(dataSource);
  }

  public getCurrentIndex(): number {
    let region: string = i18n.System.getSystemRegion();
    let regionName: string = i18n.System.getDisplayCountry(region, i18n.System.getSystemLanguage(), true);
    let index: number = this.getRegionData().regionList.indexOf(regionName);
    if (NOT_FOUND === index) {
      LogUtil.error(TAG, `region list does not contain ${regionName}, cancel updating`);
      return 0;
    }
    return index;
  }

  /**
   * 应用系统地区
   */
  public applyRegionChange(index: number): void {
    try {
      let region = this.getRegionData().regionList[index];
      let newCountry: string = this.getRegionData().getCountry(region);
      let oldCountry: string = i18n.System.getSystemRegion();
      if (newCountry !== oldCountry) {
        HiSysEventUtil.reportUserEvent(CommonConstant.EVENT_REGION_SELECT, `${newCountry}`);
        i18n.System.setSystemRegion(newCountry);
        LogUtil.info(TAG, `set system region ${newCountry} success`);
      } else {
        LogUtil.info(TAG, `region not change, do nothing`);
      }
    } catch (error) {
      LogUtil.error(TAG, `call System.setSystemRegion failed, error code: ${error.code}, message: ${error.message}.`);
    }
  }
}
