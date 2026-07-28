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
import { LogUtil } from '@ohos/hwstartupguide.common';
import { describe, it, expect, DEFAULT, beforeAll, afterAll } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import { COMMON_DELAY } from '../../types.test';
import { TestConstant } from '../../TestConstant';


const TAG: string = 'CommonComponentsTest';

const sleep: Function = (ms: number): Promise<void> => {
  return new Promise(res => setTimeout(res, ms))
};

/**
 * Common Components TestCases
 *
 * @since 2023-07-18
 */
export default function CommonComponentsTest() {
  describe('CommonComponentsTest', () => {
    LogUtil.info(TAG, 'init common components test');

    /*
      * @tc.number:CommonComponentsTest_001.
      * @tc.name: CommonComponents公共组件测试
      * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
      * @tc.desc: 拉起listPage
      */
    let dr: Driver = new Driver();
    beforeAll(async (done: Function) => {
      LogUtil.info(TAG, 'Driver create');
      dr = Driver.create();
      await sleep(COMMON_DELAY);
      LogUtil.info(TAG, 'sleep end');
      done();
    })

    /*
      * @tc.number:CommonComponentsTest_002
      * @tc.name: CommonComponents公共组件测试
      * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
      * @tc.desc: 按钮点击
      */
    it('ButtonClick', 0, async (done: Function) => {
      LogUtil.info(TAG, 'ButtonClick start');
      await dr.delayMs(TestConstant.NORMAL_DELAY);
      let button = await dr.findComponent(ON.id('button_footercomponent_footerName'));
      expect(button).assertNull();
      LogUtil.info(TAG, 'ButtonClick end');
      done();
    });
  });
}