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
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import DataShare from '@ohos.data.dataShare';

import { LogUtil } from './LogUtil';
import { SettingUtil } from './SettingUtil';
import { SystemParameterUtil } from './SystemParameterUtil';
import { AbilityManager } from '../manager/AbilityManager';

const TAG: string = 'HiViewXUtil';

const CONST_BUILD_HIDE: string = 'const.product.hide';
const RETAIL_VERSION_HIDE: string = 'const.dfx.enable_retail';
const SETTINGS_URI: string = 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=';
const SWITCH_NAME: string = 'hiview_ue_switch_enable';

/**
 * HiViewX增强服务工具类
 */
export class HiViewXUtil {
  private static switchValue: string;

  /**
   * 判断用户体验改进计划按钮是否禁用
   */
  public static isSwitchDisabled(): boolean {
    const buildHideConfig: string = SystemParameterUtil.getSync(CONST_BUILD_HIDE, '');
    const retailVersionHide: string = SystemParameterUtil.getSync(RETAIL_VERSION_HIDE, '');
    LogUtil.info(TAG, `buildHideConfig:${buildHideConfig}, retailVersionHide:${retailVersionHide}`);
    return buildHideConfig === 'true' || retailVersionHide === 'true';
  }

  /**
   * 通过datashare监听设置数据库开关值变化
   * @param context UIAbility context
   */
  public static registerDataShareListener(): void {
    HiViewXUtil.switchValue = SettingUtil.getValueSync(SWITCH_NAME, '');
    try {
      let listenUri = SETTINGS_URI + SWITCH_NAME;
      LogUtil.info(TAG, 'registerDataShareListener');
      DataShare.createDataShareHelper(AbilityManager.getInstance().getContext() as Context,
        listenUri).then((dataHelper) => {
        LogUtil.info(TAG, 'createDataShareHelper success');
        dataHelper.on('dataChange', listenUri, () => {
          const newValue = SettingUtil.getValueSync(SWITCH_NAME, '');
          if (newValue === HiViewXUtil.switchValue) {
            return;
          }
          LogUtil.info(TAG, 'dataShareHelper on dataChange');
          HiViewXUtil.switchValue = newValue;
          HiViewXUtil.startExtensionAbility();
        });
      });
    } catch (err) {
      LogUtil.error(TAG, `createDataShareHelper err: ${err?.message}`);
    }
  }

  /**
   * 拉起用户体验改进计划serviceExtension
   */
  public static startExtensionAbility() {
    LogUtil.info(TAG, 'startHiviewxServiceExtensionAbility');
    let want: Want = {
      bundleName: 'com.ohos.openharmony.hiviewx',
      abilityName: 'HiViewXSwitchServiceExtensionAbility',
      parameters: {
        isFromOOBE: true,
      },
    };

    try {
      let context = getContext() as common.UIAbilityContext;
      context.startServiceExtensionAbility(want).then(() => {
        LogUtil.info(TAG, 'startServiceExtensionAbility succeed.');
      });
    } catch (err) {
      LogUtil.error(TAG, `startServiceExtensionAbility failed, code is ${err.code}, message is ${err.message}.`);
    }
  }
}