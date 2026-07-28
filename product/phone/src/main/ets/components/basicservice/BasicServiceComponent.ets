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
import resmgr from '@ohos.resourceManager';
import commonEventManager from '@ohos.commonEventManager';
import { AlertDialog } from '@ohos.arkui.advanced.Dialog';
import { BasicServicePageController, BasicServiceUtil } from '@ohos/hwstartupguide.basicservice';
import {
  CommonConstant,
  CommonEvent,
  DeviceUtil,
  HiSysEventUtil,
  IPageController,
  LogUtil,
  PageComponent,
  ServiceEntityUtil,
  ServiceEntity,
  PageKey,
  ResourceStringUtil,
  SceneType,
  SceneTypeManager,
  EventBus,
  HeadManager,
  CardComponent,
  FooterComponent
} from '@ohos/hwstartupguide.common';
import { BasicServiceListComp } from './BasicServiceListComp';

const TAG: string = 'BasicServiceComponent';
const IS_DEVICE_PAD: boolean = DeviceUtil.isDevicePad();

@Builder
export function BasicServiceComponentLoader($$: IPageController | null | undefined): void {
  BasicServiceComponent({ mPageController: $$ as BasicServicePageController });
}

/**
 * 基础服务声明
 */
@Component
export struct BasicServiceComponent {
  @State isScrollEnd: boolean = false;
  @State mBasicServiceList: Array<ServiceEntity> = [];
  @StorageLink('isPortraitOrientation') isPortraitOrientation: boolean = false;
  @StorageLink('isAgreeAndContinue') isAgreeAndContinue: boolean = false;
  @StorageLink(CommonConstant.SHOW_EXIT_DIALOG) @Watch('showDialog') showExitDialog: boolean = false;
  @State accessibilityReadingText: string = this.isAgreeAndContinue ? '' : ResourceStringUtil.getStringSync($r('app.string.agree_continue_format_readingAid'));
  mPageController: BasicServicePageController | null = null;
  private exitDlgController: CustomDialogController = new CustomDialogController({
    builder: AlertDialog({
      content: $r('app.string.exit_dialog_tips'),
      primaryButton: {
        value: $r('app.string.cancel'),
        action: () => {
          AppStorage.set(CommonConstant.SHOW_EXIT_DIALOG, false);
        },
      },
      secondaryButton: {
        value: $r('app.string.exit'),
        action: () => {
          this.mPageController?.confirmExit();
          AppStorage.set(CommonConstant.SHOW_EXIT_DIALOG, false);
        }
      },
    }),
    alignment: DialogAlignment.Center,
    offset: {
      dx: 0,
      dy: 0,
    },
    autoCancel: true,
    gridCount: 4,
    cancel: () => {
      AppStorage.set(CommonConstant.SHOW_EXIT_DIALOG, false);
    }
  });
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
        bodyContent: () => {
          this.componentContent();
        },
        mHeadName: $r('app.string.agreement_declaration'),
        isBackArrowVisible: this.isShowBackArrow(),
        mBasePageController: this.mPageController as BasicServicePageController,
        closeTitleAnimate: true,
        scroller: this.scroller,
        headManager: this.headManager
      })

      // Footer
      Column() {
        FooterComponent({
          buttonName: $r('app.string.agree_continue_format'),
          buttonOnClick: () => {
            this.agreeAndContinue();
          },
          isButtonEnable: this.isScrollEnd || this.isAgreeAndContinue,
          accessibilityReadingText: this.accessibilityReadingText
        })
      }
    }
    .width('100%')
    .height('100%')
    .align(Alignment.End)
    .alignContent(Alignment.Bottom)
  }

  /***
   * 渐隐蒙版组件
   * @since 2024-04-26
   */
  @Builder
  linearMaskComponent(): void {
    Column() {
      Column() {
      }
      .width('100%')
      .height($r('app.float.wh_value_32'))
      .linearGradient({
        colors: [[$r('app.color.linear_mask_start_color'), 0.0], [$r('app.color.linear_mask_end_color'), 1]],
      })
      .position({ x: '0', y: IS_DEVICE_PAD ? $r('app.float.position_24') : $r('app.float.position_28') })
    }
    .width(IS_DEVICE_PAD ? $r('app.float.wh_value_480') : '100%')
    .padding({ left: $r('app.float.wh_value_16'), right: $r('app.float.wh_value_16') })
  }

  @Builder
  componentContent(): void {
    BasicServiceListComp({
      mServiceEntities: this.mBasicServiceList,
      scroller: this.scroller,
      headManager: this.headManager
    })
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToAppear');

    this.isScrollEnd = false;
    if (this.mPageController === null) {
      LogUtil.error(TAG, `mPageController init error. ControllerName:${PageKey.BASIC_SERVICE}`);
      HiSysEventUtil.reportErrorEvent(CommonConstant.BS_OPERATION_FAILED, `Init err: ControllerName:${PageKey.BASIC_SERVICE}`);
      return;
    }
    this.loadEntities();
    EventBus.getInstance().on(CommonConstant.CARD_CONTENT_SCROLL_END_EVENT, this.scrollEndEvent);
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.COMPONENT_APPEAR}, ${PageKey.BASIC_SERVICE}`);
    this.mPageController.pageAppear();
  }

  private isShowBackArrow(): boolean | undefined {
    return SceneTypeManager.getInstance().getSceneType() === SceneType.OTA_SCENE ? false :
      this.mPageController?.getPageOrderController()?.hasPrevPage();
  }

  private scrollEndEvent = () => {
    LogUtil.info(TAG, 'scrollEndEvent');
    if (!this.isScrollEnd) {
      this.isScrollEnd = true;
      this.accessibilityReadingText = '';
    }
  }

  updateServiceCheckStatus(): void {
    LogUtil.info(TAG, 'updateServiceCheckStatus');
    BasicServiceUtil.saveAgreedStatusToSP(getContext(this), true);
  }

  private agreeAndContinue(): void {
    this.updateServiceCheckStatus();
    this.mPageController?.handleNextButtonClick();
    AppStorage.setOrCreate<boolean>('isAgreeAndContinue', true);
    this.publishCommonEvent();
  }

  /**
   * 同意基础协议发送公共事件，通知预装
   */
  private publishCommonEvent(): void {
    let isOtaScene: boolean = SceneTypeManager.getInstance().getSceneType() === SceneType.OTA_SCENE;
    let isFirstBootScene: boolean = SceneTypeManager.getInstance().getSceneType() === SceneType.FIRST_BOOT_SCENE;
    let isSubUserScene: boolean = SceneTypeManager.getInstance().getSceneType() === SceneType.SUB_USER_SCENE;
    let options: commonEventManager.CommonEventPublishData = {
      // phone: 预置场景、ota升级（基础协议版本号变更)
      subscriberPermissions: [CommonConstant.HWSTARTUPGUIDE_ACCESS_PERMISSION],
      parameters: {
        'ota': isOtaScene,
        'firstBoot': isFirstBootScene,
        'subUserScene': isSubUserScene
      }
    };
    CommonEvent.publish(CommonConstant.BASIC_STATEMENT_AGREE_TERMS_OF_USE, options);
  }

  private loadEntities(): void {
    let resourceManager = this.mPageController?.getAbility()?.context.resourceManager as resmgr.ResourceManager;
    this.mPageController?.initBasicServiceList().then(() => {
      ServiceEntityUtil.getServiceEntity(resourceManager).then((mBasicServiceList: ServiceEntity[]) => {
        this.mBasicServiceList = mBasicServiceList;
      });
    }).catch((err: BusinessError) => {
      LogUtil.error(TAG, `initBasicServiceList error.code:${err.code} ,msg:${err.message}`);
      HiSysEventUtil.reportErrorEvent(CommonConstant.BS_OPERATION_FAILED, `Init err. errMsg: ${err.code} ${err.message}`);
    });
  }

  showDialog(): void {
    LogUtil.info(TAG, `showDialog ${this.showExitDialog}`);
    if (this.showExitDialog) {
      this.exitDlgController.open();
    }
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
    EventBus.getInstance().detach(CommonConstant.CARD_CONTENT_SCROLL_END_EVENT, this.scrollEndEvent);
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON,
      `${CommonConstant.COMPONENT_DISAPPEAR}, ${PageKey.BASIC_SERVICE}`);
  }
}