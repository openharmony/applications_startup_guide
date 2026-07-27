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

import {
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import {
  CommonConstant,
  LogUtil,
  OOBEUtil,
  PageKey,
  SettingUtil
} from '@ohos/hwstartupguide.common';
import { SceneTypeManager } from '@ohos/hwstartupguide.common/src/main/ets/manager/SceneTypeManager';

const TAG: string = 'OOBEUtilTest';

/**
 * OOBEUtil 工具类测试
 */
export default function OOBEUtilTest() {
  describe('OOBEUtilTest', () => {

    /**
     * @tc.number: OOBEUtilTest_001
     * @tc.name: OOBEUtil工具类测试
     */
    it('OOBEUtilTest_001', 0, async () => {
      LogUtil.info(TAG, `OOBEUtilTest_001 start`);
      let deviceStatus = SettingUtil.getValueSync(CommonConstant.DEVICE_PROVISIONED, CommonConstant.STATUS_ON);
      let userSetUp = SettingUtil.getValueSync(CommonConstant.SECURE_USER_SETUP_COMPLETE, CommonConstant.STATUS_FINISHED);
      let versionInfo = SettingUtil.getValueSync(CommonConstant.SECURE_BUILD_VERSION_RELEASE, OOBEUtil.getDisplayVersion());

      expect(deviceStatus).assertInstanceOf('String');
      LogUtil.info(TAG, `deviceStatus: ${deviceStatus}`);

      expect(userSetUp).assertInstanceOf('String');
      LogUtil.info(TAG, `userSetUp: ${userSetUp}`);

      expect(versionInfo).assertInstanceOf('String');
      LogUtil.info(TAG, `versionInfo: ${versionInfo}`);
      LogUtil.info(TAG, `OOBEUtilTest_001 end`);
    });

    /**
     * @tc.number: OOBEUtilTest_002
     * @tc.name: OOBEUtil工具类测试
     */
    it('OOBEUtilTest_002', 0, async () => {
      LogUtil.info(TAG, `OOBEUtilTest_002 start`);
      expect(OOBEUtil.getDisplayVersion()).not().assertEqual('NOH-AN00 204.1.0.13(SP1C00E13R1P13log)');

      // 测试获取系统参数为空的情况
      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(OOBEUtil, OOBEUtil.getSysParamVersion);
      when(mockFunc)().afterReturn(null);
      LogUtil.info(TAG, `getSysParamVersion: ${OOBEUtil.getSysParamVersion()}`);
      expect(OOBEUtil.getDisplayVersion()).not().assertEqual('NOH-AN00 4.1.0.13(SP1C00E13R1P13log)');
      LogUtil.info(TAG, `OOBEUtilTest_002 end`);
    });

    /**
     * @tc.number: OOBEUtilTest_003
     * @tc.name: OOBEUtil工具类测试
     */
    it('OOBEUtilTest_003', 0, async () => {
      LogUtil.info(TAG, `OOBEUtilTest_003 start`);
      let updateSystemParams = (): void => {
        SceneTypeManager.getInstance().updateSettingsData();
      };
      expect(updateSystemParams).not().assertFail();
      LogUtil.info(TAG, `OOBEUtilTest_003 end`);
    });

    /**
     * @tc.number: OOBEUtilTest_004
     * @tc.name: OOBEUtil工具类测试
     */
    it('OOBEUtilTest_004', 0, async () => {
      LogUtil.info(TAG, `OOBEUtilTest_004 start`);
      let handleFuncRes = (): void => {
        OOBEUtil.addPageButtonMap(PageKey.WELCOME, `${PageKey.WELCOME}_${new Date().toString()}`);
      };
      expect(handleFuncRes).not().assertFail();
      LogUtil.info(TAG, `OOBEUtilTest_004 end`);
    });
  });
}
