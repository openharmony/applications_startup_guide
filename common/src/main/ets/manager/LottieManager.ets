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

import lottie, { AnimationItem } from '@ohos/lottie';
import { LogUtil } from '../util/LogUtil';

const TAG: string = 'LottieManager';

/**
 * Lottie管理类
 */
export class LottieManager {
  /**
   * 加载Lottie动画
   *
   * @param lottieData Lottie数据
   * @param context Canvas Context
   * @param lottieName Lottie名称
   * @param autoplay 是否自动播放
   * @returns AnimationItem 动画实例
   */
  public static loadLottieAnimation(lottieData: object,
    context: CanvasRenderingContext2D, lottieName: string, autoplay=true): AnimationItem {
    lottie.destroy(lottieName);
    LogUtil.info(TAG, 'loadAnimation method start');
    const animation = lottie.loadAnimation({
      container: context,
      renderer: 'canvas',
      loop: true,
      autoplay: autoplay,
      name: lottieName,
      animationData: lottieData
    })
    LogUtil.info(TAG, 'loadAnimation method end');
    return animation;
  }

  /**
   * 销毁Lottie动画
   *
   * @param lottieName Lottie名称
   */
  public static destroy(lottieName: string): void {
    LogUtil.info(TAG, `on destroy to play animate. lottieName: ${lottieName}`);
    lottie.destroy(lottieName);
  }
}