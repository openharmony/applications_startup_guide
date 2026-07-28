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
import { BusinessError } from '@ohos.base';
import settings from '@ohos.settings';
import type common from '@ohos.app.ability.common';
import {
  ArrayUtil,
  CommonConstant,
  HiSysEventUtil,
  HiViewXUtil,
  LogUtil,
  ValidatorUtil,
  ServiceEntity,
  SettingUtil,
  SharePreferences,
  SystemParameterUtil,
  GlobalContext,
  EMPTY_IDENTIFY
} from '@ohos/hwstartupguide.common';
import { SaveDataFactory } from '../factory/SaveDataFactory';
import { EnhanceServiceConstant } from '../factory/savehandler/EnhanceServiceConstant';
import { ISaveDataHandler } from '../factory/savehandler/ISaveDataHandler';

const TAG: string = 'EnhanceServiceUtil';
const PARAM_NUMBER_TWO: number = 2;
const PARAM_NUMBER_THREE: number = 3;

/**
 * 增强服务声明工具类
 */
export class EnhanceServiceUtil {

  /**
   * 将保存在sp中开关状态从sp文件删除
   */
  public static deleteExcludeServicesStatusFromSp(list: ServiceEntity[]): void {
    let keyList: string[] = [];
    list.forEach((item) => {
      keyList.push(item.getServiceName());
    })
    SharePreferences.getInstance().deleteValueAsync(keyList);
  }

  /**
   * 获取服务声明临时选择状态
   * @param context 上下文
   * @param serviceEntity 服务声明
   */
  public static async getTempCheckStatus(context: Context, serviceEntity: ServiceEntity): Promise<boolean> {
    let result = await EnhanceServiceUtil.getTempCheckStatusAsync(context, serviceEntity);
    return new Promise((resolve, reject) => {
      if (result === undefined) {
        reject();
      } else {
        resolve(result);
      }
    });
  }

  /**
   * 获取协议选项复选框选择状态
   * @param context 上下文
   * @param serviceEntity 协议选项描述对象
   * @returns 协议选项复选框选择状态，获取到为boolean 或者 获取不到为未定义。
   */
  public static async getTempCheckStatusAsync(context: Context,
    serviceEntity: ServiceEntity): Promise<boolean | undefined> {
    if (serviceEntity === null || context === null) {
      LogUtil.warn(TAG, 'getTempCheckStatus failed. serviceEntity or context is null');
      HiSysEventUtil.reportErrorEvent(CommonConstant.ES_OPERATION_FAILED,
        'Get temp check status err: serviceEntity or context is null');
      return undefined;
    }
    let checkboxList: string[] = serviceEntity.getCheckboxList();
    if (checkboxList.length === 0) {
      LogUtil.warn(TAG, 'checkbox length is 0');
      return undefined;
    }
    //先读取SP,重启场景
    let isChecked: boolean | undefined = undefined;
    let hasServiceEntity: boolean = await SharePreferences.getInstance().hasValue(serviceEntity.getServiceName());
    if (hasServiceEntity) {
      isChecked =
        await SharePreferences.getInstance().getValue(serviceEntity.getServiceName(), true) as boolean;
      LogUtil.info(TAG, `${serviceEntity.getServiceName()} from sp is checked: ${isChecked}`);
      if (isChecked !== undefined) {
        return isChecked;
      }
    }
    //升级或新机场景直接从数据库读取
    const saveList: [string, string] = EnhanceServiceUtil.getTableNameAndKey(checkboxList[0]);
    let hasDefaultCheckStatus: boolean = serviceEntity.getDefaultCheckStatus();
    let checkboxListStatus = await SettingUtil.getValue(saveList[1], CommonConstant.INVALID_VALUE, saveList[0]);
    LogUtil.info(TAG, `serviceStatus name:${saveList[1]}, settingsdata value:${checkboxListStatus}`);
    if (typeof checkboxListStatus === 'string') {
      if (checkboxListStatus !== CommonConstant.INVALID_VALUE) {
        // settingsdata中存在值，则以settingsdata存储值为准
        if (checkboxListStatus === CommonConstant.STATUS_ON) {
          return true;
        } else if (checkboxListStatus === CommonConstant.STATUS_OFF) {
          return false;
        }
        // settingsdata中不存在值且设置了hasDefaultCheckStatus为关
      } else if (!hasDefaultCheckStatus) {
        return false;
      }
    }
    // settingsdata中不存在值默认为开
    return true;
  }

