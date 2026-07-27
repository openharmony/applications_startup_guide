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
import { common, Want } from '@kit.AbilityKit';
import { AbilityManager } from './AbilityManager';
import { LogUtil } from '../util/LogUtil';

const TAG = 'UpdatingInTheAirManager';
const DELAY_TIME: number = 5000;
const DEFAULT_TASK_ID: number = -1;

export class UpdatingInTheAirManager {
  private static instance?: UpdatingInTheAirManager;
  private taskId: number = DEFAULT_TASK_ID;
  private firstRun: boolean = false;

  private constructor() {
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  public static getInstance(): UpdatingInTheAirManager {
    if (!UpdatingInTheAirManager.instance) {
      UpdatingInTheAirManager.instance = new UpdatingInTheAirManager();
    }
    return UpdatingInTheAirManager.instance;
  }

  public start(): void {
    if (this.firstRun) {
      return;
    }
    this.firstRun = true;
    let want: Want = {
      bundleName: 'com.ohos.openharmony.mmitest',
      abilityName: 'MMIExtAbility',
      parameters: {
        isFromOOBE: true,
      },
    };
    this.taskId = setTimeout(() => {
      try {
        let context = AbilityManager.getInstance().getContext() as common.UIAbilityContext;
        context.startServiceExtensionAbility(want).then(() => {
          LogUtil.info(TAG, 'start MMIExtAbility succeed.');
        });
      } catch (err) {
        LogUtil.error(TAG, `start MMIExtAbility failed, code is ${err.code}, message is ${err.message}.`);
      }
    }, DELAY_TIME);
  }

  public stop(): void {
    if (this.taskId === DEFAULT_TASK_ID) {
      return;
    }
    LogUtil.info(TAG, ` clear time out taskId: ${this.taskId}`);
    clearTimeout(this.taskId);
    this.taskId = DEFAULT_TASK_ID;
  }
}