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

import { beforeAll, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { DeviceUtil, LogUtil, ResourceUtil, ScreenSizeUtil } from '@ohos/hwstartupguide.common';
import Display from '@ohos.display';
import { ScreenStateMonitor } from '@ohos/hwstartupguide.common/src/main/ets/manager/ScreenStateMonitor';

const TAG: string = 'BaseUtilTest';

export default function BaseUtilTest() {
  describe('BaseUtilTest', () => {
    beforeAll(async () => {
    });

    /**
     * @tc.number: BaseUtilTest_001
     * @tc.name: 设备工具类测试，检查是否为手机
     */
    it('BaseUtilTest_001', 0, async () => {
      LogUtil.info(TAG, 'BaseUtilTest_001 start');
      expect(DeviceUtil.isDevicePhone()).assertTrue();
      LogUtil.info(TAG, 'BaseUtilTest_001 end');
    });

    /**
     * @tc.number: BaseUtilTest_002
     * @tc.name: 设备工具类测试，检查是否为电脑
     */
    it('BaseUtilTest_002', 0, async () => {
      LogUtil.info(TAG, 'BaseUtilTest_002 start');
      expect(DeviceUtil.isDevicePc()).assertFalse();
      LogUtil.info(TAG, 'BaseUtilTest_002 end');
    });

    /**
     * @tc.number: BaseUtilTest_003
     * @tc.name: 设备工具类测试，检查是否为PAD
     */
    it('BaseUtilTest_003', 0, async () => {
      LogUtil.info(TAG, 'BaseUtilTest_003 start');
      expect(DeviceUtil.isDevicePad()).assertFalse();
      LogUtil.info(TAG, 'BaseUtilTest_003 end');
    });

    /*
    * @tc.number: BaseUtilTest_004
    * @tc.name: 屏幕尺寸工具类测试，检查屏幕是否为垂直方向
    */
    it('BaseUtilTest_004', 0, async () => {
      LogUtil.info(TAG, 'BaseUtilTest_004 start');
      expect(ScreenSizeUtil.isScreenPortraitOrientation()).not().assertUndefined();
      LogUtil.info(TAG, 'BaseUtilTest_004 end');
    });

    /*
    * @tc.number: BaseUtilTest_005
    * @tc.name: 屏幕尺寸工具类测试，获取当前屏幕宽度
    */
    it('BaseUtilTest_005', 0, async () => {
      LogUtil.info(TAG, 'BaseUtilTest_005 start');
      expect(ScreenSizeUtil.getScreenWidth()).assertLarger(0);
      LogUtil.info(TAG, 'BaseUtilTest_005 end');
    });

    /**
     * @tc.number: BaseUtilTest_006
     * @tc.name: 屏幕尺寸工具类测试
     */
    it('BaseUtilTest_006', 0, async () => {
      LogUtil.info(TAG, 'BaseUtilTest_006 start');
      expect(Display.Orientation.LANDSCAPE).assertEqual(1);
      LogUtil.info(TAG, 'BaseUtilTest_006 end');
    });

    /**
     * @tc.number: BaseUtilTest_007
     * @tc.name: isSmallFoldScreen
     */
    it('BaseUtilTest_007', 0, async () => {
      LogUtil.info(TAG, 'BaseUtilTest_007 start');
      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(DeviceUtil, DeviceUtil.getFoldScreenProperty);
      when(mockFun)().afterReturn('4,');
      DeviceUtil.isSmallFoldScreen();
      DeviceUtil.isVerde();
      DeviceUtil.isTripleFold();
      DeviceUtil.isDoubleFold();
      let loadPage = (): void => {
        DeviceUtil.isOOBEShowImportantTips();
      };
      expect(loadPage).not().assertFail();
      mocker.clear(DeviceUtil);
      LogUtil.info(TAG, 'BaseUtilTest_007 end');
    });

    /**
     * @tc.number: BaseUtilTest_008
     * @tc.name: isSmallFoldScreen
     */
    it('BaseUtilTest_008', 0, async () => {
      LogUtil.info(TAG, 'BaseUtilTest_008 start');
      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(DeviceUtil, DeviceUtil.getFoldScreenProperty);
      when(mockFun)().afterReturn('1,');
      DeviceUtil.isSmallFoldScreen();
      DeviceUtil.isTripleFold();
      DeviceUtil.isDoubleFold();
      let loadPage = (): void => {
        DeviceUtil.isDoubleFold();
      };
      expect(loadPage).not().assertFail();
      mocker.clear(DeviceUtil);
      LogUtil.info(TAG, 'BaseUtilTest_008 end');
    });

    /**
     * @tc.number: BaseUtilTest_009
     * @tc.name: isUseLandscapeResource
     */
    it('BaseUtilTest_009', 0, async () => {
      LogUtil.info(TAG, 'BaseUtilTest_009 start');
      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(DeviceUtil, DeviceUtil.isDevicePad);
      when(mockFun)().afterReturn(true);
      let mockScreenOrientation: Function = mocker.mockFunc(ScreenSizeUtil, ScreenSizeUtil.isScreenPortraitOrientation);
      when(mockScreenOrientation)().afterReturn(false);
      let result :Boolean = DeviceUtil.isUseLandscapeResource(ScreenStateMonitor.getInstance().getCurrentScreenStateModel());
      expect(result).assertTrue();
      mocker.clear(DeviceUtil);
      mocker.clear(ScreenSizeUtil);
      LogUtil.info(TAG, 'BaseUtilTest_009 end');
    });

    /**
     * @tc.number: BaseUtilTest_010
     * @tc.name: isUseLandscapeResource
     */
    it('BaseUtilTest_010', 0, async () => {
      LogUtil.info(TAG, 'BaseUtilTest_010 start');
      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(DeviceUtil, DeviceUtil.isDevicePad);
      when(mockFun)().afterReturn(false);
      let result :Boolean = DeviceUtil.isUseLandscapeResource(ScreenStateMonitor.getInstance().getCurrentScreenStateModel());
      expect(result).assertFalse();
      mocker.clear(DeviceUtil);
      LogUtil.info(TAG, 'BaseUtilTest_010 end');
    });
  });
}
