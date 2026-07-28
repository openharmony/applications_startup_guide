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
import { AnimationItem } from '@ohos/lottie';
import { ColorMetrics } from '@kit.ArkUI';
import { systemParameter } from '@kit.BasicServicesKit';
import {
  FocusUtil,
  LottieComponent,
  ShipModeManager,
  ShutdownManager,
  AccessibilityUtil,
  AccessibilityLevel,
  LogUtil
} from '@ohos/hwstartupguide.common';
// import { languageAndRegionModel } from '@ohos/hwstartupguide.languageselect';
// import { WelcomeAnimationUtil } from '../util/WelcomeAnimationUtil';
import { WelcomePageController } from '../controller/WelcomePageController';


const TAG: string = 'WelcomeComp';
const TIMEOUT: number = 5000;
const WELCOME_COMP_BUTTON_ID: string = 'welcome_comp_button_id';
const WELCOME_COMP_LOTTIE_ID: string = 'welcome_comp_lottie_id';
// OOBE 欢迎动画仅中英文：1.png(简中) + 3.png(英文)
// 资源须同步：product/phone 与 feature/welcome 的 language_animation*.json（2 图层）
// 恢复多语言改用 language_animation_all.json 并改回常量
const LANGUAGE_ANIMATION: string = 'language_animation_oobe.json';
const LANGUAGE_ANIMATION_WIDTH: Length = 360;
const LANGUAGE_ANIMATION_HEIGHT: number = 90;
const ANIMATOR_TIME: number = 200;

@Component
export struct WelcomeComp {
  @State isDisplay: boolean = true;
  @State visibilityFirst: boolean = true;
  @State videoOpacity: number = 0;
  @State visibilitySecond: boolean = false;
  @StorageLink('isScreenOn') @Watch('playConditionChange')isScreenOn: boolean = true;
  @Prop lottieWidth: Length = LANGUAGE_ANIMATION_WIDTH;
  @Prop firstSrcPath: Resource | string = '';
  @Prop secondSrcPath: Resource | string = '';
  @State isAutoPlayFirst: boolean = false;
  @Prop isAutoPlaySecond: boolean = false;
  @Prop accessibilityReadingText: string = '';
  mPageController: WelcomePageController | null = null;
  wordPosition: string = '42%';
  btnWidth: string | Resource = $r('app.float.button_value_56');
  btnHeight: string | Resource = $r('app.float.button_value_56');
  //按钮离底部的距离
  yHeight : string = '87%';
  buttonOnClick: () => void = () => {};
  isNeedFocus: boolean = false;
  private animationItem?: AnimationItem;
  private controllerFirst: VideoController = new VideoController();
  private controllerSecond: VideoController = new VideoController();

  playConditionChange() {
    LogUtil.info(TAG, `playConditionChange isScreenOn: ${this.isScreenOn}`);
    if (!this.hasWelcomeVideo()) {
      return;
    }
    if (this.isScreenOn) {
      this.controllerSecond.start();
    } else {
      this.controllerSecond.pause();
    }
  }

  private hasWelcomeVideo(): boolean {
    return this.firstSrcPath !== '' && this.secondSrcPath !== '';
  }

