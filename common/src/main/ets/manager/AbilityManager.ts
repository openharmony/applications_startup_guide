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

import type common from '@ohos.app.ability.common';
import { GlobalContext } from '../context/GlobalContext';
import { CommonUtils } from '../util/CommonUtils';
import { LogUtil } from '../util/LogUtil';

const TAG: string = 'AbilityManager';

/**
 * Ability管理类
 */
export class AbilityManager {
  private static instance?: AbilityManager;
  private mContext: common.Context | null = null;

  private constructor() {
    LogUtil.warn(TAG, 'init abilityManager');
  }

  /**
   * 设置OOBE主ability的context
   * @param context context
   */
  public setContext(context: common.Context | null): void {
    let isContextNull: boolean = CommonUtils.isEmpty(context);
    LogUtil.warn(TAG, `setContext, context is null: ${isContextNull}`);
    this.mContext = context;
    GlobalContext.getInstance().setObject('pageContext', this.mContext);
  }

  /**
   * 获取OOBE主ability的context
   */
  public getContext(): common.Context | null {
    return this.mContext;
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  static getInstance(): AbilityManager {
    if (!AbilityManager.instance) {
      AbilityManager.instance = new AbilityManager();
    }
    return AbilityManager.instance;
  }
}
