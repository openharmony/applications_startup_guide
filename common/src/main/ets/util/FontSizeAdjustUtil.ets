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

import uiAppearance from '@ohos.uiAppearance';
import settings from '@ohos.settings';
import { LogUtil } from './LogUtil';
import { SettingUtil } from './SettingUtil';
import { CommonConstant } from '../constant/CommonConstant';

const TAG: string = 'FontSizeAdjustUtil';

/**
 * 设置字体大小工具类
 *
 * @since 2024-05-22
 */
export class FontSizeAdjustUtil {

  /**
   * 更新系统字体缩放比例配置
   *
   * @param fontSizeScale 当前缩放比例
   */
  public static async setFontSizeScale(fontSizeScale: number): Promise<void> {
    try {
      LogUtil.info(TAG, `uiAppearance.setFontScale: ${fontSizeScale}`);
      await uiAppearance.setFontScale(fontSizeScale);
      SettingUtil.setValueSync(CommonConstant.SETTINGS_DATA_FONT_SIZE_SCALE,
        fontSizeScale.toString(), settings.domainName.USER_PROPERTY);
    } catch (paramError) {
      LogUtil.error(TAG, `set fontSize error.code: ${paramError?.code}, error.message: ${paramError?.message}`);
    }
    AppStorage.setOrCreate<number>('textZoomRatio', fontSizeScale * 100);
  }

  /**
   * OOBE阶段重启后读取数据库中的字体缩放比例，并更新Configuration
   */
  public static async setFontSizeScaleOnRestart(): Promise<void> {
    let settingFontSizeScale: number = Number(SettingUtil
      .getValueSync(CommonConstant.SETTINGS_DATA_FONT_SIZE_SCALE, CommonConstant.DEFAULT_FONT_SIZE_SCALE,
        settings.domainName.USER_PROPERTY));
    LogUtil.info(TAG, `settingFontSizeScale: ${settingFontSizeScale}`);
    try {
      LogUtil.info(TAG, `setFontSizeScaleOnRestart uiAppearance.setFontScale: ${settingFontSizeScale}`);
      await uiAppearance.setFontScale(settingFontSizeScale);
    } catch (paramError) {
      let code: number = (paramError).code;
      let message: string = (paramError).message;
      LogUtil.error(TAG, `set fontSize error.code: ${code}, error.message: ${message}`);
    }
    AppStorage.setOrCreate<number>('textZoomRatio', settingFontSizeScale * 100);
  }
}

