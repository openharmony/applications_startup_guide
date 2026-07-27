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
// instrument ignore file
import { LogUtil, ScreenSizeUtil } from '@ohos/hwstartupguide.common'

const TAG: string = 'OuterTipsComponent';
const BACKWARD_TRANSLATE: number = Math.min(10, Math.round(ScreenSizeUtil.getScreenWidth() * 0.01));
const FORWARD_TRANSLATE: number = BACKWARD_TRANSLATE * -1;
const SCALE_SIZE: number = 1.1;
const DURATION_TIME: number = 2000;
const LOGOMARGINBOTTOM: string = '15%';
const WORDMARGINTOP: string = '75%';
const ITERATIONS: number = -1;
const OUTERPAGE_TEXT_ID: string = 'outerpage_text_id';

@Component
export struct OuterPageComponent {
  @Prop externalPageVisible: Visibility = Visibility.None
  @State translateX: number = BACKWARD_TRANSLATE;
  @State translateY: number = BACKWARD_TRANSLATE;
  @StorageLink('isScreenOn') @Watch('playConditionChange') isScreenOn: boolean = true;
  private mBackgroundImage: Resource = $r('app.media.outer_screen_background');
  private mBackgroundScale: ScaleOptions = { x: SCALE_SIZE, y: SCALE_SIZE };
  private mBackgroundOpacity: number = 1;
  private mLogoImage: Resource = $r('app.media.ic_openharmony_logo');
  private mLogoWidth: string = '168vp';
  private logoScale: ScaleOptions = { x: 1, y: 1 };
  private logoOpacity: number = 1;

  playConditionChange() {
    LogUtil.info(TAG, `playConditionChange isScreenOn: ${this.isScreenOn}`);
    if (this.isScreenOn) {
      this.startAnimation();
    } else {
      this.finishAnimation();
    }
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, `aboutToAppear`);
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
  }

  private startAnimation(): void {
    animateTo({
      duration: DURATION_TIME,
      curve: Curve.Linear,
      iterations: ITERATIONS,
      playMode: PlayMode.Alternate
    }, () => {
      this.translateX = FORWARD_TRANSLATE;
      this.translateY = FORWARD_TRANSLATE;
    });
  }

  private finishAnimation(): void {
    animateTo({
      duration: 0,
      iterations: 1
    }, () => {
      this.translateX = BACKWARD_TRANSLATE;
      this.translateY = BACKWARD_TRANSLATE;
    });
  }

  build() {
    Stack() {
      this.backgroundComponent();
      this.logoComponent();
    }
    .visibility(this.externalPageVisible)
    .width('100%')
    .height('100%')
  }

  @Builder
  backgroundComponent() {
    Row() {
      Image(this.mBackgroundImage)
        .objectFit(ImageFit.Cover)
        .scale(this.mBackgroundScale)
        .opacity(this.mBackgroundOpacity)
        .translate({ x: this.translateX, y: this.translateY })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height('100%')
  }

  /**
   * LOGO组件
   */
  @Builder
  logoComponent() {
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
    .margin({
      bottom: LOGOMARGINBOTTOM
    })
    .width('100%')
    .height('100%')

    Row() {
      Text($r('app.string.outerpage_tips'))
        .id(OUTERPAGE_TEXT_ID)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('app.float.font_20'))
        .fontColor('#99000000')
        .lineHeight($r('app.float.wh_value_23'))
        .textAlign(TextAlign.Center)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({
          top: WORDMARGINTOP
        })
    }
  }
}