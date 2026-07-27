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

import Curves from '@ohos.curves'
import display from '@ohos.display';
import { ColorMetrics } from '@kit.ArkUI';
import { EnterHomeComponentModel } from '../model/EnterHomeComponentModel';
import { ExperienceManager } from '../manager/ExperienceManager';
import { FocusUtil } from '../util/FocusUtil';
import { FooterStyleModel } from '../model/StyleModel';
import { StyleManager } from '../manager/StyleManager';
import { ColumnSystemManager } from '../manager/ColumnSystemManager';
import { CommonConstant } from '../constant/CommonConstant';
import { HiSysEventUtil } from '../util/HiSysEventUtil';
import { LogUtil } from '../util/LogUtil';
import { AccessibilityUtil } from '../util/AccessibilityUtil';
import { DeviceUtil } from '../util/BaseUtils';

const TAG: string = 'EnterHomeComponent';
const IS_DEVICE_PAD: boolean = DeviceUtil.isDevicePad();
const IS_DEVICE_PC: boolean = DeviceUtil.isDevicePc();

const DURATION_TIME: number = 500;
const LOGO_ANMI_DURATION_TIME: number = 1000;
const LOGO_SHOW_TIME: number = 1250;
const WAIT_TIME: number = 10000;

/**
 * 立即体验页
 */
@Component
export struct EnterHomeComponent {
  @StorageProp('footBtnWidth') footBtnWidth: number | Resource = $r('app.float.width_188');
  @State isLogoVisible: boolean = false;
  @State @Watch('btnEnableChange') isBtnEnable: boolean = false;
  @State mLogoImage: Resource = $r('app.media.ic_openharmony_logo');
  // @State mLogoImage: Resource = $r('app.media.ic_next_logo');
  // UX规格，当设备为手机、折叠屏时，logo宽度为短边的70%
  @Prop mLogoWidth: string = '70%';
  @Prop logoPosition: string = '45%';
  @State @Watch('btnVisibleChange') isBtnVisible: boolean = false;
  @Prop srcPath: Resource | string = '';
  @State buttonWidth: number = 0;
  @State buttonLoadingFlag: boolean = false;
  @State blurScale: number = Number.MAX_VALUE;
  @State btnOpacity: number = 0;
  @State logoScale: ScaleOptions = { x: 0.8, y: 0.8 };
  @State logoOpacity: number = 0;
  @State videoOpacity: number = 0;
  @State @Watch('btnVisibleChange') setCloneDataFinished: boolean = true;
  private controller: VideoController = new VideoController();
  private model: EnterHomeComponentModel = new EnterHomeComponentModel();
  private isNeedFocus: boolean = false;
  private enterHomeButtonId: string = 'enterHomeButtonId';
  private footerStyleModel: FooterStyleModel | undefined = StyleManager.getInstance().getFooterStyleModel();
  buttonOnClick: () => void = () => {
  };
  enterHomeBtnPosition: string | Resource = $r('app.float.bottom_margin_height');

