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
import Want from '@ohos.app.ability.Want';
import deviceInfo from '@ohos.deviceInfo';
import bundleManager from '@ohos.bundle.bundleManager';
import resourceManager from '@ohos.resourceManager';
import { BusinessError } from '@ohos.base';
import resmgr from '@ohos.resourceManager';
import { ArrayUtil } from './ArrayUtil';
import { ServiceEntity } from '../model/ServiceEntity';
import { LogUtil } from './LogUtil';
import { AbilityManager } from '../manager/AbilityManager';
import { RawFileUtil } from './RawFileUtil';
import { ResourceUtil } from './ResourceUtil';
import { StringUtil } from './StringUtil';
import { ProtocolContent } from '../model/ProtocolContent';
import { CommonConstant } from '../constant/CommonConstant';
import { Declaration } from './Declaration';
import { ResourceStringUtil } from './ResourceStringUtil';

const TAG: string = 'ServiceEntityUtil';
const RAWFILE: string = 'rawfile:';
const JSON_SUFFIX: string = 'json';
const PAGE_PREFIX: string = 'page=';
const DECLARATION: string = 'privacy_statement.json';

/**
 * 服务声明工具类
 */
export class ServiceEntityUtil {

  /**
   * 生成服务声明对象
   * @param jsonObj json对象
   */
  public static genServiceEntity(jsonObj: Object): Promise<ServiceEntity | null> {
    LogUtil.info(TAG, 'genServiceEntity start');
    return new Promise((resolve) => {
      try {
        let serviceEntity: ServiceEntity = new ServiceEntity(jsonObj);
        LogUtil.info(TAG, `genServiceEntity begin. serviceName:${serviceEntity.getServiceName()}`);
        let metadata: bundleManager.Metadata | null = ResourceUtil.getMetadata(serviceEntity.getPackageName(),
          serviceEntity.getModuleName(), serviceEntity.getServiceName());
        if (metadata === null || StringUtil.isEmpty(metadata.value)) {
          LogUtil.error(TAG, `metadata value is null, serviceEntity:${serviceEntity.getServiceName()}`);
          resolve(null);
        }
        if (!metadata?.value.startsWith(RAWFILE) || !metadata?.value.endsWith(JSON_SUFFIX)) {
          LogUtil.error(TAG, `metadata value is invalid, metadata.value:${metadata?.value}`);
          resolve(null);
        }
        // 保存同意时间、同意版本
        let bundleInfo = bundleManager.getBundleInfoSync(serviceEntity.getPackageName(),
          bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
        if (bundleInfo !== null && bundleInfo.versionName !== undefined) {
          serviceEntity.setAgreeVersion(bundleInfo.versionName);
        }
        serviceEntity.setAgreeTime(new Date().toString());
        let fileName = metadata?.value.substr(RAWFILE.length, metadata?.value.length - RAWFILE.length) as string;
        let resourceManager = ResourceUtil.getBundleResourceManager(serviceEntity.getPackageName(),
          AbilityManager.getInstance().getContext()) as resmgr.ResourceManager;
        RawFileUtil.getStringByFile(fileName, resourceManager).then((content: string) => {
          let jsonContent: ProtocolContent = JSON.parse(content);
          ServiceEntityUtil.genProtocolContent(serviceEntity, jsonContent, resourceManager);
          LogUtil.info(TAG, `getStringByFile ${serviceEntity.getServiceName()}  success`);
          resolve(serviceEntity);
        }).catch((e: BusinessError) => {
          LogUtil.error(TAG, `getStringByFile error. fileName:${fileName} ${e?.code} ${e?.message}`);
          resolve(null);
        });
      } catch (err) {
        LogUtil.error(TAG, `genServiceEntity error: ${err}`);
        resolve(null);
      }
    });
  }

  /**
   * 判断两个声明是否是相同的声明
   * @param serviceEntity1 声明1
   * @param serviceEntity2 声明2
   */
  public static isEquals(serviceEntity1: ServiceEntity, serviceEntity2: ServiceEntity): boolean {
    if (serviceEntity1.getServiceName() !== serviceEntity2.getServiceName()) {
      return false;
    }
    if (serviceEntity1.getPackageName() !== serviceEntity2.getPackageName()) {
      return false;
    }
    if (serviceEntity1.getModuleName() !== serviceEntity2.getModuleName()) {
      return false;
    }
    if (serviceEntity1.getServiceType() !== serviceEntity2.getServiceType()) {
      return false;
    }
    return true;
  }

  /**
   * 刷新服务申明列表（拷贝克隆数组内部对象）
   * @param serviceEntityList 服务申明列表
   */
  public static refreshServiceEntityArr(serviceEntityList: Array<ServiceEntity>): void {
    if (ArrayUtil.isEmpty(serviceEntityList)) {
      return;
    }
    for (let index = 0; index < serviceEntityList.length; index++) {
      if (serviceEntityList[index] === null) {
        continue;
      }
      serviceEntityList[index] = serviceEntityList[index].getCopyObject();
    }
  }

  /**
   *解析外部应用的协议配置文件
   * @param serviceEntity
   * @param jsonObj
   * @param resourceManager
   */
  public static genProtocolContent(serviceEntity: ServiceEntity, jsonObj: ProtocolContent,
    resourceManager: resmgr.ResourceManager): void {
    if (!serviceEntity || !jsonObj) {
      return;
    }
    try {
      serviceEntity.setVersion(Number.parseFloat(jsonObj.version));
      serviceEntity.setTitle(ResourceUtil.getResourceString(resourceManager, jsonObj.title));
      serviceEntity.setContent(ResourceUtil.getResourceString(resourceManager, jsonObj.content));
      if (serviceEntity.getCustomizedCheckStatusConfig()) {
        if (ArrayUtil.isNotEmpty(jsonObj.visibleRules)) {
          for (let obj of jsonObj.visibleRules) {
            serviceEntity.addVisibleRules(obj);
          }
        }
        if (jsonObj.customizedDefaultCheckStatus !== undefined && jsonObj.customizedDefaultCheckStatus !== null) {
          serviceEntity.setCustomizedDefaultCheckStatus(jsonObj.customizedDefaultCheckStatus);
        }
      }
      if (ArrayUtil.isNotEmpty(jsonObj.params)) {
        for (let item of jsonObj.params) {
          if (item) {
            let paramValue: string = ResourceUtil.getResourceString(resourceManager, item.value);
            serviceEntity.addParamValue(item.name, paramValue);
          }
        }
      }
      if (ArrayUtil.isNotEmpty(jsonObj.abilities)) {
        for (let obj of jsonObj.abilities) {
          if (obj) {
            serviceEntity.addAbility(obj.key, obj.value);
          }
        }
      }
    } catch (e) {
      LogUtil.error(TAG, `genProtocolContent e:${e?.errorMsg} ${serviceEntity?.getServiceName()}`);
    }
  }

  /**
   * 获取页面需展示的字符串
   * @param resourceManager
   * @returns 根据系统语言获取的协议字串
   */
  public static async getServiceEntity(resourceManager: resourceManager.ResourceManager): Promise<ServiceEntity[]> {
    let mBasicServiceList: ServiceEntity[] = [];
    let declarations: Declaration[] = await ServiceEntityUtil.parseDeclarationConfigs();
    declarations.forEach((declaration: Declaration) => {
      let mDeviceAgreementEntity = new ServiceEntity(new Object());
      mDeviceAgreementEntity.setTitle(ResourceUtil.getResourceString(resourceManager,
        `$string:${declaration.title}`));
      mDeviceAgreementEntity.setContent(ResourceStringUtil.getPrivacyStatementContent(declaration.content,
        declaration.type));
      mBasicServiceList.push(mDeviceAgreementEntity);
    })
    return mBasicServiceList;
  }

  public static getDetailUrlByPrivacyWant(htmlName: string | undefined, curLanguage: string, curRegion: string) {
    let page : string = 'copyright.html';
    if (htmlName) {
      let start = htmlName.indexOf(PAGE_PREFIX);
      if (start != -1) {
        page = htmlName.substring(start + PAGE_PREFIX.length);
      }
    }
    let deviceType = deviceInfo.deviceType;
    //  需支持中英港台藏维六种语言，语言选择页仅支持中英繁藏维五种，选择繁体后通过获取系统地区来判断是何种繁体
    LogUtil.info(TAG, `getSystemLanguage begin. The current system language is:${curLanguage}`);
    if (CommonConstant.SUPPORT_LANGUAGES.indexOf(curLanguage) === -1) {
      curLanguage = CommonConstant.SUPPORT_LANGUAGES[0];
    } else {
      if (curLanguage === 'zh-Hant') {
        LogUtil.info(TAG, `getSystemRegion begin. The current system region is:${curRegion}`);
        if (curRegion === 'HK') {
          curLanguage = 'zh_HK';
        } else {
          curLanguage = 'zh_TW';
        }
      }
    }
    return `html/endUserSoftwareLicense/${curLanguage}/${page}?device=${deviceType}`;
  }

  /**
   * 解析协议与声明页面的json文件
   * @returns 解析完成后的配置
   */
  public static async parseDeclarationConfigs(): Promise<Declaration[]> {
    LogUtil.info(TAG, 'start to parseDeclarationConfigs');
    return new Promise((resolve, reject) => {
      let declarations: Declaration[] = [];
      RawFileUtil.getStringByFile(DECLARATION).then((content: string) => {
        let jsonArray: object[] = JSON.parse(content);
        for (let jsonObj of jsonArray) {
          let declaration: Declaration = new Declaration(jsonObj);
          declarations.push(declaration);
        }
        resolve(declarations);
      })
        .catch((err: BusinessError) => {
          reject(err);
        });
    });
  }
}
