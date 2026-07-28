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
import { LogUtil, ServiceEntity, GlobalContext } from '@ohos/hwstartupguide.common';
import { ServiceEntryDataSource } from '@ohos/hwstartupguide.basicservice';
import { SimpleServiceEntity } from '../../../SimpleServiceEntity.test';

const TAG: string = 'ServiceEntryDataSourceTest';

/**
 * ServiceEntryDataSource工具类测试
 */
export default function ServiceEntryDataSourceTest() {
  describe('ServiceEntryDataSourceTest', () => {

    /*
       * @tc.number:ServiceEntryDataSourceTest_001
       * @tc.name: ServiceEntryDataSource工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: ServiceEntryDataSource工具类测试
       */
    it('ServiceEntryDataSourceTest_001', 0, async () => {
      LogUtil.info(TAG, `ServiceEntryDataSourceTest_001 start`);
      let data: ServiceEntryDataSource = new ServiceEntryDataSource([]);
      data.pushData(GlobalContext.getInstance().getObject('ServiceEntity') as ServiceEntity);
      expect(data.totalCount()).assertEqual(0);
      data.pushData(new ServiceEntity(new SimpleServiceEntity('test1')));
      expect(data.totalCount()).assertEqual(1);
      data.pushDataList(GlobalContext.getInstance().getObject('ServiceEntity') as Array<ServiceEntity>);

      data = new ServiceEntryDataSource([]);
      data.pushDataList([
        new ServiceEntity(new SimpleServiceEntity('test1')),
        new ServiceEntity(new SimpleServiceEntity('test2')),
        new ServiceEntity(new SimpleServiceEntity('test3')),
      ]);
      expect(data.totalCount()).assertEqual(3);
      LogUtil.info(TAG, `ServiceEntryDataSourceTest_001 end`);
    })

    /*
       * @tc.number:ServiceEntryDataSourceTest_002
       * @tc.name: ServiceEntryDataSource工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: ServiceEntryDataSource工具类测试
       */
    it('ServiceEntryDataSourceTest_002', 0, async () => {
      LogUtil.info(TAG, `ServiceEntryDataSourceTest_001 start`);
      let data: ServiceEntryDataSource = new ServiceEntryDataSource([]);
      let serviceEntity = new ServiceEntity(new SimpleServiceEntity(''));
      data.pushData(serviceEntity);
      let serviceEntity1 = new ServiceEntity(new SimpleServiceEntity('test1'));
      data.pushData(serviceEntity1);
      LogUtil.info(TAG, `ServiceEntryDataSourceTest_002 end`);
      data = new ServiceEntryDataSource([]);
      data.pushDataList([new ServiceEntity(new SimpleServiceEntity('test1'))]);
      data.pushDataList([
        new ServiceEntity(new SimpleServiceEntity('test2')),
        new ServiceEntity(new SimpleServiceEntity('test3')),
        new ServiceEntity(new SimpleServiceEntity('test4')),
      ]);
      let pushData = (): void => {
        data.pushData(serviceEntity1);
      };
      expect(pushData).not().assertFail();
      // 即使下标非法，也不返回null
      expect(data.getData(-1)).not().assertNull();
      expect(data.getData(data.totalCount())).not().assertNull();
      // 期望获取第一条数据是test1
      expect(data.getData(0).getServiceName()).assertEqual('test1');
      LogUtil.info(TAG, `ServiceEntryDataSourceTest_002 end`);
    })

    /*
     * @tc.number:ServiceEntryDataSourceTest_003
     * @tc.name: ServiceEntryDataSource工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: ServiceEntryDataSource工具类测试
     */
    it('ServiceEntryDataSourceTest_003', 0, async () => {
      let serviceEntity = new ServiceEntity(new SimpleServiceEntity('test_name1'));
      let data: ServiceEntryDataSource = new ServiceEntryDataSource([serviceEntity]);
      serviceEntity = new ServiceEntity(new SimpleServiceEntity('test_name0'));
      data.addData(0, serviceEntity);
      expect(data.getData(0).getServiceName()).assertEqual('test_name0');
    });

    /*
     * @tc.number:ServiceEntryDataSourceTest_004
     * @tc.name: ServiceEntryDataSource工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: ServiceEntryDataSource工具类测试
     */
    it('ServiceEntryDataSourceTest_004', 0, async () => {
      let data: ServiceEntryDataSource = new ServiceEntryDataSource([]);
      data.addAllData(
        [
          new ServiceEntity(new SimpleServiceEntity('test2')),
          new ServiceEntity(new SimpleServiceEntity('test3')),
          new ServiceEntity(new SimpleServiceEntity('test4')),
        ]
      )
      expect(data.totalCount()).assertEqual(3);
    });
  })
}
