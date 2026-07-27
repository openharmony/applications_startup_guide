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

import call from '@ohos.telephony.call';
import { LengthMetrics } from '@kit.ArkUI';
import { BusinessError } from '@ohos.base';
import i18n from '@ohos.i18n';
import {
  AbilityUtil,
  CommonConstant,
  HiSysEventUtil,
  IPageController,
  LogUtil,
  PageComponent,
  ResourceStringUtil,
  BgVideoPlayerManager,
  GridLayoutComp,
  ShutdownManager,
  ShipModeManager,
  PageLayoutModel,
  pageLayoutManager,
  CardComponent,
  SystemMaterialManager,
  ButtonSystemMaterialModifier,
  FooterComponent,
  HeadManager,
  OOBEUtil
} from '@ohos/hwstartupguide.common';
import { LanguageSelectPageController } from '@ohos/hwstartupguide.languageselect';
import { PageOrderController } from '../../controller/PageOrderController';
import { LanguageSelectList } from './LanguageSelectList';
import { AssistedReadingDetailComponent } from './AssistedReadingDetailComponent';

const TAG: string = 'LanguageSelectComponent';
const MYFONTSCALE: number = 1;
const BOFONTSCALE: number = 1.3;
const NORMALFONTSCALE: number = 1.45;

@Builder
export function LanguageSelectComponentLoader($$: IPageController | null | undefined): void {
  LanguageSelectComponent({ mPageController: $$ as LanguageSelectPageController });
}

/**
 * 语言选择
 */
@Component
export struct LanguageSelectComponent {
  protected mPageController: LanguageSelectPageController | null = null;
  // 当前语言
  @StorageLink('curLanguage') @Watch('curLanguageChange') curLanguage: string = i18n.System.getSystemLanguage();
  @StorageLink('isPortraitOrientation') isPortraitOrientation: boolean = false;
  @State isMainPage: boolean = true;
  @State maxFontScale: number = this.getCurFontScale();
  @StorageLink('isNextClick') isNextClick: boolean = false;
  @StorageLink('loadingCheck') loadingCheck: boolean = false;
  @State pageLayoutModel: PageLayoutModel = pageLayoutManager.getPageLayoutConfig();
  private scroller: Scroller = new Scroller();
  private headManager: HeadManager = new HeadManager();
  @State backWelcome: boolean = false;

