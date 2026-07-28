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
import { LogUtil, ServiceExtensionManager } from '@ohos/hwstartupguide.common';

const TAG: string = 'ServiceExtensionManagerUtilTest';

const testWants: Want[] = [{
  bundleName: '1111',
  abilityName: '2222',
  parameters: {
    isFromOOBE: true,
  },
}, {
  deviceId: '',
  bundleName: '1111',
  abilityName: '2222'
}];

/**
 * ServiceExtensionManager 工具类测试
 */
export default function ServiceExtensionManagerTest() {
  describe('ServiceExtensionManagerTest', () => {

    /**
     * @tc.number: ServiceExtensionManagerTest_001
     * @tc.name: ServiceExtensionManagerTest工具类测试
     */
    it('ServiceExtensionManagerTest_001', 0, async () => {
      LogUtil.info(TAG, `ServiceExtensionManagerTest_001 start`);
      expect(ServiceExtensionManager.startServiceExtensionAbility(testWants[0])).assertThrowError;
      LogUtil.info(TAG, `ServiceExtensionManagerTest_001 end`);
    });

    /**
     * @tc.number: ServiceExtensionManagerTest_002
     * @tc.name: ServiceExtensionManagerTest工具类测试
     */
    it('ServiceExtensionManagerTest_002', 0, async () => {
      LogUtil.info(TAG, `ServiceExtensionManagerTest_002 start`);
      expect(ServiceExtensionManager.startServiceExtensionAbilities(testWants)).assertThrowError;
      LogUtil.info(TAG, `ServiceExtensionManagerTest_002 end`);
    });
  });
}