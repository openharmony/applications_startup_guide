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

import { BasePreferences } from './BasePreferences';

const FILE_NAME: string = 'shared_preferences';

/**
 * SharePreferences
 */
export class SharePreferences extends BasePreferences {
  private static instance?: SharePreferences;

  /**
   * 构造函数
   */
  private constructor() {
    super(FILE_NAME);
  }

  /**
   * 获取单例对象
   *
   * @returns instance
   */
  public static getInstance(): SharePreferences {
    if (!SharePreferences.instance) {
      SharePreferences.instance = new SharePreferences();
    }
    return SharePreferences.instance;
  }

  getTag(): string {
    return 'SharePreferences';
  }
}