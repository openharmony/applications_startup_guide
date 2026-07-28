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
import { LogUtil } from '@ohos/hwstartupguide.common';
import { EnterHomeComponentModel } from '@ohos/hwstartupguide.common/src/main/ets/model/EnterHomeComponentModel';

const TAG: string = 'EnterHomeComponentModelTest';

export default function EnterHomeComponentModelTest() {
  describe('EnterHomeComponentModelTest', () => {

    /*
     * @tc.number:EnterHomeComponentModelTest_001
     */
    it('EnterHomeComponentModelTest_001', 0, async () => {
      LogUtil.info(TAG, 'EnterHomeComponentModelTest_001 start');
      let model: EnterHomeComponentModel = new EnterHomeComponentModel();
      expect(model.getButtonVisible()).assertFalse();
      LogUtil.info(TAG, 'EnterHomeComponentModelTest_001 end');
    });

    /*
     * @tc.number:EnterHomeComponentModelTest_002
     */
    it('EnterHomeComponentModelTest_002', 0, async () => {
      let model: EnterHomeComponentModel = new EnterHomeComponentModel();
      model.setButtonVisible(true);
      expect(model.getButtonVisible()).assertFalse();
    });
  });
}
