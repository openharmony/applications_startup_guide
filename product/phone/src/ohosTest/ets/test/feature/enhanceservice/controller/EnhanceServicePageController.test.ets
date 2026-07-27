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

import {
  LogUtil,
  OOBEUtil,
  RawFileUtil,
  ServiceEntity,
  ServiceEntityUtil,
} from '@ohos/hwstartupguide.common';

import { describe, it, expect, TestType, MockKit, when, ArgumentMatchers, beforeEach } from '@ohos/hypium';
import { EnhanceServicePageController, EnhanceServiceUtil } from '@ohos/hwstartupguide.enhanceservice';
import { PageOrderController } from '../../../../../../main/ets/controller/PageOrderController';

const TAG: string = 'EnhanceServicePageControllerTest';

export default function EnhanceServicePageControllerTest() {
  describe('EnhanceServicePageControllerTest', () => {
    let controller: EnhanceServicePageController = new EnhanceServicePageController(PageOrderController.getInstance());


    beforeEach(async () => {
      controller.setEnhanceServiceList([]);
    });

    /*
    * @tc.number:EnhanceServicePageControllerTest_initEnhanceServiceList_001
    * @tc.name: 初始化页面控制器验证
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 初始化页面各种场景覆盖
    */
    it('EnhanceServicePageControllerTest_initEnhanceServiceList_001', TestType.FUNCTION, async () => {
      controller.initEnhanceServiceList();
      expect(controller.getEnhanceServiceList().length).assertEqual(0);
      LogUtil.info(TAG, `EnhanceServicePageControllerTest_initEnhanceServiceList_001 end`);
    });

    /*
    * @tc.number:EnhanceServicePageControllerTest_initEnhanceServiceList_002
    * @tc.name: 初始化页面控制器验证
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 初始化页面各种场景覆盖
    */
    it('EnhanceServicePageControllerTest_initEnhanceServiceList_002', TestType.FUNCTION, async () => {
      // 测试获取系统参数为空的情况
      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(RawFileUtil, RawFileUtil.getStringByFile);
      let asd =
        "[{\"serviceType\":\"enhance\",\"serviceName\":\"enhance_statement_auto_upgrade\",\"moduleName\":\"ouc_hm_base\",\"packageName\":\"com.ohos.openharmony.ouc\",\"validatorList\":[],\"checkboxList\":[\"settings=auto_upgrade_switch\"],\"saveDataList\":[\"settings=auto_upgrade_switch\",\"settings=wlan_auto_download_switch\",\"settings=night_upgrade_switch\"]},{\"serviceType\":\"enhance\",\"serviceName\":\"meetime_enhance_statement\",\"moduleName\":\"contactsService\",\"packageName\":\"com.ohos.openharmony.meetimeservice\",\"validatorList\":[],\"checkboxList\":[\"settings=meetime_enhance_status\"],\"saveDataList\":[\"settings=meetime_enhance_status\"]},{\"serviceType\":\"enhance\",\"serviceName\":\"hiviewcare_enhance_statement\",\"moduleName\":\"phone_phoneUI\",\"packageName\":\"com.ohos.openharmony.hiviewcare\",\"validatorList\":[],\"checkboxList\":[\"settings=hiviewcare_enhance_status\"],\"saveDataList\":[\"settings=hiviewcare_enhance_status\"]}]";
      when(mockFunc)(ArgumentMatchers.any).afterReturn(new Promise<string>((res: Function, rej: Function) => {
        res(asd);
      }));
      let mockFunc1: Function = mockKit.mockFunc(ServiceEntityUtil, ServiceEntityUtil.genServiceEntity);
      when(mockFunc1)(ArgumentMatchers.any).afterThrow('error xxx');
      await controller.initEnhanceServiceList();
      expect(controller.getEnhanceServiceList().length).assertEqual(0);
      mockKit.clearAll();
      LogUtil.info(TAG, `EnhanceServicePageControllerTest_initEnhanceServiceList_002 end`);
    });

    /*
    * @tc.number:EnhanceServicePageControllerTest_initEnhanceServiceList_003
    * @tc.name: 初始化页面控制器验证
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 初始化页面各种场景覆盖
    */
    it('EnhanceServicePageControllerTest_initEnhanceServiceList_003', TestType.FUNCTION, async () => {
      // 测试获取系统参数为空的情况
      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(RawFileUtil, RawFileUtil.getStringByFile);
      let asd =
        "[{\"serviceType\":\"enhance\",\"serviceName\":\"enhance_statement_auto_upgrade\",\"moduleName\":\"ouc_hm_base\",\"packageName\":\"com.ohos.openharmony.ouc\",\"validatorList\":[],\"checkboxList\":[\"settings=auto_upgrade_switch\"],\"saveDataList\":[\"settings=auto_upgrade_switch\",\"settings=wlan_auto_download_switch\",\"settings=night_upgrade_switch\"]},{\"serviceType\":\"enhance\",\"serviceName\":\"meetime_enhance_statement\",\"moduleName\":\"contactsService\",\"packageName\":\"com.ohos.openharmony.meetimeservice\",\"validatorList\":[],\"checkboxList\":[\"settings=meetime_enhance_status\"],\"saveDataList\":[\"settings=meetime_enhance_status\"]},{\"serviceType\":\"enhance\",\"serviceName\":\"hiviewcare_enhance_statement\",\"moduleName\":\"phone_phoneUI\",\"packageName\":\"com.ohos.openharmony.hiviewcare\",\"validatorList\":[],\"checkboxList\":[\"settings=hiviewcare_enhance_status\"],\"saveDataList\":[\"settings=hiviewcare_enhance_status\"]}]";
      when(mockFunc)(ArgumentMatchers.any).afterReturn(new Promise<string>((res: Function, rej: Function) => {
        res(asd);
      }));

      let mockFunc1: Function = mockKit.mockFunc(ServiceEntityUtil, ServiceEntityUtil.genServiceEntity);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(new Promise<string>((res: Function, rej: Function) => {
        res(null);
      }));
      await controller.initEnhanceServiceList();
      expect(controller.getEnhanceServiceList().length).assertEqual(0);
      LogUtil.info(TAG, `EnhanceServicePageControllerTest_initEnhanceServiceList_003 end`);
    });

    /*
    * @tc.number:EnhanceServicePageControllerTest_initEnhanceServiceList_004
    * @tc.name: 初始化页面控制器验证
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 初始化页面各种场景覆盖
    */
    it('EnhanceServicePageControllerTest_initEnhanceServiceList_004', TestType.FUNCTION, async () => {
      // 测试获取系统参数为空的情况
      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(RawFileUtil, RawFileUtil.getStringByFile);
      let asd =
        "[{\"serviceType\":\"enhance\",\"serviceName\":\"enhance_statement_auto_upgrade\",\"moduleName\":\"ouc_hm_base\",\"packageName\":\"com.ohos.openharmony.ouc\",\"validatorList\":[],\"checkboxList\":[\"settings=auto_upgrade_switch\"],\"saveDataList\":[\"settings=auto_upgrade_switch\",\"settings=wlan_auto_download_switch\",\"settings=night_upgrade_switch\"]},{\"serviceType\":\"enhance\",\"serviceName\":\"meetime_enhance_statement\",\"moduleName\":\"contactsService\",\"packageName\":\"com.ohos.openharmony.meetimeservice\",\"validatorList\":[],\"checkboxList\":[\"settings=meetime_enhance_status\"],\"saveDataList\":[\"settings=meetime_enhance_status\"]},{\"serviceType\":\"enhance\",\"serviceName\":\"hiviewcare_enhance_statement\",\"moduleName\":\"phone_phoneUI\",\"packageName\":\"com.ohos.openharmony.hiviewcare\",\"validatorList\":[],\"checkboxList\":[\"settings=hiviewcare_enhance_status\"],\"saveDataList\":[\"settings=hiviewcare_enhance_status\"]}]";
      when(mockFunc)(ArgumentMatchers.any).afterReturn(new Promise<string>((res: Function, rej: Function) => {
        res(asd);
      }));

      let mockFunc1: Function = mockKit.mockFunc(ServiceEntityUtil, ServiceEntityUtil.genServiceEntity);
      let enhanceService: ServiceEntity = new ServiceEntity(new Object());
      enhanceService.setServiceType('basic');
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(new Promise<string>((res: Function, rej: Function) => {
        res(enhanceService);
      }));
      await controller.initEnhanceServiceList();
      expect(controller.getEnhanceServiceList().length).assertEqual(0);
      LogUtil.info(TAG, `EnhanceServicePageControllerTest_initEnhanceServiceList_004 end`);
    });

    /*
    * @tc.number:EnhanceServicePageControllerTest_initEnhanceServiceList_005
    * @tc.name: 初始化页面控制器验证
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 初始化页面各种场景覆盖
    */
    it('EnhanceServicePageControllerTest_initEnhanceServiceList_005', TestType.FUNCTION, async () => {
      // 测试获取系统参数为空的情况
      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(RawFileUtil, RawFileUtil.getStringByFile);
      let asd =
        "[{\"serviceType\":\"enhance\",\"serviceName\":\"enhance_statement_auto_upgrade\",\"moduleName\":\"ouc_hm_base\",\"packageName\":\"com.ohos.openharmony.ouc\",\"validatorList\":[],\"checkboxList\":[\"settings=auto_upgrade_switch\"],\"saveDataList\":[\"settings=auto_upgrade_switch\",\"settings=wlan_auto_download_switch\",\"settings=night_upgrade_switch\"]},{\"serviceType\":\"enhance\",\"serviceName\":\"meetime_enhance_statement\",\"moduleName\":\"contactsService\",\"packageName\":\"com.ohos.openharmony.meetimeservice\",\"validatorList\":[],\"checkboxList\":[\"settings=meetime_enhance_status\"],\"saveDataList\":[\"settings=meetime_enhance_status\"]},{\"serviceType\":\"enhance\",\"serviceName\":\"hiviewcare_enhance_statement\",\"moduleName\":\"phone_phoneUI\",\"packageName\":\"com.ohos.openharmony.hiviewcare\",\"validatorList\":[],\"checkboxList\":[\"settings=hiviewcare_enhance_status\"],\"saveDataList\":[\"settings=hiviewcare_enhance_status\"]}]";
      when(mockFunc)(ArgumentMatchers.any).afterReturn(new Promise<string>((res: Function, rej: Function) => {
        res(asd);
      }));

      let mockFunc1: Function = mockKit.mockFunc(EnhanceServiceUtil, EnhanceServiceUtil.getTempCheckStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(new Promise<string>((res: Function, rej: Function) => {
        res(false);
      }));

      let mockFunc2: Function = mockKit.mockFunc(ServiceEntityUtil, ServiceEntityUtil.genServiceEntity);
      let enhanceService: ServiceEntity = new ServiceEntity(new Object());
      enhanceService.setServiceType('2');
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(new Promise<string>((res: Function, rej: Function) => {
        res(enhanceService);
      }));
      await controller.initEnhanceServiceList();
      expect(controller.getEnhanceServiceList().length).assertEqual(0);
      LogUtil.info(TAG, `EnhanceServicePageControllerTest_initEnhanceServiceList_005 end`);
    });

    /*
    * @tc.number:EnhanceServicePageControllerTest_handleNextButtonClick_001
    * @tc.name: 初始化页面控制器验证
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 初始化页面各种场景覆盖
    */
    it('EnhanceServicePageControllerTest_handleNextButtonClick_001', TestType.FUNCTION, async () => {
      OOBEUtil.isMeeTimeEnhanceService = false;
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

      controller.setEnhanceServiceList(mEnhanceServiceList);

      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(EnhanceServiceUtil, EnhanceServiceUtil.saveServiceCheckStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();

      let mockFunc1: Function = mockKit.mockFunc(EnhanceServiceUtil, EnhanceServiceUtil.saveEnhanceStatementsToSP);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();

      controller.handleNextButtonClick();
      expect(OOBEUtil.isMeeTimeEnhanceService).assertFalse();
      LogUtil.info(TAG, `EnhanceServicePageControllerTest_handleNextButtonClick_001 end`);
    });

    /*
    * @tc.number:EnhanceServicePageControllerTest_handleNextButtonClick_002
    * @tc.name: 初始化页面控制器验证
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 初始化页面各种场景覆盖
    */
    it('EnhanceServicePageControllerTest_handleNextButtonClick_002', TestType.FUNCTION, async () => {
      OOBEUtil.isMeeTimeEnhanceService = false;
      let mEnhanceServiceList: Array<ServiceEntity> = [];
      let enhanceService1: ServiceEntity = new ServiceEntity(new Object());
      enhanceService1.setServiceType('basic');
      enhanceService1.setServiceName('meetime_enhance_statement');
      enhanceService1.setServiceChecked(true);
      let enhanceService2: ServiceEntity = new ServiceEntity(new Object());
      enhanceService2.setServiceType('basic');
      enhanceService2.setServiceName('meetime_enhance_statement');
      enhanceService2.setServiceChecked(true);
      mEnhanceServiceList.push(enhanceService1, enhanceService2);

      controller.setEnhanceServiceList(mEnhanceServiceList);

      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(EnhanceServiceUtil, EnhanceServiceUtil.saveServiceCheckStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();

      let mockFunc1: Function = mockKit.mockFunc(EnhanceServiceUtil, EnhanceServiceUtil.saveEnhanceStatementsToSP);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();

      controller.handleNextButtonClick();
      expect(OOBEUtil.isMeeTimeEnhanceService).assertFalse();
      LogUtil.info(TAG, `EnhanceServicePageControllerTest_handleNextButtonClick_002 end`);
    });

    /*
    * @tc.number:EnhanceServicePageControllerTest_handleNextButtonClick_003
    * @tc.name: 初始化页面控制器验证
    * @tc.type: TestType.FUNCTION
    * @tc.desc: 初始化页面各种场景覆盖
    */
    it('EnhanceServicePageControllerTest_handleNextButtonClick_003', TestType.FUNCTION, async () => {
      OOBEUtil.isMeeTimeEnhanceService = false;
      let mEnhanceServiceList: Array<ServiceEntity> = [];

      controller.setEnhanceServiceList(mEnhanceServiceList);

      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(EnhanceServiceUtil, EnhanceServiceUtil.saveServiceCheckStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();

      let mockFunc1: Function = mockKit.mockFunc(EnhanceServiceUtil, EnhanceServiceUtil.saveEnhanceStatementsToSP);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();

      controller.handleNextButtonClick();
      expect(OOBEUtil.isMeeTimeEnhanceService).assertFalse();
      LogUtil.info(TAG, `EnhanceServicePageControllerTest_handleNextButtonClick_003 end`);
    });
  });
}