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
import accessibilityKit from '@ohos.accessibility';
import { CommonConstant } from '../constant/CommonConstant';
import { StringUtil } from './StringUtil';
import { LogUtil } from '../util/LogUtil';

const TAG: string = 'AccessibilityUtil';

export enum AccessibilityLevel {
  YES = 'yes'
}

/**
 * 无障碍屏幕朗读工具类
 */
export class AccessibilityUtil {
  // 用于播报按钮组件类型
  public static BUTTON: string = 'button';
  /**
   * 在开启屏幕朗读期间失去焦点时自动获焦
   *
   * @param customId 待获焦组件id
   * @param componentType 组件类型
   */
  public static getFocusOnlost(customId: string, componentType: string = ''): void {
    let eventInfo: accessibilityKit.EventInfo = ({
      type: 'requestFocusForAccessibility',
      bundleName: CommonConstant.HW_STARTUP_GUIDE_PKG_NAME,
      triggerAction: 'common',
      componentType: componentType,
      customId: customId,
    });
    accessibilityKit.sendAccessibilityEvent(eventInfo).then(() => {
      LogUtil.info(TAG, `Succeeded in send event, eventInfo type is ${eventInfo?.type}`);
    });
  }

  public static textAnnounced(text: string): void {
    accessibilityKit.sendAccessibilityEvent({
      type: 'announceForAccessibility',
      triggerAction: 'common',
      bundleName: CommonConstant.HW_STARTUP_GUIDE_PKG_NAME,
      textAnnouncedForAccessibility: text
    }).then(() => {
      LogUtil.info(TAG, `textAnnounced: ${text}`);
    });
  }

  /**
   * 在开启屏幕朗读期间失去焦点时延时自动获焦
   *
   * @param customId 待获焦组件id
   * @param componentType 组件类型
   * @param delay 延迟时间,默认200毫秒
   */
  public static async requestFocusDelay(customId: string, componentType: string = '',
    delay: number = 200): Promise<void> {
    if (!accessibilityKit.isOpenAccessibilitySync()) {
      LogUtil.info(TAG, 'Screen reader is not enabled.');
      return;
    }
    if (!StringUtil.isEmpty(customId)) {
      try {
        let eventInfo: accessibilityKit.EventInfo = ({
          type: 'requestFocusForAccessibility',
          bundleName: CommonConstant.HW_STARTUP_GUIDE_PKG_NAME,
          triggerAction: 'common',
          componentType: componentType,
          customId: customId
        });
        let timeoutId: number = setTimeout(async () => {
          await accessibilityKit.sendAccessibilityEvent(eventInfo);
          LogUtil.info(TAG, 'requestFocusForAccessibility finished.');
          if (timeoutId) {
            clearTimeout(timeoutId);
          }
        }, delay);
      } catch (e) {
        LogUtil.error(TAG, 'requestFocusForAccessibility error, code = {0}, message = {1}', e?.code, e?.message);
      }
    }
  }
}
