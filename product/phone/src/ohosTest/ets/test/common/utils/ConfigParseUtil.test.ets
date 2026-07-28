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

import { BusinessError } from '@ohos.base';
import { beforeAll, describe, expect, it } from '@ohos/hypium';
import { AbilityManager, ConfigParseUtil, LogUtil, PageConfig, GlobalContext } from '@ohos/hwstartupguide.common';
import common from '@ohos.app.ability.common';

const TAG: string = 'ConfigParseUtilTest';

export default function ConfigParseUtilTest() {
  describe('ConfigParseUtilTest', () => {
    beforeAll(async () => {
      LogUtil.info(TAG, 'HwStartUp AbilityStage onCreate1');
    });

    /*
    * @tc.number: ConfigParseUtil_001
    * @tc.name: 测试
    */
    it('ConfigParseUtil_001', 0, async () => {
      expect(ConfigParseUtil.loadCcmConfigs().catch((err: BusinessError) => {
      })).assertPromiseIsRejected;
    });

    /*
    * @tc.number: ConfigParseUtil_002
    * @tc.name: 测试
    */
    it('ConfigParseUtil_002', 0, async () => {
      let strMap = GlobalContext.getInstance().getObject('context') as Map<string, PageConfig>;
      expect(ConfigParseUtil.parseLocalPageConfigs(strMap).catch((err: BusinessError) => {
      })).assertPromiseIsRejected;

      AbilityManager.getInstance().setContext(GlobalContext.getInstance().getObject('context') as common.Context);
      expect(ConfigParseUtil.parseLocalPageConfigs(strMap).catch((err: BusinessError) => {
      })).assertPromiseIsRejected;
    });

    /*
    * @tc.number: ConfigParseUtil_003
    * @tc.name: 测试
    */
    it('ConfigParseUtil_003', 0, async () => {
      expect(ConfigParseUtil.parseCcmConfigsTemp().catch((err: BusinessError) => {
      })).assertPromiseIsRejected;
    });
  });
}
