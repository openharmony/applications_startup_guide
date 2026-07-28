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

import i18n from '@ohos.i18n';
import { LogUtil } from '@ohos/hwstartupguide.common';
import { CountryAndRegion } from './CountryAndRegion';

const TAG: string = 'LanguageAndRegion';

/**
 *语言地区
 * @since 2023-10-7
 */
export class LanguageAndRegion {
  /**
   * Display the region
   */
  static getDisplayRegion(country: string): string {
    return i18n.System.getDisplayCountry(country, i18n.getSystemLanguage(), true);
  }

  /**
   * get system regions
   */
  static getSystemRegions(): Array<CountryAndRegion> {
    LogUtil.info(TAG, 'getSystemRegions');
    let systemLocaleManager: i18n.SystemLocaleManager = new i18n.SystemLocaleManager();
    let language: string = i18n.System.getSystemLanguage();
    let sortedRegions: i18n.LocaleItem[] =
      systemLocaleManager.getRegionInfoArray(i18n.System.getSystemCountries(language));
    return sortedRegions.map(country =>
    new CountryAndRegion(country.id, country.displayName)
    );
  }

  static getSystemCountries(): Array<string> {
    return i18n.System.getSystemCountries(i18n.System.getSystemLanguage());
  }

  static isSystemRegion(region: string): boolean {
    return region === i18n.System.getSystemRegion();
  }

  static isSystemLanguage(language: string): boolean {
    return language === i18n.System.getSystemLanguage();
  }

}