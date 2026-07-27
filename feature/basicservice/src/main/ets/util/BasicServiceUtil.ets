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

import { BusinessError } from '@ohos.base';
import settings from '@ohos.settings';
import bundleManager from '@ohos.bundle.bundleManager';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { Context } from '@kit.AbilityKit';
import {
  ArrayUtil,
  CommonConstant,
  LogUtil,
  ServiceEntity,
  SettingUtil,
  SharePreferences,
  HiSysEventUtil,
  BasicService,
  RawFileUtil,
  ServiceEntityUtil,
  ServiceType,
} from '@ohos/hwstartupguide.common';
import { BasicServiceConstant } from '../constant/BasicServiceConstant';

const TAG: string = 'BasicServiceUtil';


/**
 * 基础服务声明工具类
 */
export class BasicServiceUtil {
  /**
   * 存储基础服务声明同意状态(存储到Preferences中)
   * @param context context
   * @param isAgreed 是否同意基础服务申明
   */
  public static saveAgreedStatusToSP(context: Context | null, isAgreed: boolean): void {
    if (context === null) {
      LogUtil.error(TAG, 'saveAgreedStatusToSP error. context is null.');
      return;
    }
    let agreeTime: string = new Date().toString();
    let appVersion: string = '';
    try {
      let applicationFlags = bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT;
      let bundleInfo = bundleManager.getBundleInfoForSelfSync(applicationFlags);
      appVersion = bundleInfo.versionName;
    } catch (error) {
      LogUtil.error(TAG, `getBundleInfoForSelfSync error, error code: ${error?.code}, message: ${error?.message}`);
      appVersion = 'unknown';
    }
    let agreeInfoValue: string = `version: ${appVersion}; time: ${agreeTime}; isAgreed: ${isAgreed}`;
    SharePreferences.getInstance()
      .setValue(BasicServiceConstant.KEY_BASIC_SERVICE_AGREE_STATE, agreeInfoValue)
      .catch((err: BusinessError) => {
        HiSysEventUtil.reportErrorEvent(CommonConstant.BS_OPERATION_FAILED,
          `preference set value err. errMsg: ${err.code}  ${err.message}`);
      });
    LogUtil.info(TAG, `save agreedStatus to SharePreferences. isAgreed:${isAgreed}`);
  }

  /**
   * 判断基础服务声明是否存在勾选状态（Preferences存储）
   * @param context context
   */
  public static async isHasAgreedValueFromSP(context: Context | null): Promise<boolean> {
    if (context === null) {
      LogUtil.error(TAG, 'isHasAgreedFromSP error. context is null.');
      HiSysEventUtil.reportErrorEvent(CommonConstant.BS_OPERATION_FAILED,
        'preference is has agree value  err: context is null.');
      return false;
    }
    let value = await SharePreferences.getInstance()
      .hasValue(BasicServiceConstant.KEY_BASIC_SERVICE_AGREE_STATE);
    LogUtil.info(TAG, `isHasAgreedFromSP. value:${value}`);
    return value === true;
  }

  /**
   * 判断基础服务声明是否是勾选状态（Settings存储）
   */
  public static isAgreedFromSettings(): boolean {
    let isAgreed = SettingUtil.getValueSync(CommonConstant.BASIC_STATEMENT_AGREED_KEY, CommonConstant.STATUS_OFF,
      settings.domainName.USER_SECURITY);
    LogUtil.info(TAG, `isAgreedFromSettings. isAgreed:${isAgreed}`);
    return isAgreed === CommonConstant.STATUS_ON;
  }

  /**
   * 存储基础服务声明信息(存储到Preferences中)
   * @param context context
   * @param basicServiceList 基础服务声明
   */
  public static saveBasicStatementsToSP(basicServiceList: Array<ServiceEntity> | null): void {
    if (ArrayUtil.isEmpty(basicServiceList)) {
      LogUtil.error(TAG, 'save error. basicServiceList is empty.');
      return;
    }
    basicServiceList?.forEach((serviceEntity) => {
      SharePreferences.getInstance()
        .setValue(serviceEntity.getServiceName() + CommonConstant.VERSION_SUFFIX, serviceEntity.getVersion());
      LogUtil.info(TAG, `save BasicStatement to SharePreferences. serviceName:${serviceEntity.getServiceName()} version:${serviceEntity.getVersion()}`);
    });
  }

  public static async loadVersionFromSP(): Promise<string> {
    return await SharePreferences.getInstance().getValue('basic_statement_version', '') as string;
  }

  public static saveVersionToSP(version: string): void {
    LogUtil.info(TAG, `saveVersionToSP version: ${version}`);
    SharePreferences.getInstance().setValue('basic_statement_version', version);
  }

  /**
   * 通过解析文件生成基础协议对象，调用方需要自己保证文件存在，且内容合法
   * @param resMgr
   * @param fileName
   * @returns
   */
  public static async genBasicServiceFromFile(fileName: string): Promise<BasicService> {
    let content: string = await RawFileUtil.getStringByFile(fileName).catch((err: BusinessError) => {
      HiSysEventUtil.reportErrorEvent(CommonConstant.BS_OPERATION_FAILED, `
      Get json err. errMsg: ${err.code} ${err.message}`);
    }) as string;
    let basicService: BasicService = JSON.parse(content) as BasicService;
    let services: Object[] = basicService.statementLists;
    let basicServiceList: ServiceEntity[] = [];
    for (let item of services) {
      try {
        let basicService: ServiceEntity | null = await ServiceEntityUtil.genServiceEntity(item);
        if (basicService === null || basicService.getServiceType() !== ServiceType.BASIC) {
          continue;
        }
        basicServiceList.push(basicService);
      } catch (e) {
        HiSysEventUtil.reportErrorEvent(CommonConstant.BS_OPERATION_FAILED,
          `Push service list err. errMsg: ${e.code}  ${e.message}`);
        LogUtil.error(TAG, `Push service list err. errMsg: ${e.code}  ${e.message}`);
      }
    }
    basicService.statementLists = basicServiceList;
    return basicService;
  }

  /**
   * 通过CCM配置判断是否支持版本类型
   *
   * @returns true表示支持，false表示不支持
   */
  public static isSupportVersionType(): boolean {
    let isSupport: string = 'false';
    try {
      isSupport = systemParameterEnhance.getSync(BasicServiceConstant.LICENSE_ENABLE_CCM_CONFIG, 'false');
    } catch (err) {
      LogUtil.error(TAG, `call isSupportVersionType failed, error code: ${err.code}, message: ${err.message}.`);
    }
    return isSupport === 'true';
  }
}
