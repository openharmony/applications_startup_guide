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

import { DeviceUtil, IPageController, LogUtil, SceneType, SceneTypeManager } from '@ohos/hwstartupguide.common';

import { describe, it, expect, TestType, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { PageOrderController } from '../../../../../main/ets/controller/PageOrderController';

const TAG: string = 'PageOrderControllerTest';

export default function PageOrderControllerTest() {
  describe('PageOrderControllerTest', () => {
    let mocker: MockKit = new MockKit();
    let controller: PageOrderController = PageOrderController.getInstance();

    it('PageOrderControllerTest_initPageControllers_002', TestType.FUNCTION, async () => {
      LogUtil.info(TAG, 'PageOrderControllerTest_initPageControllers_002 start');
      expect(controller.isReady()).assertInstanceOf('Boolean');
      LogUtil.info(TAG, 'PageOrderControllerTest_initPageControllers_002 end');
    });

    it('PageOrderControllerTest_initPageControllers_003', TestType.FUNCTION, async () => {
      LogUtil.info(TAG, 'PageOrderControllerTest_initPageControllers_003 start');
      expect(controller.hasNextPage()).assertInstanceOf('Boolean');
      LogUtil.info(TAG, 'PageOrderControllerTest_initPageControllers_003 end');
    });

    it('PageOrderControllerTest_initPageControllers_004', TestType.FUNCTION, async () => {
      LogUtil.info(TAG, 'PageOrderControllerTest_initPageControllers_004 start');
      expect(controller.hasPrevPage()).assertInstanceOf('Boolean');
      LogUtil.info(TAG, 'PageOrderControllerTest_initPageControllers_004 end');
    });

    it('PageOrderControllerTest_initPageControllers_005', TestType.FUNCTION, async () => {
      LogUtil.info(TAG, 'PageOrderControllerTest_initPageControllers_005 start');
      expect(controller.isExperiencePage()).assertInstanceOf('Boolean');
      LogUtil.info(TAG, 'PageOrderControllerTest_initPageControllers_005 end');
    });

    it('PageOrderControllerTest_initControllerMap_006', TestType.FUNCTION, async () => {
      LogUtil.info(TAG, 'PageOrderControllerTest_initPageControllers_006 start');
      let sceneTypeManager: SceneTypeManager = SceneTypeManager.getInstance();
      let mockFun: Function = mocker.mockFunc(sceneTypeManager, sceneTypeManager.getSceneType);
      //异步拉起生产应用
      when(mockFun)(ArgumentMatchers.any).afterReturn(SceneType.FIRST_BOOT_SCENE);
      let showTipsFunc: Function = mocker.mockFunc(DeviceUtil, DeviceUtil.isOOBEShowImportantTips);
      when(showTipsFunc)(ArgumentMatchers.any).afterReturn(true);
      let fastCloneFunc: Function = mocker.mockFunc(DeviceUtil, DeviceUtil.isSupportFastClone);
      when(fastCloneFunc)(ArgumentMatchers.any).afterReturn(true);
      controller.initControllerMap();
      // 创建子用户场景
      when(mockFun)(ArgumentMatchers.any).afterReturn(SceneType.SUB_USER_SCENE);
      controller.initControllerMap();
      // ota场景
      when(mockFun)(ArgumentMatchers.any).afterReturn(SceneType.OTA_SCENE);
      let doubleFoldFunc: Function = mocker.mockFunc(DeviceUtil, DeviceUtil.isDoubleFold);
      when(doubleFoldFunc)(ArgumentMatchers.any).afterReturn(true);
      controller.initControllerMap();
      //小折叠OTA
      when(doubleFoldFunc)(ArgumentMatchers.any).afterReturn(false);
      let smallFoldFunc: Function = mocker.mockFunc(DeviceUtil, DeviceUtil.isSmallFoldScreen);
      when(smallFoldFunc)(ArgumentMatchers.any).afterReturn(true);
      controller.initControllerMap();
      // 隐私空间场景
      when(mockFun)(ArgumentMatchers.any).afterReturn(SceneType.PRIVATE_SPACE_SCENE);
      controller.initControllerMap();
      //其他
      when(mockFun)(ArgumentMatchers.any).afterReturn(6);
      let result = (): void => {
        controller.initControllerMap();
      };
      expect(result).not().assertFail();
      mocker.clearAll();
      LogUtil.info(TAG, 'PageOrderControllerTest_initPageControllers_006 end');
    });

  });
}