  build() {
    Stack() {
      if (this.hasWelcomeVideo()) {
        this.videoComponentFirst();
        this.videoComponentSecond();
      }
      Row() {
        LottieComponent({
          lottieData: LANGUAGE_ANIMATION,
          lottieWidth: this.lottieWidth,
          lottieHeight: LANGUAGE_ANIMATION_HEIGHT,
          autoplay: !this.hasWelcomeVideo(),
          callback: (animation: AnimationItem) => {
            this.animationItem = animation;
            if (this.isAutoPlayFirst && this.hasWelcomeVideo()) {
              this.animationItem?.play();
            }
          }
        })
          .id(WELCOME_COMP_LOTTIE_ID)
          .accessibilityLevel(AccessibilityLevel.YES)
          .accessibilityText($r('app.string.welcome'))
          .onAppear(() => {
            AccessibilityUtil.getFocusOnlost(WELCOME_COMP_LOTTIE_ID);
          })
      }
      .width('100%')
      .position({ y: this.wordPosition })
      .justifyContent(FlexAlign.Center)

      Row() {
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_forward'))
            .draggable(false)
            .fontColor([Color.White])
            .fontSize($r('app.float.wh_value_24'))
            .width($r('app.float.button_icon_value_24'))
            .height($r('app.float.button_icon_value_24'))
        }
        .id(WELCOME_COMP_BUTTON_ID)
        .width(this.btnWidth)
        .height(this.btnHeight)
        .backdropBlur(Color.Blue)
        .accessibilityText(this.accessibilityReadingText)
        .onAppear(() => {
          if (this.isNeedFocus) {
            FocusUtil.requestFocus(WELCOME_COMP_BUTTON_ID, this.getUIContext());
          }
        })
        .onClick(() => {
          this.buttonOnClick();
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .position({ y: this.yHeight})
    }
    .width('100%')
    .height('100%')
    .opacity(this.videoOpacity)
  }

  /**
   * 视频组件
   */
  @Builder
  videoComponentFirst() {
    Column() {
      Video({
        src: this.firstSrcPath,
        controller: this.controllerFirst,
      })
        .width('100%')
        .height('100%')
        .scale({
          x: 1.1,
          y: 1.1
        })
        .autoPlay(this.isAutoPlayFirst)
        .controls(false)
        .accessibilityLevel('no-hide-descendants')
        .onFinish(() => {
          this.controllerSecond.start();
        })
        .onStart(() => {
          this.playVideoOpacityAnimate();
        })
        .visibility(this.visibilityFirst ? Visibility.Visible : Visibility.Hidden)
        .surfaceBackgroundColor(ColorMetrics.resourceColor(Color.Transparent))
        .backgroundColor(Color.Transparent)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  videoComponentSecond() {
    Column() {
      Video({
        src: this.secondSrcPath,
        controller: this.controllerSecond,
      })
        .width('100%')
        .height('100%')
        .scale({
          x: 1.1,
          y: 1.1
        })
        .onStart(() => {
          this.visibilitySecond = true;
          this.visibilityFirst = false;
        })
        .autoPlay(this.isAutoPlaySecond)
        .controls(false)
        .accessibilityLevel('no-hide-descendants')
        .loop(true)
        .visibility(this.visibilitySecond ? Visibility.Visible : Visibility.Hidden)
        .surfaceBackgroundColor(ColorMetrics.resourceColor(Color.Transparent))
        .backgroundColor(Color.Transparent)
    }
    .width('100%')
    .height('100%')
  }

  private playVideoOpacityAnimate(): void {
    animateTo({
      duration: ANIMATOR_TIME,
      playMode: PlayMode.Normal,
    },
      () => {
        this.videoOpacity = 1;
      });
  }

  /**
   * 定时查询系统启动是否完成  完成后拉起背景动效及欢迎展示
   */
  private bootCompletedMonitor(): void {
    LogUtil.info(TAG, 'bootCompletedMonitor');
    systemParameter.get('bootevent.boot.completed', (err, data) => {
      if (!!err) {
        LogUtil.error(TAG, `bootCompletedMonitor error, err:${err.toString()}`);
        return;
      }
      if (!!data) {
        LogUtil.warn(TAG, `boot completed!`);
        this.isAutoPlayFirst = true;
        this.animationItem?.play();
        return;
      }
      LogUtil.info(TAG, 'boot unfinished!');
      setTimeout(() => {
        this.bootCompletedMonitor();
      }, 100);
    });
  }

  aboutToAppear(): void {
    if (this.hasWelcomeVideo()) {
      this.bootCompletedMonitor();
    } else {
      this.videoOpacity = 1;
      this.isAutoPlayFirst = true;
    }
    ShipModeManager.getInstance().enter();
    ShutdownManager.getInstance().change();
    LogUtil.info(TAG, 'aboutToAppear');
    setTimeout(() => {
      if (this.hasWelcomeVideo()) {
        this.videoOpacity = 1;
      }
    }, TIMEOUT);
  }

  aboutToDisappear(): void {
    ShutdownManager.getInstance().change();
    LogUtil.info(TAG, 'aboutToDisappear');
  }
}