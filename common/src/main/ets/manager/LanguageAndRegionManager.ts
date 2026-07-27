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

import i18n from '@ohos.i18n';
import emitter from '@ohos.events.emitter';
import { Event } from '../event/Event';
import { LogUtil } from '../util/LogUtil';

const TAG: string = 'LanguageAndRegionManager';
const DEFAULT_TASK_ID: number = -1;
const DELAY_TIMEOUT: number = 2 * 1000; // 超时2S
const DELAY_CONFIGURATION: number = 300; // 延时300毫秒

/**
 * 设置语言或地区管理类
 * 设置语言或者地区之后，界面会刷新，等待刷新完毕，再执行后续操作
 */
export class LanguageAndRegionManager {
  private static instance?: LanguageAndRegionManager;
  private taskId: number = DEFAULT_TASK_ID;

  private constructor() {
  }

  /**
   * 单例
   *
   * @returns instance
   */
  public static getInstance(): LanguageAndRegionManager {
    if (!LanguageAndRegionManager.instance) {
      LanguageAndRegionManager.instance = new LanguageAndRegionManager();
    }
    return LanguageAndRegionManager.instance;
  }

  async setLanguageAndRegion(language: string, region: string): Promise<void> {
    LogUtil.info(TAG, 'setLanguageAndRegion start');
    return new Promise((resolve, reject) => {
      emitter.on(Event.LANGUAGE_CONFIGURATION_UPDATE, () => {
        // 收到设置语言或地区后，界面刷新完毕后，再处理后续
        LogUtil.info(TAG, `receive event: LANGUAGE_CONFIGURATION_UPDATE`);
        this.cancelTask();

        this.taskId = setTimeout(() => {
          // 收到事件后，再延时，处理多次触发onConfigurationUpdate的情形
          LogUtil.info(TAG, 'timeout reach to resolve configuration');
          this.taskId = DEFAULT_TASK_ID;
          resolve();
        }, DELAY_CONFIGURATION);
      });

      if (language !== null) {
        this.setSystemLanguage(language);
      }
      if (region !== null) {
        this.setSystemRegion(region);
      }

      this.taskId = setTimeout(() => {
        // 使用定时器进行兜底，处理收不到事件的情形
        LogUtil.info(TAG, 'timeout reach to resolve');
        this.taskId = DEFAULT_TASK_ID;
        resolve();
      }, DELAY_TIMEOUT);
    });
  }

  setSystemLanguage(language: string): void {
    i18n.System.setSystemLanguage(language);
  }

  getSystemLanguage(): string {
    return i18n.System.getSystemLanguage();
  }

  setSystemRegion(region: string): void {
    i18n.System.setSystemRegion(region);
  }

  getSystemRegion(): string {
    return i18n.System.getSystemRegion();
  }

  private cancelTask(): void {
    if (this.taskId !== DEFAULT_TASK_ID) {
      LogUtil.info(TAG, `cancel task taskId: ${this.taskId}`);
      clearTimeout(this.taskId);
      this.taskId = DEFAULT_TASK_ID;
    }
  }
}
