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
import { LogUtil, ServiceEntity, ServiceType, } from '@ohos/hwstartupguide.common';

const TAG: string = 'OobeFrameworkTest';

/**
 * SR000HUB7O 支持外部应用接入OOBE页面框架
 * SR000HUB7N 页面管理框架
 */
export default function OobeFrameworkTest() {
  describe('OobeFrameworkTest', () => {

    /*
       * @tc.number:basicservicePageTest_001
       * @tc.name: 协议数据结构测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: 协议数据结构测试
       */
    it('OobeFrameworkTest_001', 0, async () => {
      LogUtil.info(TAG, 'OobeFrameworkTest_001 start');

      let se: ServiceEntity = new ServiceEntity(new Object());
      se.setServiceType('basic');
      se.setServiceName('ouc');
      se.setTitle('test_title');

      // 属性
      expect('').assertDeepEquals('');

      // title
      expect(se.getTitle()).assertDeepEquals('test_title');
      expect(se.getServiceType()).assertDeepEquals(ServiceType.BASIC);

      // params
      expect(se.getParamValue('')).assertDeepEquals('');
      expect(se.getParamValue(null)).assertDeepEquals('');
      expect(se.getParamValue(undefined)).assertDeepEquals('');
      expect(se.getParamValue('1')).assertDeepEquals('');
      se.addParamValue('1', '3');
      expect(se.getParamValue('1')).assertDeepEquals('3');
      se.addParamValue('2', '4');
      expect(se.getParamValue('2')).assertDeepEquals('4');
      // abilities
      expect(se.getAbility('')).assertEqual(undefined);
      expect(se.getAbility('1')).assertEqual(undefined);
      se.addAbility('ouc', {
        bundleName: 'ouc_bundle_name',
        abilityName: 'ouc_ability_name',
      });
      expect(se.getAbility('ouc')?.bundleName).assertEqual('ouc_bundle_name');
      expect(se.getAbility('ouc')?.abilityName).assertEqual('ouc_ability_name');
      expect(se.getAbilities().size).assertDeepEquals(1);
      // title
      expect(se.getTitle()).assertDeepEquals('test_title');
      LogUtil.info(TAG, 'OobeFrameworkTest_001 end');
    });
  })
}
