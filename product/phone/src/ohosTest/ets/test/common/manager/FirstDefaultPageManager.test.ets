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
import { BasePageController,
  FirstDefaultPageManager,
  PageKey } from '@ohos/hwstartupguide.common';
import { LanguageSelectPageController } from '@ohos/hwstartupguide.languageselect';

import { describe, expect, it } from '@ohos/hypium';
import { PageOrderController } from '../../../../../main/ets/controller/PageOrderController';

const TAG: string = 'FirstDefaultPageManagerTest';

export default function FirstDefaultPageManagerTest() {
  describe('FirstDefaultPageManagerTest', () => {

    it('FirstDefaultPageManagerTest_001', 0, async () => {
      let firstController: BasePageController = new LanguageSelectPageController(PageOrderController.getInstance());
      FirstDefaultPageManager.getInstance().setDefaultFirstPage(PageKey.LANGUAGE_SELECT, firstController);
      expect(FirstDefaultPageManager.getInstance().getDefaultFirstPage()).not().assertNull();
    });
  })
}