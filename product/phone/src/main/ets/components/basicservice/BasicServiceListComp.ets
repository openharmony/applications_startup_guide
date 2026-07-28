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

import { ServiceEntryDataSource } from '@ohos/hwstartupguide.basicservice';
import {
  CommonConstant,
  EventBus,
  HeadManager,
  HeadAnimateModifier,
  LogUtil,
  ResourceUtil,
  ServiceEntity,
} from '@ohos/hwstartupguide.common';
import { BasicServiceItemComp } from './BasicServiceItemComp';

const TAG: string = 'BasicServiceListComp';

/***
 * 基础服务声明列表组件
 */
@Component
export struct BasicServiceListComp {
  @Link @Watch('onServiceListUpdated') mServiceEntities: Array<ServiceEntity>;
  scroller: Scroller = new Scroller();
  headManager?: HeadManager;
  private deviceAgreementTitle: string = '';
  private data: ServiceEntryDataSource = new ServiceEntryDataSource([]);
  private listSpace: number = 0;

  build() {
    Stack({ alignContent: Alignment.End }) {
      List({
        space: this.listSpace,
        scroller: this.scroller
      }) {
        LazyForEach(this.data, (serviceItem: ServiceEntity) => {
          ListItem() {
            // 协议子项
            BasicServiceItemComp({
              mServiceEntity: serviceItem,
              isDetailVisible: serviceItem.getTitle() === this.deviceAgreementTitle,
            })
          }
          .id(`listitem_basic_service_${serviceItem.getServiceName()}`)
        }, (item: ServiceEntity, index: number) => item.getTitle())
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .attributeModifier(new HeadAnimateModifier(this.getUIContext(), this.headManager, this.scroller, false, true))
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .onReachEnd(() => {
        LogUtil.info(TAG, `onReachEnd totalCount: ${this.data.totalCount()}`);
        if (this.data.totalCount() <= 0) {
          return;
        }
        EventBus.getInstance().emit(CommonConstant.CARD_CONTENT_SCROLL_END_EVENT);
      })
    }
    .width('100%')
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, `aboutToAppear servieEntity size:${this.mServiceEntities?.length}`);
    this.data = new ServiceEntryDataSource(this.mServiceEntities);
    this.deviceAgreementTitle = ResourceUtil.getString('$string:device_permitted_agreement');
  }

  onServiceListUpdated(): void {
    LogUtil.info(TAG, `onServiceListUpdated mServiceEntities length ${this.mServiceEntities?.length}`);
    LogUtil.info(TAG, `onServiceListUpdated data length ${this.data?.totalCount()}`);
    this.data.addAllData(this.mServiceEntities);
  }
}
