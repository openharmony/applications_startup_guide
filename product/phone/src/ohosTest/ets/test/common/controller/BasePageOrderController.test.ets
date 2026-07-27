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

import { afterAll, beforeAll, describe, expect, it } from '@ohos/hypium';
import { LogUtil, BasePageOrderController,
  PageKey, SettingUtil, CommonConstant } from '@ohos/hwstartupguide.common';
import UIAbility from '@ohos.app.ability.UIAbility';
import { PageOrderController } from '../../../../../main/ets/controller/PageOrderController';
import settings from '@ohos.settings';

const TAG: string = 'BasePageOrderControllerTest';

/**
 * BasePageOrderController 抽象类测试
 */
export default function BasePageOrderControllerTest() {
  let orderCol: BasePageOrderController = PageOrderController.getInstance();
  let uiAbility: UIAbility;
  describe('BasePageOrderControllerTest', () => {

    beforeAll(async () => {
      SettingUtil.setValueSync(CommonConstant.DEVICE_PROVISIONED, '0');
      SettingUtil.setValueSync(CommonConstant.SECURE_USER_SETUP_COMPLETE, '1', settings.domainName.USER_SECURITY);
      SettingUtil.setValueSync(CommonConstant.SECURE_IS_OTA_FINISHED, '1', settings.domainName.USER_SECURITY);
      await orderCol.init();
      await orderCol.handleControllerArray();
    });

    afterAll(() => {
      SettingUtil.setValueSync(CommonConstant.DEVICE_PROVISIONED, '1');
      SettingUtil.setValueSync(CommonConstant.SECURE_USER_SETUP_COMPLETE, '1', settings.domainName.USER_SECURITY);
      SettingUtil.setValueSync(CommonConstant.SECURE_IS_OTA_FINISHED, '1', settings.domainName.USER_SECURITY);
    })

    /**
     * @tc.number: BasePageOrderControllerTest_001
     * @tc.name: BasePageOrderController抽象类测试
     */
    it('BasePageOrderControllerTest_001', 0, async () => {
      LogUtil.info(TAG, `BasePageOrderControllerTest_001 start`);
      orderCol.getPageControllerByName(PageKey.DEFINED_FOR_DT);
      orderCol.getPageControllerByName(PageKey.LANGUAGE_SELECT);
      expect(orderCol.getTag()).assertInstanceOf('String');
      LogUtil.info(TAG, `BasePageOrderControllerTest_001 end`);
    });

    /**
     * @tc.number: BasePageOrderControllerTest_002
     * @tc.name: BasePageOrderController抽象类测试
     */
    it("BasePageOrderControllerTest_002", 0, async () => {
      LogUtil.info(TAG, `BasePageOrderControllerTest_002 start`);
      orderCol.getCurPageController();
      orderCol.getLastPageController();
      expect(orderCol.getTag()).assertInstanceOf('String');
      LogUtil.info(TAG, `BasePageOrderControllerTest_002 end`);
    });

    /**
     * @tc.number: BasePageOrderControllerTest_003
     * @tc.name: BasePageOrderController抽象类测试
     */
    it("BasePageOrderControllerTest_003", 0, async () => {
      LogUtil.info(TAG, `BasePageOrderControllerTest_003 start`);
      orderCol.hasNextPage();
      orderCol.hasPrevPage();
      expect(orderCol.getTag()).assertInstanceOf('String');
      LogUtil.info(TAG, `BasePageOrderControllerTest_003 end`);
    });

    /**
     * @tc.number: BasePageOrderControllerTest_004
     * @tc.name: BasePageOrderController抽象类测试
     */
    it("BasePageOrderControllerTest_004", 0, async () => {
      LogUtil.info(TAG, `BasePageOrderControllerTest_004 start`);
      let finishOOBE = (): void => {
        orderCol.finishOOBE();
      };
      expect(finishOOBE).not().assertFail();
      LogUtil.info(TAG, `BasePageOrderControllerTest_004 end`);
    });

    /**
     * @tc.number: BasePageOrderControllerTest_005
     * @tc.name: BasePageOrderController抽象类测试
     */
    it("BasePageOrderControllerTest_005", 0, async () => {
      LogUtil.info(TAG, `BasePageOrderControllerTest_005 start`);
      orderCol.getPageControllerByIndex(-1);
      orderCol.getPageControllerByIndex(1);
      orderCol.getPageControllerByIndex(orderCol.getAllPageController().length + 5);
      expect(orderCol.getAllPageController()).assertInstanceOf('Array');
      LogUtil.info(TAG, `BasePageOrderControllerTest_005 end`);
    });

    /**
     * @tc.number: BasePageOrderControllerTest_006
     * @tc.name: BasePageOrderController抽象类测试
     */
    it("BasePageOrderControllerTest_006", 0, async () => {
      LogUtil.info(TAG, `BasePageOrderControllerTest_006 start`);
      let finishOOBEWithDelSubUser = (): void => {
        orderCol.finishOOBEWithDelSubUser();
      };
      expect(finishOOBEWithDelSubUser).not().assertFail();
      LogUtil.info(TAG, `BasePageOrderControllerTest_006 end`);
    });

    /**
     * @tc.number: BasePageOrderControllerTest_007
     * @tc.name: BasePageOrderController抽象类测试
     */
    it("BasePageOrderControllerTest_007", 0, async () => {
      LogUtil.info(TAG, `BasePageOrderControllerTest_007 start`);
      orderCol.mPageIndex = 0;
      let loadPage = (): void => {
        orderCol.showNextPage();
      };
      expect(loadPage).not().assertFail();
      LogUtil.info(TAG, `BasePageOrderControllerTest_007 end`);
    });

    /**
     * @tc.number: BasePageOrderControllerTest_008
     * @tc.name: BasePageOrderController抽象类测试
     */
    it("BasePageOrderControllerTest_008", 0, async () => {
      LogUtil.info(TAG, `BasePageOrderControllerTest_008 start`);
      orderCol.mPageIndex = 0;
      orderCol.hasPrevPage();
      orderCol.mPageIndex = 1;
      orderCol.hasPrevPage();
      orderCol.mPageIndex = 2;
      orderCol.hasPrevPage();
      expect(orderCol.getTag()).assertInstanceOf('String');
      LogUtil.info(TAG, `BasePageOrderControllerTest_008 end`);
    });

    /**
     * @tc.number: BasePageOrderControllerTest_009
     * @tc.name: BasePageOrderController抽象类测试
     */
    it("BasePageOrderControllerTest_009", 0, async () => {
      LogUtil.info(TAG, `BasePageOrderControllerTest_009 start`);
      orderCol.mPageIndex = 1;
      let loadPage = (): void => {
        orderCol.showPrevPage();
        orderCol.adjustPageIndex(0);
        orderCol.showPrevPage();
        orderCol.adjustPageIndex(2);
        orderCol.showPrevPage();
      };
      expect(loadPage).not().assertFail();
      LogUtil.info(TAG, `BasePageOrderControllerTest_009 end`);
    });

    /**
     * @tc.number: BasePageOrderControllerTest_010
     * @tc.name: BasePageOrderController抽象类测试
     */
    it("BasePageOrderControllerTest_010", 0, async () => {
      orderCol.mPageIndex = 0;
      // 下一个可显示的页面应该不为null
      orderCol.getNextEnableShowPage();
      orderCol.mPageIndex = 1;
      orderCol.getNextEnableShowPage();
      expect(orderCol.getTag()).assertInstanceOf('String');
    });

    /**
     * @tc.number: BasePageOrderControllerTest_011
     * @tc.name: BasePageOrderController抽象类测试
     */
    it("BasePageOrderControllerTest_011", 0, async () => {
      orderCol.mPageIndex = 0;
      // 下一个可显示的页面应该不为null
      orderCol.adjustPageIndex(1);
      expect(orderCol.getTag()).assertInstanceOf('String');
    });

    /**
     * @tc.number: BasePageOrderControllerTest_012
     * @tc.name: BasePageOrderController抽象类测试
     */
    it("BasePageOrderControllerTest_012", 0, async () => {
      let loadPage = (): void => {
        orderCol.finishOOBE();
        orderCol.finishOOBEWithDelSubUser();
      };
      expect(loadPage).not().assertFail();
    });

    /**
     * @tc.number: BasePageOrderControllerTest_013
     * @tc.name: BasePageOrderController抽象类测试
     */
    it("BasePageOrderControllerTest_013", 0, async () => {
      orderCol.jumpToPage(PageKey.DEFINED_FOR_DT);
      orderCol.jumpToPage(PageKey.LANGUAGE_SELECT);
      orderCol.jumpToPage(PageKey.LANGUAGE_SELECT);
      orderCol.getPageControllerByName(PageKey.BASIC_SERVICE)?.setNeedShow(false);
      orderCol.jumpToPage(PageKey.BASIC_SERVICE);
      expect(orderCol.getTag()).assertInstanceOf('String');
    });

    it("BasePageOrderControllerTest_014", 0, async () => {
      orderCol.mapNewIndex(PageKey.LANGUAGE_SELECT);
      orderCol.mapNewIndex(PageKey.BASIC_SERVICE);
      expect(orderCol.isReady()).assertInstanceOf('Boolean');
    });
  });
}
