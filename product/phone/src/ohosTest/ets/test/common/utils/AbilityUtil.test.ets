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

import common from '@ohos.app.ability.common';
import resmgr from '@ohos.resourceManager';
import { beforeAll, describe, expect, it } from '@ohos/hypium';
import {
  AbilityManager,
  AbilityUtil,
  GlobalContext,
  LogUtil,
  PageConfig,
  RawFileUtil,
} from '@ohos/hwstartupguide.common';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';

const TAG: string = 'HwStartupGuide_AbilityUtilTest';

export default function AbilityUtilTest() {
  describe('AbilityUtilTest', () => {
    beforeAll(async () => {
      LogUtil.info(TAG, 'HwStartUp AbilityStage onCreate1');
    });

    /*
    * @tc.number:AbilityUtilTest_001
    * @tc.name: 启动ability测试
    */
    it('AbilityUtilTest_001', 0, async () => {
      let want: Want = {
        bundleName: 'com.ohos.openharmony.settings',
        abilityName: 'com.ohos.openharmony.settings.MainAbility',
      };
      let uiAbility = GlobalContext.getInstance().getObject('guideHomeAbility') as UIAbility;
      let localPage: string = 'page_configs.json';
      let config: PageConfig = new PageConfig([]);
      RawFileUtil.getStringByFile(localPage)
        .then((content: string) => {
          let jsonArray: Array<Object> = JSON.parse(content);
          config = new PageConfig(jsonArray[0]);
        });
      expect(AbilityUtil.startAbilityByContext('', '')).assertPromiseIsRejected;
      expect(AbilityUtil.startAbilityByContext(want.bundleName as string, want.abilityName as string)).assertPromiseIsPending;

      AbilityUtil.startAbilityForResult('', '', undefined, (err, result) => {
        expect(result).assertNull();
      });
      AbilityUtil.startAbilityForResult('', '', undefined, (err, result) => {
        expect(result).assertNull();
      });
      AbilityUtil.startAbilityForResultByPageConfig(config, (err, result) => {
        expect(result).assertNull();
      });
      config.setBundleName('com.ohos.openharmony.settings');
      config.setAbilityName('com.ohos.openharmony.settings.MainAbility');
      config.setParams({
        1: 'a',
      });
      AbilityUtil.startAbilityForResult(
        config.getBundleName(),
        config.getAbilityName(),
        config.getParams(),
        (err, result) => {
        expect(result).assertNull();
      });
      //startAbility
      expect(AbilityUtil.startAbility('', '')).assertPromiseIsRejected;
      expect(AbilityUtil.startAbility('', '')).assertPromiseIsResolved;
      expect(AbilityUtil.startAbility('', '')).assertThrowError;
      expect(AbilityUtil.startAbility(
        'com.ohos.openharmony.settings', 'com.ohos.openharmony.settings.MainAbility')).assertPromiseIsPending;
      uiAbility = new UIAbility();
      expect(AbilityUtil.startAbility('', '')).assertPromiseIsRejected;
      AbilityUtil.startAbilityForResult('', '', undefined, (err, result) => {
        expect(result).assertNull();
      });
    });

    /*
    * @tc.number:AbilityUtilTest_002
    * @tc.name: 销毁退出ability测试
    */
    it('AbilityUtilTest_002', 0, async () => {
      expect(AbilityUtil.terminateSelf())
        .assertPromiseIsPending;
    });

    /*
    * @tc.number:AbilityUtilTest_003
    * @tc.name: 是否UIAbility测试
    */
    it('AbilityUtilTest_003', 0, async () => {
      expect(AbilityUtil.isUIAbility(undefined)).assertFalse();
      expect(AbilityUtil.isUIAbility('')).assertFalse();
      expect(AbilityUtil.isUIAbility('ability')).assertFalse();
      expect(AbilityUtil.isUIAbility('com.ohos.settings.OobeWifiSettingsExtensionAbility')).assertFalse();
      expect(AbilityUtil.isUIAbility('com.ohos.settings.EnterpriseOobeAbility')).assertFalse();
    });

    /**
     * @tc.number: AbilityUtilTest_004
     * @tc.name: 测试
     */
    it('AbilityUtilTest_004', 0, async () => {
      LogUtil.info(TAG, 'AbilityUtilTest_004 start');
      expect(AbilityUtil.terminateSelf())
        .assertPromiseIsPending;
      LogUtil.info(TAG, 'AbilityUtilTest_004 end');
    });

    /**
     * @tc.number: AbilityUtilTest_005
     * @tc.name: 测试
     */
    it('AbilityUtilTest_005', 0, async () => {
      LogUtil.info(TAG, 'AbilityUtilTest_005 start');
      expect(AbilityUtil.startAbilityByContext('', '')).assertPromiseIsRejected;
      LogUtil.info(TAG, 'AbilityUtilTest_005 end');
    });

    /*
    * @tc.number:AbilityUtilTest_006
    * @tc.name: isAbilityAvailable测试
    */
    it('AbilityUtilTest_006', 0, async () => {
      let config: PageConfig = new PageConfig([]);
      config.setKey('account_login');
      config.setAbilityName('AccountBasicAbility');
      config.setBundleName('com.openharmony.ohos.id');
      expect(AbilityUtil.isAbilityAvailable(config)).assertPromiseIsPending();
    });
  });
}
