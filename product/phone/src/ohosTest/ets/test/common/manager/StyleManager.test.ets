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

import { beforeAll, describe, expect, it } from '@ohos/hypium';
import { LogUtil } from '@ohos/hwstartupguide.common';
import { StyleManager } from '@ohos/hwstartupguide.common/src/main/ets/manager/StyleManager';
import { PhoneFooterStyleModel } from '../../../../../main/ets/model/PhoneStyleModel';

const TAG: string = 'StyleManagerTest';

/**
 * StyleManager测试
 */
export default function StyleManagerTest() {
  let model: StyleManager;
  describe('StyleManagerTest', () => {
    beforeAll(async () => {
      model = new StyleManager();
    })

    /*
     * @tc.number:StyleManagerTest_001
     */
    it('StyleManagerTestGetFooterStyleModel', 0, async () => {
      LogUtil.info(TAG, 'StyleManagerTestGetFooterStyleModel start');
      model.setFooterStyleModel(new PhoneFooterStyleModel);
      expect(model.getFooterStyleModel()?.isNeedFocus).assertFalse();
      LogUtil.info(TAG, 'StyleManagerTestGetFooterStyleModel end');
    });
  })
}