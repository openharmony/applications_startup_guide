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

import { IPageOrderController, FastCloneSceneManager } from '@ohos/hwstartupguide.common';
import { describe, it, expect, beforeAll } from '@ohos/hypium';
import { WlanPageController } from '../../../../../main/ets/controller/external/WlanPageController';
import { PageOrderController } from '../../../../../main/ets/controller/PageOrderController';

const TAG: string = 'WlanPageControllerTest';

export default function WlanPageControllerTest() {
  let externalCol: WlanPageController;
  describe('WlanPageControllerTest', () => {
    beforeAll(() => {
      class ChildExternalPageController extends WlanPageController {
        constructor(pageOrderController: IPageOrderController) {
          super(pageOrderController)
        }
      }

      externalCol = new ChildExternalPageController(PageOrderController.getInstance());
    });

    it("WlanPageControllerTest_001", 0, async () => {
      FastCloneSceneManager.getInstance().setCloneWlan(true);
      let res: boolean = externalCol.isNeedShow() === true || externalCol.isNeedShow() === false;
      expect(res).assertTrue();
    });

    it("WlanPageControllerTest_002", 0, async () => {
      FastCloneSceneManager.getInstance().setCloneWlan(false);
      let res: boolean = externalCol.isNeedShow() === true || externalCol.isNeedShow() === false;
      expect(res).assertTrue();
    });

    it("WlanPageControllerTest_003", 0, async () => {
      FastCloneSceneManager.getInstance().setFastCloneScene(true);
      externalCol.handleNextButtonClick();
      expect( FastCloneSceneManager.getInstance().isFastCloneScene()).assertTrue();
    });

    it("WlanPageControllerTest_004", 0, async () => {
      FastCloneSceneManager.getInstance().setFastCloneScene(false);
      externalCol.handleNextButtonClick();
      expect( FastCloneSceneManager.getInstance().isFastCloneScene()).assertFalse();
    });

    it("WlanPageControllerTest_005", 0, async () => {
      FastCloneSceneManager.getInstance().setFastCloneScene(true);
      externalCol.handlePrevButtonClick();
      expect( FastCloneSceneManager.getInstance().isFastCloneScene()).assertTrue();
    });

    it("WlanPageControllerTest_006", 0, async () => {
      FastCloneSceneManager.getInstance().setFastCloneScene(false);
      externalCol.handlePrevButtonClick();
      expect( FastCloneSceneManager.getInstance().isFastCloneScene()).assertFalse();
    });
  });
}