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
import { ServiceEntity } from '@ohos/hwstartupguide.common';
import { describe, it, expect, TestType, beforeAll } from '@ohos/hypium';
import { EnhanceServiceListModel } from '../../../../../../main/ets/model/enhanceservice/EnhanceServiceListModel';

export default function EnhanceServiceListModelTest() {
  let model: EnhanceServiceListModel = new EnhanceServiceListModel();

  let emptyModel: EnhanceServiceListModel = new EnhanceServiceListModel();

  let isAllChecked: boolean = false;

  let ent0 = new ServiceEntity(new Object());
  ent0.setTitle('checkAll');

  let ent1 = new ServiceEntity(new Object());
  ent1.setTitle('test1');

  let ent2 = new ServiceEntity(new Object());
  ent2.setTitle('test2');

  let ent3 = new ServiceEntity(new Object());
  ent3.setTitle('test3');

  describe('EnhanceServiceListModelTest', () => {
    beforeAll(async () => {
      model.getAllCheckedTitle = () => {
        return 'checkAll';
      }

      model.getEntities = () => {
        return [ent0, ent1, ent2];
      }

      model.setEnableAllChecked = (val: boolean) => {
        isAllChecked = val;
      }

      model.getEnableAllChecked = () => {
        return isAllChecked;
      }
    })

    it('EnhanceServiceListModelTest_001', TestType.FUNCTION, async () => {
      model.enableEnhanceServiceItem(ent1, true);
      expect(ent1.isServiceChecked()).assertTrue();
      model.enableEnhanceServiceItem(ent1, false);
      expect(ent1.isServiceChecked()).assertFalse();
      model.enableEnhanceServiceItem(ent3, false);
      emptyModel.enableEnhanceServiceItem(ent1, true);
    });

    it('EnhanceServiceListModelTest_002', TestType.FUNCTION, async () => {
      model.enableAllEnhanceService(true);
      expect(ent1.isServiceChecked()).assertTrue();
      expect(ent2.isServiceChecked()).assertTrue();
      model.enableAllEnhanceService(false);
      expect(ent1.isServiceChecked()).assertFalse();
      expect(ent2.isServiceChecked()).assertFalse();
      emptyModel.enableAllEnhanceService(true);
    });
  });
}