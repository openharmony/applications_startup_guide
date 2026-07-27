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

import { describe, expect, it } from '@ohos/hypium';
import { LogUtil, SystemParameterUtil } from '@ohos/hwstartupguide.common';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import systemParameter from '@ohos.systemparameter';


const TAG: string = 'SystemParameterUtil';
const OHOS_BOOT_SHIPMODE: string = 'ohos.boot.shipmode';

/**
 * OtaUtil 工具类测试
 */
export default function SystemParameterUtilTest() {
  describe('SystemParameterUtil', () => {

    /**
     * @tc.number: SystemParameterUtilTest_001
     * @tc.name: OtaUtil工具类测试
     */
    it('SystemParameterUtilTest_001', 0, async () => {
      LogUtil.info(TAG, `SystemParameterUtilTest_001 start`);
      systemParameterEnhance.set(OHOS_BOOT_SHIPMODE, '1');
      let isFirstBoot: string = SystemParameterUtil.getSync(OHOS_BOOT_SHIPMODE, '');
      expect(isFirstBoot).assertInstanceOf('String');
    });
  });
}