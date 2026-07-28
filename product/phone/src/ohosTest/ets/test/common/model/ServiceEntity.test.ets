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
import { ServiceEntity, LogUtil, PageConfig, PageConfigManager } from '@ohos/hwstartupguide.common';

const TAG: string = 'SeriviceEntityTest';

/**
 * SeriviceEntity工具类测试
 */
export default function SeriviceEntityTest() {
  describe('SeriviceEntityTest', () => {

    /*
       * @tc.number:SeriviceEntityTest_001
       * @tc.name: PageConfigManager工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: SeriviceEntityTest工具类测试
       */
    it('SeriviceEntityTest_001', 0, async () => {
      LogUtil.info(TAG, 'SeriviceEntityTest_001 start');
      let serviceEntity = new ServiceEntity(new Object());
      let addParamValue = (): void => {
        serviceEntity.addParamValue('a','abc');
      };
      expect(addParamValue).not().assertFail();
      LogUtil.info(TAG, 'SeriviceEntityTest_001 end');
    });

    /*
    * @tc.number:SeriviceEntityTest_002
    * @tc.name: PageConfigManager工具类测试
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: SeriviceEntityTest工具类测试
    */
    it('SeriviceEntityTest_002', 0, async () => {
      LogUtil.info(TAG, 'SeriviceEntityTest_002 start');
      let serviceEntity = new ServiceEntity(new Object());
      expect(serviceEntity.getParamValue(null)).assertEqual('');
      expect(serviceEntity.getParamValue(undefined)).assertEqual('');
      expect(serviceEntity.getParamValue('a')).assertEqual('');
      serviceEntity.addParamValue('a','abc');
      expect(serviceEntity.getParamValue('a')).assertEqual('abc');
      LogUtil.info(TAG, 'SeriviceEntityTest_002 end');
    });

    /*
    * @tc.number:SeriviceEntityTest_004
    * @tc.name: PageConfigManager工具类测试
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: SeriviceEntityTest工具类测试
    */
    it('SeriviceEntityTest_004', 0, async () => {
      LogUtil.info(TAG, 'SeriviceEntityTest_004 start');
      let serviceEntity = new ServiceEntity(new Object());
      expect(serviceEntity.getAbility('')).assertEqual(undefined);
      expect(serviceEntity.getAbility('a')).assertEqual(undefined);
      serviceEntity.addAbility('a',{
        bundleName: 'a_bundle_name',
        abilityName: 'a_ability_name',
      });
      expect(serviceEntity.getAbility('a')?.bundleName).assertEqual('a_bundle_name');
      expect(serviceEntity.getAbility('a')?.abilityName).assertEqual('a_ability_name');
      LogUtil.info(TAG, 'SeriviceEntityTest_004 end');
    });

    /*
    * @tc.number:SeriviceEntityTest_005
    * @tc.name: PageConfigManager工具类测试
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: SeriviceEntityTest工具类测试
    */
    it('SeriviceEntityTest_005', 0, async () => {
      LogUtil.info(TAG, 'SeriviceEntityTest_005 start');
      let serviceEntity = new ServiceEntity(new Object());
      serviceEntity.setServiceType('basic');
      expect(serviceEntity.getServiceType()).assertEqual(1);
      serviceEntity.setServiceType('enhance');
      expect(serviceEntity.getServiceType()).assertEqual(2);
      LogUtil.info(TAG, 'SeriviceEntityTest_005 end');
    });

    /*
    * @tc.number:SeriviceEntityTest_006
    * @tc.name: PageConfigManager工具类测试
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: SeriviceEntityTest工具类测试
    */
    it('SeriviceEntityTest_006', 0, async () => {
      LogUtil.info(TAG, 'SeriviceEntityTest_006 start');
      let serviceEntity = new ServiceEntity(new Object());
      serviceEntity.setTitle('abc');
      expect(serviceEntity.getTitle()).assertEqual('abc');
      serviceEntity.addParamValue('a','abc');
      expect(serviceEntity.getTitle()).assertEqual('abc');
      LogUtil.info(TAG, 'SeriviceEntityTest_006 end');
    });

    /*
    * @tc.number:SeriviceEntityTest_007
    * @tc.name: PageConfigManager工具类测试
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: SeriviceEntityTest工具类测试
    */
    it('SeriviceEntityTest_007', 0, async () => {
      LogUtil.info(TAG, 'SeriviceEntityTest_007 start');
      let serviceEntity = new ServiceEntity(new Object());
      serviceEntity.setServiceExpanded(true);
      expect(serviceEntity.isServiceExpanded()).assertTrue();
      LogUtil.info(TAG, 'SeriviceEntityTest_007 end');
    });

    /*
    * @tc.number:SeriviceEntityTest_008
    * @tc.name: PageConfigManager工具类测试
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: SeriviceEntityTest工具类测试
    */
    it('SeriviceEntityTest_008', 0, async () => {
      LogUtil.info(TAG, 'SeriviceEntityTest_008 start');
      let serviceEntity = new ServiceEntity(new Object());
      serviceEntity.setServiceVisible(true);
      expect(serviceEntity.isServiceVisible()).assertTrue();
      serviceEntity.setServiceVisible(false);
      expect(serviceEntity.isServiceVisible()).assertFalse();
      LogUtil.info(TAG, 'SeriviceEntityTest_008 end');
    });

    /*
   * @tc.number:SeriviceEntityTest_009
   * @tc.name: PageConfigManager工具类测试
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: SeriviceEntityTest工具类测试
   */
    it('SeriviceEntityTest_009', 0, async () => {
      LogUtil.info(TAG, 'SeriviceEntityTest_009 start');
      let serviceEntity = new ServiceEntity(new Object());
      serviceEntity.setSwitchDisabled(true);
      expect(serviceEntity.getSwitchDisabled()).assertTrue();
      serviceEntity.setSwitchDisabled(false);
      expect(serviceEntity.getSwitchDisabled()).assertFalse();
      LogUtil.info(TAG, 'SeriviceEntityTest_009 end');
    });

    /*
   * @tc.number:SeriviceEntityTest_010
   * @tc.name: PageConfigManager工具类测试
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: SeriviceEntityTest工具类测试
   */
    it('SeriviceEntityTest_010', 0, async () => {
      LogUtil.info(TAG, 'SeriviceEntityTest_010 start');
      let serviceEntity = new ServiceEntity(new Object());
      serviceEntity.setServiceChecked(true);
      expect(serviceEntity.isServiceChecked()).assertTrue();
      serviceEntity.setServiceChecked(false);
      expect(serviceEntity.isServiceChecked()).assertFalse();
      LogUtil.info(TAG, 'SeriviceEntityTest_010 end');
    });


    /*
   * @tc.number:SeriviceEntityTest_011
   * @tc.name: PageConfigManager工具类测试
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: SeriviceEntityTest工具类测试
   */
    it('SeriviceEntityTest_011', 0, async () => {
      LogUtil.info(TAG, 'SeriviceEntityTest_011 start');
      let serviceEntity = new ServiceEntity(new Object());
      serviceEntity.setAgreeTime('100');
      expect(serviceEntity.getAgreeTime()).assertEqual('100');
      LogUtil.info(TAG, 'SeriviceEntityTest_011 end');
    });

    /*
   * @tc.number:SeriviceEntityTest_012
   * @tc.name: PageConfigManager工具类测试
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: SeriviceEntityTest工具类测试
   */
    it('SeriviceEntityTest_012', 0, async () => {
      LogUtil.info(TAG, 'SeriviceEntityTest_012 start');
      let serviceEntity = new ServiceEntity(new Object());
      serviceEntity.setAgreeVersion('1.1.0');
      expect(serviceEntity.getAgreeVersion()).assertEqual('1.1.0');
      LogUtil.info(TAG, 'SeriviceEntityTest_012 end');
    });
  })
}