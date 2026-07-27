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
import worker from '@ohos.worker';
import emitter from '@ohos.events.emitter';
import common from '@ohos.app.ability.common';
import {
  ArrayUtil,
  BasePageController,
  CommonConstant,
  GlobalContext,
  HiSysEventUtil,
  HiViewXUtil,
  IPageOrderController,
  LogUtil,
  OOBEUtil,
  PageKey,
  RawFileUtil,
  ResourceUtil,
  ServiceEntity,
  ServiceEntityUtil,
  ServiceType,
  EMPTY_IDENTIFY,
  Event,
  SceneTypeManager
} from '@ohos/hwstartupguide.common';
import { EnhanceServiceConstant } from '../factory/savehandler/EnhanceServiceConstant';
import { EnhanceServiceUtil } from '../util/EnhanceServiceUtil';

const TAG: string = 'EnhanceServicePageController';

/**
 * 增强服务声明控制器
 */
export class EnhanceServicePageController extends BasePageController {
  private mConfigFileName: string = 'enhance_service_statements.json';
  private mEnhanceServiceList: ServiceEntity[] = [];
  private mEnhanceWorker: worker.ThreadWorker = new worker.ThreadWorker('../workers/EnhanceServiceWorker'
    , { name: 'EnhanceServiceWorker' });
  private isInit: boolean = false;
  public isOTA: boolean = false;

  /**
   * 构造函数
   * @param pageOrderController 页面顺序控制器
   * @param controllerKey 控制器key
   */
  public constructor(pageOrderController: IPageOrderController) {
    super(pageOrderController, PageKey.ENHANCED_SERVICE);
    emitter.on(Event.LANGUAGE_CONFIGURATION_UPDATE, () => {
      LogUtil.info(TAG, 'language configuration update');
      this.isInit = false;
    });
  }

  async configNeedShow(): Promise<void> {
    await super.configNeedShow();
    HiViewXUtil.registerDataShareListener();
  }

  loadData(): void {
    if (!SceneTypeManager.getInstance().isOtaScene()) {
      setTimeout(() => {
        this.initEnhanceServiceList();
      }, 0);
    }
  }

  /**
   * 设置协议子项显示/不显示
   *
   * @param enhanceService 服务声明
   */
  async setServiceVisible(enhanceService: ServiceEntity) {
    let visibleStatus: boolean = true;
    let isVisibleRulesEmpty: boolean = ArrayUtil.isEmpty(enhanceService.getVisibleRules());
    if (enhanceService.getCustomizedCheckStatusConfig() && this.isOTA && !isVisibleRulesEmpty) {
      visibleStatus = EnhanceServiceUtil.getCustomizedVisible(enhanceService);
    } else {
      visibleStatus = await EnhanceServiceUtil.getTempVisible(this.mUIAbility?.context as
      common.UIAbilityContext, enhanceService);
    }
    LogUtil.info(TAG, `visibleStatus: ${visibleStatus}, enhanceService name: ${enhanceService.getServiceName()}`);
    enhanceService.setServiceVisible(visibleStatus);
  }

