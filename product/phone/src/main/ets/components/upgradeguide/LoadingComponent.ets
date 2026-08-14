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
import { BasicServicePageController } from '@ohos/hwstartupguide.basicservice';
import {
  CommonConstant,
  IPageController,
  LogUtil,
  PageComponent,
  PageKey,
  WindowManager,
} from '@ohos/hwstartupguide.common';
import { EnhanceServicePageController } from '@ohos/hwstartupguide.enhanceservice';
import { LoadingPageController } from '@ohos/hwstartupguide.otaservice';
import { PageOrderController } from '../../controller/PageOrderController';

const TAG: string = 'LoadingComponent';

@Builder
export function LoadingComponentLoader($$: IPageController | null | undefined): void {
  LoadingComponent({ mPageController: $$ as LoadingPageController });
}

/**
 * loading页面
 */
@Component
export struct LoadingComponent {
  private static readonly DELAY_TIME: number = 100;
  protected mPageController: LoadingPageController | null = null;
  @StorageProp('isShowLoadingTips') isShowLoadingTips: boolean = false;
  private waitTipsLoadTimer: number = -1;

  build() {
    PageComponent({
      content: () => {
        this.buildBlackLoadingPageContent();
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
      .transition(TransitionEffect.asymmetric(
        TransitionEffect.OPACITY.animation({ duration: CommonConstant.TRANSACTION_TIME })
          .combine(TransitionEffect.move(TransitionEdge.END)),
        TransitionEffect.OPACITY.animation({ duration: CommonConstant.TRANSACTION_TIME })
          .combine(TransitionEffect.move(TransitionEdge.START))))
  }

  @Builder
  buildBlackLoadingPageContent(): void {
    Stack() {
      this.blackLoadingContent()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Transparent)
  }

  @Builder
  blackLoadingContent(): void {
    Column() {
      Column() {
        LoadingProgress()
          .color($r('sys.color.icon_on_primary'))
          .width($r('app.float.wh_value_72'))
          .height($r('app.float.wh_value_72'))

        Text($r('app.string.loading_tips'))
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Regular)
          .fontSize($r('app.float.font_16'))
          .fontColor($r('sys.color.icon_on_primary'))
          .textAlign(TextAlign.Center)
          .margin({ top: $r('app.float.margin_8'), left: $r('app.float.margin_16'), right: $r('app.float.margin_16') })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .visibility(this.isShowLoadingTips ? Visibility.None : Visibility.Visible)
    .padding({
      bottom: $r('app.float.height_40'),
    })
    .justifyContent(FlexAlign.Center)
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToAppear');
    WindowManager.getInstance().setWindowLayoutFullScreen(true);
    LogUtil.info(TAG, 'setWindowLayoutFullScreen true');

    if (this.mPageController === null) {
      LogUtil.error(TAG, `mPageController init error. ControllerName:${PageKey.LOADING}`);
      this.init();
      return;
    }
    this.mPageController.pageAppear();
    setTimeout(() => {
      this.init();
    }, LoadingComponent.DELAY_TIME);
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
    clearTimeout(this.waitTipsLoadTimer);
  }

  private init() {
    LogUtil.info(TAG, 'init');
    // OTA场景
    let otaEnhanceServiceController = PageOrderController.getInstance()
      .getPageControllerByName(PageKey.SERVICE_CHANGED) as EnhanceServicePageController;
    otaEnhanceServiceController.isOTA = true;
    let otaBasicServiceController = PageOrderController.getInstance()
      .getPageControllerByName(PageKey.BASIC_SERVICE) as BasicServicePageController;
    Promise.all<void>([
      otaEnhanceServiceController.initEnhanceServiceList(),
      otaBasicServiceController.initBasicServiceList()
    ]).then(() => {
      this.showNextPage();
    });
  }

  private showNextPage() {
      this.mPageController?.handleNextButtonClick();
  }
}