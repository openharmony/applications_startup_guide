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

import { LogUtil } from '@ohos/hwstartupguide.common';
import {
  EDM_PROVISIONING_OFFLINE_MODE,
  EnterpriseDeviceManager,
  OFFLINE_TRIGGER_COUNT,
  OfflineTriggerType,
} from '@ohos/hwstartupguide.welcome/src/main/ets/manager/EnterpriseDeviceManager';
import { afterAll, beforeAll, describe, expect, it } from '@ohos/hypium';

const TAG: string = 'EnterpriseDeviceManagerTest';

/**
 * 根据次数和类型执行触发离线定制暗码
 * @param enterpriseDeviceManager 企业设备管理对象
 * @param times 执行次数
 * @param type 触发类型 0:触摸屏触摸 1:鸿蒙键
 */
function handleOfflineTriggerExecuteTimesByType(enterpriseDeviceManager: EnterpriseDeviceManager, times: number,
  type: number) {
  for (let index = 0; index < times; index++) {
    enterpriseDeviceManager.handleOfflineTrigger(type);
  }
}

export default function EnterpriseDeviceManagerTest() {

  describe('EnterpriseDeviceManagerTest', () => {
    beforeAll(async () => {
      LogUtil.info(TAG, 'EnterpriseDeviceManagerTest start');
    });

    /**
     * @tc.number:EnterpriseDeviceManagerTest_001
     * @tc.name: 按六次鸿蒙键触发离线定制流程
     */
    it('EnterpriseDeviceManagerTest_001', 0, () => {
      LogUtil.info(TAG, 'EnterpriseDeviceManagerTest_001 start');
      let enterpriseDeviceManager: EnterpriseDeviceManager = new EnterpriseDeviceManager();
      AppStorage.setOrCreate(EDM_PROVISIONING_OFFLINE_MODE, false);
      handleOfflineTriggerExecuteTimesByType(enterpriseDeviceManager, OFFLINE_TRIGGER_COUNT, OfflineTriggerType.Press);
      expect(AppStorage.get<boolean>(EDM_PROVISIONING_OFFLINE_MODE)).assertDeepEquals(true);
      LogUtil.info(TAG, 'EnterpriseDeviceManagerTest_001 end');
    });

    /**
     * @tc.number:EnterpriseDeviceManagerTest_002
     * @tc.name: 按六次屏幕触发离线定制流程
     */
    it('EnterpriseDeviceManagerTest_002', 0, () => {
      LogUtil.info(TAG, 'EnterpriseDeviceManagerTest_002 start');
      AppStorage.setOrCreate(EDM_PROVISIONING_OFFLINE_MODE, false);
      let enterpriseDeviceManager: EnterpriseDeviceManager = new EnterpriseDeviceManager();
      handleOfflineTriggerExecuteTimesByType(enterpriseDeviceManager, OFFLINE_TRIGGER_COUNT, OfflineTriggerType.Touch);
      expect(AppStorage.get<boolean>(EDM_PROVISIONING_OFFLINE_MODE)).assertDeepEquals(true);
      LogUtil.info(TAG, 'EnterpriseDeviceManagerTest_002 end');
    });

    /**
     * @tc.number:EnterpriseDeviceManagerTest_003
     * @tc.name: 鸿蒙键和触屏组合测试触发离线定制
     * @tc.describe:
     * 1.注册鸿蒙键监听
     * 2.按3次屏幕再按3次鸿蒙键
     * 3.判断是否触发离线定制模式
     * 4.再按3次鸿蒙键
     * 5.注销鸿蒙键监听
     * 6.清理所有计数器
     * 7.判断是否触发离线定制模式
     */
    it('EnterpriseDeviceManagerTest_003', 0, () => {
      LogUtil.info(TAG, 'EnterpriseDeviceManagerTest_003 start');
      AppStorage.setOrCreate(EDM_PROVISIONING_OFFLINE_MODE, false);
      let enterpriseDeviceManager: EnterpriseDeviceManager = new EnterpriseDeviceManager();
      enterpriseDeviceManager.registerKeysIntercept();
      handleOfflineTriggerExecuteTimesByType(enterpriseDeviceManager, 3, OfflineTriggerType.Touch);
      handleOfflineTriggerExecuteTimesByType(enterpriseDeviceManager, 3, OfflineTriggerType.Press);
      expect(AppStorage.get<boolean>(EDM_PROVISIONING_OFFLINE_MODE)).assertDeepEquals(false);
      handleOfflineTriggerExecuteTimesByType(enterpriseDeviceManager, 3, OfflineTriggerType.Press);
      enterpriseDeviceManager.unRegisterKeyIntercept();
      enterpriseDeviceManager.clearTimers();
      expect(AppStorage.get<boolean>(EDM_PROVISIONING_OFFLINE_MODE)).assertDeepEquals(true);
      LogUtil.info(TAG, 'EnterpriseDeviceManagerTest_003 end');
    });

    /**
     * @tc.number:EnterpriseDeviceManagerTest_004
     * @tc.name: 鸿蒙键和触屏排列组合测试触发离线定制
     */
    it('EnterpriseDeviceManagerTest_004', 0, () => {
      LogUtil.info(TAG, 'EnterpriseDeviceManagerTest_004 start');
      AppStorage.setOrCreate(EDM_PROVISIONING_OFFLINE_MODE, false);
      let enterpriseDeviceManager: EnterpriseDeviceManager = new EnterpriseDeviceManager();
      handleOfflineTriggerExecuteTimesByType(enterpriseDeviceManager, 3, OfflineTriggerType.Touch);
      enterpriseDeviceManager.clearTimer(OfflineTriggerType.Touch);
      handleOfflineTriggerExecuteTimesByType(enterpriseDeviceManager, 3, OfflineTriggerType.Touch);
      expect(AppStorage.get<boolean>(EDM_PROVISIONING_OFFLINE_MODE)).assertDeepEquals(false);
      handleOfflineTriggerExecuteTimesByType(enterpriseDeviceManager, 3, OfflineTriggerType.Touch);
      expect(AppStorage.get<boolean>(EDM_PROVISIONING_OFFLINE_MODE)).assertDeepEquals(true);
      LogUtil.info(TAG, 'EnterpriseDeviceManagerTest_004 end');
    });

    /**
     * @tc.number:EnterpriseDeviceManagerTest_005
     * @tc.name: 已经触发离线定制后再次触摸屏幕
     */
    it('EnterpriseDeviceManagerTest_005', 0, () => {
      LogUtil.info(TAG, 'EnterpriseDeviceManagerTest_005 start');
      AppStorage.setOrCreate(EDM_PROVISIONING_OFFLINE_MODE, true);
      let enterpriseDeviceManager: EnterpriseDeviceManager = new EnterpriseDeviceManager();
      handleOfflineTriggerExecuteTimesByType(enterpriseDeviceManager, 3, OfflineTriggerType.Touch);
      expect(AppStorage.get<boolean>(EDM_PROVISIONING_OFFLINE_MODE)).assertDeepEquals(true);
      LogUtil.info(TAG, 'EnterpriseDeviceManagerTest_005 end');
    });
  });

  afterAll(async () => {
    LogUtil.info(TAG, 'EnterpriseDeviceManagerTest end');
  });
}