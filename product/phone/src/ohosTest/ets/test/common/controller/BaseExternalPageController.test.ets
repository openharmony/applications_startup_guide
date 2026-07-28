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
  BaseExternalPageController,
  IPageOrderController,
  PageAction,
  PageKey,
} from '@ohos/hwstartupguide.common';
import { PageOrderController } from '../../../../../main/ets/controller/PageOrderController';

const TAG: string = 'BaseExternalPageControllerTest';

/**
 * BaseExternalPageController 抽象类测试
 */
export default function BaseExternalPageControllerTest() {
  let externalCol: BaseExternalPageController;
  describe('BaseExternalPageControllerTest', () => {
    beforeAll(() => {
      class ChildExternalPageController extends BaseExternalPageController {
        constructor(pageOrderController: IPageOrderController) {
          super(pageOrderController, PageKey.DEFINED_FOR_DT)
        }
      }

      externalCol = new ChildExternalPageController(PageOrderController.getInstance());
    });

    /**
     * @tc.number: BaseExternalPageControllerTest_001
     * @tc.name: BaseExternalPageController抽象类测试
     */
    it('BaseExternalPageControllerTest_001', 0, async () => {
      LogUtil.info(TAG, `BaseExternalPageControllerTest_001 start`);
      let handleReceivedData = (): void => {
        externalCol.handleReceivedData({});
      };
      expect(handleReceivedData).not().assertFail();
      LogUtil.info(TAG, `BaseExternalPageControllerTest_001 end`);
    });

    /**
     * @tc.number: BaseExternalPageControllerTest_002
     * @tc.name: BaseExternalPageController抽象类测试
     */
    it("BaseExternalPageControllerTest_002", 0, async () => {
      LogUtil.info(TAG, `BaseExternalPageControllerTest_002 start`);
      let handleAbilityResult = (): void => {
        externalCol.handleAbilityResult(null);
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `BaseExternalPageControllerTest_002 end`);
    });

    /**
     * @tc.number: BaseExternalPageControllerTest_003
     * @tc.name: BaseExternalPageController抽象类测试
     */
    it("BaseExternalPageControllerTest_003", 0, async () => {
      LogUtil.info(TAG, `BaseExternalPageControllerTest_003 start`);
      let handleAbilityResult = (): void => {
        externalCol.loadPage(1);
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `BaseExternalPageControllerTest_003 end`);
    });

    /**
     * @tc.number: BaseExternalPageControllerTest_004
     * @tc.name: BaseExternalPageController抽象类测试
     */
    it("BaseExternalPageControllerTest_004", 0, async () => {
      LogUtil.info(TAG, `BaseExternalPageControllerTest_004 start`);
      externalCol.unMonitorKeyboardHeightChanged();
      let handleAbilityResult = (): void => {
        externalCol.unMonitorKeyboardHeightChanged();
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `BaseExternalPageControllerTest_004 end`);
    });

    /**
     * @tc.number: BaseExternalPageControllerTest_005
     * @tc.name: BaseExternalPageController抽象类测试
     */
    it("BaseExternalPageControllerTest_005", 0, async () => {
      LogUtil.info(TAG, `BaseExternalPageControllerTest_005 start`);
      let handleAbilityResult = (): void => {
        externalCol.handleLoadAbilityError(0);
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `BaseExternalPageControllerTest_005 end`);
    });

    /**
     * @tc.number: BaseExternalPageControllerTest_006
     * @tc.name: BaseExternalPageController抽象类测试
     */
    it("BaseExternalPageControllerTest_006", 0, async () => {
      LogUtil.info(TAG, `BaseExternalPageControllerTest_006 start`);
      let handleAbilityResult = (): void => {
        externalCol.handleAbilityResult({
          resultCode: 100
        });
        externalCol.handleAbilityResult({
          resultCode: 101
        });
        externalCol.handleAbilityResult({
          resultCode: 99
        });
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `BaseExternalPageControllerTest_006 end`);
    });

    /**
     * @tc.number: BaseExternalPageControllerTest_007
     * @tc.name: BaseExternalPageController抽象类测试
     */
    it("BaseExternalPageControllerTest_007", 0, async () => {
      LogUtil.info(TAG, `BaseExternalPageControllerTest_007 start`);
      let data:Record<string, Object> = {
        'resultCode': 100,
      };
      externalCol.handleReceivedData(data);
      let data2:Record<string, Object> = {
        'test': 100,
      };
      let handleAbilityResult = (): void => {
        externalCol.handleReceivedData(data2);
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `BaseExternalPageControllerTest_007 end`);
    });

    /**
     * @tc.number: BaseExternalPageControllerTest_008
     * @tc.name: BaseExternalPageController抽象类测试
     */
    it("BaseExternalPageControllerTest_008", 0, async () => {
      LogUtil.info(TAG, `BaseExternalPageControllerTest_008 start`);
      let handleAbilityResult = (): void => {
        externalCol.sendData();
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `BaseExternalPageControllerTest_008 end`);
    });

    /**
     * @tc.number: BaseExternalPageControllerTest_009
     * @tc.name: BaseExternalPageController抽象类测试
     */
    it("BaseExternalPageControllerTest_009", 0, async () => {
      LogUtil.info(TAG, `BaseExternalPageControllerTest_009 start`);
      let handleAbilityResult = (): void => {
        externalCol.loadPage(PageAction.ACTION_DEFAULT);
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `BaseExternalPageControllerTest_009 end`);
    });

    /**
     * @tc.number: BaseExternalPageControllerTest_010
     * @tc.name: BaseExternalPageController抽象类测试
     */
    it("BaseExternalPageControllerTest_010", 0, async () => {
      LogUtil.info(TAG, `BaseExternalPageControllerTest_010 start`);
      let data:Record<string, Object> = {
        'eventCode': NaN,
      };
      let handleAbilityResult = (): void => {
        externalCol.handleReceivedData(data);
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `BaseExternalPageControllerTest_010 end`);
    });

    /**
     * @tc.number: BaseExternalPageControllerTest_011
     * @tc.name: BaseExternalPageController抽象类测试
     */
    it("BaseExternalPageControllerTest_011", 0, async () => {
      LogUtil.info(TAG, `BaseExternalPageControllerTest_011 start`);
      let procy:UIExtensionProxy = {
        send() {''},
        sendSync() {return {}},
        on() {''},
        off() {''},
      };
      let handleAbilityResult = (): void => {
        externalCol.setDataSendProxy(procy);
        externalCol.monitorKeyboardHeightChanged(procy);
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `BaseExternalPageControllerTest_011 end`);
    });

  });
}
