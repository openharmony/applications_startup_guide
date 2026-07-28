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
import { CommonConstant } from '../constant/CommonConstant';
import { BasePageController } from '../controller/BasePageController';
import { HeadManager, HeadAnimateModifier } from '../manager/HeadManager';
import { pageLayoutManager } from '../manager/PageLayoutManager';
import { PageLayoutModel } from '../model/PageLayoutModel';
import { EventBus } from '../util/EventBus';
import { GridLayoutComp } from './GridLayoutComp';
import { HeadComponent } from './HeadComponent';
import { LogUtil } from '../util/LogUtil';
import { StyleManager } from '../manager/StyleManager';
import { CardNonGridComponent } from './CardNonGridComponent';
import { CardSystemMaterialModifier } from '../manager/SystemMaterialManager';

const TAG: string = 'CardComponent';

const CONTENT_MARGIN_BOTTOM: number = 16;
const TITLE_ANIMATE_CONTAINER: string = 'title_animate_container';

@Component
export struct CardComponent {
  @BuilderParam bodyContent?: () => void;
  @State pageLayoutModel: PageLayoutModel = pageLayoutManager.getPageLayoutConfig();
  @Prop mHeadName: ResourceStr = $r('app.string.empty_string');
  @Prop scrollMarginTop: Length = $r('app.float.margin_0');
  headManager: HeadManager = new HeadManager();
  closeTitleAnimate: boolean = false;
  cardBorderBottom: Length = 0;
  cardBackgroundColor: ResourceColor = Color.Transparent;
  scroller?: Scroller;
  mBasePageController: BasePageController | null = null;
  isBackArrowVisible: boolean = true;
  isUseTitle: boolean = true;
  private cardScroller: Scroller = new Scroller();
  private styleManager: StyleManager = StyleManager.getInstance();
  backClick?: () => void;

  build() {
    if (this.styleManager.isGrid) {
      this.gridLayout()
    } else {
      CardNonGridComponent({
        bodyContent: this.bodyContent,
        mHeadName: this.mHeadName,
        isBackArrowVisible: this.isBackArrowVisible,
        mBasePageController: this.mBasePageController,
        isUseTitle: this.isUseTitle,
        backClick: this.backClick
      })
    }
  }

  @Builder
  gridLayout() {
    Column() {
      GridLayoutComp({ buildContent: () => this.buildPageContent() })
    }
    .width('100%')
    .height('100%')
    .padding({
      top: $r('app.float.height_56'),
      left: $r('app.float.margin_16'),
      right: $r('app.float.margin_16'),
      bottom: this.pageLayoutModel.cardPaddingBottom,
    })
  }

  @Builder
  buildPageContent(): void {
    Column() {
      HeadComponent({
        headName: this.mHeadName,
        isBackArrowVisible: this.isBackArrowVisible,
        backClick: () => {
          if(this.backClick) {
            this.backClick();
          }
          this.mBasePageController?.handlePrevButtonClick();
        },
        headModel: this.headManager.headModel
      })

      RelativeContainer() {
        Scroll(this.cardScroller) {
          if (this.bodyContent) {
            this.bodyContent()
          }
        }
        .align(Alignment.Top)
        .width('100%')
        .height(`calc(100% - ${CONTENT_MARGIN_BOTTOM}vp)`)
        .borderRadius(this.cardBorderBottom)
        .backgroundColor(this.cardBackgroundColor)
        .scrollBar(BarState.Off)
        .attributeModifier(new HeadAnimateModifier(
          this.getUIContext(), this.headManager, this.cardScroller, this.closeTitleAnimate))
        .onReachEnd(() => {
          LogUtil.info(TAG, 'CARD_CONTENT_SCROLL_END');
          EventBus.getInstance().emit(CommonConstant.CARD_CONTENT_SCROLL_END_EVENT);
        })
        .id(TITLE_ANIMATE_CONTAINER)
        .edgeEffect(
          this.closeTitleAnimate ? EdgeEffect.None : EdgeEffect.Spring,
          { alwaysEnabled: true }
        )

        if (!this.closeTitleAnimate || this.scroller) {
          ScrollBar({
            scroller: this.scroller ? this.scroller : this.cardScroller,
            direction: ScrollBarDirection.Vertical,
            state: BarState.Auto
          })
            .accessibilityLevel('no')
            .margin({
              top: this.scrollMarginTop,
              bottom: $r('app.float.margin_24'),
            })
            .alignRules({
              left: {
                anchor: TITLE_ANIMATE_CONTAINER,
                align: HorizontalAlign.End
              }
            })
            .enableNestedScroll(true)
        }
      }
      .width(this.pageLayoutModel.bodyWidth)
      .layoutWeight(1)
    }
    .attributeModifier(new CardSystemMaterialModifier())
    .borderRadius($r('app.float.border_radius_32'))
    .clip(true)
  }
}