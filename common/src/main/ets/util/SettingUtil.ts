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
import settings from '@ohos.settings';
import type common from '@ohos.app.ability.common';
import { Context } from '@ohos.abilityAccessCtrl';
import { AbilityManager } from '../manager/AbilityManager';
import { LogUtil } from './LogUtil';
import { EMPTY_IDENTIFY } from './StringUtil';

const TAG: string = 'SettingUtil';

/**
 * Settings工具类
 */
export class SettingUtil {
  /**
   * 设置settings数据（同步方法）
   * @param name 名称
   * @param value 值
   * @param tableName 表名
   * @return true：设置成功；false：设置失败
   */
  public static setValueSync(name: string, value: string, tableName?: string): boolean {
    let pageContext: common.Context = AbilityManager.getInstance().getContext();
    if (pageContext) {
      return SettingUtil.setValueSyncWithContext(pageContext, name, value, tableName);
    }
    LogUtil.error(TAG, 'setValueSync context is null');
    return false;
  }

  public static setValueSyncWithContext(context: Context, name: string, value: string, tableName?: string): boolean {
    try {
      // 数据兼容阶段，勿 argue & comment, start
      if (tableName) { // secure 数据
        // 适配settingData当前现状，两边存储数据，
        let resultSecure = settings.setValueSync(context, name, value, tableName);
        let resultGlobal = settings.setValueSync(context, name, value);

        LogUtil.info(TAG,
          `setValueSync name:${name} resultSecure:${resultSecure} resultGlobal:${resultGlobal}`);
        return resultSecure ? resultSecure : resultGlobal;
      } else { // global 数据
        let resultGlobal = settings.setValueSync(context, name, value);
        LogUtil.info(TAG, `setValueSync global name:${name} result:${resultGlobal}`);
        return resultGlobal;
      }
    } catch (error) {
      LogUtil.error(TAG, `setValueSyncWithContext error: ${error?.code}, ${error?.message}`);
      return false;
    }
  }

  public static setValueSyncWithContextForService(context: Context, name: string, value: string, tableName: string): boolean {
    try {
      let result = settings.setValueSync(context, name, value, tableName);
      LogUtil.info(TAG, `setValueSyncForService name:${name} result:${result}`);
      return result;
    } catch (error) {
      LogUtil.error(TAG, `setValueSyncForService error, error.code:${error.code}, error.message:${error.message}`);
      return false;
    }
  }

  /**
   * 设置settings数据（异步方法）
   * @param name 名称
   * @param value 值
   * @param tableName 表名
   * @return true：设置成功；false：设置失败
   */
  public static async setValue(name: string, value: string, tableName?: string): Promise<boolean> {
    try {
      let pageContext: common.Context = AbilityManager.getInstance().getContext();
      if (!pageContext) {
        LogUtil.error(TAG, `setValue name:${name} context is null`);
        return false;
      }
      if (tableName) {
        let resultSecure: boolean = await settings.setValue(pageContext, name, value, tableName);
        let resultGlobal: boolean = await settings.setValue(pageContext, name, value);
        LogUtil.info(TAG,
          `setValue name:${name} resultSecure:${resultSecure} resultGlobal:${resultGlobal}`);
        return resultSecure ? resultSecure : resultGlobal;
      } else {
        let resultGlobal: boolean = await settings.setValue(pageContext, name, value);
        LogUtil.info(TAG, `setValue global name:${name} result:${resultGlobal}`);
        return resultGlobal;
      }
    } catch (error) {
      LogUtil.error(TAG, `setValue error: ${error?.code}, ${error?.message}`);
    }
    return false;
  }

  /**
   * 获取settings数据（异步方法）
   * @param name 名称
   * @param defValue 默认值
   * @param tableName 表名
   * @return null：获取数据失败； resultSecure：获取secure表数据； resultGlobal：获取global表数据
   */
  public static async getValue(name: string, defValue: string, tableName?: string): Promise<string> {
    try {
      let pageContext: common.Context = AbilityManager.getInstance().getContext();
      if (!pageContext) {
        LogUtil.error(TAG, `getValue name:${name} context is null`);
        return null;
      }
      if (tableName) {
        let resultSecure = await settings.getValue(pageContext, name, tableName);
        if (resultSecure !== null) {
          LogUtil.info(TAG, `getValue name:${name}`);
          return resultSecure;
        }
        let resultGlobal = await settings.getValue(pageContext, name);
        resultGlobal = resultGlobal ?? defValue;
        LogUtil.info(TAG, `getValue secure find null but from global name:${name}`);
        return resultGlobal;
      } else { // global 数据
        let resultGlobal = await settings.getValue(pageContext, name);
        resultGlobal = resultGlobal ?? defValue;
        LogUtil.info(TAG, `getValue global name:${name}`);
        return resultGlobal;
      }
    } catch (e) {
      LogUtil.error(TAG, `get value error ${e}`);
    }
    return defValue;
  }

