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
import { ColumnSystemManager, DeviceUtil, NumberUtils } from '@ohos/hwstartupguide.common';

import { describe, it, expect, beforeAll, afterAll, MockKit, when } from '@ohos/hypium'
import { mediaquery } from '@kit.ArkUI';
import { ColumnDevice } from '@ohos/hwstartupguide.common/src/main/ets/manager/ColumnSystemManager';

/**
 * ColumnSystemManager工具类测试
 */
export default function ColumnSystemManagerTest() {
  describe('ColumnSystemManager', () => {
    let instance: ColumnSystemManager = ColumnSystemManager.getInstance();
    beforeAll(() => {
      instance.registerMediaQuery();
    });

    /**
     * @tc.number: ColumnSystemManager_columCount
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_columCount', 0, () => {
      let columCount: number = instance.getColumnCount();
      expect(columCount).not().assertUndefined();
    })

    /**
     * @tc.number: ColumnSystemManager_singleColumnWidth
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_singleColumnWidth', 0, () => {
      let singleColumnWidth: number = instance.getSingleColumnWidth();
      expect(NumberUtils.compare(singleColumnWidth, -1)).assertFalse();

      let singleColumnWidthVp: number = instance.getSingleColumnWidthVp();
      expect(NumberUtils.compare(singleColumnWidthVp, -1)).assertFalse();
    })

    /**
     * @tc.number: ColumnSystemManager_ColumnMargin
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_ColumnMargin', 0, () => {
      let columnMargin: number = instance.getColumnMargin();
      expect(NumberUtils.compare(columnMargin, -1)).assertFalse();

      let columnMarginVp: number = instance.getColumnMarginVp();
      expect(NumberUtils.compare(columnMarginVp, -1)).assertFalse();
    })

    /**
     * @tc.number: ColumnSystemManager_ColumnGutter
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_ColumnGutter', 0, () => {
      let columnGutter: number = instance.getColumnGutter();
      expect(NumberUtils.compare(columnGutter, -1)).assertFalse();

      let columnGutterVp: number = instance.getColumnGutterVp();
      expect(NumberUtils.compare(columnGutterVp, -1)).assertFalse();
    });

    /**
     * @tc.number: ColumnSystemManagerTest_CustomWidth
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManagerTest_CustomWidth', 0, () => {
      let customWidth: number = instance.getCustomWidth(2, 0);
      expect(NumberUtils.compare(customWidth, -1)).assertFalse();

      expect(instance.getCustomWidth(0, 0)).assertEqual(0);

      let customWidthVp: number = instance.getCustomWidthVp(2, 0);
      expect(NumberUtils.compare(customWidthVp, -1)).assertFalse();
    });

    /**
     * @tc.number: ColumnSystemManager_registerMediaQuery
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_registerMediaQuery', 0, () => {
      (instance as object)['hasRegister'] = true;
      let ret = instance.registerMediaQuery();
      expect(ret == null).assertTrue();
    })

    /**
     * @tc.number: ColumnSystemManager_unregisterMediaQuery
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_unregisterMediaQuery', 0, () => {
      let ret = instance.unregisterMediaQuery();
      expect(ret == null).assertTrue();

      (instance as object)['lgListener'] = null;
      ret = instance.unregisterMediaQuery();
      expect(ret == null).assertTrue();

      (instance as object)['lgListener'] = null;
      (instance as object)['mdListener'] = null;
      (instance as object)['smListener'] = null;
      ret = instance.unregisterMediaQuery();
      expect(ret == null).assertTrue();
    })

    /**
     * @tc.number: ColumnSystemManager_unregisterMediaQuery_001
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_unregisterMediaQuery_001', 0, () => {

      (instance as object)['columnCount'] = 400;
      let ret: Object = (instance as object)['updateButtonWidth']();
      expect(ret == null).assertTrue();

      (instance as object)['columnCount'] = 4;
      ret = (instance as object)['updateButtonWidth']();
      expect(ret == null).assertTrue();

      (instance as object)['columnCount'] = 300;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceUtil, DeviceUtil.isDevicePc);
      when(mockFunc)().afterReturn(true);
      ret = (instance as object)['updateButtonWidth']();
      expect(ret == null).assertTrue();

      (instance as object)['columnCount'] = 300;
      when(mockFunc)().afterReturn(false);
      ret = (instance as object)['updateButtonWidth']();
      expect(ret == null).assertTrue();

    })

    /**
     * @tc.number: ColumnSystemManager_calcColumnWidth
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_calcColumnWidth', 0, async () => {
      let ret = await instance.calcColumnWidth();
      expect(ret == undefined).assertTrue();
    })

    /**
     * @tc.number: ColumnSystemManager_getCurrentColumnCountByWidth
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_getCurrentColumnCountByWidth', 0, () => {
      let ret = ColumnSystemManager.getCurrentColumnCountByWidth(700);
      expect(ret).assertEqual(8);

      ret = ColumnSystemManager.getCurrentColumnCountByWidth(300);
      expect(ret).assertEqual(4);

      ret = ColumnSystemManager.getCurrentColumnCountByWidth(1200);
      expect(ret).assertEqual(12);
    })

    /**
     * @tc.number: ColumnSystemManager_updateColumnWidth
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_updateColumnWidth', 0, () => {
      let ret = instance.updateColumnWidth(0);
      expect(ret == null).assertTrue();

      ret = instance.updateColumnWidth(1);
      expect(ret == null).assertTrue();
    })

    /**
     * @tc.number: ColumnSystemManager_getColumnMarginVpByColumnCount
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_getColumnMarginVpByColumnCount', 0, () => {
      let ret = ColumnSystemManager.getColumnMarginVpByColumnCount(4);
      expect(ret === 16).assertTrue();

      ret = ColumnSystemManager.getColumnMarginVpByColumnCount(8);
      expect(ret === 16).assertTrue();

      ret = ColumnSystemManager.getColumnMarginVpByColumnCount(0);
      expect(ret === 16).assertTrue();

    })

    /**
     * @tc.number: ColumnSystemManager_getColumnGutterVpByColumnCount
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_getColumnGutterVpByColumnCount', 0, () => {
      let ret = ColumnSystemManager.getColumnGutterVpByColumnCount(4);
      expect(ret === 16).assertTrue();

      ret = ColumnSystemManager.getColumnGutterVpByColumnCount(8);
      expect(ret === 16).assertTrue();

      ret = ColumnSystemManager.getColumnGutterVpByColumnCount(0);
      expect(ret === 16).assertTrue();

    })

    /**
     * @tc.number: ColumnSystemManager_updateMarginAndGutter
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_updateMarginAndGutter', 0, () => {
      (instance as object)['columnCount'] = 4;
      let ret: Object = (instance as object)['updateMarginAndGutter']();
      expect(ret == null).assertTrue();

      (instance as object)['columnCount'] = 8;
      ret = (instance as object)['updateMarginAndGutter']();
      expect(ret == null).assertTrue();

      (instance as object)['columnCount'] = 0;
      ret = (instance as object)['updateMarginAndGutter']();
      expect(ret == null).assertTrue();
    })

    /**
     * @tc.number: ColumnSystemManager_onColumnChangeInner
     * @tc.name: ColumnSystemManager工具类测试
     */
    it('ColumnSystemManager_onColumnChangeInner', 0, async () => {
      let ret: Object = await (instance as object)['onColumnChangeInner'](0);
      expect(ret == null).assertTrue();
    })

    beforeAll(() => {
      instance.unregisterMediaQuery();
    });
  });
}