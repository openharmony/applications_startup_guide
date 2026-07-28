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
import { LogUtil } from '../util/LogUtil';

const TAG: string = 'ExperiencePageComponent';

@Builder
function dummyFunction() {
};

/**
 * 立即体验页定制动效组件
 */
@Component
export struct ExperiencePageComponent {
  @BuilderParam content: () => void = dummyFunction;
  onPageShow?: () => void;
  onHidden?: () => void;

  build() {
    Column() {
      if (this.content) {
        this.content();
      }
    }
    .renderGroup(true)
    .transition(TransitionEffect.OPACITY.animation({ duration: CommonConstant.TRANSACTION_TIME }))
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToAppear');
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
  }
}