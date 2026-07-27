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
import { BaseText, LinkText, NormalText } from '@ohos/hwstartupguide.common/src/main/ets/textparse/parser/TextModel';
import { LinkTextParser } from '@ohos/hwstartupguide.common/src/main/ets/textparse/parser/LinkTextParser';
import Want from '@ohos.app.ability.Want';

const TAG: string = 'LinkParserTest';

/**
 * LinkParser工具类测试
 */
export default function LinkParserTest() {
  describe('LinkParserTest', () => {

    /*
       * @tc.number:LinkParserTest_001
       * @tc.name: LinkParser工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: LinkParser工具类测试
       */
    it('LinkParserTest_001', 0, async () => {
      LogUtil.info(TAG, 'LinkParserTest_001 start');
      expect(LinkTextParser.getInstance().parseText([])).assertDeepEquals([]);

      let linkText = new LinkText('123');
      linkText.setWant({
        'uri': 'link'
      })

      expect(JSON.stringify(LinkTextParser.getInstance().parseText([
        new BaseText('BaseText'),
        new NormalText('<a link="link">123</a>'),
        new NormalText('2'),
        new NormalText('1<a'),
        new NormalText('1<a>'),
        new NormalText('1<a></a>'),
        new NormalText('1</a>'),
      ]))).assertDeepEquals(JSON.stringify([
        new BaseText('BaseText'),
        linkText,
        new NormalText('2'),
        new NormalText('1'),
        new NormalText('<a'),
        new NormalText('<a'),
        new NormalText('1'),
        new LinkText('1'),
        new NormalText('1</a>'),
      ]));
      LogUtil.info(TAG, 'LinkParserTest_001 end');
    });

    it('LinkParserTest_002', 0, async () => {
      LogUtil.info(TAG, 'LinkParserTest_002 start');
      let abilities: Map<string, Want> = new Map();
      abilities.set('link', {
        bundleName: 'com.hmos.settings',
        abilityName: 'com.hmos.settings.MainAbility',
      })
      LinkTextParser.getInstance().initAbilities(abilities);

      expect(JSON.stringify(LinkTextParser.getInstance().parseText([
        new BaseText('BaseText'),
        new NormalText('<a link="link">123</a>'),
        new NormalText('2'),
        new NormalText('1<a'),
        new NormalText('1<a>'),
        new NormalText('1<a></a>'),
        new NormalText('1</a>'),
      ]))).not().assertDeepEquals(JSON.stringify([
        new BaseText('BaseText'),
        new LinkText('123'),
        new NormalText('2'),
        new NormalText('1'),
        new NormalText('<a'),
        new NormalText('<a'),
        new NormalText('1'),
        new LinkText('1'),
        new NormalText('1</a>'),
      ]));
      LogUtil.info(TAG, 'LinkParserTest_002 end');
    });
  });
}
