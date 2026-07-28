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

import {
  ArrayUtil,
  CommonConstant,
  GlobalContext,
  HiSysEventUtil,
  LogUtil,
  ServiceEntity,
  ServiceEntityUtil,
  SharePreferences
} from '@ohos/hwstartupguide.common';
import { CheckStatus, EnhanceServiceUtil } from '@ohos/hwstartupguide.enhanceservice';

const TAG: string = 'EnhanceServiceListModel';

export class EnhanceServiceListModel {
  /**
   * 是否勾选全选的状态
   */
  public isAllChecked: CheckStatus = CheckStatus.NONE_CHECKED;

  /**
   * 声明一个获取所有服务条款列表的方法，并由EnhanceServiceListComp来实现
   */
  public getEntities: () => Array<ServiceEntity> = () => {
    return [];
  };

  /**
   * 声明一个勾选全选的方法，并由EnhanceServiceListComp来实现
   */
  public setEnableAllChecked: (val: boolean) => void = (val: boolean) => {
  };

  /**
   * 声明一个获取全选是否勾选的方法，并由EnhanceServiceListComp来实现
   */
  public getEnableAllChecked: () => boolean = () => {
    return false;
  };

  /**
   * 声明一个获取全选标题的方法，并由EnhanceServiceListComp来实现
   */
  public getAllCheckedTitle: () => string = () => {
    return '';
  };

  constructor() {
  }

  /**
   * 开启或者关闭某一个服务
   * @param serviceItem 一个服务条款的对象
   * @param isOn 是否开启
   */
  public enableEnhanceServiceItem(serviceItem: ServiceEntity, isOn: boolean): void {
    LogUtil.info(TAG, `enableEnhanceServiceItem ${serviceItem.getServiceName()} isOn:${isOn}`);
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `enableEnhanceServiceItem ${serviceItem.getServiceName()} isOn:${isOn}`);
    if (serviceItem) {
      // 过滤出特定的服务协议
      let realEnhancedServices = this.getRealEnhancedService();
      if (ArrayUtil.isEmpty(realEnhancedServices)) {
        LogUtil.warn(TAG, 'enableEnhanceServiceItem failed as real services are empty');
        return;
      }
      for (let serviceItemTemp of realEnhancedServices) {
        if (ServiceEntityUtil.isEquals(serviceItem, serviceItemTemp)) {
          serviceItemTemp.setServiceChecked(isOn);
          break;
        }
      }
      this.updateEnhanceServiceSdStatus(serviceItem, isOn);
      serviceItem.setServiceChecked(isOn);
      this.updateAllCheckedStatus();
    }
  }

  /**
   * 更新所有增强服务的勾选状态
   */
  public updateAllCheckedStatus(): void {
    this.isAllChecked = EnhanceServiceUtil.isEnableAllChecked(this.getRealEnhancedService());
    this.setEnableAllChecked(this.isAllChecked === CheckStatus.ALL_CHECKED);
    LogUtil.info(TAG, `onServiceEntityListChange isAllChecked:${this.isAllChecked},isEnableAllChecked:${this.getEnableAllChecked()}`);
    this.updateEnhanceServiceSdStatus(this.getAllCheckService(), this.getEnableAllChecked());
    this.getAllCheckService()?.setServiceChecked(this.getEnableAllChecked());
  }

  /**
   * 获取代表"全选"的增强服务
   * @returns 一个服务对象，如果不存在则返回undefined
   */
  public getAllCheckService(): ServiceEntity {
    return this.getEntities().filter(i => i?.getTitle() === this.getAllCheckedTitle())[0];
  }

  /**
   * 开启/关闭全部增强协议选项
   * @param isOn true 开启, false 关闭
   */
  public enableAllEnhanceService(isOn: boolean): void {
    this.setEnableAllChecked(isOn);
    LogUtil.info(TAG, `enableAllEnhanceService isEnableAllChecked:${this.getEnableAllChecked()}`);
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `enableEnhanceServiceItem CheckAll isOn:${isOn}`);

    if (ArrayUtil.isEmpty(this.getEntities())) {
      LogUtil.warn(TAG, 'enableAllEnhanceService failed realEnhancedServices is empty.');
      return;
    }
    for (let serviceItem of this.getEntities()) {
      if (!serviceItem) {
        continue;
      }
      if (serviceItem.getTitle() === this.getAllCheckedTitle()) {
        serviceItem.setServiceChecked(isOn);
        this.updateEnhanceServiceSdStatus(serviceItem, isOn);
      } else if (serviceItem.getSwitchDisabled() && serviceItem.isServiceVisible()) {
        serviceItem.setServiceChecked(isOn);
        this.updateEnhanceServiceSdStatus(serviceItem, isOn);
      }
    }
  }

  private updateEnhanceServiceSdStatus(serviceItem: ServiceEntity, isOn: boolean) {
    LogUtil.info(TAG, `updateEnhanceServiceSdStatus to sp: ${serviceItem.getServiceName()}, isOn: ${isOn}`);
    SharePreferences.getInstance().setValue(serviceItem.getServiceName(), isOn);
  }

  /**
   * 筛选除了全选之外的可见服务列表
   * @returns 服务列表
   */
  private getRealEnhancedService(): Array<ServiceEntity> {
    let realEnhancedService: ServiceEntity[] = this.getEntities().filter(i => i && i.getTitle() !==
    this.getAllCheckedTitle() && i.isServiceVisible()).slice();
    return realEnhancedService;
  }
}