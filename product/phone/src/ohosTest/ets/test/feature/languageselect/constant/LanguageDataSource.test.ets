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


import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LanguageDataSource } from '@ohos/hwstartupguide.languageselect';

export default function LanguageDataSourceTest() {
  describe('getData_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_string_when_languageList_is_null', 0, () => {
      let languageArray: string[] = [];
      let languagedatasource: LanguageDataSource = new LanguageDataSource(languageArray);
      const result = languagedatasource.getData(0);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_index_is_out_of_bounds', 0, () => {
      let languageArray: string[] = ['en', 'zh', 'hi'];
      let languagedatasource: LanguageDataSource = new LanguageDataSource(languageArray);
      const result1 = languagedatasource.getData(-1);
      const result2 = languagedatasource.getData(3);
      expect(result1).assertEqual('');
      expect(result2).assertEqual('');
    });

    it('should_return_correct_language_when_index_is_valid', 0, () => {
      let languageArray: string[] = ['en', 'zh', 'hi'];
      let languagedatasource: LanguageDataSource = new LanguageDataSource(languageArray);
      const result1 = languagedatasource.getData(0);
      const result2 = languagedatasource.getData(1);
      const result3 = languagedatasource.getData(2);
      expect(result1).assertEqual('en');
      expect(result2).assertEqual('zh');
      expect(result3).assertEqual('hi');
    });

    it('should_return_length_of_languageList_when_languageList_is_not_null', 0, () => {
      let languageArray: string[] = ['Java', 'Python', 'JavaScript'];
      let languagedatasource: LanguageDataSource = new LanguageDataSource(languageArray);
      let result = languagedatasource.totalCount();
      expect(result).assertEqual(languageArray.length);
    });
  });
}