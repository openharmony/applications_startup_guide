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

import common from '@ohos.app.ability.common';
import window from '@ohos.window';
import { LogUtil } from './LogUtil';
const TAG: string = 'WindowUtils';
/**
 * 窗口工具类
 *
 * @since 2024-04-16
 */
export class WindowUtils {
  /**
   * 获取窗口属性(尺寸，窗口类型，是否全屏等)
   *
   * @param context 上下文
   * @returns 窗口属性
   */
  static async getWindowProperty(context: common.BaseContext): Promise<window.WindowProperties> {
    try {
      let windowClass: window.Window = await window.getLastWindow(context);
      return windowClass.getWindowProperties();
    } catch (error) {
      LogUtil.error(TAG, `getWindowProperty error: ${error?.code}, ${error?.message}`);
      return null;
    }
  }

  /**
   * 获取状态栏的高度
   *
   * @param context 上下文
   * @returns 窗口内容规避区域
   */
  static async getSystemBarHeight(context: common.BaseContext): Promise<number> {
    let windowClass: window.Window = await window.getLastWindow(context);
    let type: window.AvoidAreaType = window.AvoidAreaType.TYPE_SYSTEM;
    let avoidArea: window.AvoidArea = windowClass?.getWindowAvoidArea(type);
    let height = avoidArea.topRect.height;
    return height;
  }
}