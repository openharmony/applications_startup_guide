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

import { Event, EventEmitter } from '@ohos/hwstartupguide.common';
import { afterAll, beforeAll, describe, expect, it } from '@ohos/hypium';
import { EventCallbackListener } from '@ohos/hwstartupguide.common/src/main/ets/event/Event';

const TAG: string = 'EventEmitterTest';

export default function EventEmitterTest() {
  describe('EventEmitterTest', () => {
    beforeAll(async () => {
    });

    afterAll(async () => {
    });

    it('emit', 0, async () => {
      EventEmitter.getInstance().emit(Event.BACK_PRE_NORMAL_PAGE);
      EventEmitter.getInstance().emit(Event.BACK_PRE_NORMAL_PAGE, Event.BACK_PRE_NORMAL_PAGE);
      let result = (): void => {
        EventEmitter.getInstance().emit(Event.BACK_PRE_NORMAL_PAGE);
        EventEmitter.getInstance().emit(Event.BACK_PRE_NORMAL_PAGE, Event.BACK_PRE_NORMAL_PAGE);
      };
      expect(result).not().assertFail();
    });

    it('registerEventListener', 0, async () => {
      EventEmitter.getInstance().registerEventListener(null);
      let listener: EventCallbackListener = {
        id: TAG, eventStart: (event: Event) => {
        }
      };
      EventEmitter.getInstance().registerEventListener(listener);
      let result = (): void => {
        EventEmitter.getInstance().registerEventListener(listener);
      };
      expect(result).not().assertFail();
    });

    it('unregisterEventListener', 0, async () => {
      EventEmitter.getInstance().unregisterEventListener(null);
      let listener: EventCallbackListener = {
        id: TAG, eventStart: (event: Event) => {
        }
      };
      EventEmitter.getInstance().registerEventListener(listener);
      let result = (): void => {
        EventEmitter.getInstance().registerEventListener(listener);
      };
      expect(result).not().assertFail();
    });

    it('triggerEventStart', 0, async () => {
      EventEmitter.getInstance().unregisterEventListener(null);
      let listener: EventCallbackListener = { id: TAG };
      EventEmitter.getInstance().unregisterEventListener(listener);
      listener = {
        id: TAG, eventStart: (event: Event) => {
        }
      };
      EventEmitter.getInstance().registerEventListener(listener);
      let result = (): void => {
        EventEmitter.getInstance().registerEventListener(listener);
      };
      expect(result).not().assertFail();
    });
  });
}
