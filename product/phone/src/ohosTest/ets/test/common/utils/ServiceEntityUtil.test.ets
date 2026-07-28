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
import resmgr from '@ohos.resourceManager';
import i18n from '@ohos.i18n';
import { Ability, Param } from '@ohos/hwstartupguide.common/src/main/ets/model/ProtocolContent';
import {
  LogUtil,
  ProtocolContent,
  ResourceUtil,
  ServiceEntity,
  ServiceEntityUtil,
  GlobalContext,
  RawFileUtil,
  AbilityManager,
} from '@ohos/hwstartupguide.common';
import common from '@ohos.app.ability.common';
import { SimpleParam } from '../../SimpleServiceEntity.test';

const TAG: string = 'ServiceEntityUtilTest';

/**
 * ServiceEntityUtil工具类测试
 */
export default function ServiceEntityUtilTest() {
  describe('ServiceEntityUtilTest', () => {

    /*
       * @tc.number:ServiceEntityUtilTest_001
       * @tc.name: ServiceEntityUtil工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: ServiceEntityUtil工具类测试
       */
    it('ServiceEntityUtilTest_001', 0, async () => {
      LogUtil.info(TAG, 'ServiceEntityUtilTest_001 start');
      let mocker: MockKit = new MockKit();
      let mockee = new ResourceUtil();
      let mockFunc: Function = mocker.mockFunc(mockee, ResourceUtil.getMetadata);
      when(mockFunc)('test').afterReturn(null);

      let mockeeRawFileUtil = new RawFileUtil();
      let mockFuncGetStringByFile: Function = mocker.mockFunc(mockeeRawFileUtil, RawFileUtil.getStringByFile);
      when(mockFuncGetStringByFile)('test').afterReturn('{}');
      let metaNull = await ServiceEntityUtil.genServiceEntity(new Object());
      expect(metaNull).assertNull();

      when(mockFunc)('test').afterReturn(new SimpleParam());
      let metaEmpty = await ServiceEntityUtil.genServiceEntity(new Object());
      expect(metaEmpty).assertNull();

      when(mockFunc)('test').afterReturn(new SimpleParam('profile'));
      let invalidPrefix = await ServiceEntityUtil.genServiceEntity(new Object());
      expect(invalidPrefix).assertNull();

      when(mockFunc)('test').afterReturn(new SimpleParam('rawfile:test.txt'));
      let invalidSuffix = await ServiceEntityUtil.genServiceEntity(new Object());
      expect(invalidSuffix).assertNull();

      when(mockFunc)('test').afterReturn(new SimpleParam('rawfile:test.json'));
      let ouc = await ServiceEntityUtil.genServiceEntity(new Object());
      expect(ouc).assertNull();

      LogUtil.info(TAG, 'ServiceEntityUtilTest_001 end');
    });

    /*
   * @tc.number:ServiceEntityUtilTest_002
   * @tc.name: ServiceEntityUtil工具类测试
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: ServiceEntityUtil工具类测试
   */
    it('ServiceEntityUtilTest_002', 0, async () => {
      let serviceEntity2 = new ServiceEntity(new Object());
      let serviceEntity1 = new ServiceEntity(new Object());

      serviceEntity2 = new ServiceEntity(new Object());
      serviceEntity2.setServiceName('serviceName2');

      serviceEntity1 = new ServiceEntity(new Object());
      serviceEntity1.setServiceName('serviceName1');
      expect(ServiceEntityUtil.isEquals(serviceEntity1, serviceEntity2)).assertFalse();

      serviceEntity2 = new ServiceEntity(new Object());
      serviceEntity2.setServiceName('serviceName');
      serviceEntity2.setPackageName('packageName2');

      serviceEntity1 = new ServiceEntity(new Object());
      serviceEntity1.setServiceName('serviceName');
      serviceEntity1.setPackageName('packageName1');
      expect(ServiceEntityUtil.isEquals(serviceEntity1, serviceEntity2)).assertFalse();

      serviceEntity2 = new ServiceEntity(new Object());
      serviceEntity2.setServiceName('serviceName');
      serviceEntity2.setPackageName('packageName');
      serviceEntity2.setModuleName('moduleName2');

      serviceEntity1 = new ServiceEntity(new Object());
      serviceEntity1.setServiceName('serviceName');
      serviceEntity1.setPackageName('packageName');
      serviceEntity1.setModuleName('moduleName1');
      expect(ServiceEntityUtil.isEquals(serviceEntity1, serviceEntity2)).assertFalse();

      serviceEntity2 = new ServiceEntity(new Object());
      serviceEntity2.setServiceName('serviceName');
      serviceEntity2.setPackageName('packageName');
      serviceEntity2.setModuleName('moduleName');
      serviceEntity2.setServiceType('basic');

      serviceEntity1 = new ServiceEntity(new Object());
      serviceEntity1.setServiceName('serviceName');
      serviceEntity1.setPackageName('packageName');
      serviceEntity1.setModuleName('moduleName');
      serviceEntity1.setServiceType('enhance');
      expect(ServiceEntityUtil.isEquals(serviceEntity1, serviceEntity2)).assertFalse();

      serviceEntity2 = new ServiceEntity(new Object());
      serviceEntity2.setServiceName('serviceName');
      serviceEntity2.setPackageName('packageName');
      serviceEntity2.setModuleName('moduleName');
      serviceEntity2.setServiceType('basic');

      serviceEntity1 = new ServiceEntity(new Object());
      serviceEntity1.setServiceName('serviceName');
      serviceEntity1.setPackageName('packageName');
      serviceEntity1.setModuleName('moduleName');
      serviceEntity1.setServiceType('basic');
      expect(ServiceEntityUtil.isEquals(serviceEntity1, serviceEntity2)).assertTrue();
    });

    /*
   * @tc.number:ServiceEntityUtilTest_003
   * @tc.name: ServiceEntityUtil工具类测试
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: ServiceEntityUtil工具类测试
   */
    it('ServiceEntityUtilTest_003', 0, async () => {
      let serviceEntityList: Array<ServiceEntity>  = GlobalContext.getInstance().getObject('serviceEntity2') as Array<ServiceEntity>;

      serviceEntityList = new Array<ServiceEntity>();
      let serviceEntity = new ServiceEntity(new Object());
      serviceEntity.setServiceName('serviceName');
      serviceEntity.setPackageName('packageName');
      serviceEntity.setModuleName('moduleName');
      serviceEntity.setServiceType('basic');

      serviceEntityList.push(GlobalContext.getInstance().getObject('serviceEntity2') as ServiceEntity);
      serviceEntityList.push(serviceEntity);
      let refreshServiceEntityArr = (): void => {
        ServiceEntityUtil.refreshServiceEntityArr(serviceEntityList);
      };
      expect(refreshServiceEntityArr).not().assertFail();
    });

    /*
   * @tc.number:ServiceEntityUtilTest_004
   * @tc.name: ServiceEntityUtil工具类测试
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: ServiceEntityUtil工具类测试
   */
    it('ServiceEntityUtilTest_004', 0, async () => {
      let serviceEntity = GlobalContext.getInstance().getObject('ServiceEntity') as ServiceEntity;
      let jsonObj = GlobalContext.getInstance().getObject('jsonObj') as ProtocolContent;
      let resourceManager = ResourceUtil.getBundleResourceManager(new ServiceEntity(new Object()).getPackageName(),
        AbilityManager.getInstance().getContext()) as resmgr.ResourceManager;
      ServiceEntityUtil.genProtocolContent(serviceEntity, jsonObj, resourceManager);
      ServiceEntityUtil.genProtocolContent(new ServiceEntity(new Object()), new ProtocolContent(new Object()), resourceManager);

      let protocolContent = new ProtocolContent(new Object());
      protocolContent.serviceName = 'serviceName';
      protocolContent.packageName = 'packageName';
      protocolContent.moduleName = 'moduleName';
      protocolContent.serviceType = 'basic';
      protocolContent.params = [new Param('name', '$string:device_permitted_agreement')];
      protocolContent.abilities = [new Ability('test', {
        bundleName: 'com.hmos.settings',
      })];
      ServiceEntityUtil.genProtocolContent(new ServiceEntity(new Object()), protocolContent, resourceManager);

      protocolContent = new ProtocolContent(new Object());
      protocolContent.version = '1.0';
      protocolContent.title = 'title';
      protocolContent.content = 'content';
      let context = GlobalContext.getInstance().getObject('context') as common.Context;
      ServiceEntityUtil.genProtocolContent(new ServiceEntity(new Object()), protocolContent, context.resourceManager);

      let params: Param[] = [];
      params.push(new Param('testKey', 'testValue'));

      let abilities: Ability[] = [];
      abilities.push(new Ability('testKey', {
        bundleName: 'com.hmos.settings',
      }));

      protocolContent = new ProtocolContent(new Object());
      protocolContent.serviceName = 'serviceName';
      protocolContent.packageName = 'packageName';
      protocolContent.moduleName = 'moduleName';
      protocolContent.serviceType = 'basic';
      protocolContent.params = params;
      protocolContent.abilities = abilities;

      let genProtocolContent = (): void => {
        ServiceEntityUtil.genProtocolContent(new ServiceEntity(new Object()),
          protocolContent, context.resourceManager);
      };
      expect(genProtocolContent).not().assertFail();
    });

    /*
    * @tc.number:ServiceEntityUtilTest_005
    * @tc.name: ServiceEntityUtil工具类测试
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: ServiceEntityUtil工具类测试
    */
    it('ServiceEntityUtilTest_005', 0, async () => {
      let serviceEntityList: Array<ServiceEntity>  = GlobalContext.getInstance().getObject('serviceEntity2') as Array<ServiceEntity>;

      serviceEntityList = new Array<ServiceEntity>();
      ServiceEntityUtil.refreshServiceEntityArr(serviceEntityList);
      let serviceEntity = new ServiceEntity(new Object());
      serviceEntity.setServiceName('serviceName');
      serviceEntity.setPackageName('packageName');
      serviceEntity.setModuleName('moduleName');
      serviceEntity.setServiceType('basic');

      serviceEntityList.push(serviceEntity);
      let prevLength = serviceEntityList.length;
      ServiceEntityUtil.refreshServiceEntityArr(serviceEntityList);
      expect(serviceEntityList.length).assertEqual(prevLength);
    });

    /*
    * @tc.number:ServiceEntityUtilTest_006
    * @tc.name: ServiceEntityUtil工具类测试
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: ServiceEntityUtil工具类测试
    */
    it('ServiceEntityUtilTest_006', 0, async () => {
      let resourceManager = ResourceUtil.getBundleResourceManager(new ServiceEntity(new Object()).getPackageName(),
        AbilityManager.getInstance().getContext()) as resmgr.ResourceManager;
      let result = ServiceEntityUtil.getServiceEntity(resourceManager);
      expect(result).not().assertNull();
    });
  });
}
const sleep: Function = (ms: number): Promise<void> => {
  return new Promise(res => setTimeout(res, ms))
};

