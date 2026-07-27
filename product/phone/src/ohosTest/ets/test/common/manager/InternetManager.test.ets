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
import { InternetManager } from '@ohos/hwstartupguide.common';

import { describe, expect, it } from '@ohos/hypium';

const TAG: string = 'InternetManagerTest';

export default function InternetManagerTest() {
  describe('InternetManagerTest', () => {

    it('InternetManagerTest_001', 0, async () => {
      InternetManager.getInstance().init();
      let isNetConnected: boolean = InternetManager.getInstance().isNetConnected();
      let res: boolean = isNetConnected === true || isNetConnected === false;
      expect(res).assertTrue();
    });

    it('InternetManagerTest_002', 0, async () => {
      let result = (): void => {
        InternetManager.getInstance().unRegister();
      };
      expect(result).not().assertFail();
    });

    it('InternetManagerTest_003', 0, async () => {
      InternetManager.getInstance().init();
      InternetManager.getInstance().init();
      let result = (): void => {
        InternetManager.getInstance().unRegister();
      };
      expect(result).not().assertFail();
    });
  })
}