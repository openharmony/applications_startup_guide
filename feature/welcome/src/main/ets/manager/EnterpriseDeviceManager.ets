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

import { inputConsumer, KeyCode } from '@kit.InputKit';
import { LogUtil } from '@ohos/hwstartupguide.common';

export const ENTERPRISE_DEVICE_MANAGER_TAG: string = 'EnterpriseDeviceManager';

export const OFFLINE_TRIGGER_COUNT = 6;
export const OFFLINE_TRIGGER_DURATION_MS = 6000;
export const EDM_PROVISIONING_OFFLINE_MODE = 'EDM_PROVISIONING_OFFLINE_MODE';

export enum OfflineTriggerType {
  // 触摸屏点击
  Touch = 0,
  // 鸿蒙键
  Press = 1,
}

/**
 * 企业设备管理
 */
export class EnterpriseDeviceManager {
  private static instance: EnterpriseDeviceManager;
  /**
   * 左meta键抬起事件
   */
  protected metaKeyUpOptions: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCode.KEYCODE_META_LEFT,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };
  protected metaKeyCallback: Callback<inputConsumer.KeyOptions> = (keyOptions: inputConsumer.KeyOptions) => {
    if (!keyOptions.isFinalKeyDown) {
      LogUtil.info(ENTERPRISE_DEVICE_MANAGER_TAG, 'left meta key callback key up');
      this.handleOfflineTrigger(OfflineTriggerType.Press);
    }
  };
  protected timers: (number | undefined)[] = [undefined, undefined];
  protected counters: number[] = [0, 0];
  protected triggerOfflineMode: boolean | undefined = AppStorage.get<boolean>(EDM_PROVISIONING_OFFLINE_MODE);

  /**
   * 单例模式获取对象
   * @returns 企业设备管理对象
   */
  public static getInstance(): EnterpriseDeviceManager {
    if (!EnterpriseDeviceManager.instance) {
      EnterpriseDeviceManager.instance = new EnterpriseDeviceManager();
    }
    return EnterpriseDeviceManager.instance;
  }
  /**
   * 离线定制触发暗码
   * @param offlineTriggerType 触发类型
   */
  public handleOfflineTrigger(offlineTriggerType: OfflineTriggerType): void {
    if (this.triggerOfflineMode) {
      return;
    }
    if (this.timers[offlineTriggerType] === undefined) {
      this.counters[offlineTriggerType] = 1;
      LogUtil.info(ENTERPRISE_DEVICE_MANAGER_TAG,
        `handleOfflineTrigger offlineTriggerType: ${offlineTriggerType}, new counter`);
      this.timers[offlineTriggerType] = setTimeout(() => {
        this.clearTimer(offlineTriggerType);
      }, OFFLINE_TRIGGER_DURATION_MS);
    } else {
      this.counters[offlineTriggerType]++;
      LogUtil.info(ENTERPRISE_DEVICE_MANAGER_TAG,
        `handleOfflineTrigger offlineTriggerType: ${offlineTriggerType}, count: ${this.counters[offlineTriggerType]}`);
      if (this.counters[offlineTriggerType] === OFFLINE_TRIGGER_COUNT) {
        this.clearTimer(offlineTriggerType);
        this.triggerOfflineMode = true;
        AppStorage.setOrCreate(EDM_PROVISIONING_OFFLINE_MODE, true);
      }
    }
  }

  /**
   * 注册监听左meta键抬起事件
   */
  public registerKeysIntercept(): void {
    try {
      inputConsumer.on('key', this.metaKeyUpOptions, this.metaKeyCallback);
    } catch (error) {
      LogUtil.error(ENTERPRISE_DEVICE_MANAGER_TAG, `registerKeysIntercept fail, ${error?.code}, ${error?.message}`);
    }
  }

  /**
   * 取消注册监听左meta键抬起事件
   */
  public unRegisterKeyIntercept(): void {
    LogUtil.info(ENTERPRISE_DEVICE_MANAGER_TAG, 'unRegisterKeyIntercept');
    try {
      inputConsumer.off('key', this.metaKeyUpOptions);
    } catch (error) {
      LogUtil.error(ENTERPRISE_DEVICE_MANAGER_TAG, `unRegisterKeyIntercept fail, ${error?.code}, ${error?.message}`);
    }
  }
  /**
   * 清理离线定制标识timer
   */
  public clearTimer(type: OfflineTriggerType): void {
    clearTimeout(this.timers[type]);
    this.timers[type] = undefined;
    this.counters[type] = 0;
  }

  /**
   * 清理所有timer
   */
  public clearTimers(): void {
    LogUtil.info(ENTERPRISE_DEVICE_MANAGER_TAG, 'clearTimers');
    for (const timer of this.timers) {
      if (timer !== undefined) {
        clearTimeout(timer);
      }
    }
  }
}
