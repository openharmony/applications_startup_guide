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

import { BasePageController, IPageOrderController, PageKey } from '@ohos/hwstartupguide.common';

/**
 * 语言选择页控制器
 */
export class LanguageSelectPageController extends BasePageController {
  /**
   * 构造函数
   * @param pageOrderController 页面顺序控制器
   * @param controllerKey 控制器key
   */
  public constructor(pageOrderController: IPageOrderController) {
    super(pageOrderController, PageKey.LANGUAGE_SELECT);
  }

  /**
   * 点击下一页
   */
  handleNextButtonClick(): void {
    super.handleNextButtonClick();
  }
}
