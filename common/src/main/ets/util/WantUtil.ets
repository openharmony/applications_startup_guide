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

import Want from '@ohos.app.ability.Want';
import { CommonConstant } from '../constant/CommonConstant';
import { PageConfig } from '../model/config/PageConfig';
import { StringUtil } from './StringUtil';

/**
 * Want工具类
 */
export class WantUtil {
  /**
   * 是否是有效的want
   * @returns 是否有效
   */
  public static isValidPrivacyWant(privacyWant: Want | null): boolean {
    if (privacyWant && privacyWant.bundleName && privacyWant.abilityName) {
      return true;
    }
    return false;
  }

  /**
   * 是否是有效的非OOBE want
   * @returns 是否有效
   */
  public static isOobePrivacyWant(privacyWant: Want): boolean {
    if (privacyWant && privacyWant.bundleName !== CommonConstant.HW_STARTUP_GUIDE_PKG_NAME) {
      return true;
    }
    return false;
  }

  /**
   * startAbility 必须显式指定 bundleName 与 abilityName，禁止 action/uri 隐式匹配拉起。
   */
  public static isExplicitStartWant(want: Want | null | undefined): boolean {
    if (!want) {
      return false;
    }
    return StringUtil.isNotEmpty(want.bundleName) && StringUtil.isNotEmpty(want.abilityName);
  }

  /**
   * 外部页面配置是否包含显式拉起目标（与 PageConfig.action 差异字段无关）。
   */
  public static isExplicitPageConfig(config: PageConfig | null | undefined): boolean {
    if (!config) {
      return false;
    }
    return StringUtil.isNotEmpty(config.getBundleName()) && StringUtil.isNotEmpty(config.getAbilityName());
  }

  /**
   * 构造仅含 bundleName、abilityName、parameters 的显式 Want，剔除 action/uri 等隐式匹配字段。
   */
  public static buildExplicitStartWant(bundleName: string, abilityName: string,
    parameters?: Record<string, Object>): Want | null {
    if (!StringUtil.isNotEmpty(bundleName) || !StringUtil.isNotEmpty(abilityName)) {
      return null;
    }
    let explicitWant: Want = {
      bundleName: bundleName,
      abilityName: abilityName,
    };
    if (parameters) {
      explicitWant.parameters = parameters;
    }
    return explicitWant;
  }
}
