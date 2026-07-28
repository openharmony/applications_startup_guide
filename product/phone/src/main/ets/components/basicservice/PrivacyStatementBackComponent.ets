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

import { TitleBar } from '@ohos/hwstartupguide.common';

/**
 * 隐私声明返回组件
 *
 */
@Component
export struct PrivacyStatementBackComponent {
  private handleClick?: () => boolean;
  private title: ResourceStr = $r('app.string.empty_string');

  build(): void {
    Column() {
      TitleBar({
        title: this.title,
        onBack: () => {
          if (this.handleClick === undefined) {
            return false;
          }
          return this.handleClick?.();
        },
      })
        .id('titlebar_privacy_back')
    }
    .alignItems(HorizontalAlign.Start)
  }
}
