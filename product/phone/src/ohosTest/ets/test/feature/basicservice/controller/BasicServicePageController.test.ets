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

import { afterAll, ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import {
  LogUtil,
  RawFileUtil,
  ServiceEntityUtil,
  ServiceEntity,
  EventEmitter,
  EventReceiver,
  Event,
  CommonConstant
} from '@ohos/hwstartupguide.common';
import { BasicServicePageController, BasicServiceUtil } from '@ohos/hwstartupguide.basicservice';
import { PageOrderController } from '../../../../../../main/ets/controller/PageOrderController';

const TAG: string = 'BasicServicePageControllerTest';

class TestEventReceiver implements EventReceiver {
  public events: Event[] = [];

  constructor() {
    EventEmitter.getInstance().addEventReceiver(this);
  }

  public receive(event: Event): void {
    this.events.push(event);
  }

  public clear() {
    this.events.splice(0, this.events.length);
  }
}

export default function BasicServicePageControllerTest() {
  describe('BasicServicePageControllerTest', () => {
    /**
     * @tc.number:BasicServicePageControllerTest_001
     * @tc.name: BasicServicePageController工具类测试
     */
    it('BasicServicePageControllerTest_001', 0, async () => {
      LogUtil.info(TAG, `BasicServicePageControllerTest_001 start`);
      let controller = new BasicServicePageController(PageOrderController.getInstance());
      expect(controller.initBasicServiceList()).assertPromiseIsPending();
      LogUtil.info(TAG, `BasicServicePageControllerTest_001 end`);
    });

    /**
     * @tc.number:BasicServicePageControllerTest_005
     * @tc.name: BasicServicePageController工具类测试
     */
    it('BasicServicePageControllerTest_004', 0, async () => {
      LogUtil.info(TAG, `BasicServicePageControllerTest_004 start`);
      let controller = new BasicServicePageController(PageOrderController.getInstance());

      let mockKit: MockKit = new MockKit();
      let mockFunc1: Function = mockKit.mockFunc(BasicServiceUtil, BasicServiceUtil.isHasAgreedValueFromSP);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(new Promise<string>((res: Function, rej: Function) => {
        res(true);
      }));

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(new Promise<string>((res: Function, rej: Function) => {
        res(false);
      }));
      let mockFunc3: Function = mockKit.mockFunc(BasicServiceUtil, BasicServiceUtil.isAgreedFromSettings);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(new Promise<string>((res: Function, rej: Function) => {
        res(false);
      }));
      expect(controller.initBasicServiceList()).assertPromiseIsPending();
      LogUtil.info(TAG, `BasicServicePageControllerTest_004 end`);
    });

    /**
     * @tc.number:BasicServicePageControllerTest_005
     * @tc.name: BasicServicePageController工具类测试
     */
    it('BasicServicePageControllerTest_005', 0, async () => {
      let controller = new BasicServicePageController(PageOrderController.getInstance());
      controller.handlePrevButtonClick();
      expect(controller.initBasicServiceList()).assertPromiseIsPending();
    });

    /**
     * @tc.number:BasicServicePageControllerTest_006
     * @tc.name: BasicServicePageController工具类测试
     */
    it('BasicServicePageControllerTest_006', 0, async () => {
      let controller = new BasicServicePageController(PageOrderController.getInstance());
      controller.saveBasicServiceData();
      expect(controller.initBasicServiceList()).assertPromiseIsPending();
    });

    it('BasicServicePageControllerTest_007', 0, async () => {
      let controller = new BasicServicePageController(PageOrderController.getInstance());
      expect(controller.getBasicServiceList().length).assertEqual(0);
    })

    it('BasicServicePageControllerTest_008', 0, () => {
      let controller = new BasicServicePageController(PageOrderController.getInstance());
      controller.showExitDialog();
      expect(AppStorage.get(CommonConstant.SHOW_EXIT_DIALOG)).assertTrue();
    })

    afterAll(async ()=>{
      let controller = new BasicServicePageController(PageOrderController.getInstance());
      await controller.configNeedShow();
      controller.handleNextButtonClick();
      controller.getBasicServiceList();
      controller.confirmExit();
      controller.pageAppear();
    })
  });
}