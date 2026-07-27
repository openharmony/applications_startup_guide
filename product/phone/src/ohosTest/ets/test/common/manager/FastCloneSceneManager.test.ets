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
import { FastCloneSceneManager } from '@ohos/hwstartupguide.common';

import { describe, expect, it } from '@ohos/hypium';

const TAG: string = 'FastCloneSceneManagerTest';

export default function FastCloneSceneManagerTest() {
  describe('FastCloneSceneManagerTest', () => {

    it('FastCloneSceneManagerTest_001', 0, async () => {
      FastCloneSceneManager.getInstance().setFastCloneScene(true);
      expect(FastCloneSceneManager.getInstance().isFastCloneScene()).assertTrue();
    });

    it('FastCloneSceneManagerTest_002', 0, async () => {
      FastCloneSceneManager.getInstance().setFastCloneScene(false);
      expect(FastCloneSceneManager.getInstance().isFastCloneScene()).assertFalse();
    });

    it('FastCloneSceneManagerTest_003', 0, async () => {
      FastCloneSceneManager.getInstance().setNetworkId('testNetworkId');
      expect(FastCloneSceneManager.getInstance().getNetworkId()).assertEqual('testNetworkId');
    });

    it('FastCloneSceneManagerTest_004', 0, async () => {
      FastCloneSceneManager.getInstance().setCloneWlan(true);
      expect(FastCloneSceneManager.getInstance().isCloneWlan()).assertTrue();
    });

    it('FastCloneSceneManagerTest_005', 0, async () => {
      FastCloneSceneManager.getInstance().setCloneWlan(false);
      expect(FastCloneSceneManager.getInstance().isCloneWlan()).assertFalse();
    });

    it('FastCloneSceneManagerTest_006', 0, async () => {
      FastCloneSceneManager.getInstance().setWaitNetConnected(false);
      expect(FastCloneSceneManager.getInstance().isWaitNetConnected()).assertFalse();
    });

    it('FastCloneSceneManagerTest_007', 0, async () => {
      FastCloneSceneManager.getInstance().setRequestTypFast(false);
      expect(FastCloneSceneManager.getInstance().isRequestTypFast()).assertFalse();
    });
  })
}