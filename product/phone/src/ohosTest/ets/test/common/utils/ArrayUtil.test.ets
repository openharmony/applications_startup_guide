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
import { ArrayUtil, LogUtil } from '@ohos/hwstartupguide.common';
import { PageConfig } from '@ohos/hwstartupguide.common/src/main/ets/model/config/PageConfig';

const TAG: string = 'ArrayUtilTest';

/**
 * ArrayUtil工具类测试
 */
export default function ArrayUtilTest() {
  describe('ArrayUtilTest', () => {

    /*
       * @tc.number:ArrayUtilTest_001
       * @tc.name: ArrayUtil工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: ArrayUtil工具类测试
       */
    it('ArrayUtilTest_001', 0, async () => {
      LogUtil.info(TAG, 'ArrayUtilTest_001 start');
      let strArray: Array<string> | undefined | null = undefined;
      expect(ArrayUtil.isEmpty<string>(strArray)).assertTrue();
      expect(ArrayUtil.isNotEmpty<string>(strArray)).assertFalse();
      strArray = null;
      expect(ArrayUtil.isEmpty<string>(strArray)).assertTrue();
      expect(ArrayUtil.isNotEmpty<string>(strArray)).assertFalse();
      strArray = new Array<string>();
      expect(ArrayUtil.isEmpty(strArray)).assertTrue();
      expect(ArrayUtil.isNotEmpty(strArray)).assertFalse();
      strArray.push('test1');
      expect(ArrayUtil.isEmpty(strArray)).assertFalse();
      expect(ArrayUtil.isNotEmpty(strArray)).assertTrue();
      strArray.push('empty');
      expect(ArrayUtil.isEmpty(strArray)).assertFalse();
      expect(ArrayUtil.isNotEmpty(strArray)).assertTrue();
      LogUtil.info(TAG, 'ArrayUtilTest_001 end');
    });

    /*
   * @tc.number:ArrayUtilTest_002
   * @tc.name: ArrayUtil工具类测试
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: ArrayUtil工具类测试 isMapEmpty isMapNotEmpty
   */
    it('ArrayUtilTest_002', 0, async () => {
      LogUtil.info(TAG, 'ArrayUtilTest_002 start');
      let strMap: Map<string, string> | undefined | null = undefined;
      expect(ArrayUtil.isMapEmpty<string, string>(strMap)).assertTrue();
      expect(ArrayUtil.isMapNotEmpty<string, string>(strMap)).assertFalse();
      strMap = null;
      expect(ArrayUtil.isMapEmpty<string, string>(strMap)).assertTrue();
      expect(ArrayUtil.isMapNotEmpty<string, string>(strMap)).assertFalse();
      strMap = new Map<string, string>();
      expect(ArrayUtil.isMapEmpty(strMap)).assertTrue();
      expect(ArrayUtil.isMapNotEmpty(strMap)).assertFalse();
      strMap.set('testkey', 'testvalue');
      expect(ArrayUtil.isMapEmpty(strMap)).assertFalse();
      expect(ArrayUtil.isMapNotEmpty(strMap)).assertTrue();
      strMap.set('a', 'abc');
      expect(ArrayUtil.isMapEmpty(strMap)).assertFalse();
      expect(ArrayUtil.isMapNotEmpty(strMap)).assertTrue();
      LogUtil.info(TAG, 'ArrayUtilTest_002 end');
    });

    /*
   * @tc.number:ArrayUtilTest_001
   * @tc.name: ArrayUtil工具类测试
   * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
   * @tc.desc: ArrayUtil工具类测试
   */
    it('ArrayUtilTest_003', 0, async () => {
      let pageConfigMap: Map<string, PageConfig> | undefined | null = undefined;
      ArrayUtil.sortPageConfigs(pageConfigMap);
      pageConfigMap = null;
      ArrayUtil.sortPageConfigs(pageConfigMap);
      pageConfigMap = new Map<string, PageConfig>();
      ArrayUtil.sortPageConfigs(pageConfigMap);


      let pageConfig1 = new PageConfig(new Object());
      pageConfig1.setKey('testkey1');
      pageConfig1.setIndex(10);
      pageConfig1.setAction('add');
      pageConfigMap.set('testkey1', pageConfig1);


      let pageConfig2 = new PageConfig(new Object());
      pageConfig2.setKey('testkey2');
      pageConfig2.setIndex(0);
      pageConfig2.setAction('delete');
      pageConfigMap.set('testkey2', pageConfig2);

      let pageConfig3 = new PageConfig(new Object());
      pageConfig3.setKey('testkey3');
      pageConfig3.setIndex(5);
      pageConfig3.setAction('alter');
      pageConfigMap.set('testkey3', pageConfig3);

      ArrayUtil.sortPageConfigs(pageConfigMap);
      expect(JSON.stringify(Array.from(pageConfigMap.keys()))).assertEqual('["testkey2","testkey3","testkey1"]');
      pageConfigMap.set('', new PageConfig(new Object()));
      ArrayUtil.sortPageConfigs(pageConfigMap);
      LogUtil.info(TAG, 'ArrayUtilTest_003 end');
    });
  });
}
