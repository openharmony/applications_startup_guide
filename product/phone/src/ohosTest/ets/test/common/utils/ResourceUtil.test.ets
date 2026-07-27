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

import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { LogUtil, ResourceUtil, GlobalContext, AbilityManager } from '@ohos/hwstartupguide.common';
import common from '@ohos.app.ability.common';

const TAG: string = 'ResourceUtilTest';

/**
 * ResourceUtil工具类测试
 */
export default function ResourceUtilTest() {
  describe('ResourceUtilTest', () => {
    let mocker: MockKit = new MockKit();
    /*
       * @tc.number:ResourceUtilTest_001
       * @tc.name: ResourceUtil工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: ResourceUtil工具类测试
       */
    it('ResourceUtilTest_001', 0, async () => {
      LogUtil.info(TAG, 'ResourceUtilTest_001 start');
      let bundleName: string | null = '';
      let moduleName: string | null = '';
      let metaDataName: string | null = '';
      expect(ResourceUtil.getMetadata(bundleName, moduleName, metaDataName)).assertNull();
      bundleName = 'com.ohos.startupguide';
      moduleName = 'hwstartupguide.common';
      metaDataName = 'ArkTSPartialUpdate';
      expect(ResourceUtil.getMetadata(bundleName, moduleName, metaDataName)).assertNull();

      LogUtil.info(TAG, 'ResourceUtilTest_001 end');
    });

    /*
       * @tc.number:ResourceUtilTest_002
       * @tc.name: ResourceUtil工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: ResourceUtil工具类测试
       */
    it('ResourceUtilTest_002', 0, async () => {
      LogUtil.info(TAG, 'ResourceUtilTest_002 start');
      expect(ResourceUtil.getFormatStringName('')).assertDeepEquals('');
      expect(ResourceUtil.getFormatStringName('$string:param_value')).assertDeepEquals('param_value');
      LogUtil.info(TAG, 'ResourceUtilTest_002 end');
    });

    /*
       * @tc.number:ResourceUtilTest_003
       * @tc.name: ResourceUtil工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: ResourceUtil工具类测试
       */
    it('ResourceUtilTest_003', 0, async () => {
      LogUtil.info(TAG, 'ResourceUtilTest_003 start');
      let context = GlobalContext.getInstance().getObject('context') as common.Context;
      expect(ResourceUtil.getResourceString(null, '')).assertDeepEquals('');
      expect(ResourceUtil.getResourceString(null, '$string:hwstartguide_title')).assertDeepEquals('');
      expect(ResourceUtil.getResourceString(null, 'profile:param_value')).assertDeepEquals('profile:param_value');
      expect(ResourceUtil.getResourceString(context.resourceManager, 'profile:empty'))
        .assertDeepEquals('profile:empty');
      LogUtil.info(TAG, 'ResourceUtilTest_003 end');
    });

    /*
       * @tc.number:ResourceUtilTest_004
       * @tc.name: ResourceUtil工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: ResourceUtil工具类测试
       */
    it('ResourceUtilTest_004', 0, async () => {
      LogUtil.info(TAG, 'ResourceUtilTest_004 start');
      expect(ResourceUtil.getString('')).assertDeepEquals('');
      LogUtil.info(TAG, 'ResourceUtilTest_004 end');
    });

    /*
       * @tc.number:ResourceUtilTest_005
       * @tc.name: ResourceUtil工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: ResourceUtil工具类测试
       */
    it('ResourceUtilTest_005', 0, async () => {
      LogUtil.info(TAG, 'ResourceUtilTest_005 start');
      expect(ResourceUtil.getStringByResource(null)).assertDeepEquals('');
      expect(ResourceUtil.getStringByResource({
        bundleName: $r('app.string.TestAbility_label').bundleName,
        moduleName: $r('app.string.TestAbility_label').moduleName,
        id: $r('app.string.TestAbility_label').id,
      })).assertDeepEquals('test label');
      expect(ResourceUtil.getStringByResource({
        bundleName: $r('app.string.TestAbility_desc').bundleName,
        moduleName: $r('app.string.TestAbility_desc').moduleName,
        id: $r('app.string.TestAbility_desc').id,
      })).assertDeepEquals("the test ability");
      LogUtil.info(TAG, 'ResourceUtilTest_005 end');
    });

    /*
       * @tc.number:ResourceUtilTest_006
       * @tc.name: ResourceUtil工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: ResourceUtil工具类测试
       */
    it('ResourceUtilTest_006', 0, async () => {
      LogUtil.info(TAG, 'ResourceUtilTest_006 start');
      let context = GlobalContext.getInstance().getObject('context') as common.Context;
      expect(ResourceUtil.getBundleString(null, '', '')).assertNull();
      expect(ResourceUtil.getBundleString(context, '', '')).assertNull();
      expect(ResourceUtil.getBundleString(context, 'com.hmos.settings', '')).assertNull();
      LogUtil.info(TAG, 'ResourceUtilTest_006 end');
    });

    /*
       * @tc.number:ResourceUtilTest_007
       * @tc.name: ResourceUtil工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: ResourceUtil工具类测试
       */
    it('ResourceUtilTest_007', 0, async () => {
      LogUtil.info(TAG, 'ResourceUtilTest_007 start');
      let context = GlobalContext.getInstance().getObject('context') as common.Context;
      expect(ResourceUtil.getBundleResourceManager('', null)).assertNull();
      expect(ResourceUtil.getBundleResourceManager('', context)).assertNull();
      expect(ResourceUtil.getBundleResourceManager('com.ohos.openharmony.settings', context));
      LogUtil.info(TAG, 'ResourceUtilTest_007 end');
    });

    it('ResourceUtilTest_getNumber_008', 0, async () => {
      LogUtil.info(TAG, 'ResourceUtilTest_getNumber_008 start');
      let handleAbilityResult = (): void => {
        ResourceUtil.getNumber($r('app.string.enter_home'));
      };
      expect(handleAbilityResult).not().assertFail();
      LogUtil.info(TAG, 'ResourceUtilTest_getNumber_008 end');
    });
  });
}