  /**
   * 获取服务声明开关是否不可操作
   * @param context 上下文
   * @param serviceEntity 服务声明
   */
  public static getTempSwitchDisabled(context: Context, serviceEntity: ServiceEntity): Promise<boolean> {
    return new Promise((resolve, reject) => {
      if (serviceEntity === null || context === null) {
        LogUtil.error(TAG, 'getTempForceCheckStatus failed. serviceEntity or context is null');
        HiSysEventUtil.reportErrorEvent(CommonConstant.ES_OPERATION_FAILED,
          'Get temp switch disabled status err: serviceEntity or context is null');
        reject();
        return;
      }
      if (serviceEntity.getServiceName() === EnhanceServiceConstant.HIVIEWXSERVICENAME) {
        LogUtil.info(TAG, `isSwitchDisabled: ${HiViewXUtil.isSwitchDisabled()}`);
        // HiViewXUtil接口返回true时，输出的false用于TitleCheckBox组件的enabled属性
        if (HiViewXUtil.isSwitchDisabled() === true) {
          LogUtil.info(TAG, `Enter_isSwitchDisabled`);
          resolve(false);
        }
        resolve(true);
      }
      resolve(true);
    });
  }

  /**
   * 获取校验器显示规则
   * @param context 上下文
   * @param serviceEntity 服务声明
   */
  public static getTempVisible(context: Context, serviceEntity: ServiceEntity): Promise<boolean> {
    return new Promise((resolve, reject) => {
      if (serviceEntity === null || context === null) {
        LogUtil.error(TAG, 'getTempVisibleStatus failed. serviceEntity or context is null');
        HiSysEventUtil.reportErrorEvent(CommonConstant.ES_OPERATION_FAILED,
          'Get temp visible status err: serviceEntity or context is null');
        reject();
        return;
      }
      let validatorList: string[] = serviceEntity.getValidatorList();
      LogUtil.info(TAG, `validatorListis: ${validatorList}`);
      if (ArrayUtil.isEmpty(validatorList)) {
        resolve(true);
        return;
      }
      try {
        let result = true;
        for (let i = 0; i < validatorList.length; i++) {
          let params = validatorList[i].split('=');
          const type = params[0];
          const keyValue = params[1];
          if (params.length === PARAM_NUMBER_THREE) {
            const value = params[2];
            if (type === EnhanceServiceConstant.VALIDATOR_SYS_PARAMETER) {
              LogUtil.info(TAG, EnhanceServiceConstant.VALIDATOR_SYS_PARAMETER);
              const sysParameterConfig: string = SystemParameterUtil.getSync(keyValue, '');
              result &&= (sysParameterConfig === value);
            } else if (type === EnhanceServiceConstant.VALIDATOR_SETTINGS) {
              LogUtil.info(TAG, EnhanceServiceConstant.VALIDATOR_SETTINGS);
              const tableKeyName = keyValue.split(',');
              let settingsConfig: string =
                       SettingUtil.getValueSync(tableKeyName[1], CommonConstant.STATUS_OFF, tableKeyName[0]);
              result &&= (settingsConfig === value);
            }
          } else if (params.length === PARAM_NUMBER_TWO && type === EnhanceServiceConstant.VALIDATOR_CUSTOM) {
            LogUtil.info(TAG, EnhanceServiceConstant.VALIDATOR_CUSTOM);
            const validatorUtil = new ValidatorUtil();
            const customFunction: Function = Reflect.get(validatorUtil, keyValue, validatorUtil);
            result &&= customFunction();
          }
          if (!result) {
            resolve(result);
          }
        }
        resolve(result);
      } catch (error) {
        LogUtil.error(TAG, `validator error: ${error.code}, ${error.message}`);
      }
      resolve(true);
    });
  }

