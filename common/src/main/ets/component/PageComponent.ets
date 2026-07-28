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

import { CommonConstant } from '../constant/CommonConstant';
import { LogUtil } from '../util/LogUtil';

const TAG: string = 'PageComponent';

@Builder
function dummyFunction() {
};

/**
 * OOBE内部页面模板组件
 * 支持通用动效
 */
@Component
export struct PageComponent {
  @StorageLink('isNextClick') isNextClick: boolean = false;
  @BuilderParam content: () => void = dummyFunction;
  @StorageLink('isExperiencePage') isExperiencePage: boolean = false;
  onPageShow?: () => void;
  onHidden?: () => void;
  private marginTop: string = '0vp';
  private marginBottom: string = '0vp';

  getDisappearAnim() {
    if (this.isExperiencePage) {
      return TransitionEffect.OPACITY.animation({ duration: CommonConstant.TRANSACTION_TIME });
    }
    return TransitionEffect.OPACITY.animation({ duration: CommonConstant.TRANSACTION_TIME })
      .combine(TransitionEffect.move(this.isNextClick ? TransitionEdge.START : TransitionEdge.END));
  }

  build() {
    Column() {
      if (this.content) {
        this.content();
      }
    }
    .margin({
      top: this.marginTop,
      bottom: this.marginBottom
    })
    .transition(TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({ duration: CommonConstant.TRANSACTION_TIME })
        .combine(TransitionEffect.move(this.isNextClick ? TransitionEdge.END : TransitionEdge.START)),
      this.getDisappearAnim()))
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToAppear');
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
  }
}