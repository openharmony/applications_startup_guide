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

import { ArgumentMatchers, beforeAll, describe, expect, it, MockKit, when, afterAll } from '@ohos/hypium';
import common from '@ohos.app.ability.common';
import {
  GlobalContext,
  LogUtil,
  ServiceEntity,
  SharePreferences,
} from '@ohos/hwstartupguide.common';
import { ServiceStatementUtil } from '@ohos/hwstartupguide.otaservice';
import { EMPTY_IDENTIFY } from '@ohos/hwstartupguide.common/src/main/ets/util/StringUtil';


const TAG: string = 'ServiceStatementUtilTest';

export default function ServiceStatementUtilTest() {
  describe('ServiceStatementUtilTest', () => {
    beforeAll(async () => {
      LogUtil.info(TAG, 'ServiceStatementUtilTest start');
    });

    /**
     * @tc.number:OtaServiceUtilTest_001
     * @tc.name: ota工具类测试
     */
    it('ServiceStatementUtilTest_001', 0, async () => {
      LogUtil.info(TAG, `ServiceStatementUtilTest_001 start`);
      let sp0 = await ServiceStatementUtil.getVersionFromSP(null);
      expect(sp0).assertNull();
      LogUtil.info(TAG, `ServiceStatementUtilTest_001 end`);
    });

    /**
     * @tc.number:OtaServiceUtilTest_002
     * @tc.name: ota工具类测试
     */
    it('ServiceStatementUtilTest_002', 0, async () => {
      LogUtil.info(TAG, `ServiceStatementUtilTest_002 start`);
      let sp1 = await ServiceStatementUtil.getVersionFromSP(null);
      expect(sp1).assertNull();
      LogUtil.info(TAG, `ServiceStatementUtilTest_002 end`);
    });

    /**
     * @tc.number:OtaServiceUtilTest_005
     * @tc.name: ota工具类测试
     */
    it('ServiceStatementUtilTest_005', 0, async () => {
      LogUtil.info(TAG, `ServiceStatementUtilTest_005 start`);
      let sp3 = (): void => {
        ServiceStatementUtil.updateVersionToSP(null);
      }
      expect(sp3).not().assertFail();
      LogUtil.info(TAG, `ServiceStatementUtilTest_005 end`);
    });

    /**
     * @tc.number:OtaServiceUtilTest_006
     * @tc.name: ota工具类测试
     */
    it('ServiceStatementUtilTest_006', 0, async () => {
      LogUtil.info(TAG, `ServiceStatementUtilTest_006 start`);
      let context = GlobalContext.getInstance().getObject('context') as common.Context;
      let sp1 = (): void => {
        ServiceStatementUtil.updateVersionToSP(null);
      }
      expect(sp1).not().assertFail();
      LogUtil.info(TAG, `ServiceStatementUtilTest_006 end`);
    });

    /**
     * @tc.number:OtaServiceUtilTest_007
     * @tc.name: ota工具类测试
     */
    it('ServiceStatementUtilTest_007', 0, async () => {
      LogUtil.info(TAG, `ServiceStatementUtilTest_006 start`);
      let context = GlobalContext.getInstance().getObject('context') as common.Context;
      let se_a: ServiceEntity = new ServiceEntity(new Object());
      se_a.setServiceType('enhanced');
      se_a.setServiceName('serviceName');
      se_a.setTitle('test_title');
      se_a.setServiceChecked(true);
      ServiceStatementUtil.updateVersionToSP(null);
      let handleAbilityResult = (): void => {
        ServiceStatementUtil.updateVersionToSP(se_a);
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, `ServiceStatementUtilTest_007 end`);
    });

    afterAll(async () => {
      LogUtil.info(TAG, 'ServiceStatementUtilTest end');
    })
  });
}