  /**
   * 获取应用自定义校验器显示规则结果
   *
   * @param serviceEntity 服务声明
   * @returns 协议显示/不显示
   */
  public static getCustomizedVisible(serviceEntity: ServiceEntity): boolean {
    if (!serviceEntity) {
      LogUtil.error(TAG, 'getCustomizedVisible failed. serviceEntity is null');
      return false;
    }
    let customizedVisibleCRules: string[] = serviceEntity.getVisibleRules();
    try {
      let result = true;
      for (let i = 0; i < customizedVisibleCRules.length; i++) {
        result &&= EnhanceServiceUtil.getValidatorRes(customizedVisibleCRules[i]);
        if (!result) {
          return result;
        }
      }
      LogUtil.info(TAG, `customized visible result is:${result}`);
      return result;
    } catch (error) {
      LogUtil.error(TAG, `getCustomizedVisible error: ${error.code}, ${error.message}`);
    }
    return true;
  }

  /**
   * 解析单个校验器显示规则结果
   *
   * @param validatorStr 校验器显示规则
   * @returns 单个校验器显示规则结果
   */
  private static getValidatorRes(validatorStr: string): boolean {
    let params = validatorStr.split('=');
    if (ArrayUtil.isEmpty(params) || params.length < PARAM_NUMBER_TWO) {
      LogUtil.error(TAG, 'validator rule is empty!');
      return true;
    }
    try {
      const saveDataType = params[0];
      const keyValue = params[1];
      if (params.length === PARAM_NUMBER_THREE) {
        const value = params[2];
        if (saveDataType === EnhanceServiceConstant.VALIDATOR_SYS_PARAMETER) {
          LogUtil.info(TAG, EnhanceServiceConstant.VALIDATOR_SYS_PARAMETER);
          const sysParameterConfig: string = SystemParameterUtil.getSync(keyValue, '');
          return (sysParameterConfig === value);
        } else if (saveDataType === EnhanceServiceConstant.VALIDATOR_SETTINGS) {
          LogUtil.info(TAG, EnhanceServiceConstant.VALIDATOR_SETTINGS);
          const tableKeyName = keyValue.split(',');
          let settingsConfig: string =
            SettingUtil.getValueSync(tableKeyName[1], CommonConstant.STATUS_OFF, tableKeyName[0]);
          return (settingsConfig === value);
        }
      } else if (params.length === PARAM_NUMBER_TWO && saveDataType === EnhanceServiceConstant.VALIDATOR_CUSTOM) {
        LogUtil.info(TAG, EnhanceServiceConstant.VALIDATOR_CUSTOM);
        const validatorUtil = new ValidatorUtil();
        const customFunction: Function = Reflect.get(validatorUtil, keyValue, validatorUtil);
        return customFunction();
      }
    } catch (error) {
      LogUtil.error(TAG, `getValidatorRes error: ${error.code}, ${error.message}`);
    }
    return true;
  }

