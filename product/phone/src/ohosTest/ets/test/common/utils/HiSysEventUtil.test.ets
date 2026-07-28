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

import {
  CommonConstant,
  HiSysEventUtil,
  LogUtil,
  PageKey,
  SceneType,
  SharePreferences
} from '@ohos/hwstartupguide.common';
import { describe, expect, it } from '@ohos/hypium'

const TAG: string = 'HiSysEventUtilTest';
const USER_IMPROVEMENT_PLAN_AGREE_STATE: string = 'user_improvement_plan_agree_plan';

export default function HiSysEventUtilTest() {
  describe('HiSysEventUtilTest', () => {

    /**
     * @tc.number: HiSysEventUtilTest_003
     * @tc.name: HiSysEventUtil测试
     */
    it('HiSysEventUtilTest_003', 0, async () => {
      LogUtil.info(TAG, 'HiSysEventUtilTest_003 start');
      await SharePreferences.getInstance().setValue(USER_IMPROVEMENT_PLAN_AGREE_STATE, true);
      expect(await HiSysEventUtil.isAgreedFromSP()).assertTrue();
      HiSysEventUtil.reportUserEvent('user_event_test1', 'event1_finish');
      LogUtil.info(TAG, 'HiSysEventUtilTest_003 end');
    });

    /**
     * @tc.number: HiSysEventUtilTest_004
     * @tc.name: HiSysEventUtil测试
     */
    it('HiSysEventUtilTest_004', 0, async () => {
      LogUtil.info(TAG, 'HiSysEventUtilTest_004 start');
      await SharePreferences.getInstance().setValue(
        USER_IMPROVEMENT_PLAN_AGREE_STATE, true);
      expect(HiSysEventUtil.isAgreedFromSP()).not().assertFail();
      await HiSysEventUtil.isAgreedFromSP();
      HiSysEventUtil.reportUserEvent('user_event_test2', 'event2_finish', true);
      LogUtil.info(TAG, 'HiSysEventUtilTest_004 end');
    });

    /**
     * @tc.number: HiSysEventUtilTest_005
     * @tc.name: HiSysEventUtil测试
     */
    it('HiSysEventUtilTest_005', 0, async () => {
      LogUtil.info(TAG, 'HiSysEventUtilTest_005 start');
      await SharePreferences.getInstance().setValue(
        USER_IMPROVEMENT_PLAN_AGREE_STATE, false);
      expect(HiSysEventUtil.isAgreedFromSP()).not().assertFail();
      await HiSysEventUtil.isAgreedFromSP();
      HiSysEventUtil.reportUserEvent('user_event_test3', 'event3_finish');
      LogUtil.info(TAG, 'HiSysEventUtilTest_005 end');
    });

    /**
     * @tc.number: HiSysEventUtilTest_006
     * @tc.name: HiSysEventUtil测试
     */
    it('HiSysEventUtilTest_006', 0, async () => {
      LogUtil.info(TAG, 'HiSysEventUtilTest_006 start');
      await SharePreferences.getInstance().setValue(
        USER_IMPROVEMENT_PLAN_AGREE_STATE, true);
      expect(HiSysEventUtil.isAgreedFromSP()).not().assertFail();
      await HiSysEventUtil.isAgreedFromSP();
      HiSysEventUtil.reportErrorEvent('error_event_test1', 'error1');
      LogUtil.info(TAG, 'HiSysEventUtilTest_006 end');
    });

    /**
     * @tc.number: HiSysEventUtilTest_007
     * @tc.name: HiSysEventUtil测试
     */
    it('HiSysEventUtilTest_007', 0, async () => {
      LogUtil.info(TAG, 'HiSysEventUtilTest_007 start');
      await SharePreferences.getInstance().setValue(
        USER_IMPROVEMENT_PLAN_AGREE_STATE, false);
      expect(HiSysEventUtil.isAgreedFromSP()).not().assertFail();
      await HiSysEventUtil.isAgreedFromSP();
      HiSysEventUtil.reportErrorEvent('error_event_test2', 'error2');
      LogUtil.info(TAG, 'HiSysEventUtilTest_007 end');
    });

    /**
     * @tc.number: HiSysEventUtilTest_008
     * @tc.name: HiSysEventUtil测试
     */
    it('HiSysEventUtilTest_008', 0, async () => {
      LogUtil.info(TAG, 'HiSysEventUtilTest_008 start');
      await SharePreferences.getInstance().setValue(
        USER_IMPROVEMENT_PLAN_AGREE_STATE, true);
      expect(HiSysEventUtil.isAgreedFromSP()).not().assertFail();
      await HiSysEventUtil.isAgreedFromSP();
      HiSysEventUtil.reportUpgradeGuideEvent('990030013', 'testBundle', 'testAbility');
      LogUtil.info(TAG, 'HiSysEventUtilTest_008 end');
    });

    /**
     * @tc.number: HiSysEventUtilTest_009
     * @tc.name: HiSysEventUtil测试
     */
    it('HiSysEventUtilTest_009', 0, async () => {
      LogUtil.info(TAG, 'HiSysEventUtilTest_009 start');
      await SharePreferences.getInstance().setValue(
        USER_IMPROVEMENT_PLAN_AGREE_STATE, false);
      expect(HiSysEventUtil.isAgreedFromSP()).not().assertFail();
      await HiSysEventUtil.isAgreedFromSP();
      HiSysEventUtil.reportUpgradeGuideEvent('990030012', 'testBundle', 'testAbility');
      LogUtil.info(TAG, 'HiSysEventUtilTest_009 end');
    });

    /**
     * @tc.number: HiSysEventUtilTest_010
     * @tc.name: HiSysEventUtil测试
     */
    it('HiSysEventUtilTest_010', 0, async () => {
      LogUtil.info(TAG, 'HiSysEventUtilTest_010 start');
      await SharePreferences.getInstance().setValue(
        USER_IMPROVEMENT_PLAN_AGREE_STATE, false);
      expect(HiSysEventUtil.isAgreedFromSP()).not().assertFail();
      await HiSysEventUtil.isAgreedFromSP();
      HiSysEventUtil.reportErrorEvent('error_event_test2', 'error2');
      LogUtil.info(TAG, 'HiSysEventUtilTest_010 end');
    });

    /**
     * @tc.number: HiSysEventUtilTest_011
     * @tc.name: HiSysEventUtil测试
     */
    it('HiSysEventUtilTest_011', 0, async () => {
      LogUtil.info(TAG, 'HiSysEventUtilTest_011 start');
      let eventInfo: string = `${PageKey.WELCOME}_${new Date().toString()}`;
      let handleFuncRes = (): void => {
        HiSysEventUtil.reportClickPageButtonEvent(CommonConstant.CLICK_PAGE_BUTTON, eventInfo,
          SceneType.FIRST_BOOT_SCENE);
      };
      expect(handleFuncRes).not().assertFail();
      LogUtil.info(TAG, 'HiSysEventUtilTest_011 end');
    });
  });
}