  /**
   * 获取settings数据（同步方法）
   * @param name 名称
   * @param defValue 默认值
   * @param tableName 表名
   * @return 值
   */
  public static getValueSync(name: string, defValue: string, tableName?: string): string {
    let pageContext: common.Context = AbilityManager.getInstance().getContext();
    if (pageContext) {
      return this.getValueSyncWithContext(pageContext, name, defValue, tableName);
    }
    LogUtil.error(TAG, 'getValueSync context is null');
    return '';
  }

  /**
   * 获取settings数据（同步方法）
   * @param name 名称
   * @param defValue 默认值
   * @param tableName 表名
   * @return 值
   */
  public static getValueSyncWithContext(context: Context, name: string, defValue: string, tableName?: string): string {
      // 数据兼容阶段，勿 argue & comment, start
      if (tableName) { // secure 数据
        // 适配settingData当前现状，secure读不到，则从global读取
        let resultSecure = settings.getValueSync(context, name, EMPTY_IDENTIFY, tableName);
        if (resultSecure !== EMPTY_IDENTIFY) {
          LogUtil.info(TAG, `getValueSync name:${name}`);
          return resultSecure;
        }
        let resultGlobal = settings.getValueSync(context, name, defValue);
        LogUtil.info(TAG, `getValueSync secure find null but global name:${name}`);
        return resultGlobal;
      } else { // global 数据
        let resultGlobal = settings.getValueSync(context, name, defValue);
        LogUtil.info(TAG, `getValueSync global name:${name}`);
        return resultGlobal;
      }
  }

  /**
   * 临时方案
   * 获取settings数据 不考虑多用户兼容性
   * @param name 名称
   * @param defValue 默认值
   * @param tableName 表名
   * @return 值
   */
  public static getValueDirect(name: string, defValue: string, tableName?: string): string {
    let pageContext: common.Context = AbilityManager.getInstance().getContext();
    if (pageContext) {
      let value = tableName ? settings.getValueSync(pageContext, name, defValue, tableName) :
      settings.getValueSync(pageContext, name, defValue);
      LogUtil.info(TAG, `getValueSync name:${name}`);
      return value;
    }
    LogUtil.error(TAG, 'getValueSync context is null');
    return '';
  }

  /**
   * 设置多用户settings数据（同步方法）
   * @param name 名称
   * @param value 值
   * @param tableName 表名称
   * @return true：设置成功；false：设置失败
   */
  public static setValueSecuritySync(name: string, value: string, tableName?: string): boolean {
    let pageContext: common.Context = AbilityManager.getInstance().getContext();
    try {
      if (pageContext) {
        let result = settings.setValueSync(pageContext, name, value, tableName);
        LogUtil.info(TAG, `setValueSecuritySync name:${name} result:${result}`);
        return result;
      } else {
        LogUtil.error(TAG, `setValueSecuritySync name:${name} context is null`);
      }
    } catch (error) {
      LogUtil.error(TAG, `setValueSecuritySync error: ${error?.code}, ${error?.message}`);
    }
    return false;
  }

  /**
   * 设置多用户settings数据（异步方法）
   * @param name 名称
   * @param value 值
   * @param tableName 表名称
   * @return true：设置成功；false：设置失败
   */
  public static async setValueSecurity(name: string, value: string, tableName?: string): Promise<boolean> {
    let pageContext: common.Context = AbilityManager.getInstance().getContext();
    try {
      if (pageContext) {
        let result: boolean = await settings.setValue(pageContext, name, value, tableName);
        LogUtil.info(TAG, `setValueSecurity name:${name} result:${result}`);
        return result;
      } else {
        LogUtil.error(TAG, `setValueSecurity context is null`);
      }
    } catch (error) {
      LogUtil.error(TAG, `setValueSecurity error: ${error?.code}, ${error?.message}`);
    }
    return false;
  }
}
