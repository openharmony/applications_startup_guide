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
import { mediaConfigManager, LogUtil, MediaConfigConstants } from '@ohos/hwstartupguide.common';

const TAG: string = 'MediaConfigManagerTest';

/**
 * MediaConfigManagerTest媒体资源配置类
 */
export default function MediaConfigManagerTest() {

  describe('MediaConfigManagerTest', () => {
    beforeAll(async () => {
      await mediaConfigManager.initMediaConfig();
    })

    it('MediaConfigManagerTest_001', 0, () => {
      LogUtil.info(TAG, 'MediaConfigManagerTest_001 start');
      let result = (): void => {
        mediaConfigManager.initMediaConfig();
      };
      expect(result).not().assertFail();
      LogUtil.info(TAG, 'MediaConfigManagerTest_001 end');
    });
  })
}