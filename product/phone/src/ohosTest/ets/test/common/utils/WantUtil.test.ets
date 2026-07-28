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
import { describe, expect, it, MockKit, when } from '@ohos/hypium';
import { CommonConstant, LogUtil, OOBEUtil, SettingUtil, WantUtil } from '@ohos/hwstartupguide.common';
import Want from '@ohos.app.ability.Want';


const TAG: string = 'WantUtilTest';

export default function WantUtilTest() {
  describe('WantUtilTest', () => {

    /*
     * @tc.number:WantUtilTest_001
     * @tc.name: WantUtilTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: WantUtilTest工具类测试
     */
    it('WantUtilTest_001', 0, async () => {
      LogUtil.info(TAG, 'WantUtilTest_001 start');
      expect(WantUtil.isValidPrivacyWant({
        bundleName: 'a_bundle_name',
        abilityName: 'a_ability_name',
      })).assertEqual(true);
      expect(WantUtil.isValidPrivacyWant({
        bundleName: 'a_bundle_name',
        abilityName: '',
      })).assertEqual(false);
      expect(WantUtil.isValidPrivacyWant({
        bundleName: '',
        abilityName: '',
      })).assertEqual(false);
      LogUtil.info(TAG, 'WantUtilTest_001 end');
    });

    /*
     * @tc.number:WantUtilTest_002
     * @tc.name: WantUtilTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: WantUtilTest工具类测试
     */
    it('WantUtilTest_002', 0, async () => {
      LogUtil.info(TAG, 'WantUtilTest_002 start');
      expect(WantUtil.isOobePrivacyWant({
        bundleName: 'a_bundle_name',
        abilityName: 'a_ability_name',
      })).assertEqual(true);
      expect(WantUtil.isValidPrivacyWant({
        bundleName: 'com.ohos.startupguide',
        abilityName: '',
      })).assertEqual(false);
      LogUtil.info(TAG, 'WantUtilTest_002 end');
    });

    /*
     * @tc.number:WantUtilTest_003
     * @tc.name: WantUtilTest工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: WantUtilTest工具类测试
     */
    it('WantUtilTest_003', 0, async () => {
      LogUtil.info(TAG, 'WantUtilTest_003 start');
      expect(WantUtil.isOobePrivacyWant({
        bundleName: 'com.openharmony',
        abilityName: '',
      })).assertEqual(true);
      expect(WantUtil.isOobePrivacyWant({
        bundleName: 'com.ohos.startupguide',
        abilityName: '',
      })).assertEqual(false);
      LogUtil.info(TAG, 'WantUtilTest_003 end');
    });

    /*
     * @tc.number:WantUtilTest_004
     * @tc.name: 显式Want构造测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 验证启动Want仅保留显式目标和参数，不携带隐式匹配字段
     */
    it('WantUtilTest_004', 0, async () => {
      LogUtil.info(TAG, 'WantUtilTest_004 start');
      let sourceWant: Want = {
        bundleName: 'com.example.bundle',
        abilityName: 'ExampleAbility',
        action: 'example.action',
        uri: 'example://privacy',
        parameters: {
          return_index: 4061,
        },
      };
      let explicitWant = WantUtil.buildExplicitStartWant(
        sourceWant.bundleName as string,
        sourceWant.abilityName as string,
        sourceWant.parameters
      );
      expect(explicitWant).not().assertNull();
      expect(explicitWant?.bundleName).assertEqual('com.example.bundle');
      expect(explicitWant?.abilityName).assertEqual('ExampleAbility');
      expect(explicitWant?.parameters).assertEqual(sourceWant.parameters);
      expect(explicitWant?.action).assertUndefined();
      expect(explicitWant?.uri).assertUndefined();
      let implicitWant: Want = {
        action: 'example.action',
      };
      expect(WantUtil.isExplicitStartWant(implicitWant)).assertEqual(false);
      expect(WantUtil.buildExplicitStartWant('', 'ExampleAbility', sourceWant.parameters)).assertNull();
      LogUtil.info(TAG, 'WantUtilTest_004 end');
    });
  })
}