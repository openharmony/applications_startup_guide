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
import { HtmlParser } from '@ohos/hwstartupguide.common/src/main/ets/textparse/parser/HtmlParser';
import { NormalText } from '@ohos/hwstartupguide.common/src/main/ets/textparse/parser/TextModel';

const TAG: string = 'HtmlParserTest';

/**
 * HtmlParser工具类测试
 */
export default function HtmlParserTest() {
  describe('HtmlParserTest', () => {

    /*
       * @tc.number:HtmlParserTest_001
       * @tc.name: HtmlParser工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: HtmlParser工具类测试
       */
    it('HtmlParserTest_001', 0, async () => {
      LogUtil.info(TAG, 'HtmlParserTest_001 start');
      HtmlParser.getInstance().init('&lt;123&gt;');
      expect(HtmlParser.getInstance().parseText([])).assertDeepEquals([new NormalText('<123>')]);
      LogUtil.info(TAG, 'HtmlParserTest_001 end');
    });

    /*
       * @tc.number:HtmlParserTest_002
       * @tc.name: HtmlParser工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: HtmlParser工具类测试
       */
    it('HtmlParserTest_002', 0, async () => {
      LogUtil.info(TAG, 'HtmlParserTest_002 start');
      HtmlParser.getInstance().init('');
      expect(HtmlParser.getInstance().parseText([])).assertDeepEquals([]);
      LogUtil.info(TAG, 'HtmlParserTest_002 end');
    });
  });
}
