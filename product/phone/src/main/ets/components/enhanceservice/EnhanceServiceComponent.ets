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
import {
  CommonConstant,
  HiSysEventUtil,
  IPageController,
  LogUtil,
  PageComponent,
  PageConfigManager,
  PageKey,
  ServiceEntity,
  CardComponent,
  HeadManager,
  FooterComponent
} from '@ohos/hwstartupguide.common';
import { EnhanceServicePageController } from '@ohos/hwstartupguide.enhanceservice';
import { EnhanceServiceListComp } from './EnhanceServiceListComp';

const TAG: string = 'EnhanceServiceComponent';

@Builder
export function EnhanceServiceComponentLoader($$: IPageController | null | undefined): void {
  EnhanceServiceComponent({ mPageController: $$ as EnhanceServicePageController });
}

/**
 * 增强服务申明
 */
@Component
export struct EnhanceServiceComponent {
  @State mEnhancedServiceList: ServiceEntity[] = [];
  @State mCheckBoxStatus: boolean = true;
  @StorageLink('isPortraitOrientation') isPortraitOrientation: boolean = false;
  protected mPageController?: EnhanceServicePageController;
  @State isButtonEnable: boolean = false;
  @State loadingFlag: boolean = false;
  private scroller: Scroller = new Scroller();
  private headManager: HeadManager = new HeadManager();

  build() {
    PageComponent({
      content: () => {
        this.buildPageContent();
      },
      onPageShow: () => {
        if (this.onPageShow) {
          this.onPageShow();
        }
      },
      onHidden: () => {
        if (this.onPageHide) {
          this.onPageHide();
        }
      }
    })
  }

  @Builder
  buildPageContent(): void {
    Stack() {
      CardComponent({
        bodyContent: () => this.componentContent(),
        mHeadName: this.mPageController?.isOTA ? $r('app.string.ota_service_and_improve') :
          $r('app.string.enhance_services_page_title'),
        isBackArrowVisible: !this.mPageController?.isOTA &&
          this.mPageController?.getPageOrderController()?.hasPrevPage(),
        mBasePageController: this.mPageController as EnhanceServicePageController,
        cardBorderBottom: $r('app.float.radius_value_16'),
        closeTitleAnimate: true,
        scroller: this.scroller,
        headManager: this.headManager
      })

      // Footer
      Column() {
        FooterComponent({
          buttonName: $r('app.string.continue_format'),
          buttonOnClick: () => {
            this.onClickNextButton();
          },
          isButtonEnable: this.isButtonEnable,
          buttonLoadingFlag: this.loadingFlag
        })
      }
    }
    .width('100%')
    .height('100%')
    .align(Alignment.End)
    .alignContent(Alignment.Bottom)
  }

  @Builder
  componentContent(): void {
    EnhanceServiceListComp({
      controller: this.mPageController,
      mServiceEntities: this.mEnhancedServiceList,
      scroller: this.scroller,
      headManager: this.headManager
    })
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToAppear');

    this.mPageController?.initEnhanceServiceList().then(() => {
      this.mEnhancedServiceList = [];
      this.mPageController?.getEnhanceServiceList().forEach((item: ServiceEntity) => {
        this.mEnhancedServiceList.push(item);
      });
    }).catch((e: BusinessError) => {
      LogUtil.error(TAG, `initEnhanceServiceList error.${e.code} ${e.message}`);
      HiSysEventUtil.reportErrorEvent(CommonConstant.ES_OPERATION_FAILED, `Init err. errMsg:${e.code} ${e.message}`);
    }).finally(() => {
      // 解除禁用
      this.isButtonEnable = true;
    });

    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.COMPONENT_APPEAR}, ${TAG}`);
  }

  private onClickNextButton(): void {
    if (!this.mPageController) {
      return;
    }
    if (!this.mPageController?.isOTA) {
      this.mPageController.updateMeetimeState();
    }
    let isHasExperiencePage: boolean = PageConfigManager.getInstance().hasPage(PageKey.EXPERIENCE_NOW);
    LogUtil.info(TAG, `isHasExperiencePage: ${isHasExperiencePage}`);
    if (isHasExperiencePage && !this.mPageController?.isOTA) {
      this.saveData();
      return;
    }
    this.saveDataSync();
  }

  private saveData(): void {
    if (!this.mPageController) {
      return;
    }
    this.mPageController.setEnhanceServiceList(this.mEnhancedServiceList);
    this.mPageController.saveEnhanceServiceData();
    this.mPageController.handleNextButtonClick();
  }

  private saveDataSync(): void {
    if (!this.mPageController) {
      return;
    }
    this.mPageController.setEnhanceServiceList(this.mEnhancedServiceList);
    this.loadingFlag = true;
    let isTimeout: boolean = false;
    let timeoutID = setTimeout(() => {
      isTimeout = true;
      LogUtil.warn(TAG, 'save data timeout');
      this.mPageController?.handleNextButtonClick();
    }, CommonConstant.ENHANCE_SERVICE_TIMEOUT);
    this.mPageController.setWorkerOnMessage(() => {
      clearTimeout(timeoutID);
      LogUtil.warn(TAG, 'save data success');
      if (!isTimeout) {
        this.mPageController?.handleNextButtonClick();
      }
    });
    this.mPageController?.saveEnhanceServiceData();
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.COMPONENT_DISAPPEAR}, ${TAG}`);
  }
}
