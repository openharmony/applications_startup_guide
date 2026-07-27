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
import { BaseText  } from '@ohos/hwstartupguide.common/src/main/ets/textparse/parser/TextModel';

const TAG: string = 'TextModelTest';

/**
 * TextModel工具类测试
 */
export default function TextModelTest() {
  describe('TextModelTest', () => {
    /*
     * @tc.number:TextModelTest_001
     * @tc.name: TextModel基类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: TextModel基类测试
     */
    it('TextModelTest_001', 0, async () => {
      LogUtil.info(TAG, 'TextModelTest_001 start');
      let text = new BaseText('');
      text.setText('111');
      expect(text.getText()).assertEqual('111');
      LogUtil.info(TAG, 'TextModelTest_001 end');
    });
  })
}