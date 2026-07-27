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

import { RegionSelectPageController } from '@ohos/hwstartupguide.regionselect';
import {
  CommonConstant,
  HiSysEventUtil,
  IPageController,
  LogUtil,
  PageComponent,
  ShipModeManager,
  CardComponent,
  SystemMaterialManager,
  FooterComponent,
  HeadManager,
} from '@ohos/hwstartupguide.common';
import { RegionSelectListComp } from './RegionSelectListComp';

const TAG: string = 'RegionSelectComponent';

@Builder
export function RegionSelectComponentLoader($$: IPageController | null | undefined): void {
  RegionSelectComponent({ mPageController: $$ as RegionSelectPageController });
}

/**
 * 地区选择页面控件
 */
@Component
export struct RegionSelectComponent {
  protected mPageController: RegionSelectPageController | null = null;
  @StorageLink('isPortraitOrientation') isPortraitOrientation: boolean = false;
  @StorageLink('loadingFlag') loadingFlag: boolean = false;
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
        bodyContent: this.componentContent,
        mHeadName: $r('app.string.region_select'),
        isBackArrowVisible: this.mPageController?.getPageOrderController()?.hasPrevPage(),
        mBasePageController: this.mPageController as RegionSelectPageController,
        cardBorderBottom: $r('app.float.radius_value_16'),
        cardBackgroundColor: SystemMaterialManager.listBackgroundColor(),
        closeTitleAnimate: true,
        scroller: this.scroller,
        headManager: this.headManager
      })

      // Footer
      Column() {
        FooterComponent({
          buttonName: $r('app.string.continue'),
          buttonOnClick: () => {
            this.continue();
          },
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
    Column() {
      RegionSelectListComp({
        scroller: this.scroller,
        headManager: this.headManager
      })
    }
    .flexGrow(1)
  }

  private continue(): void {
    this.mPageController?.handleNextButtonClick();
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToAppear');
    ShipModeManager.getInstance().leave();
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.COMPONENT_APPEAR} ${TAG}`);
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.COMPONENT_DISAPPEAR} ${TAG}`);
  }
}