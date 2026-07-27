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
import { util } from '@kit.ArkTS';
import { Callback } from '@kit.BasicServicesKit';
import lottie, { AnimationItem } from '@ohos/lottie';
import { LottieManager } from '../manager/LottieManager';
import { LogUtil } from '../util/LogUtil';
import { RawFileUtil } from '../util/RawFileUtil';

const TAG: string = 'LottieComponent';

/**
 * Lottie组件
 */
@Component
export struct LottieComponent {
  lottieName: string = util.generateRandomUUID();
  lottieId: string = '';
  lottieData?: object | string;
  @Prop lottieWidth: Length = 0;
  @Prop lottieHeight: Length = 0;
  @StorageLink('isScreenOn') @Watch('playConditionChange') isScreenOn: boolean = true;
  lottieMargin: Length = 0;
  destroyOnDisAppear: boolean = false;
  settings: RenderingContextSettings = new RenderingContextSettings(true);
  context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  callback?: Callback<AnimationItem>;
  @Prop autoplay: boolean = true;
  lottieAnimation: AnimationItem | undefined = undefined;

  playConditionChange() {
    LogUtil.info(TAG, `playConditionChange isScreenOn: ${this.isScreenOn}`);
    if (this.isScreenOn) {
      this.lottieAnimation?.play();
    } else {
      this.lottieAnimation?.pause();
    }
  }

  build(): void {
    Canvas(this.context)
      .id(this.lottieId)
      .width(this.lottieWidth)
      .height(this.lottieHeight)
      .margin({
        top: this.lottieMargin,
        bottom: this.lottieMargin
      })
      .onReady(async () => {
        LogUtil.info(TAG, `Canvas onReady. lottieName: ${this.lottieName}`);
        if (!this.lottieData) {
          return;
        }
        LogUtil.warn(TAG, `Canvas onReady. width: ${this.context.width}, height：${this.context.height}`);
        if (typeof this.lottieData === 'string') {
          const data = await RawFileUtil.getLottieData(this.lottieData);
          this.lottieAnimation = LottieManager.loadLottieAnimation(data, this.context, this.lottieName, this.autoplay);
        } else {
          this.lottieAnimation =
            LottieManager.loadLottieAnimation(this.lottieData, this.context, this.lottieName, this.autoplay);
        }
        if (this.callback && this.lottieAnimation) {
          this.callback(this.lottieAnimation);
        }
      })
      .onAreaChange((oldValue: Area, newValue: Area) => {
        LogUtil.warn(TAG,
          `areaChange. old: [${JSON.stringify(oldValue.globalPosition)},${oldValue.width},${oldValue.height}],
          new：[${JSON.stringify(newValue.globalPosition)},${newValue.width},${newValue.height}]`);
      })
      .onDisAppear(() => {
        if (this.destroyOnDisAppear) {
          LogUtil.info(TAG, `on destroy to play animate. lottieName: ${this.lottieName}`);
          lottie.destroy(this.lottieName);
        }
      })
  }
}