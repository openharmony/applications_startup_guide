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
import { GlobalContext, LogUtil, PageConfig, PageConfigManager } from '@ohos/hwstartupguide.common';

const TAG: string = 'PageConfigManagerTest';

/**
 * PageConfigManager工具类测试
 */
export default function PageConfigManagerTest() {
  describe('PageConfigManagerTest', () => {

    /*sss
       * @tc.number:PageConfigManagerTest_001
       * @tc.name: PageConfigManager工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: PageConfigManager工具类测试
       */
    it('PageConfigManagerTest_001', 0, async () => {
      LogUtil.info(TAG, 'PageConfigManagerTest_001 start');
      expect(PageConfigManager.getInstance().loadPageConfigs());
      LogUtil.info(TAG, 'PageConfigManagerTest_001 end');
    });

    /*
   * @tc.number:PageConfigManagerTest_002
   * @tc.name: PageConfigManager工具类测试
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: PageConfigManager工具类测试 isMapEmpty isMapNotEmpty
   */
    it('PageConfigManagerTest_002', 0, async () => {
      LogUtil.info(TAG, 'PageConfigManagerTest_002 start');
      expect(PageConfigManager.getInstance().getPageConfigKeys()).assertDeepEquals([]);
      expect(PageConfigManager.getInstance().getPageConfig('')).assertDeepEquals(undefined);
      LogUtil.info(TAG, 'PageConfigManagerTest_002 end');
    });

    /*
   * @tc.number:PageConfigManagerTest_003
   * @tc.name: PageConfigManager工具类测试
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: PageConfigManager工具类测试
   */
    it('PageConfigManagerTest_003', 0, async () => {
      LogUtil.info(TAG, 'PageConfigManagerTest_003 start');
      GlobalContext.getInstance().setObject('ServiceEntity', null);
      let promiseNull = await PageConfigManager.getInstance()
        .combinePageConfigs(GlobalContext.getInstance().getObject('ServiceEntity') as Map<string, PageConfig>);
      expect(promiseNull).assertDeepEquals(new Map<string, PageConfig>());

      let map = new Map<string, PageConfig>();
      let pageConfig = new PageConfig(new Object());
      pageConfig.setIndex(2);
      pageConfig.setKey('test');
      map.set('test', pageConfig);
      let promise = await PageConfigManager.getInstance().combinePageConfigs(map);
      expect(promise).assertDeepEquals(map);
      LogUtil.info(TAG, 'PageConfigManagerTest_003 end');
    });
  })
}
