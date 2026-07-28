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

@Observed
export class PageLayoutModel {
  /**
   * 欢迎页按钮宽度
   */
  public welBtnWidth: string = '56vp';

  /**
   * 欢迎页按钮高度
   */
  public welBtnHeight: string = '56vp';

  /**
   * 欢迎页按钮距离顶部的距离
   */
  public welBtnPosition: string = '88.8%';

  /**
   * 欢迎页图片距离顶部的距离
   */
  public welImgPosition: string = '44%';

  /**
   * 页面卡片距离顶部的距离
   */
  public cardViewMarginTop: string = '0vp';

  /**
   * 页面卡片距离底部的距离
   */
  public cardViewMarginBottom: string = '0vp';

  /**
   * 页面主体内容距离卡片底部的距离
   */
  public cardViewPaddingBottom: string = '16vp';

  /**
   * 立即体验页按钮距离顶部的距离
   */
  public enterHomeBtnPosition: string = '68vp';

  /**
   * 屏幕状态
   */
  public screenState: string = '';

  /**
   * 是否需要定制UX
   */
  public isSpecialStyle: boolean = false;

  /**
   * 内容区宽度
   */
  public bodyWidth: string = 'calc(100% - 32vp)';

  /**
   * 选择语言页紧急呼叫与辅助阅读与两边的间距
   */
  public callAndReadingPosition: number = 16;

  /**
   * 通用按钮宽度
   */
  public btnWidth: string = '188vp';

  /**
   * 卡片距离页面底部的距离
   */
  public cardPaddingBottom: string = '132vp';

  /**
   * 同意按钮距离底部距离
   */
  public agreeBtnMarginBottom: string  = '68vp';

  /**
   * 跳过按钮距离底部距离
   */
  public skipBtnMarginBottom: string  = '16.5vp';

  /**
   * 紧急呼叫与辅助阅读距离顶部卡片间距
   */
  public callAndReadingPaddingTop: number  = 24;
}