  playAnim(): void {
    animateTo({
      duration: DURATION_TIME,
      curve: Curves.cubicBezierCurve(0.44, 0.00, 0.80, 1.00),
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.isBtnEnable = true;
      },
    },
      () => {
        this.btnOpacity = 1;
        this.blurScale = 0;
        this.isBtnEnable = false;
      });
  }

  playLogoAnim(): void {
    animateTo({
      duration: LOGO_ANMI_DURATION_TIME,
      curve: Curves.cubicBezierCurve(0.2,0,0.2,1),
      playMode: PlayMode.Normal,
    },
      () => {
        this.logoScale = { x: 1, y: 1 };
        this.logoOpacity = 1;
      });
  }

  btnVisibleChange(): void {
    if (this.isLogoVisible && this.isBtnVisible && this.setCloneDataFinished) {
      AccessibilityUtil.getFocusOnlost(this.enterHomeButtonId, AccessibilityUtil.BUTTON);
      this.playAnim();
    }
  }

  btnEnableChange(): void {
    if (this.isNeedFocus && this.isBtnEnable) {
      FocusUtil.requestFocus(this.enterHomeButtonId, this.getUIContext());
    }
  }

  btnShow(): void {
    this.isLogoVisible = true;
    this.logoOpacity = 1;
    this.logoScale = { x: 1, y: 1 };
    this.isBtnVisible = true;
    this.btnOpacity = 1;
    this.blurScale = 0;
    this.isBtnEnable = true;
    this.setCloneDataFinished = true;
    ExperienceManager.getInstance().stopListenSettingData();
  }

  private showLogoImmediately(): void {
    this.isLogoVisible = true;
    this.playLogoAnim();
    this.btnVisibleChange();
    LogUtil.info(TAG, 'showLogoImmediately');
  }

  async setCloneDatas(): Promise<void> {
    LogUtil.info(TAG, `setCloneDatas start`);
    await ExperienceManager.getInstance().setCloneDatas();
    this.setCloneDataFinished = true;
    LogUtil.info(TAG, `setCloneDatas end`);
  }

  aboutToAppear(): void {
    this.setCloneDatas();
    try {
      if (IS_DEVICE_PAD || IS_DEVICE_PC) {
        let displayClass = display.getDefaultDisplaySync();
        // 获取屏幕高度，返回值单位为px像素
        let screenHeight = Math.min(displayClass.height, displayClass.width);
        // UX规格，当设备为PAD或PC时，logo宽度为短边的50%
        this.mLogoWidth = screenHeight * 0.4 + 'px';
        LogUtil.info(TAG, `mLogoWidth is ${this.mLogoWidth}`);
      }
    } catch (error) {
      LogUtil.error(TAG, `aboutToAppear error: ${error?.code}, ${error?.message}`);
    }
    this.model.getButtonVisible = () => {
      return this.isBtnVisible;
    };
    this.model.setButtonVisible = (isBtnVisible: boolean) => {
      this.isBtnVisible = isBtnVisible;
    };
    ExperienceManager.getInstance().registerEnterHomeComponentModel(this.model);
    this.showLogoImmediately();
    ExperienceManager.getInstance().startListenSettingDataChange();
    ExperienceManager.getInstance().waitForSecondsToSetButtonVisible();
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.COMPONENT_APPEAR} ${TAG}`);
    // 保护措施，设置10秒延时，保证按钮可以出现
    setTimeout(() => {
      if (!this.isLogoVisible || !this.isBtnVisible || !this.setCloneDataFinished) {
        this.btnShow();
        LogUtil.warn(TAG, 'times out, Unknown error, next button show');
      }
    }, WAIT_TIME)
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.COMPONENT_DISAPPEAR} ${TAG}`);
  }

  /**
   * 视频组件
   */
  @Builder
  videoComponent() {
    Video({
      src: this.srcPath,
      controller: this.controller,
    })
      .width('100%')
      .height('100%')
      .autoPlay(true)
      .objectFit(ImageFit.Cover)
      .controls(false)
      .accessibilityLevel('no-hide-descendants')
      .onFinish(() => {
        ExperienceManager.getInstance().waitForSecondsToSetButtonVisible();
      })
      .onPrepared(() => {
        this.videoOpacity = 1;
      })
      .surfaceBackgroundColor(ColorMetrics.resourceColor(Color.Transparent))
      .backgroundColor(Color.Transparent)
      .opacity(this.videoOpacity)
      .onStart(() => {
        setTimeout(() => {
          this.isLogoVisible = true;
          this.btnVisibleChange();
          this.playLogoAnim();
          LogUtil.info(TAG, 'playLogoAnim');
        }, LOGO_SHOW_TIME)
      })
      .focusable(false)
  }

  /**
   * 背景图组件
   */
  @Builder
  backgroundComponent() {
    if (this.srcPath) {
      Image(this.srcPath)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .draggable(false)
        .accessibilityLevel('no-hide-descendants')
    }
  }

  build() {
    Stack() {
      this.backgroundComponent();
      Row() {
        // 加载svg格式图片
        Image(this.mLogoImage)
          .objectFit(ImageFit.Contain)
          .draggable(false)
          .width(this.mLogoWidth)
          .opacity(this.logoOpacity)
          .scale(this.logoScale)
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height('100%')
      // .position({ y: this.logoPosition }) // 原按 Y 百分比定位，OpenHarmony Logo 需垂直居中

      Row() {
        Button() {
          if (this.buttonLoadingFlag) {
            LoadingProgress()
              .width(this.footerStyleModel?.buttonLoadingProgressSize)
              .height(this.footerStyleModel?.buttonLoadingProgressSize)
              .color($r('sys.color.icon_on_primary'))
          } else {
            Text($r('app.string.enter_home'))
              .height('100%')
              .fontWeight(FontWeight.Medium)
              .textAlign(TextAlign.Center)
              .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
              .fontSize($r('sys.float.Body_L'))
              .minFontSize($r('app.float.font_9'))
              .maxFontSize($r('sys.float.Body_L'))
              .textOverflow({ overflow: this.footerStyleModel?.textOverflow })
          }
        }
        .type(DeviceUtil.isDevicePc() ? ButtonType.Normal : ButtonType.Capsule)
        .constraintSize({
          minWidth: this.footBtnWidth,
          maxWidth: this.footerStyleModel?.isButtonWidthFixed ? this.footBtnWidth :
            ColumnSystemManager.getInstance().getCustomWidthVp(4)
        })
        .padding({
          left: $r('app.float.margin_16'),
          right: $r('app.float.margin_16'),
        })
        .height($r('app.float.custom_button_height'))
        .borderRadius($r('sys.float.corner_radius_level4'))
        .opacity(this.btnOpacity)
        .blur(this.blurScale)
        .backdropBlur(this.blurScale)
        .visibility(this.isLogoVisible && this.isBtnVisible ? Visibility.Visible : Visibility.None)
        .id(this.enterHomeButtonId)
        .enabled(!this.buttonLoadingFlag)
        .onClick(() => {
          if (this.isBtnEnable) {
            this.buttonOnClick();
            this.buttonLoadingFlag = true;
          }
        })
      }
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: this.enterHomeBtnPosition })
    }
    .alignContent(Alignment.Bottom)
  }
}
