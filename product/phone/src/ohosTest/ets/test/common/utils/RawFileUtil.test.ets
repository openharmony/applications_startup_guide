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
import common from '@ohos.app.ability.common';
import { LogUtil, RawFileUtil, GlobalContext } from '@ohos/hwstartupguide.common';

const TAG: string = 'RawFileUtilTest';

/**
 * RawFileUtil工具类测试
 */
export default function RawFileUtilTest() {
  describe('RawFileUtilTest', () => {

    /*
       * @tc.number:RawFileUtilTest_001
       * @tc.name: RawFileUtil工具类测试
       * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
       * @tc.desc: RawFileUtil工具类测试
       */
    it('RawFileUtilTest_001', 0, async () => {
      LogUtil.info(TAG, 'RawFileUtilTest_001 start');
      let fileName: string | null = '';
      RawFileUtil.getStringByFile(fileName);
      fileName = 'page_configs.json';
      RawFileUtil.getStringByFile(fileName)
      expect(RawFileUtil.getLottieData('')).assertPromiseIsRejected();
      LogUtil.info(TAG, 'RawFileUtilTest_001 end');
    });

    it('RawFileUtilTest_002', 0, async (done: Function) => {
      let fileName: string = '';
      expect(RawFileUtil.getLottieData(fileName)).assertPromiseIsRejected();
      done();
    });

    it('RawFileUtilTest_003', 0, async (done: Function) => {
      let fileName: string = 'empty.json';
      RawFileUtil.getLottieData(fileName);
      expect(RawFileUtil.getLottieData('')).assertPromiseIsRejected();
      done();
    });

    it('RawFileUtilTest_004', 0, async (done: Function) => {
      let fileName: string = 'quick_setup_animate.json';
      RawFileUtil.getLottieData(fileName);
      expect(RawFileUtil.getLottieData('')).assertPromiseIsRejected();
      done();
    });
  });
}

