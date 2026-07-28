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
  CommonConstant,
  DeviceUtil,
  QrCodeUtils,
  SettingUtil,
  SharePreferences
} from '@ohos/hwstartupguide.common';
import { SceneTypeManager } from '@ohos/hwstartupguide.common/src/main/ets/manager/SceneTypeManager';
import settings from '@ohos.settings';

const TAG: string = 'SceneTypeManagerTest';

/**
 * SceneTypeManager工具类测试
 */
export default function SceneTypeManagerTest() {
  describe('SceneTypeManagerTest', () => {
    afterAll(() => {
      SettingUtil.setValueSync(CommonConstant.DEVICE_PROVISIONED, '1');
      SettingUtil.setValueSync(CommonConstant.SECURE_USER_SETUP_COMPLETE, '1', settings.domainName.USER_SECURITY);
      SettingUtil.setValueSync(CommonConstant.SECURE_IS_OTA_FINISHED, '1', settings.domainName.USER_SECURITY);
    })

    it('SceneTypeManagerTest_001', 0, async (done: Function) => {
      SettingUtil.setValueSync(CommonConstant.DEVICE_PROVISIONED, '0');
      SettingUtil.setValueSync(CommonConstant.SECURE_USER_SETUP_COMPLETE, '1', settings.domainName.USER_SECURITY);
      SettingUtil.setValueSync(CommonConstant.SECURE_IS_OTA_FINISHED, '1', settings.domainName.USER_SECURITY);
      let handleAbilityResult = (): void => {
        SceneTypeManager.getInstance().init();
      };
      expect(handleAbilityResult).not().assertFail();
      done();
    });

    it('SceneTypeManagerTest_002', 0, async (done: Function) => {
      SettingUtil.setValueSync(CommonConstant.DEVICE_PROVISIONED, '1');
      SettingUtil.setValueSync(CommonConstant.SECURE_USER_SETUP_COMPLETE, '0', settings.domainName.USER_SECURITY);
      SettingUtil.setValueSync(CommonConstant.SECURE_IS_OTA_FINISHED, '1', settings.domainName.USER_SECURITY);
      SettingUtil.setValueSync(CommonConstant.HMOS_2_NEXT_FLAG, 'EMPTY');
      let handleAbilityResult = (): void => {
        SceneTypeManager.getInstance().init();
      };
      expect(handleAbilityResult).not().assertFail();
      done();
    });

    it('SceneTypeManagerTest_005', 0, async () => {
      SettingUtil.setValueSync(CommonConstant.DEVICE_PROVISIONED, CommonConstant.STATUS_OFF);
      SettingUtil.setValueSync(CommonConstant.SECURE_USER_SETUP_COMPLETE, CommonConstant.STATUS_NO_FINISHED,
        settings.domainName.USER_SECURITY);

      expect(SceneTypeManager.getInstance().isNewSubUser()).assertFalse();
    })


    it('SceneTypeManagerTest_006', 0, async () => {
      SettingUtil.setValueSync(CommonConstant.DEVICE_PROVISIONED, CommonConstant.STATUS_ON);
      SettingUtil.setValueSync(CommonConstant.SECURE_USER_SETUP_COMPLETE, CommonConstant.STATUS_FINISHED,
        settings.domainName.USER_SECURITY);

      expect(SceneTypeManager.getInstance().isNewSubUser()).assertFalse();
    })

    it('SceneTypeManagerTest_007', 0, async () => {
      SettingUtil.setValueSync(CommonConstant.DEVICE_PROVISIONED, CommonConstant.STATUS_OFF);
      SettingUtil.setValueSync(CommonConstant.SECURE_USER_SETUP_COMPLETE, CommonConstant.STATUS_FINISHED,
        settings.domainName.USER_SECURITY);
      expect(SceneTypeManager.getInstance().isNewSubUser()).assertFalse();
    })

    it('SceneTypeManagerTest_008', 0, async () => {
      expect(SceneTypeManager.getInstance().isOtaIncomplete()).assertInstanceOf('Boolean');
    });

    it('SceneTypeManagerTest_init', 0, async () => {
      let mocker: MockKit = new MockKit();
      // changeOtaStatus(true);
      changeIsMigratePrivacySpaceStatus(true);
      SceneTypeManager.getInstance().init();
      changeIsMigratePrivacySpaceStatus(false);
      SceneTypeManager.getInstance().init();
      changeOtaStatus(false);
      SceneTypeManager.getInstance().init();
      SharePreferences.getInstance().setValue(CommonConstant.HMOS_2_NEXT_FLAG, CommonConstant.IS_HMOS_2_NEXT);
      changeIsNewSubUser(true);
      SceneTypeManager.getInstance().init();
      changeIsNewSubUser(false);
      let isDevicePcMock: Function = mocker.mockFunc(DeviceUtil, DeviceUtil.isDevicePc);
      when(isDevicePcMock)(ArgumentMatchers.any).afterReturn(true);
      let isNeedQrCodeMock: Function = mocker.mockFunc(QrCodeUtils, QrCodeUtils.isNeedQrCode);
      when(isNeedQrCodeMock)(ArgumentMatchers.any).afterReturn(true);
      let handleAbilityResult = (): void => {
        SceneTypeManager.getInstance().init();
      };
      expect(handleAbilityResult).not().assertFail();
      mocker.clearAll();
    });

    it('SceneTypeManagerTest_initUpgradeFromDual', 0, async () => {
      SettingUtil.setValueSync(CommonConstant.UPGRADE_FROM_DUAL, 'test', settings.domainName.USER_SECURITY);
      let handleAbilityResult = (): void => {
        SceneTypeManager.getInstance().init();
      };
      expect(handleAbilityResult).not().assertFail();
      // changeOtaStatus(true);
    });

  })
}

function changeOtaStatus(res: boolean) {
  SettingUtil.setValueSync(CommonConstant.SECURE_IS_OTA_FINISHED,
    res ? CommonConstant.STATUS_NO_FINISHED : CommonConstant.STATUS_FINISHED,
    settings.domainName.USER_SECURITY);
}

function changeIsMigratePrivacySpaceStatus(res: boolean) {
  SettingUtil.setValueSync(CommonConstant.MIGRATE_PRIVACY_SPACE_STATUS,
    res ? CommonConstant.MIGRATE_PRIVACY_SPACE_STATUS_ON : CommonConstant.MIGRATE_PRIVACY_SPACE_STATUS_OFF);
}

function changeIsNewSubUser(res: boolean) {
  SettingUtil.setValueSync(CommonConstant.DEVICE_PROVISIONED,
    res ? CommonConstant.STATUS_FINISHED : CommonConstant.STATUS_NO_FINISHED);
  SettingUtil.setValueSync(CommonConstant.SECURE_USER_SETUP_COMPLETE,
    res ? CommonConstant.STATUS_NO_FINISHED : CommonConstant.STATUS_FINISHED,
    settings.domainName.USER_SECURITY);
}
