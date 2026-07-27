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
import { LogUtil, GlobalContext } from '@ohos/hwstartupguide.common';
import { StrategyChain } from '@ohos/hwstartupguide.common/src/main/ets/textparse/strategy/StrategyChain';
import { HtmlParser } from '@ohos/hwstartupguide.common/src/main/ets/textparse/parser/HtmlParser';
import { BaseText } from '@ohos/hwstartupguide.common/src/main/ets/textparse/parser/TextModel';
import { BoldTextParser } from '@ohos/hwstartupguide.common/src/main/ets/textparse/parser/BoldTextParser';

const TAG: string = 'StrategyChainTest';

/**
 * StrategyChain工具类测试
 */
export default function StrategyChainTest() {
  describe('StrategyChainTest', () => {

    /*
       * @tc.number:StrategyChainTest_001
       * @tc.name: StrategyChain工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: StrategyChain工具类测试
       */
    it('StrategyChainTest_001', 0, async () => {
      LogUtil.info(TAG, 'StrategyChainTest_001 start');
      let parserChain: StrategyChain = new StrategyChain(HtmlParser.getInstance());
      let baseTextEmptyArray = parserChain.parseText(GlobalContext.getInstance()
        .getObject('StrategyChainTest_001') as Array<BaseText>);
      expect(baseTextEmptyArray.length).assertEqual(0);

      parserChain = new StrategyChain(HtmlParser.getInstance());
      HtmlParser.getInstance().init('test<b>BOLD</b>');
      let baseTextArray = parserChain.parseText([]);
      expect(baseTextArray.length).assertEqual(1);

      parserChain.setNextStrategy(new StrategyChain(BoldTextParser.getInstance()));
      let boldTextArray = parserChain.parseText([
        new BaseText('test<b>BOLD</b>'),
      ]);
      expect(boldTextArray.length).assertEqual(3);
      LogUtil.info(TAG, 'StrategyChainTest_001 end');
    });
  });
}
