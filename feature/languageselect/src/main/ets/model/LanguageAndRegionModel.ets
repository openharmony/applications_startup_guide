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
  SharePreferences
} from '@ohos/hwstartupguide.common';

const TAG: string = 'LanguageAndRegionModel';

/**
 * OOBE 语言选择页当前仅展示的语言（中文、英文）。
 * 藏文/维文/繁体等语种资源未补齐时临时关闭入口；恢复多语言时注释本常量及 filter 调用。
 */
const OOBE_DISPLAY_LANGUAGES: string[] = ['zh-Hans', 'en-Latn-US'];

/**
 * 欢迎页 language_animation.json 图层顺序，与系统 getLanguageInfoArray 排序一致。
 * 恢复多语言欢迎动画时与 OOBE_DISPLAY_LANGUAGES 一并调整。
 */
export const WELCOME_ANIMATION_LANGUAGE_ORDER: string[] =
  ['zh-Hans', 'ug', 'bo', 'zh-Hant', 'en-Latn-US'];

/**
 *语言地区
 * @since 2024-4-9
 */
class LanguageAndRegionModel {
  private priorRegionsMap: Map<string, string[]> = new Map<string, string[]>();
  constructor() {
    this.buildRegionsMap();
  }

  /**
   * 语音选择和地区联动：
   * 1、用户选择简体中文，地区选择列表头部是[中国，中国香港，中国澳门，中国台湾]
   * 2、用户选择繁体中文，地区选择列表头部是[中国台湾，中国香港，中国澳门，中国]
   * 3、用户选择繁体中文（中国香港），地区选择列表头部是[中国香港，中国台湾，中国澳门，中国]
   * 4、用户选择英语，地区选择列表头部是[美国，澳大利亚，加拿大，印度，新西兰，新加坡，英国]
   */
  private buildRegionsMap() {
    // 简体中文优先地区:中国, 香港, 澳门, 台湾
    let zhHansRegions = ['CN', 'HK', 'MO', 'TW'];
    // 繁体中文优先地区:台湾, 香港, 澳门, 中国
    let zhHantRegions = ['TW', 'HK', 'MO', 'CN'];
    let zhHantHkRegions = ['HK', 'TW', 'MO', 'CN'];
    // 英语优先地区:美国, 澳大利亚, 加拿大, 印度, 新西兰, 新加坡, 英国
    let engRegions = ['US', 'AU', 'CA', 'IN', 'NZ', 'SG', 'GB'];
    this.priorRegionsMap.set('zh-Hans', zhHansRegions);
    this.priorRegionsMap.set('bo', zhHansRegions);
    this.priorRegionsMap.set('ug', zhHansRegions);
    this.priorRegionsMap.set('zh-Hant', zhHantRegions);
    this.priorRegionsMap.set('zh-Hant-HK', zhHantHkRegions);
    this.priorRegionsMap.set('en-Latn-US', engRegions);
    this.priorRegionsMap.set('en', engRegions);
  }

  /**
   * get system regions
   */
  getSystemLanguages(): string[] {
    let languageArray: string[] = i18n.System.getSystemLanguages();
    let systemLocaleManager: i18n.SystemLocaleManager = new i18n.SystemLocaleManager();
    try {
      let sortedLanguages: i18n.LocaleItem[] = systemLocaleManager.getLanguageInfoArray(languageArray);
      languageArray = [];
      sortedLanguages.forEach(((item: i18n.LocaleItem, index: number, array: i18n.LocaleItem[]) => {
        languageArray.push(item.id);
      }));
    } catch (error) {
      LogUtil.error(TAG,
        `call getLanguageInfoArray failed, error code: ${error.code}, message: ${error.message}.`);
    }
    LogUtil.info(TAG, `getSysDisplayLanguage languageArray: ${languageArray}`);
    // OOBE 语言选择页仅展示中文、英文；恢复多语言时注释 filter 行，改用下面 return
    languageArray = this.filterOobeDisplayLanguages(languageArray);
    // return languageArray;
    return languageArray;
  }

  /**
   * 过滤 OOBE 语言选择列表，仅保留中英文入口。
   * 恢复多语言支持时注释 getSystemLanguages 中的 filter 调用即可，无需删除本方法。
   */
  private filterOobeDisplayLanguages(languageArray: string[]): string[] {
    let filteredLanguages: string[] = [];
    for (let lang of OOBE_DISPLAY_LANGUAGES) {
      if (languageArray.includes(lang)) {
        filteredLanguages.push(lang);
      }
    }
    // 部分系统仅暴露 en，与 en-Latn-US 等价展示英文入口
    if (!filteredLanguages.includes('en-Latn-US') && languageArray.includes('en')) {
      filteredLanguages.push('en');
    }
    if (filteredLanguages.length === 0) {
      return ['zh-Hans', 'en-Latn-US'];
    }
    return filteredLanguages;
  }

  /**
   * Display in the system language
   */
  getSysDisplayLanguage(language: string) {
    LogUtil.info(TAG, 'getSysDisplayLanguage');
    return i18n.getDisplayLanguage(language, i18n.getSystemLanguage(), true);
  }

  /**
   * Display the language
   */
  getDisplayLanguage(language: string): string {
    LogUtil.info(TAG, 'getDisplayLanguage');
    return i18n.getDisplayLanguage(language, language, true);
  }

  setSystemLanguage(language: string): void {
    HiSysEventUtil.reportUserEvent(CommonConstant.EVENT_SELECT_LANGUAGE, `${language}`);
    try {
      // 应用系统语言设置
      i18n.System.setSystemLanguage(language);
      // 用户选择语言后，生成关联的优先地区列表和优先选择地区
      this.changeRegionsByLanguage(language);
      AppStorage.setOrCreate<string>('curLanguage', language);
      AppStorage.setOrCreate<boolean>('isoLanguage', i18n.isRTL(language));
    } catch (error) {
      HiSysEventUtil.reportErrorEvent(CommonConstant.RUN_SERVIVCES_FAILED,
        `setSystemLanguage err: ${error.code}, ${error.message}`);
      LogUtil.error(TAG, `set system language failed, err message:${error?.message}, err code:${error?.code}`);
    }
  }

  public changeRegionsByLanguage(language: string) {
    let priorityRegions: string[] = this.priorRegionsMap.get(language) ?? [];
    SharePreferences.getInstance()
      .setValue(CommonConstant.PRIOR_REGIONS, priorityRegions);
    if (priorityRegions.length > 0) {
      LogUtil.info(TAG, `change system region to ${priorityRegions[0]} by selecting language ${language}`);
      try {
        i18n.System.setSystemRegion(priorityRegions[0]);
      } catch (error) {
        LogUtil.error(TAG, `set system region failed ${error?.message}`);
      }
    }
  }

  getSystemLanguage(): string {
    return i18n.System.getSystemLanguage();
  }

  getCurIndex(languageArray?: string[]): number {
    if (!languageArray) {
      languageArray = this.getSystemLanguages();
    }
    let language = this.getSystemLanguage();
    let curIndex: number = 0;
    for (let index = 0; index < languageArray.length; index++) {
      if (languageArray[index] === language) {
        curIndex = index;
      }
    }
    return curIndex;
  }
}

export let languageAndRegionModel = new LanguageAndRegionModel();
