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
import { BasicDataSource, LogUtil } from '@ohos/hwstartupguide.common';
import { CountryAndRegion } from '../model/CountryAndRegion';


const END_INDEX_ONE: number = 1;
/**
 * RegionDataSource For Lazy Loading
 */

const TAG: string = 'RegionDataSource';

/**
 * 地区列表数据源
 */
export class RegionDataSource extends BasicDataSource<string> {
  public regionList: string[] = [];
  private countryAndRegionList: CountryAndRegion[] = [];

  constructor(regionArray: CountryAndRegion[]) {
    super();
    this.countryAndRegionList = regionArray;
    for (let regionArrayItem of regionArray) {
      this.regionList.push(regionArrayItem.getRegion());
    }
  }

  public totalCount(): number {
    return this.regionList?.length;
  }

  public getCountry(region: string): string {
    LogUtil.info(TAG, 'getCountry');
    let country: string = '';
    for (let regionArrayItem of this.countryAndRegionList) {
      if (regionArrayItem.getRegion() === region) {
        country = regionArrayItem.getCountry();
        break;
      }
    }
    return country;
  }

  public getData(index: number): string {
    if (!this.regionList) {
      LogUtil.error(TAG, 'getData. regionList is null');
      this.regionList = [];
      return '';
    }
    if (index < 0 || index >= this.regionList.length) {
      LogUtil.error(TAG, 'getData. index is invalid');
      return '';
    }
    return this.regionList[index];
  }

  public addData(regionItem: string): void {
    if (!this.regionList) {
      this.regionList = [];
    }
    this.regionList.unshift(regionItem);
    this.notifyDataReload();
  }

  public removeData(regionItem: string): void {
    for (let i = 0; i < this.totalCount(); i++) {
      if (this.regionList[i] === regionItem) {
        this.regionList.splice(i, END_INDEX_ONE);
        this.notifyDataDelete(i);
      }
    }
  }

  /**
   * 从另一个对象同步数据
   * @param other
   */
  public copyFrom(other: RegionDataSource): void {
    this.countryAndRegionList = other.countryAndRegionList;
    this.regionList.splice(0, this.regionList.length);
    for (let item of this.countryAndRegionList) {
      this.regionList.push(item.getRegion());
    }
    this.notifyDataReload();
  }
}



