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

import { GlobalContext, KvStore, LogUtil } from '@ohos/hwstartupguide.common';
import { describe, expect, it, afterItSpecified } from '@ohos/hypium';

const TAG: string = 'KvStoreTest';

/**
 * KvStore工具类测试
 */
export default function KvStoreTest() {
  describe('KvStoreTest', () => {
    /*
     * @tc.number:KvStoreTest_001
     * @tc.name: KvStore工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: KvStore工具类测试
     */
    it('KvStoreTest_001', 0, async () => {
      LogUtil.info(TAG, 'KvStoreTest_001 start');
      let putPromise = KvStore.getInstance().put('1', '1');
      expect(putPromise).assertPromiseIsPending();
      LogUtil.info(TAG, 'KvStoreTest_001 end');
    });

    /*
     * @tc.number:KvStoreTest_002
     * @tc.name: KvStore工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: KvStore工具类测试
     */
    it('KvStoreTest_002', 0, async () => {
      LogUtil.info(TAG, 'KvStoreTest_002 start');
      let getPromise = KvStore.getInstance().get('');
      expect(getPromise).assertPromiseIsPending();
      LogUtil.info(TAG, 'KvStoreTest_002 end');
    });

    /*
     * @tc.number:KvStoreTest_003
     * @tc.name: KvStore工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: KvStore工具类测试
     */
    it('KvStoreTest_003', 0, async () => {
      LogUtil.info(TAG, 'KvStoreTest_003 start');
      let deletePromise = KvStore.getInstance().delete('');
      expect(deletePromise).assertPromiseIsPending();
      LogUtil.info(TAG, 'KvStoreTest_003 end');
    });

    /*
     * @tc.number:KvStoreTest_004
     * @tc.name: KvStore工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: KvStore工具类测试
    */
    it('KvStoreTest_004', 0, async () => {
      LogUtil.info(TAG, 'KvStoreTest_004 start');
      let res: Uint8Array | string | number | boolean = '';
      KvStore.getInstance().put('', res).then(async () => {
        let deletePromise = KvStore.getInstance().delete('KvStoreTest_004');
        expect(deletePromise).assertPromiseIsPending();
      });
      LogUtil.info(TAG, 'KvStoreTest_004 end');
    });

    /*
     * @tc.number:KvStoreTest_004
     * @tc.name: KvStore工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: KvStore工具类测试
    */
    it('KvStoreTest_005', 0, async () => {
      LogUtil.info(TAG, 'KvStoreTest_005 start');
      let store = KvStore.getInstance();
      expect(store).not().assertNull();
      LogUtil.info(TAG, 'KvStoreTest_005 end');
    });

    it('KvStoreTest_006', 0, async () => {
      LogUtil.info(TAG, 'KvStoreTest_006 start');
      let obj = GlobalContext.getInstance().getObject('startupGuideKvStore') as KvStore;
      expect(obj).not().assertNull();
      LogUtil.info(TAG, 'KvStoreTest_006 end');
    });

    it('KvStoreTest_007', 0, async () => {
      LogUtil.info(TAG, 'KvStoreTest_007 start');
      await KvStore.getInstance().delete('test');
      await KvStore.getInstance().put('test', 'test');
      let result = await KvStore.getInstance().get('test');
      expect(result).assertEqual('test');
      await KvStore.getInstance().delete('test');
      LogUtil.info(TAG, 'KvStoreTest_007 end');
    });

    it('KvStoreTest_008', 0, async () => {
      LogUtil.info(TAG, 'KvStoreTest_008 start');
      // 验证批量查询的内容是否正确, 顺序是否符合预期
      await Promise.all<void>([
        KvStore.getInstance().put('test1', 'value_test1'),
        KvStore.getInstance().put('test2', 'value_test2'),
      ])
      let result = await KvStore.getInstance().getEntries('test');
      expect(result.length).assertEqual(2);
      expect(result[0].key).assertEqual('test1');
      expect(result[0].value.value).assertEqual('value_test1');
      expect(result[1].key).assertEqual('test2');
      expect(result[1].value.value).assertEqual('value_test2');
      await KvStore.getInstance().delete('test1');
      await KvStore.getInstance().delete('test2');
      LogUtil.info(TAG, 'KvStoreTest_008 end');
    });

    it('KvStoreTest_009', 0, async () => {
      LogUtil.info(TAG, 'KvStoreTest_009 start');
      let result = await KvStore.getInstance().get('test');
      expect(result).assertUndefined();
      LogUtil.info(TAG, 'KvStoreTest_009 end');
    });

    it('KvStoreTest_010', 0, async () => {
      LogUtil.info(TAG, 'KvStoreTest_010 start');
      // 因为KvStore允许传入的key的最大长度是1024, 这里构造一个超长的参数来验证非法参数的异常处理逻辑
      let param ='';
      for(let i = 0; i < 1025; i++) {
        param = param.concat('a');
      }
      let result = (): void => {
        KvStore.getInstance().put(param, 'test');
      };
      expect(result).not().assertFail();
      LogUtil.info(TAG, 'KvStoreTest_010 end');
    });
  });
}