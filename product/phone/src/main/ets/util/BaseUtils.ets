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
/* instrument ignore file */
import systemParameter from '@ohos.systemParameterEnhance';
import {
  LogUtil,
  DeviceUtil,
  ScreenSizeUtil,
  Orientation
} from '@ohos/hwstartupguide.common';

const TAG: string = 'BaseUtil';
// md: 600vp~840vp 8栅格
const MD_SCREEN_WIDTH: number = 840;
const OOBE_ORIENTATION_TYPE: string = 'const.oobe.orientation';
const OOBE_ORIENTATION: string = systemParameter.getSync(OOBE_ORIENTATION_TYPE, '0');

export class BaseUtil {
  /**
   * 判断OOBE CCM配置项是否为竖屏显示
   *
   * @returns true:竖屏显示,false:非竖屏显示
   */
  public static isPortrait(): boolean {
    LogUtil.info(TAG, `const.oobe.orientation:${OOBE_ORIENTATION}`);
    return OOBE_ORIENTATION === Orientation.PORTRAIT;
  }

  /**
   * 获取栅格之间的间距
   *
   * @returns 边缘间距大小
   */
  public static getGutterSize(): Resource {
    if (ScreenSizeUtil.getScreenWidth() > MD_SCREEN_WIDTH) {
      return $r('app.float.wh_value_24');
    }
    return $r('app.float.wh_value_16');
  }

  /**
   * 获取页面内边距大小
   *
   * @returns 边距大小
   */
  public static getPaddingSize(): Resource | number {
    if (!DeviceUtil.isDevicePad()) {
      return $r('app.float.wh_value_16');
    }
    if (ScreenSizeUtil.isScreenPortraitOrientation()) {
      return BaseUtil.getGutterSize();
    }
    return 0;
  }

  /**
   * 获取页面宽度大小
   *
   * @returns 宽度大小
   */
  public static getWidthSize(): ResourceStr {
    if (!DeviceUtil.isDevicePad() || ScreenSizeUtil.isScreenPortraitOrientation()) {
      return '100%';
    }
    return $r('app.float.wh_value_480');
  }
}