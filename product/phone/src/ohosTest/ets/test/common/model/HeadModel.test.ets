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

import { HeadModel } from '@ohos/hwstartupguide.common/src/main/ets/model/HeadModel';
import { describe, expect, it } from '@ohos/hypium';

export default function HeadModelTest() {
  describe('HeadModelTest', () => {

    /*
     * @tc.number:HeadModelTest_001
     */
    it('HeadModelTest_001', 0, () => {
      const headModel = new HeadModel();
      expect(headModel.maxTitleHeight).assertEqual(0);
    });

    /*
     * @tc.number:HeadModelTest_002
     */
    it('HeadModelTest_002', 0, () => {
      const headModel = new HeadModel();
      expect(headModel.titleOpacity).assertEqual(1);
    });

    /*
     * @tc.number:HeadModelTest_003
     */
    it('HeadModelTest_003', 0, () => {
      const headModel = new HeadModel();
      expect(headModel.titleHeight).assertEqual('auto');
    });
  })
}