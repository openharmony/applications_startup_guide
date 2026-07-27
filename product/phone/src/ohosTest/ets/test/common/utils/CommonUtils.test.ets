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
import { LogUtil, CommonUtils, CommonConstant, } from '@ohos/hwstartupguide.common';
import { EMPTY_IDENTIFY } from '@ohos/hwstartupguide.common/src/main/ets/util/StringUtil';

const TAG: string = 'CommonUtilsTest';

export default function CommonUtilsTest() {
  describe('CommonUtilsTest', () => {
    beforeAll(async () => {
      LogUtil.info(TAG, 'HwStartUp AbilityStage onCreate1');
    });

    /*
    * @tc.number:CommonUtilsTest_001
    * @tc.name: 工具测试
    */
    it('CommonUtilsTest_001', 0, async () => {
      LogUtil.info(TAG, `CommonUtilsTest_001 start`);
      expect(CommonUtils.mapConvertToArray<string, string>(null)).assertEqual(null);

      let strMap: Map<string, string> = new Map();
      strMap.set('1', '1');
      strMap.set('2', '2');
      expect(CommonUtils.mapConvertToArray<string, string>(strMap)).not().assertNull();
      LogUtil.info(TAG, `CommonUtilsTest_001 end`);
    });

    /**
     * @tc.number:CommonUtilsTest_002
     * @tc.name: 工具测试
     */
    it('CommonUtilsTest_002', 0, async () => {
      LogUtil.info(TAG, `CommonUtilsTest_002 start`);
      expect(CommonUtils.isEmpty<string | null>(null)).assertTrue();
      expect(CommonUtils.isEmpty<string | undefined>(undefined)).assertTrue();
      expect(CommonUtils.isEmpty<string | undefined>('a')).assertFalse();
      LogUtil.info(TAG, `CommonUtilsTest_002 end`);
    });

    /**
     * @tc.number:CommonUtilsTest_003
     * @tc.name: 工具测试
     */
    it('CommonUtilsTest_003', 0, async () => {
      LogUtil.info(TAG, `CommonUtilsTest_003 start`);

      expect(CommonUtils.isStringEmpty(null)).assertTrue();
      expect(CommonUtils.isStringEmpty(undefined)).assertTrue();
      expect(CommonUtils.isStringEmpty('')).assertTrue();
      expect(CommonUtils.isStringEmpty(EMPTY_IDENTIFY)).assertTrue();

      LogUtil.info(TAG, `CommonUtilsTest_003 end`);
    });

    /**
     * @tc.number:CommonUtilsTest_004
     * @tc.name: 工具测试
     */
    it('CommonUtilsTest_004', 0, async () => {
      LogUtil.info(TAG, `CommonUtilsTest_004 start`);
      expect(CommonUtils.getKeys(null).length).assertEqual(0);
      expect(CommonUtils.getKeys(undefined).length).assertEqual(0);

      interface EmployeeType {
        id: number,
        role: string,
      }

      let employees: Record<number, EmployeeType> = {
        0: {
          id: 1, role: 'Designer'
        },
        1: {
          id: 2, role: 'Developer'
        },
        2: {
          id: 3, role: 'Developer'
        },
      }
      expect(CommonUtils.getKeys(employees).length).assertEqual(3);

      LogUtil.info(TAG, `CommonUtilsTest_004 end`);
    });

    /**
     * @tc.number:CommonUtilsTest_005
     * @tc.name: 工具测试
     */
    it('CommonUtilsTest_005', 0, async () => {
      LogUtil.info(TAG, `CommonUtilsTest_005 start`);

      expect(CommonUtils.stringifyTuple<string, number>(null)).assertEqual('');
      expect(CommonUtils.stringifyTuple<string, number>([['demo1', 1], ['demo2', 2]])).not().assertEqual('');

      LogUtil.info(TAG, `CommonUtilsTest_005 end`);
    });

    /**
     * @tc.number:CommonUtilsTest_006
     * @tc.name: 工具测试
     */
    it('CommonUtilsTest_006', 0, async () => {
      LogUtil.info(TAG, `CommonUtilsTest_006 start`);

      expect(CommonUtils.stringify<null>(null)).assertEqual('');
      let json: string = `{\'demo1\':\'Tests1\',\'demo2\':\'Tests2\'}`;
      expect(CommonUtils.stringify<string>(json)).not().assertEqual('');

      LogUtil.info(TAG, `CommonUtilsTest_006 end`);
    });

    /**
     * @tc.number:CommonUtilsTest_007
     * @tc.name: 工具测试
     */
    it('CommonUtilsTest_007', 0, async () => {
      LogUtil.info(TAG, `CommonUtilsTest_007 start`);
      expect(CommonUtils.parseJson<string>(null)).assertEqual(null);
      let json: string = '{ "name1":"demo1", "name2":"demo2"}';
      let map: Map<string, string> = CommonUtils.parseJson<Map<string, string>>(json);
      expect(map).not().assertEqual(null);

      json = `{\'demo1\':\'Tests1\',\'demo2\':\'Tests2\'}`;
      expect(CommonUtils.parseJson<string>(json)).assertEqual(null);

      LogUtil.info(TAG, `CommonUtilsTest_007 end`);
    });

    /**
     * @tc.number:CommonUtilsTest_008
     * @tc.name: 工具测试
     */
    it('CommonUtilsTest_008', 0, async () => {
      LogUtil.info(TAG, `CommonUtilsTest_008 start`);

      expect(CommonUtils.parseToFloat(null)).assertEqual(0);
      expect(CommonUtils.parseToFloat('1.2')).assertEqual(1.2);

      LogUtil.info(TAG, `CommonUtilsTest_008 end`);
    });

  });
}
