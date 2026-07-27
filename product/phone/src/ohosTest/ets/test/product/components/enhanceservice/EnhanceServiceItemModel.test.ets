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
import { describe, it, expect } from '@ohos/hypium';
import { EnhanceServiceItemModel } from '../../../../../../main/ets/model/enhanceservice/EnhanceServiceItemModel';
import { LogUtil} from '@ohos/hwstartupguide.common';
import want from '@ohos.app.ability.Want';

const TAG: string = 'ServiceEntityUtilTest';

export default function EnhanceServiceItemModelTest() {
  let model: EnhanceServiceItemModel = new EnhanceServiceItemModel();

  describe('EnhanceServiceItemModelTest', () => {
    it('EnhanceServiceItemModelTest_001', 0, async () => {
      LogUtil.info(TAG, `EnhanceServiceItemModelTest_001 start`);
      expect(model.openDialog()).assertEqual(0);
      expect(model.openDialog({})).assertEqual(0);
      expect(model.openDialog({
        bundleName: 'string',
        abilityName: 'string',
        parameters: {
          type: 'permissionStatement'
        },
      })).assertEqual(1);
      expect(model.openDialog({
        bundleName: 'string',
        abilityName: 'string',
      })).assertEqual(2);
      LogUtil.info(TAG, `EnhanceServiceItemModelTest_001 end`);
    });
  });

}