  /**
   * 初始化增强服务声明
   */
  async initEnhanceServiceList(): Promise<void> {
    if (this.isInit) {
      this.mEnhanceServiceList?.forEach(serviceEntity => {
        this.setServiceVisible(serviceEntity);
      });
      LogUtil.info(this.getKey(), 'already initialized , will return');
      return;
    }
    this.isInit = true;
    LogUtil.info(this.getKey(), 'initEnhanceServiceList');
    let content = await RawFileUtil.getStringByFile(this.mConfigFileName).catch((err: BusinessError) => {
      HiSysEventUtil.reportErrorEvent(CommonConstant.ES_OPERATION_FAILED,
        `Get json err. errMsg: ${err.code}  ${err.message}`);
    });

    if (content) {
      let services: Object[] = JSON.parse(content);
      let enhanceServiceList: ServiceEntity[] = [];
      for (let item of services) {
        try {
          let enhanceService: ServiceEntity | null = await ServiceEntityUtil.genServiceEntity(item);
          if (enhanceService === null || enhanceService.getServiceType() !== ServiceType.ENHANCE) {
            continue;
          }
          await this.setServiceVisible(enhanceService);
          if (!enhanceService.isServiceVisible()) {
            continue;
          }
          if (enhanceService.getCustomizedCheckStatusConfig() && this.isOTA && enhanceService.isServiceVisible()) {
            await this.setServiceCustomizedChecked(enhanceService);
            LogUtil.info(TAG, `CustomizedCheckStatusConfig is:${enhanceService.getCustomizedCheckStatusConfig()},
              status:${enhanceService.getCustomizedDefaultCheckStatus()},
              isChecked:${enhanceService.isServiceChecked()}`);
          } else {
            let checkStatus = await EnhanceServiceUtil.getTempCheckStatus(this.mUIAbility?.context as
            common.UIAbilityContext, enhanceService);
            enhanceService.setServiceChecked(checkStatus);
          }
          let switchDisabledStatus = await EnhanceServiceUtil.getTempSwitchDisabled(this.mUIAbility?.context as
          common.UIAbilityContext, enhanceService);
          enhanceService.setSwitchDisabled(switchDisabledStatus);
          LogUtil.debug(this.getKey(), `add service, service name: ${enhanceService.getServiceName()}, isChecked:
            ${enhanceService.isChecked}, isVisible: ${enhanceService.isServiceVisible()}, isDisable:
            ${enhanceService.getSwitchDisabled()}`);
          enhanceServiceList.push(enhanceService);
        } catch (e) {
          HiSysEventUtil.reportErrorEvent(CommonConstant.ES_OPERATION_FAILED,
            `Push service list err. errMsg: ${e?.code}  ${e?.message}`);
          LogUtil.error(this.getKey(), `Push service list err. errMsg: ${e?.code}  ${e?.message}`);
        }
      }
      this.mEnhanceServiceList = enhanceServiceList;
      if (this.isOTA) {
        this.mEnhanceServiceList = await this.dataFilter(enhanceServiceList);
        if (this.mEnhanceServiceList.length === 0) {
          this.setNeedShow(false);
        }
      }
      this.addOpenAll();
      HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON,
        `init enhance_service_list size: ${enhanceServiceList.length}`);
    }
  }

  /**
   * 设置自动引导默认开关
   *
   * @param enhanceService 服务声明
   */
  private async setServiceCustomizedChecked(enhanceService: ServiceEntity): Promise<void> {
    if (enhanceService.getCustomizedDefaultCheckStatus() === undefined) {
      LogUtil.warn(TAG, `customized default checkStatus is undifined!, visible rules empty is:
        ${ArrayUtil.isEmpty(enhanceService.getVisibleRules())}`);
      let checkStatus = await EnhanceServiceUtil.getTempCheckStatus(this.mUIAbility?.context as common.UIAbilityContext,
        enhanceService);
      enhanceService.setCustomizedDefaultCheckStatus(checkStatus);
    }
    enhanceService.setServiceChecked(enhanceService.getCustomizedDefaultCheckStatus() as boolean);
  }

  private addOpenAll(): void {
    let mDeviceAgreementEntity = new ServiceEntity();
    let allCheckTitle: string = ResourceUtil.getStringByResource({
      bundleName: $r('app.string.open_all_enhance_service').bundleName,
      moduleName: $r('app.string.open_all_enhance_service').moduleName,
      id: $r('app.string.open_all_enhance_service').id,
    });
    mDeviceAgreementEntity.setTitle(allCheckTitle);
    mDeviceAgreementEntity.setServiceName(EnhanceServiceConstant.KEY_ENHANCE_SERVICE_AGREE_STATE);
    let checkStatus = EnhanceServiceUtil.getAllEnhancedChecked(this.mEnhanceServiceList);
    if (typeof checkStatus === 'boolean') {
      mDeviceAgreementEntity.setServiceChecked(checkStatus);
    }
    this.mEnhanceServiceList.unshift(mDeviceAgreementEntity);
    LogUtil.info(TAG, `aboutToAppear size:${this.mEnhanceServiceList.length}`);
  }

  /**
   * 获取增强服务声明
   */
  getEnhanceServiceList(): Array<ServiceEntity> {
    return this.mEnhanceServiceList;
  }

  /**
   * 更新增强服务声明
   */
  setEnhanceServiceList(mEnhanceServiceList: Array<ServiceEntity>): void {
    this.mEnhanceServiceList = mEnhanceServiceList;
  }

  /**
   * 点击下一页
   * 保证写完settingsdata数据库再拉起服务的异步临时解决方案
   * 可能会导致点击完成按钮画面消失稍慢，后续增强协议之后接入其他页面，保证充分时间写完数据库可改回同步方式
   */
  public handleNextButtonClick(): void {
    // 畅连服务开启标记位
    super.handleNextButtonClick();
  }

  private async dataFilter(serviceList: ServiceEntity[]): Promise<ServiceEntity[]> {
    let tempServiceList: ServiceEntity[] = [];
    for (let item of serviceList) {
      if (!item.isServiceVisible()) {
        LogUtil.info(TAG, `${item.getServiceName()} ServiceVisible: ${item.isServiceVisible()}`);
        continue;
      }
      let version = item.getVersion().toString();
      let versionSP = await EnhanceServiceUtil.getVersionFromSP(item);
      LogUtil.info(TAG, `${item.getServiceName()} versrion: ${version}, versionSP: ${versionSP}`);
      if (versionSP === EMPTY_IDENTIFY || version !== versionSP) { // 没存储过
        tempServiceList.push(item);
      }
    }
    return tempServiceList;
  }

  /**
   * 存储数据
   */
  public saveEnhanceServiceData(): void {
    LogUtil.info(this.getKey(), 'saveEnhanceServiceDataStart');
    if (ArrayUtil.isEmpty(this.mEnhanceServiceList)) {
      return;
    }
    EnhanceServiceUtil.deleteExcludeServicesStatusFromSp(this.mEnhanceServiceList);
    this.mEnhanceServiceList.forEach(item => {
      if (item.isServiceVisible()) {
        GlobalContext.getInstance().setObject(item.getServiceName(), item.isChecked);
        HiSysEventUtil.reportEnhancedServiceEvent(item.getServiceName(), item.isChecked);
      }
    });
    LogUtil.info(this.getKey(), `cache service items, size: ${this.mEnhanceServiceList.length}`);
    let msg: PostMessage = {
      list: JSON.stringify(this.mEnhanceServiceList),
      context: this.getAbility()?.context,
    }
    try {
      this.mEnhanceWorker.postMessage(msg);
    } catch (err) {
      LogUtil.error(this.getKey(), `enhanceWorker exception ${err?.msg}`);
    }
  }

  public updateMeetimeState(): void {
    let meetimeServiceFilter =
      this.mEnhanceServiceList.filter(i => i.getServiceName() === 'meetime_enhance_statement' &&
        i.isServiceChecked() === true);
    if (meetimeServiceFilter.length === 1) {
      OOBEUtil.isMeeTimeEnhanceService = true;
      LogUtil.info(this.getKey(), 'isMeeTimeEnhanceService is true');
    }
  }

  /**
   * 设置worker的onMessage回调
   *
   * @param callback worker的onMessage回调
   */
  public setWorkerOnMessage(callback: Function): void {
    this.mEnhanceWorker.onmessage = (): void => {
      callback();
    }
  }
}

export interface PostMessage {
  list: string;
  context: Context | undefined;
}
