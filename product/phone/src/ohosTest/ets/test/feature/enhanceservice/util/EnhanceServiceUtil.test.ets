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

import { ArgumentMatchers, beforeAll, describe, expect, it, MockKit, when } from '@ohos/hypium';
import {
  CommonConstant,
  GlobalContext,
  LogUtil,
  ServiceEntity,
  SettingUtil,
  SharePreferences,
  SystemParameterUtil
} from '@ohos/hwstartupguide.common';
import { EnhanceServiceConstant, EnhanceServiceUtil, SaveDataFactory } from '@ohos/hwstartupguide.enhanceservice';
import { SimpleServiceEntity } from '../../../SimpleServiceEntity.test';

const TAG: string = 'EnhanceServiceUtilTest';
const sleep: Function = (ms: number): Promise<void> => {
  return new Promise(res => setTimeout(res, ms))
};

export default function EnhanceServiceUtilTest() {
  describe('EnhanceServiceUtilTest', () => {
    beforeAll(async () => {
      LogUtil.info(TAG, 'HwStartUp AbilityStage onCreate1');
      GlobalContext.getInstance().setObject('null', null);
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_001
    * @tc.name: 判断是否所有的增强服务均已勾选测试
    */
    it('EnhanceServiceUtilTest_001', 0, async () => {
      let contextNull: Context = GlobalContext.getInstance().getObject('null') as Context;
      let entityNull = GlobalContext.getInstance().getObject('null') as ServiceEntity
      LogUtil.info(TAG,"test null");
      // getTempCheckStatus
      try  {
        EnhanceServiceUtil.getTempCheckStatus(contextNull, entityNull)
      } catch (error) {
      };

      LogUtil.info(TAG,"test not null");
      let se_a: ServiceEntity = new ServiceEntity(new Object());
      se_a.setServiceType('enhanced');
      se_a.setServiceName('serviceName');
      se_a.setTitle('test_title');
      se_a.setServiceChecked(true);
      let ses: Array<ServiceEntity> = [];
      ses.push(se_a);
      GlobalContext.getInstance().setObject('context123', null);
      GlobalContext.getInstance().setObject('entity1', null);
      let context: Context = GlobalContext.getInstance().getObject('context') as Context;
      let context123: Context = GlobalContext.getInstance().getObject('context123') as Context;
      let entity1 = GlobalContext.getInstance().getObject('entity1') as ServiceEntity
      // 制造测试数据，以覆盖内部checkboxListStatus相关的逻辑
      let entity2 = new ServiceEntity(new SimpleServiceEntity());
      entity2.setCheckboxList(['settings=test_key']);
      SettingUtil.setValueSync('test_key', CommonConstant.STATUS_ON);
      await EnhanceServiceUtil.getTempCheckStatus(context, entity2);
      SettingUtil.setValueSync('test_key', CommonConstant.STATUS_OFF);
      await EnhanceServiceUtil.getTempCheckStatus(context, entity2);
      SettingUtil.setValueSync('test_key', CommonConstant.INVALID_VALUE);
      await EnhanceServiceUtil.getTempCheckStatus(context, entity2);

      entity2.setCheckboxList(['settings=test_key2']);
      expect(await EnhanceServiceUtil.getTempCheckStatus(context, entity2)).not().assertNull();

      EnhanceServiceUtil.setTempCheckStatus(contextNull, entity2, true);

      entity2.setSaveDataListList([]);
      EnhanceServiceUtil.setTempCheckStatus(context, entity2, true);
      EnhanceServiceUtil.setTempCheckStatus(context, entity2, false);

      entity2.setSaveDataListList(['test']);
      EnhanceServiceUtil.setTempCheckStatus(context, entity2, true);
      EnhanceServiceUtil.setTempCheckStatus(context, entity2, false);
      // saveServiceCheckStatus
      expect(EnhanceServiceUtil.saveServiceCheckStatus(context123, entity1));
      expect(EnhanceServiceUtil.saveServiceCheckStatus(context, entity1));
      expect(EnhanceServiceUtil.saveServiceCheckStatus(context, se_a));
      expect(EnhanceServiceUtil.saveServiceCheckStatus(context, entity2));
      let mocker: MockKit = new MockKit();
      let serviceEntity = new ServiceEntity([]);
      let mockfunc: Function = mocker.mockFunc(serviceEntity, serviceEntity.getSaveDataListList);
      when(mockfunc)().afterReturn(null);
      expect(serviceEntity.getSaveDataListList()).assertEqual(null);
      expect(EnhanceServiceUtil.saveServiceCheckStatus(context, se_a));
      // isEnableAllChecked
      expect(EnhanceServiceUtil.isEnableAllChecked(GlobalContext.getInstance()
        .getObject('ServiceEntity') as Array<ServiceEntity>)).assertEqual(0);
      expect(EnhanceServiceUtil.isEnableAllChecked(ses)).assertEqual(2);
      se_a.setServiceChecked(false);
      expect(EnhanceServiceUtil.isEnableAllChecked(ses)).assertEqual(0);
      let se_b: ServiceEntity = new ServiceEntity(new Object);
      se_b.setServiceChecked(true);
      ses.push(se_b);
      expect(EnhanceServiceUtil.isEnableAllChecked(ses)).assertEqual(1);
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getTempCheckStatus_001
    * @tc.name: 判断是否所有的增强服务均已勾选测试
    */
    it('EnhanceServiceUtilTest_getTempCheckStatus_001', 0, async () => {
      let se_a: ServiceEntity = new ServiceEntity(new Object());
      se_a.setServiceType('enhanced');
      se_a.setServiceName('serviceName');
      se_a.setTitle('test_title');
      se_a.setServiceChecked(true);

      GlobalContext.getInstance().setObject('context123', null);
      GlobalContext.getInstance().setObject('entity1', null);
      let context: Context = GlobalContext.getInstance().getObject('context') as Context;

      // getTempCheckStatus
      let ret = EnhanceServiceUtil.getTempCheckStatus(context, se_a);
      expect(ret).not().assertFail();
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getTempCheckStatus_002
    * @tc.name: 判断是否所有的增强服务均已勾选测试
    */
    it('EnhanceServiceUtilTest_getTempCheckStatus_002', 0, async () => {
      let se_a: ServiceEntity = new ServiceEntity(new Object());
      se_a.setServiceType('enhanced');
      se_a.setServiceName('serviceName');
      se_a.setTitle('test_title');
      se_a.setServiceChecked(true);

      GlobalContext.getInstance().setObject('context123', null);
      GlobalContext.getInstance().setObject('entity1', null);
      let context: Context = GlobalContext.getInstance().getObject('context') as Context;
      // getTempCheckStatus
      let ret = EnhanceServiceUtil.getTempCheckStatus(context, se_a);
      expect(ret).not().assertFail();
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getTempCheckStatus_003
    * @tc.name: 判断是否所有的增强服务均已勾选测试
    */
    it('EnhanceServiceUtilTest_getTempCheckStatus_003', 0, async () => {
      let se_a: ServiceEntity = new ServiceEntity(new Object());
      se_a.setServiceType('enhanced');
      se_a.setServiceName('serviceName');
      se_a.setTitle('test_title');
      se_a.setServiceChecked(true);

      GlobalContext.getInstance().setObject('context123', null);
      GlobalContext.getInstance().setObject('entity1', null);
      let context: Context = GlobalContext.getInstance().getObject('context') as Context;


      // getTempCheckStatus
      let ret = EnhanceServiceUtil.getTempCheckStatus(context, se_a);
      expect(ret).not().assertFail();
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_saveEnhanceStatementsToSP_001
    * @tc.name: 判断是否所有的增强服务均已勾选测试
    */
    it('EnhanceServiceUtilTest_saveEnhanceStatementsToSP_001', 0, async () => {
      let context: Context = GlobalContext.getInstance().getObject('context') as Context;
      let contextNull: Context = GlobalContext.getInstance().getObject('null') as Context;

      let mEnhanceServiceList: Array<ServiceEntity> = [];
      let enhanceService1: ServiceEntity = new ServiceEntity(new Object());
      enhanceService1.setServiceType('basic');
      enhanceService1.setServiceName('meetime_enhance_statement');
      enhanceService1.setServiceChecked(true);
      let enhanceService2: ServiceEntity = new ServiceEntity(new Object());
      enhanceService2.setServiceType('basic');
      enhanceService2.setServiceName('meetime_enhance_statement');
      enhanceService2.setServiceChecked(false);
      mEnhanceServiceList.push(enhanceService1, enhanceService2);
      EnhanceServiceUtil.saveEnhanceStatementsToSP(context, mEnhanceServiceList);

      EnhanceServiceUtil.saveEnhanceStatementsToSP(context, []);

      let result = (): void => {
        EnhanceServiceUtil.saveEnhanceStatementsToSP(contextNull, []);
      };
      expect(result).not().assertFail();
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_saveServiceCheckStatus_001
    * @tc.name: 判断是否所有的增强服务均已勾选测试
    */
    it('EnhanceServiceUtilTest_saveServiceCheckStatus_001', 0, async () => {
      GlobalContext.getInstance().setObject('context123', null);
      let context: Context = GlobalContext.getInstance().getObject('context123') as Context;
      let serviceEntity = GlobalContext.getInstance().getObject('context123') as ServiceEntity;

      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(EnhanceServiceUtil, EnhanceServiceUtil.getTempCheckStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(new Promise<string>((res: Function, rej: Function) => {
        res(false);
      }));

      expect(EnhanceServiceUtil.saveServiceCheckStatus(context, serviceEntity));
      expect(EnhanceServiceUtil.saveServiceCheckStatus(context, serviceEntity));


      let context1: Context = GlobalContext.getInstance().getObject('context') as Context;
      let enhanceService1: ServiceEntity = new ServiceEntity(new Object());
      enhanceService1.setServiceType('basic');
      enhanceService1.setServiceName('meetime_enhance_statement');
      enhanceService1.setServiceChecked(true);
      expect(EnhanceServiceUtil.saveServiceCheckStatus(context1, enhanceService1));

      enhanceService1.setSaveDataListList(['asd']);
      expect(EnhanceServiceUtil.saveServiceCheckStatus(context1, enhanceService1));

      let mockFunc1: Function = mockKit.mockFunc(SaveDataFactory, SaveDataFactory.getHandler);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('OK');
      expect(EnhanceServiceUtil.saveServiceCheckStatus(context1, enhanceService1));

      when(mockFunc1)(ArgumentMatchers.any).afterThrow('error xxx');
      expect(EnhanceServiceUtil.saveServiceCheckStatus(context, enhanceService1));
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_saveServiceCheckStatus_002
    * @tc.name: 判断是否所有的增强服务均已勾选测试
    */
    it('EnhanceServiceUtilTest_saveServiceCheckStatus_002', 0, async () => {

      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(EnhanceServiceUtil, EnhanceServiceUtil.getTempCheckStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(new Promise<string>((res: Function, rej: Function) => {
        res(false);
      }));

      let context1: Context = GlobalContext.getInstance().getObject('context') as Context;
      let enhanceService1: ServiceEntity = new ServiceEntity(new Object());
      enhanceService1.setServiceType('basic');
      enhanceService1.setServiceName('meetime_enhance_statement');
      enhanceService1.setServiceChecked(true);
      enhanceService1.setSaveDataListList(['asd']);

      let mockFunc1: Function = mockKit.mockFunc(SaveDataFactory, SaveDataFactory.getHandler);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(null);
      expect(EnhanceServiceUtil.saveServiceCheckStatus(context1, enhanceService1));
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_setAllEnhancedChecked_001
    * @tc.name: 判断是否所有的增强服务均已勾选测试
    */
    it('EnhanceServiceUtilTest_setAllEnhancedChecked_001', 0, async () => {
      expect(EnhanceServiceUtil.setAllEnhancedChecked(true));
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getAllEnhancedChecked
    * @tc.name: 判断是否所有的增强服务均已勾选测试
    */
    it('EnhanceServiceUtilTest_getAllEnhancedChecked_01', 0, async () => {
      let se_a: ServiceEntity = new ServiceEntity(new Object());
      se_a.setServiceType('enhanced');
      se_a.setServiceName('serviceName');
      se_a.setTitle('test_title');
      se_a.setServiceChecked(true);
      let ses: Array<ServiceEntity> = [];
      ses.push(se_a);

      expect(EnhanceServiceUtil.getAllEnhancedChecked(ses)).assertTrue();

      se_a.setServiceChecked(false);
      expect(EnhanceServiceUtil.getAllEnhancedChecked(ses)).assertFalse();

      let se_b: ServiceEntity = new ServiceEntity(new Object);
      se_b.setServiceChecked(true);
      ses.push(se_b);
      expect(EnhanceServiceUtil.getAllEnhancedChecked(ses)).assertFalse();
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getTempVisible_001
    * @tc.name: 判断增强服务可见性
    */
    it('EnhanceServiceUtilTest_getTempVisible_001', 0, async () => {
      let context1: Context = GlobalContext.getInstance().getObject('context') as Context;
      let enhanceService1: ServiceEntity = new ServiceEntity(new Object());
      enhanceService1.setValidatorList(["isRcsEnable"]);
      enhanceService1.setServiceType('enhance');

      let enhanceService2: ServiceEntity = new ServiceEntity(new Object());
      enhanceService2.setValidatorList([]);
      await EnhanceServiceUtil.getTempVisible(context1, enhanceService1);
      let handleAbilityResult = (): void => {
        EnhanceServiceUtil.getTempVisible(context1, enhanceService2);
      };
      expect(handleAbilityResult).not().assertFail();
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getTempVisible_002
    * @tc.name: 判断增强服务页面内容可见性
    */
    it('EnhanceServiceUtilTest_getTempVisible_002', 0, async () => {
      let context1: Context = GlobalContext.getInstance().getObject('context') as Context;
      let contextNull: Context = GlobalContext.getInstance().getObject('null') as Context;
      let entity: ServiceEntity = new ServiceEntity(new SimpleServiceEntity(EnhanceServiceConstant.RCSERVICENAME));
      let entityEmpty: ServiceEntity = new ServiceEntity(new SimpleServiceEntity(''));
      entity.setValidatorList(["abc"]);
      entity.setServiceType('enhance');
      await EnhanceServiceUtil.getTempVisible(context1, entity);
      entity.setValidatorList([EnhanceServiceConstant.RCSTATUS]);
      entity.setServiceType('enhance');
      await EnhanceServiceUtil.getTempVisible(context1, entity);
      await EnhanceServiceUtil.getTempVisible(context1, entityEmpty);
      let handleAbilityResult = (): void => {
        EnhanceServiceUtil.getTempVisible(contextNull, entity);
      };
      expect(handleAbilityResult).not().assertFail();
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getTempSwitchDisabled_001
    * @tc.name: 判断服务声明开关是否不可操作
    */
    it('EnhanceServiceUtilTest_getTempSwitchDisabled_001', 0, async () => {
      let context1: Context = GlobalContext.getInstance().getObject('context') as Context;
      let enhanceService1: ServiceEntity = new ServiceEntity(new Object());
      enhanceService1.setServiceType('enhance');
      enhanceService1.setServiceName('hiviewpage_enhance_statement');

      await EnhanceServiceUtil.getTempSwitchDisabled(context1, enhanceService1);
      let handleAbilityResult = (): void => {
        EnhanceServiceUtil.getTempSwitchDisabled(context1, enhanceService1);
      };
      expect(handleAbilityResult).not().assertFail();
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getTempSwitchDisabled_002
    * @tc.name: 判断服务声明开关是否不可操作
    */
    it('EnhanceServiceUtilTest_getTempSwitchDisabled_002', 0, async () => {
      let context1: Context = GlobalContext.getInstance().getObject('context') as Context;
      let enhanceService1: ServiceEntity = new ServiceEntity(new Object());
      enhanceService1.setServiceType('enhance');
      enhanceService1.setServiceName('abc');
      let result:boolean = await EnhanceServiceUtil.getTempVisible(context1, enhanceService1);
      expect(result).assertEqual(true);
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getTempSwitchDisabled_003
    * @tc.name: 判断服务声明开关是否不可操作
    */
    it('EnhanceServiceUtilTest_getTempSwitchDisabled_003', 0, async () => {
      let context: Context = GlobalContext.getInstance().getObject('context') as Context;
      let entity: ServiceEntity = new ServiceEntity(new SimpleServiceEntity(EnhanceServiceConstant.HIVIEWXSERVICENAME));
      let entityEmpty: ServiceEntity = new ServiceEntity(new SimpleServiceEntity(''));
      await EnhanceServiceUtil.getTempSwitchDisabled(context, entity);
      await EnhanceServiceUtil.getTempSwitchDisabled(context, entityEmpty);
      let handleAbilityResult = (): void => {
        EnhanceServiceUtil.getTempSwitchDisabled(context, entityEmpty);
      };
      expect(handleAbilityResult).not().assertFail();
    });


    /*
   * @tc.number:EnhanceServiceUtilTest_001
   * @tc.name: 判断是否所有的增强服务均已勾选测试
   */
    it('EnhanceServiceUtilTest_005', 0, async () => {
      let entity: ServiceEntity = new ServiceEntity(new Object());
      entity.setServiceType('enhanced');
      entity.setServiceName('serviceName');
      entity.setTitle('test_title');
      entity.setServiceChecked(true);
      let entities: Array<ServiceEntity> = [];
      entities.push(entity);
      GlobalContext.getInstance().setObject('context123', null);
      GlobalContext.getInstance().setObject('entity1', null);
      let context: Context = GlobalContext.getInstance().getObject('context') as Context;
      let contextNull: Context = GlobalContext.getInstance().getObject('context123') as Context;
      let entityNull = GlobalContext.getInstance().getObject('entity1') as ServiceEntity
      expect(await EnhanceServiceUtil.getTempCheckStatus(contextNull, entityNull)).not().assertNull();
      // 制造测试数据，以覆盖内部checkboxListStatus相关的逻辑
      let entity2 = new ServiceEntity(new SimpleServiceEntity());
      entity2.setCheckboxList(['settings=test_key']);
      SettingUtil.setValueSync('test_key', CommonConstant.STATUS_ON);
      expect(await EnhanceServiceUtil.getTempCheckStatus(context, entity2)).not().assertNull();
      SettingUtil.setValueSync('test_key', CommonConstant.STATUS_OFF);
      expect(await EnhanceServiceUtil.getTempCheckStatus(context, entity2)).not().assertNull();
      SettingUtil.setValueSync('test_key', CommonConstant.INVALID_VALUE);
      expect(await EnhanceServiceUtil.getTempCheckStatus(context, entity2)).not().assertNull();

      entity2.setCheckboxList(['settings=test_key2']);
      expect(await EnhanceServiceUtil.getTempCheckStatus(context, entity2)).not().assertNull();

      entity2.setSaveDataListList([]);
      EnhanceServiceUtil.setTempCheckStatus(contextNull, entityNull, false);

      entity2.setSaveDataListList(['test']);
      EnhanceServiceUtil.setTempCheckStatus(contextNull, entityNull, false);
    });

    /*
   * @tc.number:EnhanceServiceUtilTest_001
   * @tc.name: 判断是否所有的增强服务均已勾选测试
   */
    it('EnhanceServiceUtilTest_006', 0, async () => {
      GlobalContext.getInstance().setObject('null', null);
      let contextNull: Context = GlobalContext.getInstance().getObject('null') as Context;
      let entityNull = GlobalContext.getInstance().getObject('null') as ServiceEntity
      // getTempCheckStatus
      let result: boolean = await EnhanceServiceUtil.getTempCheckStatus(contextNull, entityNull);
      expect(result).not().assertFail();
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getCustomizedVisible_001
    * @tc.name: 获取应用自定义校验器显示规则结果测试
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 数据库获取显示规则验证
    */
    it('EnhanceServiceUtilTest_getCustomizedVisible_001', 0, async () => {
      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(SettingUtil, SettingUtil.getValueSync);
      when(mockFunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn('0');
      let enhanceService: ServiceEntity = new ServiceEntity(new Object());
      let visibleRule: string = 'settings=secure,appgallery_autoupdate_status=0';
      enhanceService.addVisibleRules(visibleRule);
      let res: boolean = EnhanceServiceUtil.getCustomizedVisible(enhanceService);
      expect(res).assertEqual(true);
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getCustomizedVisible_002
    * @tc.name: 获取应用自定义校验器显示规则结果测试
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 数据库获取显示规则验证
    */
    it('EnhanceServiceUtilTest_getCustomizedVisible_002', 0, async () => {
      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(SettingUtil, SettingUtil.getValueSync);
      when(mockFunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn('1');
      let enhanceService: ServiceEntity = new ServiceEntity(new Object());
      let visibleRule: string = 'settings=secure,appgallery_autoupdate_status=0';
      enhanceService.addVisibleRules(visibleRule);
      let res: boolean = EnhanceServiceUtil.getCustomizedVisible(enhanceService);
      expect(res).assertEqual(false);
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getCustomizedVisible_003
    * @tc.name: 获取应用自定义校验器显示规则结果测试
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 显示规则为空验证
    */
    it('EnhanceServiceUtilTest_getCustomizedVisible_003', 0, async () => {
      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(SettingUtil, SettingUtil.getValueSync);
      when(mockFunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn('1');
      let enhanceService: ServiceEntity = new ServiceEntity(new Object());
      let res: boolean = EnhanceServiceUtil.getCustomizedVisible(enhanceService);
      expect(res).assertEqual(true);
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getCustomizedVisible_004
    * @tc.name: 获取应用自定义校验器显示规则结果测试
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 获取显示规则字符串列表异常验证
    */
    it('EnhanceServiceUtilTest_getCustomizedVisible_004', 0, async () => {
      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(SettingUtil, SettingUtil.getValueSync);
      when(mockFunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn('1');
      let enhanceService: ServiceEntity = new ServiceEntity(new Object());
      let visibleRule: string = 'settings,secure,appgallery_autoupdate_status,0';
      enhanceService.addVisibleRules(visibleRule);
      let res: boolean = EnhanceServiceUtil.getCustomizedVisible(enhanceService);
      expect(res).assertEqual(true);
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getCustomizedVisible_005
    * @tc.name: 获取应用自定义校验器显示规则结果测试
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 系统参数获取显示规则验证
    */
    it('EnhanceServiceUtilTest_getCustomizedVisible_005', 0, async () => {
      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(SystemParameterUtil, SystemParameterUtil.getSync);
      when(mockFunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn('true');
      let enhanceService: ServiceEntity = new ServiceEntity(new Object());
      let visibleRule: string = 'sysparameter=appgallery_autoupdate_status=true';
      enhanceService.addVisibleRules(visibleRule);
      let res: boolean = EnhanceServiceUtil.getCustomizedVisible(enhanceService);
      expect(res).assertEqual(true);
    });

    /*
    * @tc.number:EnhanceServiceUtilTest_getCustomizedVisible_006
    * @tc.name: 获取应用自定义校验器显示规则结果测试
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 系统参数获取显示规则验证
    */
    it('EnhanceServiceUtilTest_getCustomizedVisible_006', 0, async () => {
      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(SystemParameterUtil, SystemParameterUtil.getSync);
      when(mockFunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn('false');
      let enhanceService: ServiceEntity = new ServiceEntity(new Object());
      let visibleRule: string = 'sysparameter=appgallery_autoupdate_status=true';
      enhanceService.addVisibleRules(visibleRule);
      let res: boolean = EnhanceServiceUtil.getCustomizedVisible(enhanceService);
      expect(res).assertEqual(false);
    });
  });
}