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

import { beforeAll, describe, expect, it } from '@ohos/hypium';
import {
  CommonConstant,
  LogUtil,
  ServiceEntity,
  SharePreferences
} from '@ohos/hwstartupguide.common';
import { BasicServiceUtil } from '@ohos/hwstartupguide.basicservice';
import { BasicServiceConstant } from '@ohos/hwstartupguide.basicservice/src/main/ets/constant/BasicServiceConstant';
import { SceneTypeManager } from '@ohos/hwstartupguide.common/src/main/ets/manager/SceneTypeManager';
import { abilityDelegatorRegistry } from '@kit.TestKit';

const TAG: string = 'BasicServiceUtilTest';

export default function BasicServiceUtilTest() {
  describe('BasicServiceUtilTest', () => {
    let context: Context;

    beforeAll(() => {
      context = abilityDelegatorRegistry.getAbilityDelegator().getAppContext();
    })

    /**
     * @tc.number:BasicServiceUtilTest_001
     * @tc.name: 基础协议工具类测试
     */
    it('BasicServiceUtilTest_001', 0, async () => {
      LogUtil.info(TAG, `BasicServiceUtilTest_001 start`);
      let saveAgreedStatusToSP = (): void => {
        BasicServiceUtil.saveAgreedStatusToSP(null, true);
      }
      expect(saveAgreedStatusToSP).not().assertFail();
      LogUtil.info(TAG, `BasicServicePageTest_001 end`);
    });

    /**
     * @tc.number:BasicServiceUtilTest_004
     * @tc.name: 基础协议工具类测试
     */
    it('BasicServiceUtilTest_004', 0, async () => {
      LogUtil.info(TAG, `BasicServiceUtilTest_004 start`);
      BasicServiceUtil.saveAgreedStatusToSP(context, true);
      let result =
        await SharePreferences.getInstance().getValue(BasicServiceConstant.KEY_BASIC_SERVICE_AGREE_STATE, false);
      expect(result).assertInstanceOf('String');
      LogUtil.info(TAG, `BasicServiceUtilTest_004 end`);
    });

    /**
     * @tc.number:BasicServiceUtilTest_006
     * @tc.name: 基础协议工具类测试
     */
    it('BasicServiceUtilTest_006', 0, async () => {
      LogUtil.info(TAG, `BasicServiceUtilTest_006 start`);
      BasicServiceUtil.saveAgreedStatusToSP(context, false);
      let result =
        await SharePreferences.getInstance().getValue(BasicServiceConstant.KEY_BASIC_SERVICE_AGREE_STATE, true);
      expect(result).assertInstanceOf('String');
      LogUtil.info(TAG, `BasicServiceUtilTest_006 end`);
    });

    /**
     * @tc.number:BasicServiceUtilTest_007
     * @tc.name: 基础协议工具类测试
     */
    it('BasicServiceUtilTest_007', 0, async () => {
      LogUtil.info(TAG, `BasicServiceUtilTest_007 start`);
      BasicServiceUtil.saveAgreedStatusToSP(context, true);
      let result = await BasicServiceUtil.isHasAgreedValueFromSP(context);
      expect(result).assertTrue();
      LogUtil.info(TAG, `BasicServiceUtilTest_007 end`);
    });

    /**
     * @tc.number:BasicServiceUtilTest_008
     * @tc.name: 基础协议工具类测试
     */
    it('BasicServiceUtilTest_008', 0, async () => {
      LogUtil.info(TAG, `BasicServiceUtilTest_008 start`);
      let result = await BasicServiceUtil.isHasAgreedValueFromSP(null);
      expect(result).assertEqual(false);
      LogUtil.info(TAG, `BasicServiceUtilTest_008 end`);
    });

    /**
     * @tc.number:BasicServiceUtilTest_009
     * @tc.name: 基础协议工具类测试
     */
    it('BasicServiceUtilTest_009', 0, async () => {
      LogUtil.info(TAG, `BasicServiceUtilTest_009 start`);
      let saveBasicStatementsToSP = (): void => {
        BasicServiceUtil.saveBasicStatementsToSP(null);
      }
      expect(saveBasicStatementsToSP).not().assertFail();
      LogUtil.info(TAG, `BasicServiceUtilTest_009 end`);
    });

    /**
     * @tc.number:BasicServiceUtilTest_010
     * @tc.name: 基础协议工具类测试
     */
    it('BasicServiceUtilTest_010', 0, async () => {
      LogUtil.info(TAG, `BasicServiceUtilTest_010 start`);
      let mBasicServiceList: Array<ServiceEntity> = [];
      let saveBasicStatementsToSP = (): void => {
        BasicServiceUtil.saveBasicStatementsToSP(mBasicServiceList);
      }
      expect(saveBasicStatementsToSP).not().assertFail();
      LogUtil.info(TAG, `BasicServiceUtilTest_010 end`);
    });

    /**
     * @tc.number:BasicServiceUtilTest_011
     * @tc.name: 基础协议工具类测试
     */
    it('BasicServiceUtilTest_011', 0, async () => {
      LogUtil.info(TAG, `BasicServiceUtilTest_011 start`);
      let se: ServiceEntity = new ServiceEntity(new Object());
      let mBasicServiceList: Array<ServiceEntity> = [];

      se.setServiceType('basic');
      se.setServiceName('ouc');
      se.setVersion(1.1);
      mBasicServiceList.push(se);
      BasicServiceUtil.saveBasicStatementsToSP(mBasicServiceList);
      let result =
        await SharePreferences.getInstance().getValue(`${se.getServiceName()}${CommonConstant.VERSION_SUFFIX}`, 0.0);
      expect(result).not().assertUndefined();
      LogUtil.info(TAG, `BasicServiceUtilTest_011 end`);
    });

    /**
     * @tc.number:BasicServiceUtilTest_012
     * @tc.name: 基础协议工具类测试
     */
    it('BasicServiceUtilTest_012', 0, async () => {
      LogUtil.info(TAG, `BasicServiceUtilTest_011 start`);
      let saveAgreedStatusToSetting = (): void => {
        SceneTypeManager.getInstance().saveAgreedStatusToSetting(false);
      }
      expect(saveAgreedStatusToSetting).not().assertFail();
      LogUtil.info(TAG, `BasicServiceUtilTest_012 end`);
    });

    /**
     * @tc.number:BasicServiceUtilTest_013
     * @tc.name: 基础协议工具类测试
     */
    it('BasicServiceUtilTest_013', 0, async () => {
      LogUtil.info(TAG, `BasicServiceUtilTest_013 start`);
      expect(BasicServiceUtil.isAgreedFromSettings()).not().assertNull();
      LogUtil.info(TAG, `BasicServiceUtilTest_013 end`);
    });
  });
}
