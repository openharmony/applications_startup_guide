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

import { EventBus } from '@ohos/hwstartupguide.common/src/main/ets/util/EventBus';
import { describe, expect, it } from '@ohos/hypium';

export default function EventBusTest() {
  describe('EventBusTest', () => {
    /*
    * @tc.number: EventBusTest_001
    * @tc.name: 测试获取单例实例
    */
    it('EventBusTest_001', 0, async () => {
      const instance = EventBus.getInstance();
      expect(instance).not().assertUndefined();
    });

    /*
    * @tc.number: EventBusTest_002
    * @tc.name: 测试注册事件
    */
    it('EventBusTest_002', 0, async () => {
      const instance = EventBus.getInstance();
      let callbackCalled = false;
      const callback = () => {
        callbackCalled = true;
      };
      instance.on('testEvent', callback);
      instance.emit('testEvent');
      expect(callbackCalled).assertTrue();
      instance.off('testEvent');
    });

    /*
    * @tc.number: EventBusTest_003
    * @tc.name: 测试注销事件
    */
    it('EventBusTest_003', 0, async () => {
      const instance = EventBus.getInstance();
      let callbackCalled = false;
      const callback = () => {
        callbackCalled = true;
      };
      instance.on('testEvent', callback);
      instance.off('testEvent');
      instance.emit('testEvent');
      expect(callbackCalled).assertFalse();
    });

    /*
    * @tc.number: EventBusTest_004
    * @tc.name: 测试注销特定回调
    */
    it('EventBusTest_004', 0, async () => {
      const instance = EventBus.getInstance();
      let callback1Called = false;
      let callback2Called = false;
      const callback1 = () => {
        callback1Called = true;
      };
      const callback2 = () => {
        callback2Called = true;
      };
      instance.on('testEvent', callback1);
      instance.on('testEvent', callback2);
      instance.detach('testEvent', callback1);
      instance.emit('testEvent');
      expect(callback1Called).assertFalse();
      expect(callback2Called).assertTrue();
      instance.off('testEvent');
    });
  });
}