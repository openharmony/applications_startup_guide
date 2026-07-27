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
import type { BusinessError } from '@ohos.base';
import type common from '@ohos.app.ability.common';
import bundleManager from '@ohos.bundle.bundleManager';
import type resmgr from '@ohos.resourceManager';
import { LogUtil } from './LogUtil';
import { StringUtil } from './StringUtil';
import { AbilityManager } from '../manager/AbilityManager';

const TAG: string = 'ResourceUtil';
const LINK_STRING_FLAG: string = '$string:';

/**
 * 资源工具类
 */
export class ResourceUtil {
  /**
   * 获取指定应用的指定模块下的metadata数据
   * @param bundleName 应用包名
   * @param moduleName 模块名
   * @param metaDataName metadata名称
   */
  public static getMetadata(bundleName: string, moduleName: string, metaDataName: string): bundleManager.Metadata | null {
    try {
      let applicationInfo = bundleManager.getApplicationInfoSync(bundleName,
        bundleManager.ApplicationFlag.GET_APPLICATION_INFO_WITH_METADATA);
      if (applicationInfo === null || applicationInfo.metadata === null) {
        LogUtil.error(TAG,
          `applicationInfo or metadata is null. getMetadata failed. bundleName:${bundleName} ${(applicationInfo === null)}`);
        return null;
      }
      let metadataObj = applicationInfo.metadata;
      for (let key in metadataObj) {
        if (key !== moduleName) {
          continue;
        }
        for (let index in metadataObj[key]) {
          if (metadataObj[key][index].name !== metaDataName) {
            continue;
          }
          return metadataObj[key][index];
        }
      }
      LogUtil.debug(TAG, `applicationInfo. metaDataName:${metaDataName}.`);
      return null;
    } catch (err) {
      LogUtil.error(TAG, `getMetadata error:${err?.code} ${err?.message}`);
      return null;
    }
  }

  /**
   * 标准化字串名称
   * @param name 名称
   */
  public static getFormatStringName(name: string): string {
    return name.replace(LINK_STRING_FLAG, '');
  }

  /**
   * 获取指定资源管理器下的字串值
   * 例1： "value": "Param value" --返回原始值“Param value”
   * 例2： "value": "$string:param_value" --返回param_value对应的国际化字串值
   * @param resourceManager 资源管理器
   * @param stringName 字符串名称
   */
  public static getResourceString(resourceManager: resmgr.ResourceManager, stringName: string): string {
    try {
      if (StringUtil.isEmpty(stringName)) {
        LogUtil.error(TAG, 'getResourceString failed. stringName is null.');
        return '';
      }
      if (stringName.startsWith(LINK_STRING_FLAG)) {
        // value: $string:param_value 返回param_value对应的国际化字串值
        if (resourceManager === null) {
          LogUtil.error(TAG, 'getResourceString failed. resourceManager is null.');
          return '';
        }
        return resourceManager.getStringByNameSync(ResourceUtil.getFormatStringName(stringName));
      }
    } catch (error) {
      LogUtil.error(TAG, `getStringByNameSync failed. error: ${error?.code} ${error.message}`);
    }
    // value: Param value 返回原始值 Param value
    return stringName;
  }

  /**
   * 获取指定应用的字串
   * @param name 字符串名
   * @returns 字符串内容
   */
  public static getString(name: string): string {
    let context = AbilityManager.getInstance().getContext();
    if (context && context.resourceManager) {
      return ResourceUtil.getResourceString(context.resourceManager, name);
    }
    return '';
  }

  /**
   * 获取应用内资源数字
   * @param resource 资源信息
   * @return 数字，单位px
   */
  public static getNumber(resource: Resource): number {
    let context = AbilityManager.getInstance().getContext();
    try {
      if (context && context.resourceManager) {
        return context.resourceManager.getNumber(resource.id);
      }
    } catch (error) {
      LogUtil.error(TAG, `getNumber err: ${(error as BusinessError).code}  ${(error as BusinessError).message}`);
    }
    return 0;
  }

  /**
   * 获取string资源值
   * @param resource Resource资源类
   * @param args 格式化字符串资源参数
   * @returns 字符串结果
   */
  public static getStringByResource(resource: resmgr.Resource, ...args: Array<string | number>): string {
    if (!resource) {
      return '';
    }
    try {
      let context = AbilityManager.getInstance().getContext();
      if (!(context && context.resourceManager)) {
        LogUtil.error(TAG, 'getStringByResource failed.');
        return '';
      }
      if (args && args.length > 0) {
        return context.resourceManager.getStringSync(resource, ...args);
      } else {
        return context.resourceManager.getStringSync(resource);
      }
    } catch (error) {
      LogUtil.error(TAG,
        `getStringByResource err: ${(error as BusinessError).code}  ${(error as BusinessError).message}`);
    }
    return '';
  }

  /**
   * 获取指定应用的字串
   * @param context 上下文
   * @param bundleName 应用包名
   * @param stringName 字串名称
   */
  public static getBundleString(context: common.Context, bundleName: string, stringName: string): string | null {
    try {
      if (context === null || StringUtil.isEmpty(bundleName) || StringUtil.isEmpty(stringName)) {
        LogUtil.error(TAG, `getBundleString failed. bundleName:${bundleName}  stringName:${stringName}`);
        return null;
      }
      let resourceManager = ResourceUtil.getBundleResourceManager(bundleName, context);
      if (resourceManager === null) {
        LogUtil.error(TAG,
          `getBundleString failed.resourceManager is null, bundleName:${bundleName}, stringName:${stringName}`);
        return '';
      }
      return resourceManager.getStringByNameSync(stringName);
    } catch (error) {
      LogUtil.error(TAG,
        `getStringByNameSync failed.bundleName:${bundleName}, stringName:${stringName}, error:${error?.code} ${error.message}`);
    }
    return '';
  }

  /**
   * 获取指定包名资源管理器
   * @param bundleName 应用包名
   * @param context 上下文
   */
  public static getBundleResourceManager(bundleName: string,
    context: common.Context | null): resmgr.ResourceManager | null {
    if (context === null || StringUtil.isEmpty(bundleName)) {
      LogUtil.error(TAG, `getBundleResourceManager failed. bundleName:${bundleName}`);
      return null;
    }
    let bundleContext = context.createBundleContext(bundleName);
    if (bundleContext === null) {
      LogUtil.error(TAG, `createBundleContext failed. bundleName:${bundleName}`);
      return null;
    }
    return bundleContext.resourceManager;
  }
}
