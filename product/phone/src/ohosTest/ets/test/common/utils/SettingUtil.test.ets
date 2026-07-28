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
import { GlobalContext, LogUtil, SettingUtil } from '@ohos/hwstartupguide.common';

const TAG: string = 'SettingUtilTest';

/**
 * SettingUtil工具类测试
 */
export default function SettingUtilTest() {
  describe('SettingUtilTest', () => {

    /**
     * @tc.number:SettingUtilTest_002
     * @tc.name: StringUtil工具类测试，测试获取settingData内容
     */
    it('SettingUtilTest_002', 0, async () => {
      LogUtil.info(TAG, `SettingUtilTest_002 start`);
      GlobalContext.getInstance().setObject('pageContext', null);
      let input: string | undefined | null = 'user_setup_test1';
      let res = SettingUtil.getValueSync(input, '1');
      expect(res).assertInstanceOf('String');
      let res2 = SettingUtil.setValueSync(input, '0');
      expect(res2).assertInstanceOf('Boolean');
      LogUtil.info(TAG, `SettingUtilTest_002 end`);
    });

    /**
     * @tc.number:SettingUtilTest_003
     * @tc.name: StringUtil工具类测试，测试获取settingData内容
     */
    it('SettingUtilTest_003', 0, async () => {
      LogUtil.info(TAG, `SettingUtilTest_003 start`);
      GlobalContext.getInstance().setObject('pageContext', null);
      let input: string | undefined | null = 'user_setup_test1';
      let res = SettingUtil.getValueDirect(input, '1');
      expect(res).assertInstanceOf('String');
      LogUtil.info(TAG, `SettingUtilTest_003 end`);
    });

  });
}