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

import { afterAll, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { LogUtil, GlobalContext, SettingUtil } from '@ohos/hwstartupguide.common';
import { SaveDataFactory } from '@ohos/hwstartupguide.enhanceservice/src/main/ets/factory/SaveDataFactory';
import {
  SettingsSaveHandler
} from '@ohos/hwstartupguide.enhanceservice/src/main/ets/factory/savehandler/SettingsSaveHandler';

const TAG: string = 'SettingsSaveHandlerTest';

/**
 * 增强服务数据存储工厂
 */
export default function SettingsSaveHandlerTest() {
  describe('SettingsSaveHandlerTest', () => {
    /*
       * @tc.number:SaveDataFactoryTest_001
       * @tc.name: 存储工厂测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: 增强服务数据存储工厂存储规则获取处理器测试
       */
    it('SettingsSaveHandlerTest_001', 0, async () => {
      LogUtil.info(TAG, `SettingsSaveHandlerTest_001 start`);
      GlobalContext.getInstance().setObject('null', null);
      let contextNull = GlobalContext.getInstance().getObject('null') as Context;
      let context1 = GlobalContext.getInstance().getObject('context123') as Context;
      SettingsSaveHandler.getInstance().saveData(contextNull, '', true);
      SettingsSaveHandler.getInstance().saveData(context1, '', true);
      SettingsSaveHandler.getInstance().saveData(context1, '', true);
      expect(SaveDataFactory.getHandler('settings=night_upgrade_switch'))
        .assertEqual(SettingsSaveHandler.getInstance());
      expect(SaveDataFactory.getHandler('error')).assertNull();
      LogUtil.info(TAG, `SettingsSaveHandlerTest_001 end`);
    })

    /*
      * @tc.number: SettingsSaveHandlerTest_002
      * @tc.name: 测试
      */
    it('SettingsSaveHandlerTest_002', 0, async () => {
      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(SettingUtil, SettingUtil.getValueSync);
      let context = GlobalContext.getInstance().getObject('context') as Context;
      let context1 = GlobalContext.getInstance().getObject('context123') as Context;
      GlobalContext.getInstance().setObject('null', null);
      let contextNull = GlobalContext.getInstance().getObject('null') as Context;
      //save data
      let str: string = 'abc';
      //get data
      str = 'abc';
      expect(SettingsSaveHandler.getInstance().getData(contextNull, '')).assertNull();
      expect(SettingsSaveHandler.getInstance().getData(context1, '')).assertNull();
      expect(SettingsSaveHandler.getInstance().getData(context, '')).assertNull();
      expect(SettingsSaveHandler.getInstance().getData(context, str)).assertNull();
      str = 'settings=sss';
      when(mockFunc)('sss').afterReturn('1');
      expect(SettingsSaveHandler.getInstance().getData(context, str)).assertUndefined();
    });
  })
}
