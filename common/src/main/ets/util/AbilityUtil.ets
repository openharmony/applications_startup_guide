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
import bundle from '@ohos.bundle.bundleManager';
import { BusinessError } from '@ohos.base';
import { LogUtil } from './LogUtil';
import { PageConfig } from '../model/config/PageConfig';
import { AbilityCallback } from './CommonUtils';
import { AbilityManager } from '../manager/AbilityManager';
import { WantUtil } from './WantUtil';

const TAG: string = 'AbilityUtil';

/**
 * Ability工具类
 */
export class AbilityUtil {
  /**
   * 未整改成UIExtensionAbility的外部应用Ability名
   * 新老框架兼容阶段，不要commit。适配SR000IFK6D 【OOBE】页面接入框架整改
   */
  public static oldAbilityNames: Set<string> = new Set<string>([
    'EntryAbility', // xgate(在CCM上，本地搜不到勿删)
    'ProtocolUIAbility'// 畅连用户协议和关于畅连与隐私声明
  ]);

  /**
   * 启动 ability（显式指定 bundleName / abilityName，禁止隐式 Want）
   * @param bundleName 包名
   * @param abilityName ability 名称
   * @param parameters 可选参数
   */
  public static startAbilityByContext(bundleName: string, abilityName: string,
    parameters?: Record<string, Object>): Promise<void> {
    LogUtil.info(TAG, 'startAbilityByContext start');
    return new Promise((resolve, reject) => {
      let context = AbilityManager.getInstance().getContext();
      if (context === null) {
        LogUtil.error(TAG, 'startAbilityByContext failed. context is null');
        reject();
        return;
      }
      let explicitWant = WantUtil.buildExplicitStartWant(bundleName, abilityName, parameters);
      if (!explicitWant) {
        LogUtil.error(TAG,
          `startAbilityByContext rejected: require explicit bundleName and abilityName, got bundle:${bundleName}, ability:${abilityName}`);
        reject();
        return;
      }
      let targetAbilityName = explicitWant.abilityName;
      (context as common.UIAbilityContext).startAbility(explicitWant).then(() => {
        LogUtil.info(TAG, `startAbilityByContext success. ${targetAbilityName}`);
        resolve();
      }).catch((err: BusinessError) => {
        LogUtil.error(TAG, `startAbilityByContext failed. errMsg:${err.message}`);
        reject(err);
      });
    });
  }

  /**
   * 启动ability
   * @param bundleName 包名
   * @param abilityName ability名称
   */
  public static startAbility(bundleName: string, abilityName: string): Promise<void> {
    LogUtil.info(TAG, 'startAbility start');
    return AbilityUtil.startAbilityByContext(bundleName, abilityName);
  }

  /**
   * 销毁退出ability
   */
  public static terminateSelf(): Promise<void> {
    LogUtil.info(TAG, 'terminateSelf start');
    return new Promise((resolve, reject) => {
      let context = AbilityManager.getInstance().getContext();
      if (context === null) {
        LogUtil.error(TAG, 'terminateSelf failed. context is null');
        reject();
        return;
      }
      (context as common.UIAbilityContext).terminateSelf().then(() => {
        LogUtil.info(TAG, 'terminateSelf success.');
        resolve();
      }).catch((error: BusinessError) => {
        LogUtil.error(TAG, `terminateSelf failed. errMsg:${error?.message}`);
        reject(error);
      });
    });
  }

  /**
   * 启动 ability 并等待结果（显式指定 bundleName / abilityName）
   * @param bundleName 包名
   * @param abilityName ability 名称
   * @param parameters 可选参数
   * @param callback 回调函数
   */
  public static startAbilityForResult(bundleName: string, abilityName: string,
    parameters: Record<string, Object> | undefined,
    callback: AbilityCallback): void {
    let context = AbilityManager.getInstance().getContext();
    if (context === null) {
      LogUtil.error(TAG, 'startAbilityForResult failed. context is null');
      let error: BusinessError<string> = {
        name: '',
        message: '',
        code: 100,
        data: 'context is null',
      };
      callback(error, null);
      return;
    }

    let explicitWant = WantUtil.buildExplicitStartWant(bundleName, abilityName, parameters);
    if (!explicitWant) {
      LogUtil.error(TAG,
        `startAbilityForResult rejected: invalid explicit want bundle:${bundleName}, ability:${abilityName}`);
      let error: BusinessError<string> = {
        name: '',
        message: '',
        code: 100,
        data: 'invalid explicit want',
      };
      callback(error, null);
      return;
    }
    try {
      (context as common.UIAbilityContext).startAbilityForResult(explicitWant, (err, result) => {
        if (err.code) {
          // 处理业务逻辑错误
          LogUtil.error(TAG, `startAbilityForResult failed.${err.code}  errMsg:${err.message}`);
          let error: BusinessError<string> = {
            name: '',
            message: '',
            code: err.code,
            data: err.message,
          };
          callback(error, null);
          return;
        }
        // 执行正常业务
        LogUtil.info(TAG, `startAbilityForResult success bundleName:${bundleName}`);
        callback(null, result);
      });
    } catch (e) {
      // 处理入参错误异常
      LogUtil.error(TAG, `startAbilityForResult err. errCode:${e?.code} errMsg:${e?.message}`);
    }
  }

