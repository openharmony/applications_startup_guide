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
import { BaseText, BoldText, NormalText } from '@ohos/hwstartupguide.common/src/main/ets/textparse/parser/TextModel';
import { BoldTextParser } from '@ohos/hwstartupguide.common/src/main/ets/textparse/parser/BoldTextParser';

const TAG: string = 'BoldParserTest';

/**
 * BoldParser工具类测试
 */
export default function BoldParserTest() {
  describe('BoldParserTest', () => {

    /*
       * @tc.number:BoldParserTest_001
       * @tc.name: BoldParser工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: BoldParser工具类测试
       */
    it('BoldParserTest_001', 0, async () => {
      LogUtil.info(TAG, 'BoldParserTest_001 start');
      expect(BoldTextParser.getInstance().parseText([])).assertDeepEquals([]);
      expect(BoldTextParser.getInstance().parseText([
        new BaseText('BaseText'),
        new NormalText('<b></b>'),
        new NormalText('<b>Text'),
        new NormalText('<b>123</b>'),
      ])).assertDeepEquals([
        new BaseText('BaseText'),
        new NormalText('Text'),
        new BoldText('123'),
      ]);
      LogUtil.info(TAG, 'BoldParserTest_001 end');
    });
  });
}
