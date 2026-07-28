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
import { WindowManager, LogUtil } from '@ohos/hwstartupguide.common';

const TAG: string = 'WindowManagerTest';

/**
 * WindowManager工具类测试
 */
export default function WindowManagerTest() {
  describe('WindowManagerTest', () => {

    /**
     * @tc.number: WindowManagerTest_001
     * @tc.name: WindowManager工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: WindowManager工具类测试
     */
    it('WindowManagerTest_001', 0, async () => {
      LogUtil.info(TAG, 'WindowManagerTest_001 start');
      expect(WindowManager.getInstance().getKeyboardHeight());
      LogUtil.info(TAG, 'WindowManagerTest_001 end');
    });
  })
}