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
import { BgVideoPlayerManager, GlobalContext, LogUtil } from '@ohos/hwstartupguide.common';

const TAG: string = 'BgVideoPlayerManagerTest';

/**
 * BgVideoPlayerManager工具类测试
 */
export default function BgVideoPlayerManagerTest() {
  describe('BgVideoPlayerManagerTest', () => {

    /**
     * @tc.number:BgVideoPlayerManagerTest_001
     * @tc.name: BgVideoPlayerManager工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: BgVideoPlayerManager工具类测试
     */
    it('BgVideoPlayerManagerTest_001', 0, async () => {
      LogUtil.info(TAG, 'BgVideoPlayerManagerTest_001 start');
      GlobalContext.getInstance().setObject('BgVideoPlayerManager', null);
      expect(BgVideoPlayerManager.getInstance()).not().assertNull();
      GlobalContext.getInstance().setObject('BgVideoPlayerManager', new BgVideoPlayerManager());
      expect(BgVideoPlayerManager.getInstance()).not().assertNull();
      LogUtil.info(TAG, 'BgVideoPlayerManagerTest_001 end');
    });

    /**
     * @tc.number:BgVideoPlayerManagerTest_002
     * @tc.name: BgVideoPlayerManager工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: BgVideoPlayerManager工具类测试
     */
    it('BgVideoPlayerManagerTest_002', 0, async () => {
      LogUtil.info(TAG, 'BgVideoPlayerManagerTest_002 start');
      let controller: VideoController = new VideoController();
      BgVideoPlayerManager.getInstance().setBgVideoController(controller);
      expect(BgVideoPlayerManager.getInstance().getBgVideoController()).not().assertNull();
      LogUtil.info(TAG, 'BgVideoPlayerManagerTest_002 end');
    });

    /**
     * @tc.number:BgVideoPlayerManagerTest_003
     * @tc.name: BgVideoPlayerManager工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: BgVideoPlayerManager工具类测试
     */
    it('BgVideoPlayerManagerTest_003', 0, async (done: Function) => {
      LogUtil.info(TAG, 'BgVideoPlayerManagerTest_003 start');
      let controller: VideoController = new VideoController();
      BgVideoPlayerManager.getInstance().setBgVideoController(controller);

      BgVideoPlayerManager.getInstance().playVideo(0);
      await sleep(1000);
      expect(BgVideoPlayerManager.getInstance().getBgVideoFrame()).assertEqual(1);
      BgVideoPlayerManager.getInstance().playVideo(0);
      await sleep(1000);
      expect(BgVideoPlayerManager.getInstance().getBgVideoFrame()).assertEqual(2);
      BgVideoPlayerManager.getInstance().playVideo(0);
      await sleep(1000);
      expect(BgVideoPlayerManager.getInstance().getBgVideoFrame()).assertEqual(3);
      BgVideoPlayerManager.getInstance().playVideo(0);
      await sleep(1000);
      expect(BgVideoPlayerManager.getInstance().getBgVideoFrame()).assertEqual(0);

      done();
      LogUtil.info(TAG, 'BgVideoPlayerManagerTest_003 end');
    });

    /**
     * @tc.number:BgVideoPlayerManagerTest_004
     * @tc.name: BgVideoPlayerManager工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: BgVideoPlayerManager工具类测试
     */
    it('BgVideoPlayerManagerTest_004', 0, async (done: Function) => {
      LogUtil.info(TAG, 'BgVideoPlayerManagerTest_004 start');
      let controller: VideoController = new VideoController();
      BgVideoPlayerManager.getInstance().setBgVideoController(controller);

      BgVideoPlayerManager.getInstance().playVideo(2);
      await sleep(1000);
      expect(BgVideoPlayerManager.getInstance().getBgVideoFrame()).assertEqual(3);
      BgVideoPlayerManager.getInstance().playVideo(2);
      await sleep(1000);
      expect(BgVideoPlayerManager.getInstance().getBgVideoFrame()).assertEqual(2);
      BgVideoPlayerManager.getInstance().playVideo(2);
      await sleep(1000);
      expect(BgVideoPlayerManager.getInstance().getBgVideoFrame()).assertEqual(1);
      BgVideoPlayerManager.getInstance().playVideo(2);
      await sleep(1000);
      expect(BgVideoPlayerManager.getInstance().getBgVideoFrame()).assertEqual(0);
      done();
      LogUtil.info(TAG, 'BgVideoPlayerManagerTest_004 end');
    });
  })
}

const sleep: Function = (ms: number): Promise<void> => {
  return new Promise(res => setTimeout(res, ms))
};