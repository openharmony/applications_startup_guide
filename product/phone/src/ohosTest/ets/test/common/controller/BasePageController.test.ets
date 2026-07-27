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

import { beforeAll, describe, expect, it } from '@ohos/hypium';
import {
  LogUtil,
  BasePageController,
  IPageOrderController,
  PageAction,
  PageKey,
} from '@ohos/hwstartupguide.common';
import { PageOrderController } from '../../../../../main/ets/controller/PageOrderController';

const TAG: string = 'BasePageControllerTest';

/**
 * BasePageController 抽象类测试
 */
export default function BasePageControllerTest() {
  const key = 'ChildPageControllerTag';
  let col: BasePageController;
  describe('BasePageControllerTest', () => {
    beforeAll(() => {
      class ChildPageController extends BasePageController {
        constructor(pageOrderController: IPageOrderController) {
          super(pageOrderController, PageKey.DEFINED_FOR_DT)
        }
      }

      col = new ChildPageController(PageOrderController.getInstance());
    });
    /**
     * @tc.number: BasePageControllerTest_001
     * @tc.name: BasePageController抽象类测试
     */
    it('BasePageControllerTest_001', 0, async () => {
      LogUtil.info(TAG, `BasePageControllerTest_001 start`);
      expect(col.getKey()).assertInstanceOf('String');
      let setNeedShow = (): void => {
        col.setNeedShow(true);
      };
      expect(setNeedShow).not().assertFail();
      LogUtil.info(TAG, `BasePageControllerTest_001 end`);
    });

    /**
     * @tc.number: BasePageControllerTest_002
     * @tc.name: BasePageController抽象类测试
     */
    it("BasePageControllerTest_002", 0, async () => {
      LogUtil.info(TAG, `BasePageControllerTest_002 start`);
      col.isNeedShow();
      col.getAbility();
      expect(col.getPageOrderController()).not().assertUndefined();
      LogUtil.info(TAG, `BasePageControllerTest_002 end`);
    });

    /**
     * @tc.number: BasePageControllerTest_003
     * @tc.name: BasePageController抽象类测试
     */
    it("BasePageControllerTest_003", 0, async () => {
      LogUtil.info(TAG, `BasePageControllerTest_003 start`);
      let handlePrevButtonClick = (): void => {
        col.handlePrevButtonClick();
      };
      expect(handlePrevButtonClick).not().assertFail();
      LogUtil.info(TAG, `BasePageControllerTest_003 end`);
    });

    /**
     * @tc.number: BasePageControllerTest_003
     * @tc.name: BasePageController抽象类测试
     */
    it("BasePageControllerTest_004", 0, async () => {
      LogUtil.info(TAG, `BasePageControllerTest_004 start`);
      expect(col.getPageConfig()).assertEqual(undefined);
      let loadPage = (): void => {
        col.loadPage(1);
      };
      expect(loadPage).not().assertFail();
      LogUtil.info(TAG, `BasePageControllerTest_004 end`);
    });

    /**
     * @tc.number: BasePageControllerTest_005
     * @tc.name: BasePageController抽象类测试
     */
    it("BasePageControllerTest_005", 0, async () => {
      LogUtil.info(TAG, `BasePageControllerTest_004 start`);
      let loadPage = (): void => {
        col.loadPage(PageAction.ACTION_DEFAULT);
      };
      expect(loadPage).not().assertFail();
      LogUtil.info(TAG, `BasePageControllerTest_005 end`);
    });
  });
}
