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

const TAG: string = 'RegionBasicDataSourceTest';

/**
 * BasicDataSource基础数据类测试
 */
export default function RegionBasicDataSourceTest() {
  const key = 'ChildDataSourceTag';
  let col: BasicDataSource<ServiceEntity>;
  describe('RegionBasicDataSourceTest', () => {

    beforeAll(() => {
      class ChildDataSource extends BasicDataSource<ServiceEntity> {
        getData(index: number): ServiceEntity {
          throw new Error('Method not implemented.');
        }
      }
      col = new ChildDataSource();
    });

    /*
     * @tc.number:RegionBasicDataSourceTest_001
     * @tc.name: BasicDataSource抽象类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: RegionBasicDataSourceTest抽象类测试
     */
    it('RegionBasicDataSourceTest_001', 0, async () => {
      LogUtil.info(TAG, `RegionBasicDataSourceTest_001 start`);
      expect(col.totalCount()).assertEqual(0);
      LogUtil.info(TAG, `RegionBasicDataSourceTest_001 end`);
    })
  })
}