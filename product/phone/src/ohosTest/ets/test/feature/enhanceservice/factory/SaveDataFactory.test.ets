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
import { LogUtil, } from '@ohos/hwstartupguide.common';
import { SaveDataFactory } from '@ohos/hwstartupguide.enhanceservice/src/main/ets/factory/SaveDataFactory';
import {
  SettingsSaveHandler
} from '@ohos/hwstartupguide.enhanceservice/src/main/ets/factory/savehandler/SettingsSaveHandler';

const TAG: string = 'SaveDataFactoryTest';

/**
 * 增强服务数据存储工厂
 */
export default function SaveDataFactoryTest() {
  describe('SaveDataFactoryTest', () => {
    /*
       * @tc.number:SaveDataFactoryTest_001
       * @tc.name: 存储工厂测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: 增强服务数据存储工厂存储规则获取处理器测试
       */
    it('SaveDataFactoryTest_001', 0, async () => {
      LogUtil.info(TAG, `SaveDataFactoryTest_001 start`);
      expect(SaveDataFactory.getHandler(undefined)).assertEqual(null);
      expect(SaveDataFactory.getHandler('')).assertEqual(null);
      expect(SaveDataFactory.getHandler(undefined)).assertEqual(null);
      expect(SaveDataFactory.getHandler('settings=night_upgrade_switch'))
        .assertEqual(SettingsSaveHandler.getInstance());
      expect(SaveDataFactory.getHandler('error')).assertEqual(null);
      LogUtil.info(TAG, `SaveDataFactoryTest_001 end`);
    })

    /*
   * @tc.number: SaveDataFactoryTest_001
   * @tc.name: 测试
   */
    it('SaveDataFactoryTest_002', 0, async () => {
      let str: string = 'abc';
      expect(SaveDataFactory.getHandler(undefined)).assertNull();
      expect(SaveDataFactory.getHandler('')).assertNull();
      expect(SaveDataFactory.getHandler(undefined)).assertNull();
      expect(SaveDataFactory.getHandler(str)).assertNull();
      str = 'settings=';
      expect(SaveDataFactory.getHandler(str)).assertEqual(SettingsSaveHandler.getInstance());
    });
  })
}
