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

import { ArgumentMatchers, beforeAll, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { ExperienceManager, LogUtil, SceneType, SceneTypeManager, SettingUtil } from '@ohos/hwstartupguide.common';
import { EnterHomeComponentModel } from '@ohos/hwstartupguide.common/src/main/ets/model/EnterHomeComponentModel';
import { uiAppearance } from '@kit.ArkUI';

const SWITCH_NAME: string = 'isFirstPageLoaded';

const TAG: string = 'ExperienceManagerTest';

/**
 * ExperienceManager工具类测试
 */
export default function ExperienceManagerTest() {
  let isBtnVisible: boolean = false;
  let model: EnterHomeComponentModel;
  describe('ExperienceManagerTest', () => {
    beforeAll(async () => {
      model = new EnterHomeComponentModel();
      model.getButtonVisible = () => {
        return isBtnVisible;
      };
      model.setButtonVisible = (btnVisible: boolean) => {
        isBtnVisible = btnVisible;
      };
    })

    /**
     * @tc.number:ExperienceManagerTest_001
     * @tc.name: ExperienceManager工具类测试
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: ExperienceManager工具类测试
     */
    it('ExperienceManagerTest_001', 0, (done: Function) => {
      LogUtil.info(TAG, 'ExperienceManagerTest_001 start');
      expect(ExperienceManager.getInstance().getIsPhone()).assertFalse();
      ExperienceManager.getInstance().setIsPhone(true);
      expect(ExperienceManager.getInstance().getIsPhone()).assertTrue();
      done();
      LogUtil.info(TAG, 'ExperienceManagerTest_001 end');
    });

    /*
     * @tc.number:ExperienceManagerTest_002
     */
    it('ExperienceManagerTest_002', 0, async () => {
      LogUtil.info(TAG, 'ExperienceManagerTest_002 start');
      SettingUtil.setValueSync(SWITCH_NAME, 'false');
      await sleep(1000);
      expect(ExperienceManager.getInstance().isDeskAlreadyReady()).assertFalse();
      LogUtil.info(TAG, 'ExperienceManagerTest_002 end');
    });

    /*
     * @tc.number:ExperienceManagerTest_003
     */
    it('ExperienceManagerTest_003', 0, async () => {
      ExperienceManager.getInstance().registerEnterHomeComponentModel(model)
      expect(model.getButtonVisible()).assertFalse();
    });

    /*
     * @tc.number:ExperienceManagerTest_004
     */
    it('ExperienceManagerTest_004', 0, async () => {
      LogUtil.info(TAG, 'ExperienceManagerTest_004 start');
      model.setButtonVisible(false);
      ExperienceManager.getInstance().startListenSettingDataChange();
      await sleep(2000);
      SettingUtil.setValueSync(SWITCH_NAME, 'true');
      await sleep(1000);
      let result = (): void => {
        model.getButtonVisible()
      };
      expect(result).not().assertFail();
      LogUtil.info(TAG, 'ExperienceManagerTest_004 end');
    });

    /*
     * @tc.number:ExperienceManagerTest_005
     */
    it('ExperienceManagerTest_005', 0, async () => {
      LogUtil.info(TAG, 'ExperienceManagerTest_005 start');
      model.setButtonVisible(false);
      ExperienceManager.getInstance().waitForSecondsToSetButtonVisible();
      await sleep(5000);
      expect(model.getButtonVisible()).assertTrue();
      LogUtil.info(TAG, 'ExperienceManagerTest_005 end');
    });

    /*
     * @tc.number:ExperienceManagerTest_006
     */
    it('ExperienceManagerTest_006', 0, async () => {
      LogUtil.info(TAG, 'ExperienceManagerTest_006 start');
      model.setButtonVisible(false);
      ExperienceManager.getInstance().setIsPhone(false);
      ExperienceManager.getInstance().startListenSettingDataChange();
      expect(model.getButtonVisible()).assertTrue();
      LogUtil.info(TAG, 'ExperienceManagerTest_006 end');
    });

    /*
     * @tc.number:ExperienceManagerTest_007
     */
    it('ExperienceManagerTest_007', 0, async () => {
      LogUtil.info(TAG, 'ExperienceManagerTest_007 start');
      model.setButtonVisible(false);
      SettingUtil.setValueSync(SWITCH_NAME, 'false');
      await sleep(1000);
      ExperienceManager.getInstance().onIsFirstPageLoadedChange()
      expect(model.getButtonVisible()).assertFalse();
      LogUtil.info(TAG, 'ExperienceManagerTest_007 end');
    });
  })
}

const sleep: Function = (ms: number): Promise<void> => {
  return new Promise(res => setTimeout(res, ms))
};