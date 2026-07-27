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

import commonEventManager from '@ohos.commonEventManager';
import { describe, expect, it } from '@ohos/hypium';
import { LogUtil, CommonEvent, CommonConstant } from '@ohos/hwstartupguide.common';

const TAG: string = 'CommonEventTest';

/**
 * CommonEvent测试类
 */
export function CommonEventTest() {
  describe('CommonEventTest', () => {
    /**
     * @tc.number:CommonEventTest_001
     * @tc.name: CommonEvent工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: CommonEvent工具类测试
     */
    it('CommonEvent_001', 0, async () => {
      LogUtil.info(TAG, 'CommonEvent_001 start');
      let options: commonEventManager.CommonEventPublishData = {};
      expect(CommonEvent.publish(CommonConstant.HWSTARTUPGUIDE_FINISHED_EVENT, options));
      LogUtil.info(TAG, 'CommonEvent_001 end');
    });
  })
}