  /**
   * 启动 ability 并等待结果（由 PageConfig 构造显式 Want）
   * @param config 页面配置
   * @param callback 回调函数
   */
  public static startAbilityForResultByPageConfig(config: PageConfig | undefined,
    callback: AbilityCallback): void {
    if (!WantUtil.isExplicitPageConfig(config)) {
      LogUtil.error(TAG, `startAbilityForResultByPageConfig rejected: invalid page config ${config?.getKey()}`);
      let error: BusinessError<string> = {
        name: '',
        message: '',
        code: 100,
        data: 'invalid explicit page config',
      };
      callback(error, null);
      return;
    }
    AbilityUtil.startAbilityForResult(config!.getBundleName(), config!.getAbilityName(), config!.getParams(), callback);
  }

  /**
   *Ability是否存在
   */
  public static isAbilityAvailable(pageConfig: PageConfig | undefined): Promise<boolean> {
    if (AbilityUtil.isUIAbility(pageConfig?.getAbilityName())) {
      return AbilityUtil.isUIAbilityAvailable(pageConfig);
    } else {
      return AbilityUtil.isUIExtensionAbilityAvailable(pageConfig);
    }
  }

  /**
   *UIExtensionAbility是否存在
   */
  private static isUIExtensionAbilityAvailable(pageConfig: PageConfig | undefined): Promise<boolean> {
    LogUtil.info(TAG, `${pageConfig?.getKey()}: isUIExtensionAbilityAvailable start`);
    return new Promise((resolve, reject) => {
      let want: Want = {
        bundleName: pageConfig?.getBundleName(),
        abilityName: pageConfig?.getAbilityName(),
      };
      let extensionAbilityType = bundle.ExtensionAbilityType.UNSPECIFIED;
      let abilityFlags: number = bundle.AbilityFlag.GET_ABILITY_INFO_DEFAULT;
      try {
        bundle.queryExtensionAbilityInfo(want, extensionAbilityType, abilityFlags, (err, data) => {
          if (err) {
            LogUtil.error(TAG, `${pageConfig?.getKey()}: queryExtensionAbilityInfo failed`, err);
            reject(err);
          } else {
            LogUtil.info(TAG, `${pageConfig?.getKey()}: queryExtensionAbilityInfo successfully.`);
            resolve(true);
          }
        });
      } catch (err) {
        LogUtil.error(TAG, `${pageConfig?.getKey()}: queryExtensionAbilityInfo error`, err);
        reject(err);
      }
    });
  }

  /**
   * UIAbility是否存在
   * 新老框架兼容阶段，不要commit。适配SR000IFK6D 【OOBE】页面接入框架整改
   */
  private static isUIAbilityAvailable(pageConfig: PageConfig | undefined): Promise<boolean> {
    LogUtil.info(TAG, `${pageConfig?.getKey()}: isUIAbilityAvailable start`);
    return new Promise((resolve, reject) => {
      let want: Want = {
        bundleName: pageConfig?.getBundleName(),
        abilityName: pageConfig?.getAbilityName(),
      };
      let abilityFlags: number = bundle.AbilityFlag.GET_ABILITY_INFO_DEFAULT;
      try {
        bundle.queryAbilityInfo(want, abilityFlags, (err, data) => {
          if (err) {
            LogUtil.error(TAG, `${pageConfig?.getKey()}: queryAbilityInfo failed`, err);
            reject(err);
          } else {
            LogUtil.info(TAG, `${pageConfig?.getKey()}: queryAbilityInfo successfully.`);
            resolve(true);
          }
        });
      } catch (err) {
        LogUtil.error(TAG, `${pageConfig?.getKey()}: queryAbilityInfo error`, err);
        reject(err);
      }
    });
  }

  /**
   * 新老框架兼容阶段，不要commit。适配SR000IFK6D 【OOBE】页面接入框架整改
   * 是否是未整改成UIExtensionAbility的Ability
   * @param abilityName
   * @returns boolean
   */
  public static isUIAbility(abilityName: string | undefined): boolean {
    if (!abilityName) {
      return false;
    }
    let isUIAbilityFlag: boolean = AbilityUtil.oldAbilityNames.has(abilityName);
    LogUtil.info(TAG, `isUIAbility : ${isUIAbilityFlag} for ${abilityName}`);
    return isUIAbilityFlag;
  }
}
