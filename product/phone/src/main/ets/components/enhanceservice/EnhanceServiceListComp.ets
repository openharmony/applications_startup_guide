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
  HeadAnimateModifier,
  HeadManager,
  HiSysEventUtil,
  LogUtil,
  ResourceUtil,
  ServiceEntity,
  StringUtil,
  SystemMaterialManager
} from '@ohos/hwstartupguide.common';
import {
  CheckStatus,
  EnhanceServicePageController,
  EnhanceServiceUtil,
  TitleCheckBox
} from '@ohos/hwstartupguide.enhanceservice';
import { EnhanceServiceItemComp } from './EnhanceServiceItemComp';
import { EnhanceServiceListModel } from '../../model/enhanceservice/EnhanceServiceListModel';

const ENABLE_ALL_ENHANCED_SERVICES: string = 'ENABLE_ALL_ENHANCED_SERVICES';
const TAG: string = 'EnhanceServiceListComp';

/**
 * 增强服务声明列表组件
 */
@Component
export struct EnhanceServiceListComp {
  @Link @Watch('onServiceEntityListChange') mServiceEntities: Array<ServiceEntity>;
  @StorageLink('isPortraitOrientation') isPortraitOrientation: boolean = false;
  @State isEnableAllChecked: boolean = false;
  deviceAgreementTitle: string = '';
  controller?: EnhanceServicePageController;
  private model: EnhanceServiceListModel = new EnhanceServiceListModel();
  scroller: Scroller = new Scroller();
  headManager?: HeadManager;

  build() {
    Row() {
      List({ scroller: this.scroller }) {
        if (this.controller?.isOTA) {
          ListItem() {
            Column() {
              Text($r('app.string.ota_enhance_service_update'))
                .id('text_ser _statement')
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
                .fontWeight(FontWeight.Medium)
                .textAlign(TextAlign.Start)
                .lineHeight($r('app.float.lineHeight_21'))
                .margin({
                  bottom: $r('app.float.distance_8'),
                })
            }
            .justifyContent(FlexAlign.End)
            .padding({
              left: $r('sys.float.ohos_id_default_padding_start'),
            })
          }
        }
        ForEach(this.mServiceEntities, (serviceItem: ServiceEntity) => {
          ListItem() {
            if (serviceItem?.getTitle() === this.deviceAgreementTitle) {
              // 全选增强服务
              Row() {
                TitleCheckBox({
                  mTitle: $r('app.string.open_all_enhance_service'),
                  isOn: $isEnableAllChecked,
                  mOnChange: (isOn: boolean) => {
                    HiSysEventUtil.reportUserEvent(ENABLE_ALL_ENHANCED_SERVICES, 'in the Enhanced Services Statement',
                      isOn);
                    this.model.updateAllCheckedStatus();
                    if (this.model.isAllChecked !== CheckStatus.PARTIAL_CHECKED || isOn) {
                      this.model.enableAllEnhanceService(isOn);
                    }
                  },
                })
              }
              .constraintSize({
                minHeight: $r('app.float.wh_value_56')
              })
              .width('100%')
              .align(Alignment.Center)
              .borderRadius($r('app.float.distance_16'))
              .backgroundColor(SystemMaterialManager.listBackgroundColor())
              .margin({
                bottom: $r('app.float.margin_16'),
              })
              .padding({
                top: $r('app.float.padding_16'),
                bottom: $r('app.float.padding_16'),
              })
            } else {
              // 增强协议子项
              EnhanceServiceItemComp({
                mServiceEntity: serviceItem,
                mOnCheckStatusChange: (isOn) => {
                  LogUtil.info(TAG, `item callback isOn:${isOn}`);
                  this.enableEnhanceServiceItem(serviceItem, isOn);
                },
              })
                .margin({
                  bottom: $r('app.float.margin_16'),
                })
            }
          }
          .visibility(serviceItem?.isServiceVisible() === true ? Visibility.Visible : Visibility.None)
          .id(`listitem_enhanced_service_${serviceItem.getServiceName()}`)
          .width('100%')
        })
      }
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .attributeModifier(new HeadAnimateModifier(this.getUIContext(), this.headManager, this.scroller, false, true))
      .height('100%')
      .borderRadius($r('app.float.radius_value_16'))
      .width('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
  }

  aboutToAppear(): void {
    this.model.getEntities = () => {
      return this.mServiceEntities;
    };

    this.model.setEnableAllChecked = (val: boolean) => {
      this.isEnableAllChecked = val;
    };

    this.model.getEnableAllChecked = () => {
      return this.isEnableAllChecked;
    };

    this.model.getAllCheckedTitle = () => {
      return this.deviceAgreementTitle;
    };

    this.deviceAgreementTitle = ResourceUtil.getStringByResource({
      bundleName: $r('app.string.open_all_enhance_service').bundleName,
      moduleName: $r('app.string.open_all_enhance_service').moduleName,
      id: $r('app.string.open_all_enhance_service').id,
    });

    this.isEnableAllChecked = EnhanceServiceUtil.getAllEnhancedChecked(this.mServiceEntities);
  }

  onServiceEntityListChange(): void {
    this.isEnableAllChecked = this.model.getAllCheckService()?.isServiceChecked() ?? false;
  }

  /**
   * 勾选单项增强服务
   * @param serviceItem 要勾选的服务对象
   * @param isOn true 表示开启， false 表示关闭
   */
  private enableEnhanceServiceItem(serviceItem: ServiceEntity, isOn: boolean): void {
    LogUtil.info(TAG, `enableEnhanceServiceItem ${serviceItem.getServiceName()} isOn:${isOn}`);
    this.model.enableEnhanceServiceItem(serviceItem, isOn);
  }
}
