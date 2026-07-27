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
import { LogUtil, TimeOutUtil, } from '@ohos/hwstartupguide.common/index';

const TAG: string = 'TimeOutUtilTest';
const DELAY_TIMEOUT: number = 3 * 1000;

export default function TimeOutUtilTest() {
  describe('TimeOutUtilTest', () => {
    beforeAll(async () => {

    });

    it('TimeOutUtilTest_001', 0, async () => {
      let timeOutUtil: TimeOutUtil = new TimeOutUtil(DELAY_TIMEOUT, (): void => {
        LogUtil.info(TAG, 'TimeOutUtilTest_001');
      }, TAG);
      timeOutUtil.setTimeout();
      let handleAbilityResult = (): void => {
        timeOutUtil.clearTimeout();
      };
      expect(handleAbilityResult).not().assertFail();
    });

    it('TimeOutUtilTest_002', 0, async () => {
      let timeOutUtil: TimeOutUtil = new TimeOutUtil(DELAY_TIMEOUT, (): void => {
        LogUtil.info(TAG, 'TimeOutUtilTest_002');
      }, TAG);
      timeOutUtil.setTimeout();
      sleep(DELAY_TIMEOUT + 1000);
      let handleAbilityResult = (): void => {
        timeOutUtil.clearTimeout();
      };
      expect(handleAbilityResult).not().assertFail();
    });
  });
}

const sleep: Function = (ms: number): Promise<void> => {
  return new Promise(res => setTimeout(res, ms))
};