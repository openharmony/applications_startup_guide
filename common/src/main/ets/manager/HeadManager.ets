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
import Curves from '@ohos.curves';
import { HeadModel } from '../model/HeadModel';

const OPACITY_ONE: number = 1;
const OPACITY_ZERO: number = 0;
const MIN_TITLE_HEIGHT: number = 36;

export class HeadManager {
  /**
   * 头部数据
   */
  public headModel: HeadModel = new HeadModel();

  private getTitleHeight2Number(): number {
    if (typeof this.headModel.titleHeight === 'string') {
      return this.headModel.maxTitleHeight;
    }
    return this.headModel.titleHeight as number;
  }

  private getFinalTitleHeight(): Length {
    let titleHeight = this.getTitleHeight2Number();
    return titleHeight <= this.headModel.maxTitleHeight - MIN_TITLE_HEIGHT ?
      MIN_TITLE_HEIGHT : 'auto';
  }

  private setTitleOpacity(): void {
    if (this.getTitleHeight2Number() <=  this.headModel.maxTitleHeight - MIN_TITLE_HEIGHT) {
      this.headModel.titleOpacity = OPACITY_ZERO;
    } else  {
      this.headModel.titleOpacity = OPACITY_ONE;
    }
  }

  private setAnimate2TitleOpacity(uiContent: UIContext): void {
    uiContent.animateTo({
      curve: Curves.springCurve(0, 1, 188, 25),
    }, () => {
      this.setTitleOpacity();
    });
  }

  private setAnimate2Title(uiContent: UIContext, titleHeight: Length): void {
    uiContent.animateTo({
      curve: Curves.springCurve(0, 1, 188, 25),
    }, () => {
      this.headModel.titleHeight = titleHeight;
      this.setTitleOpacity();
    });
  }

  /**
   * 滚动框架开始
   *
   * @param uiContent ui上下文
   * @param currentOffset 当前偏移量
   * @param offset 下一次偏移
   * @returns 经过计算后下一次偏移
   */
  public onScrollFrameBegin(
    uiContent: UIContext, currentOffset: number, offset: number): OnScrollFrameBeginHandlerResult {
    const endOffset = currentOffset + offset;
    const titleHeight = this.getTitleHeight2Number();
    const endTitleHeight = titleHeight - offset;

    if (endOffset > 0 && titleHeight > MIN_TITLE_HEIGHT && endTitleHeight < this.headModel.maxTitleHeight) {
      this.headModel.titleHeight = endTitleHeight < MIN_TITLE_HEIGHT ? MIN_TITLE_HEIGHT : endTitleHeight;
      this.setAnimate2TitleOpacity(uiContent);
      return {
        offsetRemain: endTitleHeight < MIN_TITLE_HEIGHT ? MIN_TITLE_HEIGHT - endTitleHeight : 0
      };
    }

    if (endOffset < 0 && titleHeight < this.headModel.maxTitleHeight) {
      this.headModel.titleHeight = endTitleHeight >= this.headModel.maxTitleHeight ?
        'auto' : endTitleHeight;
      this.setAnimate2TitleOpacity(uiContent);
      return {
        offsetRemain: endTitleHeight > this.headModel.maxTitleHeight ?
          this.headModel.maxTitleHeight - endTitleHeight : 0
      };
    }

    return {
      offsetRemain: offset
    };
  }

  /**
   * 将要滚动时执行
   *
   * @param uiContent ui上下文
   * @param endOffset 最终偏移量
   * @param scrollSource 滚动源
   */
  public onWillScroll(uiContent: UIContext, endOffset: number, scrollSource: ScrollSource): void {
    if ((scrollSource !== ScrollSource.SCROLLER_ANIMATION && scrollSource !== ScrollSource.OTHER_USER_INPUT)) {
      return;
    }
    const titleHeight = this.getTitleHeight2Number();
    if (endOffset <= 0 && titleHeight === MIN_TITLE_HEIGHT) {
      this.setAnimate2Title(uiContent, 'auto');
    } else if (endOffset > 0 && this.getTitleHeight2Number() === this.headModel.maxTitleHeight) {
      this.setAnimate2Title(uiContent, 0);
    }
  }

  /**
   * 滚动停止时执行
   *
   * @param uiContent ui上下文
   */
  public onScrollStop(uiContent: UIContext): void {
    const titleHeight = this.getFinalTitleHeight();
    this.setAnimate2Title(uiContent, titleHeight);
  }

  /**
   * 标题高度是否改变
   *
   * @returns true 改变 false 没改变
   */
  public isTitleHeightChange(): boolean {
    return this.headModel.titleHeight !== 'auto';
  }
}

export class HeadAnimateModifier implements AttributeModifier<ScrollAttribute | ListAttribute> {
  private headManager: HeadManager;
  private scroller: Scroller;
  private uiContent: UIContext;
  private closeAnimate: boolean;
  private isList: boolean = false;
  private isEnd: boolean = false;
  private _hasAnimation: boolean = false;

  constructor(uiContent: UIContext, headManager: HeadManager, scroller: Scroller,
    closeAnimate: boolean = false, isList: boolean = false) {
    this.uiContent = uiContent;
    this.scroller = scroller;
    this.headManager = headManager;
    this.closeAnimate = closeAnimate;
    this.isList = isList;
  }

  private get hasAnimation(): boolean {
    return this._hasAnimation || !this.isEnd;
  }

  private initHasAnimation(): void {
    if (this.headManager.isTitleHeightChange() && !this._hasAnimation) {
      this._hasAnimation = true;
    }
  }

  private onWillScroll(yOffset: number, scrollSource: ScrollSource) {
    const currentOffset = this.scroller.currentOffset();
    if (!this.hasAnimation || !currentOffset) {
      return;
    }
    const offset = yOffset + currentOffset.yOffset;
    this.headManager.onWillScroll(this.uiContent, offset, scrollSource);
    this.initHasAnimation();
  }

  /**
   * 应用标准样式
   *
   * @param instance ScrollAttribute
   */
  applyNormalAttribute(instance: ScrollAttribute | ListAttribute): void {
    if (!this.headManager || !this.scroller || !this.uiContent || this.closeAnimate) {
      return;
    }
    instance.onScrollFrameBegin((offset: number, state: ScrollState) => {
      this.isEnd = this.scroller.isAtEnd();
      const currentOffset = this.scroller.currentOffset();
      if (!this.hasAnimation || !currentOffset) {
        return {
          offsetRemain: offset
        };
      }
      const res = this.headManager.onScrollFrameBegin(this.uiContent, currentOffset.yOffset, offset);
      this.initHasAnimation();
      return res;
    }).onScrollStop(() => {
      this.isEnd = this.scroller.isAtEnd();
      if (!this.hasAnimation) {
        return;
      }
      this.headManager.onScrollStop(this.uiContent);
    }).fadingEdge(true);
    if (this.isList) {
      (instance as ListAttribute).onWillScroll((scrollOffset: number, scrollState: ScrollState,
        scrollSource: ScrollSource) => {
        this.onWillScroll(scrollOffset, scrollSource);
      });
    } else {
      (instance as ScrollAttribute).onWillScroll((
        xOffset: number, yOffset: number, scrollState: ScrollState, scrollSource: ScrollSource) => {
        this.onWillScroll(yOffset, scrollSource);
      });
    }
  }
}