  curLanguageChange(): void {
    this.maxFontScale = this.getCurFontScale();
  }

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
    if (this.isMainPage) {
      this.loadFirstLevelPage();
    } else {
      this.loadSecongLevelPage();
    }
  }

  /**
   * 加载语言选择一级页面
   */
  @Builder
  loadFirstLevelPage(): void {
    Stack() {
      CardComponent({
        bodyContent: this.componentContent,
        mHeadName: $r('app.string.choose_language'),
        isBackArrowVisible: this.mPageController?.getPageOrderController()?.hasPrevPage(),
        mBasePageController: this.mPageController as LanguageSelectPageController,
        cardBorderBottom: $r('app.float.radius_value_16'),
        cardBackgroundColor: SystemMaterialManager.listBackgroundColor(),
        closeTitleAnimate: true,
        scroller: this.scroller,
        headManager: this.headManager,
        backClick: () => {
          this.backWelcome = true;
        }
      })

      Column() {
        GridLayoutComp({ buildContent: () => this.emergencyCallComponent() })
      }
      .zIndex(1)
      .visibility(Visibility.None)
      // Footer
      Column() {
        FooterComponent({
          buttonName: $r('app.string.continue'),
          buttonOnClick: () => {
            this.continue();
          },
          buttonLoadingFlag: this.loadingCheck,
        })
      }
      .hitTestBehavior(HitTestMode.Transparent)
      .accessibilityLevel('no')
      .zIndex(2)

      Column() {
        GridLayoutComp({ buildContent: () => this.readingAidComponent() })
      }
      .zIndex(1)
      .hitTestBehavior(HitTestMode.Transparent)
      .visibility(Visibility.None)
    }
    .width('100%')
    .height('100%')
    .align(Alignment.End)
    .alignContent(Alignment.Bottom)
    .transition(TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({ duration: CommonConstant.TRANSACTION_TIME })
        .combine(TransitionEffect.move(this.isNextClick ? TransitionEdge.START : TransitionEdge.START)),
      TransitionEffect.OPACITY.animation({ duration: CommonConstant.TRANSACTION_TIME })
        .combine(this.getDisappearAnim())))
  }

  getDisappearAnim() {
    if (this.backWelcome) {
      this.backWelcome = false;
      return TransitionEffect.OPACITY.animation({ duration: CommonConstant.TRANSACTION_TIME })
        .combine(TransitionEffect.move(TransitionEdge.END));
    }
    return TransitionEffect.OPACITY.animation({ duration: CommonConstant.TRANSACTION_TIME })
      .combine(TransitionEffect.move(this.isMainPage ? TransitionEdge.START : TransitionEdge.END));
  }

  /**
   * 加载辅助阅读二级页面
   */
  @Builder
  loadSecongLevelPage(): void {
    AssistedReadingDetailComponent({
      isMainPage: this.isMainPage
    });
  }

  /**
   * 底部紧急呼叫组件
   */
  @Builder
  emergencyCallComp(): void {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Start }) {
      Column() {
        Button() {
          Image($r('app.media.ic_public_phone'))
            .width($r('app.float.wh_value_24'))
            .height($r('app.float.wh_value_24'))
            .draggable(false)
            .matchTextDirection(true)
        }
        .attributeModifier(new ButtonSystemMaterialModifier($r('sys.color.comp_background_tertiary')))
        .accessibilityImgStyle()

        Text($r('app.string.emergency_call'))
          .accessibilityTextStyle()
          .maxFontScale(this.maxFontScale)
      }
      .accessibilityText(ResourceStringUtil.getStringSync($r('app.string.emergency_call')))
      .accessibilityRole(AccessibilityRoleType.BUTTON)
      .onClick(() => {
        this.callTelephone();
      })
      .alignItems(HorizontalAlign.Center)
      .width($r('app.float.wh_value_72'))
      .visibility(call.hasVoiceCapability() ? Visibility.Visible : Visibility.Hidden)
    }
  }

  /**
   * 底部辅助阅读组件
   */
  @Builder
  readingAidComp(): void {
    Flex({ direction: FlexDirection.RowReverse, justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Start }) {
      Column() {
        Button() {
          Image($r('app.media.ic_public_password_visible'))
            .width($r('app.float.wh_value_24'))
            .height($r('app.float.wh_value_24'))
            .draggable(false)
            .matchTextDirection(true)
        }
        .attributeModifier(new ButtonSystemMaterialModifier($r('sys.color.comp_background_tertiary')))
        .accessibilityImgStyle()

        Text($r('app.string.vision_settings'))
          .accessibilityTextStyle()
          .maxFontScale(this.maxFontScale)
      }
      .accessibilityText(ResourceStringUtil.getStringSync($r('app.string.vision_settings')))
      .accessibilityRole(AccessibilityRoleType.BUTTON)
      .onClick(() => {
        this.handleReadingAid();
      })
      .alignItems(HorizontalAlign.Center)
      .width($r('app.float.wh_value_72'))
    }
  }

  @Builder
  emergencyCallComponent(): void {
    Column() {
      this.emergencyCallComp();
    }
    .width('100%')
    .padding({
      start: LengthMetrics.vp(this.pageLayoutModel.callAndReadingPosition),
      top: LengthMetrics.vp(this.pageLayoutModel.callAndReadingPaddingTop)
    })
    .height(this.pageLayoutModel.cardPaddingBottom)
  }

  @Builder
  readingAidComponent(): void {
    Column() {
      this.readingAidComp();
    }
    .width('100%')
    .padding({
      end: LengthMetrics.vp(this.pageLayoutModel.callAndReadingPosition),
      top: LengthMetrics.vp(this.pageLayoutModel.callAndReadingPaddingTop)
    })
    .height(this.pageLayoutModel.cardPaddingBottom)
  }

  @Builder
  componentContent(): void {
    Column() {
      LanguageSelectList({
        scroller: this.scroller,
        headManager: this.headManager
      })
    }
    .flexGrow(1)
  }

  private callTelephone(): void {
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, 'callTelephone');
    OOBEUtil.addPageButtonMap('callTelephone', `callTelephone_${new Date().toString()}`);
    AbilityUtil.startAbilityByContext(
      'com.ohos.openharmony.emergencycommunication',
      'com.ohos.openharmony.emergencycommunication.EmergencyCallAbility'
    ).catch((err: BusinessError) => {
      LogUtil.error(TAG, 'error code:' + err.code + 'err.message:' + err.message);
    });
  }

  private handleReadingAid(): void {
    BgVideoPlayerManager.getInstance().playVideo(0);
    this.isMainPage = false;
    OOBEUtil.addPageButtonMap('readingAid', `readingAid_${new Date().toString()}`);
  }

  private getCurFontScale(): number {
    if (this.curLanguage === 'my') {
      return MYFONTSCALE;
    }
    return this.curLanguage === 'bo' ? BOFONTSCALE : NORMALFONTSCALE;
  }

  private continue(): void {
    LogUtil.info(TAG, `Continue isReady:${PageOrderController.getInstance().isReady()}`);
    this.mPageController?.handleNextButtonClick();
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, `aboutToAppear isReady:${PageOrderController.getInstance().isReady()}`);
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.COMPONENT_APPEAR} ${TAG}`);
    setTimeout(() => {
      ShipModeManager.getInstance().enter();
      ShutdownManager.getInstance().change();
    });
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
    ShutdownManager.getInstance().change();
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.COMPONENT_DISAPPEAR} ${TAG}`);
  }
}

/**
 * 紧急呼叫/辅助阅读文本样式
 */
@Extend(Text)
function accessibilityTextStyle() {
  .fontSize($r('app.float.font_9'))
  .fontWeight(FontWeight.Medium)
  .width('100%')
  .textAlign(TextAlign.Center)
  .align(Alignment.Top)
  .width('100%')
  .maxFontScale($r('app.float.font_9'))
  .minFontSize($r('app.float.font_6'))
  .maxLines(2)
  .textOverflow({ overflow: TextOverflow.Clip })
}

@Styles
function pressedStyles() {
  .backgroundColor($r('sys.color.interactive_pressed'))
}

/**
 * 紧急呼叫/辅助阅读图标样式
 */
@Extend(Button)
function accessibilityImgStyle() {
  .width($r('app.float.wh_value_40'))
  .height($r('app.float.wh_value_40'))
  .borderRadius($r('app.float.radius_20'))
  .margin({ bottom: $r('app.float.padding_4') })
  .stateStyles({
    pressed: pressedStyles
  })
}
