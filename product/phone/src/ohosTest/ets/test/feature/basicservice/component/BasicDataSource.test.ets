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
import { LogUtil, ServiceEntity, GlobalContext } from '@ohos/hwstartupguide.common';
import { BasicDataSource } from '@ohos/hwstartupguide.basicservice';

const TAG: string = 'BasicDataSourceTest';

/**
 * BasicDataSource基础数据类测试
 */
export default function BasicDataSourceTest() {
  const key = 'ChildDataSourceTag';
  let col: BasicDataSource<ServiceEntity>;
  describe('BasicDataSourceTest', () => {

    beforeAll(() => {
      class ChildDataSource extends BasicDataSource<ServiceEntity> {
        getData(index: number): ServiceEntity {
          throw new Error('Method not implemented.');
        }
      }
      col = new ChildDataSource();
    });

    /*
     * @tc.number:BasicDataSourceTest_001
     * @tc.name: BasicDataSource抽象类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: BasicDataSource抽象类测试
     */
    it('BasicDataSourceTest_001', 0, async () => {
      LogUtil.info(TAG, `BasicDataSourceTest_001 start`);
      expect(col.totalCount()).assertEqual(0);
      LogUtil.info(TAG, `BasicDataSourceTest_001 end`);
    })

    /*
     * @tc.number:BasicDataSourceTest_002
     * @tc.name: BasicDataSource抽象类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: BasicDataSource抽象类测试
     */
    it('BasicDataSourceTest_002', 0, async () => {
      LogUtil.info(TAG, `BasicDataSourceTest_002 start`);
      let dataChangeListener: DataChangeListener = {
        onDataReloaded: () => {},
        onDataAdded: () => {},
        onDataAdd: () => {},
        onDataMoved: () => {},
        onDataMove: () => {},
        onDataDeleted: () => {},
        onDataDelete: () => {},
        onDataChanged: () => {},
        onDataChange: () => {},
        onDatasetChange: (dataOperations: DataOperation[]): void => {
          throw new Error('Function not implemented.');
        }
      };
      col.registerDataChangeListener(dataChangeListener);
      col.notifyDataReload();
      col.notifyDataAdd(0);
      col.notifyDataAdd(1);
      col.notifyDataAdd(2);
      col.notifyDataChange(0);
      col.notifyDataDelete(0);
      col.notifyDataMove(1, 2);
      let addParamValue = (): void => {
        col.unregisterDataChangeListener(dataChangeListener);
      };
      expect(addParamValue).not().assertFail();
      LogUtil.info(TAG, `BasicDataSourceTest_002 end`);
    })
  })
}