  /**
   * 设置服务声明临时勾选状态
   * @param context 上下文
   * @param serviceEntity 服务声明
   * @param isOn 勾选状态
   */
  public static setTempCheckStatus(context: Context, serviceEntity: ServiceEntity, isOn: boolean): void {
    if (serviceEntity === null || context === null) {
      LogUtil.error(TAG, 'setTempCheckStatus failed. serviceEntity is null or context is null');
      HiSysEventUtil.reportErrorEvent(CommonConstant.ES_OPERATION_FAILED,
        'Set temp check status err: serviceEntity or context is null');
      return;
    }
    let serviceStatus: string = isOn === true ? CommonConstant.STATUS_ON : CommonConstant.STATUS_OFF;
    let saveDataList: string[] = serviceEntity.getSaveDataListList();
    if (saveDataList.length === 0) {
      return;
    }
    for (let item of saveDataList) {
      const tableNameAndKey: [string, string] = EnhanceServiceUtil.getTableNameAndKey(item);
      let result = false;
      let pageContext: common.Context = GlobalContext.getInstance().getObject('pageContext') as common.Context;
      if (pageContext) {
        result = SettingUtil.setValueSyncWithContextForService(pageContext, tableNameAndKey[1], serviceStatus,
          tableNameAndKey[0]);
      }
      HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `save enhance service ${serviceEntity.getServiceName()} succeed: ${result}`);
    }
  }

  /**
   * 存储增强服务声明版本信息(存储到sharePreferences中)
   * @param context context
   * @param enhanceServiceList 增强服务声明
   */
  public static saveEnhanceStatementsToSP(context: Context | null | undefined,
    enhanceServiceList: ServiceEntity[] | null): void {
    if (context === null || context === undefined) {
      LogUtil.error(TAG, 'saveBasicStatementsToSP error. context is null.');
      return;
    }
    if (ArrayUtil.isEmpty(enhanceServiceList)) {
      LogUtil.error(TAG, 'save error. enhanceServiceList is empty.');
      return;
    }
    enhanceServiceList?.forEach((serviceEntity) => {
      if (serviceEntity.isServiceVisible()) {
        SharePreferences.getInstance()
          .setValue(`${serviceEntity.getServiceName()}${CommonConstant.VERSION_SUFFIX}`, serviceEntity.getVersion(),
            context);
        LogUtil.info(TAG, `save enhanceStatement to SharePreferences. serviceName:${serviceEntity.getServiceName()}
      version:${serviceEntity.getVersion()}`);
      }
    });
  }

  /**
   * 存储服务勾选状态
   * @param context 上下文
   * @param serviceEntity 服务声明
   */
  public static async saveServiceCheckStatus(context: Context, serviceEntity: ServiceEntity): Promise<void> {
    return EnhanceServiceUtil.saveServiceCheckStatusSync(context, serviceEntity);
  }

  public static saveServiceCheckStatusSync(context: Context | undefined, serviceEntity: ServiceEntity): void {
    if (serviceEntity === null || context === null || context === undefined) {
      LogUtil.error(TAG, 'saveServiceCheckStatus failed. serviceEntity is null or context is null');
      return;
    }
    let saveDataList: string[] = serviceEntity.getSaveDataListList();
    if (ArrayUtil.isEmpty(saveDataList)) {
      return;
    }
    try {
      for (let item of saveDataList) {
        let handler: ISaveDataHandler | null = SaveDataFactory.getHandler(item);
        if (handler === null) {
          LogUtil.error(TAG, `saveItemCheckStatus failed ${item}.`);
          HiSysEventUtil.reportErrorEvent(CommonConstant.ES_OPERATION_FAILED,
            'Save Service check status err: serviceEntity or context is null');
          continue;
        }
        handler.saveData(context, item, serviceEntity.isChecked);
        LogUtil.info(TAG, 'saveEnhanceServiceDataEnd');
      }
    } catch (err) {
      LogUtil.error(TAG, `saveCheckStatus getTempCheckStatus error. serviceName:${serviceEntity.getServiceName()}`);
      HiSysEventUtil.reportErrorEvent(CommonConstant.ES_OPERATION_FAILED,
        `Save Service check status err. serviceName:${serviceEntity.getServiceName()}`);
    }
    // 增强服务隐私合规保存同意信息
    try {
      LogUtil.info(TAG, 'saveEnhanceService agree info');
      let agreeInfoKey = EnhanceServiceConstant.AGREE_INFO_PREFIX + serviceEntity.getServiceName();
      let statusValue: string = serviceEntity.isChecked ? CommonConstant.STATUS_ON : CommonConstant.STATUS_OFF;
      let agreeInfoValue = `version:${serviceEntity.getAgreeVersion()}; time:${serviceEntity.getAgreeTime()}; status:${statusValue}`;
      SettingUtil.setValueSyncWithContext(context, agreeInfoKey, agreeInfoValue, settings.domainName.USER_SECURITY);
    } catch (err) {
      LogUtil.error(TAG, `saveEnhanceService agreeInfo error. serviceName:${serviceEntity.getServiceName()}`);
    }
  }

  /**
   * 判断是否所有的增强服务均已勾选
   * 0:都不选；1：部分选中；2：都选
   * @param enhanceServices 增强服务声明数组
   */
  public static isEnableAllChecked(enhanceServices: ServiceEntity[]): CheckStatus {
    if (ArrayUtil.isEmpty(enhanceServices)) {
      return CheckStatus.NONE_CHECKED;
    }
    let cnt = enhanceServices.filter(item => item?.isServiceChecked()).length;
    if (cnt === enhanceServices.length) {
      return CheckStatus.ALL_CHECKED;
    } else if (cnt === 0) {
      return CheckStatus.NONE_CHECKED;
    } else {
      return CheckStatus.PARTIAL_CHECKED;
    }
  }

  /**
   * 查看全选增强服务勾选状态
   */
  public static getAllEnhancedChecked(enhanceServices: ServiceEntity[]): boolean {
    if (ArrayUtil.isEmpty(enhanceServices)) {
      return false;
    }
    let itemOnNum: number = enhanceServices.filter(
      i => i.getServiceName() !== EnhanceServiceConstant.KEY_ENHANCE_SERVICE_AGREE_STATE &&
        i.isServiceVisible() === true && i.isServiceChecked() === true).length;
    LogUtil.info(TAG, `itemOnNum:${itemOnNum}`);

    let allItemNum: number = enhanceServices.filter(
      i => i.getServiceName() !== EnhanceServiceConstant.KEY_ENHANCE_SERVICE_AGREE_STATE &&
        i.isServiceVisible() === true).length;
    LogUtil.info(TAG, `allItemNum:${allItemNum}`);
    if (itemOnNum === allItemNum) {
      return true;
    }
    return false;
  }

  /**
   * 设置全选增强服务勾选状态
   */
  public static async setAllEnhancedChecked(isChecked: boolean): Promise<void> {
    let result = await SharePreferences.getInstance().setValue(
      EnhanceServiceConstant.KEY_ENHANCE_SERVICE_AGREE_STATE, isChecked)
      .catch((err: BusinessError) => {
        HiSysEventUtil.reportErrorEvent(CommonConstant.ES_OPERATION_FAILED,
          `preference set value err. errMsg: ${err.code}  ${err.message}`);
        LogUtil.error(TAG, `preference set value err. errMsg: ${err.code}  ${err.message}`);
      });
    return result;
  }

  /**
   * 解析增强协议的tableName和key
   * @param svaeRuleStr
   * @return [tableName, key]
   */
  public static getTableNameAndKey(saveRuleStr: string): [string, string] {
    saveRuleStr = saveRuleStr.replace(EnhanceServiceConstant.PREFIX, '');
    let tableName: string = settings.domainName.DEVICE_SHARED;
    let key: string = saveRuleStr;
    const saveStatus: string[] = saveRuleStr.split(',');
    if (saveStatus.length === 2) {
      tableName = saveStatus[0].trim().toLowerCase();
      key = saveStatus[1].trim();
    }
    return [tableName, key];
  }

  /**
   * 获取历史版本
   * @param serviceEntity 服务实体
   * @returns 历史版本信息默认为empty
   */
  public static async getVersionFromSP(serviceEntity: ServiceEntity): Promise<string> {
    let key = `${serviceEntity.getServiceName()}${CommonConstant.VERSION_SUFFIX}`;
    let value = await SharePreferences.getInstance().getValue(key, EMPTY_IDENTIFY);
    return value.toString();
  }
}


export enum CheckStatus {
  /**
   * 都不选
   */
  NONE_CHECKED = 0,

  /**
   * 部分选中
   */
  PARTIAL_CHECKED = 1,

  /**
   * 都选
   */
  ALL_CHECKED = 2,
}
