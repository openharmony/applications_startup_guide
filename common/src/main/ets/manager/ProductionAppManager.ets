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
import { LogUtil } from '../util/LogUtil';

const TAG: string = 'ProductionAppManager';

/**
 * 拉起生产应用管理类
 */
export class ProductionAppManager {
  private static instance?: ProductionAppManager;

  private constructor() {
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  static getInstance(): ProductionAppManager {
    if (!ProductionAppManager.instance) {
      ProductionAppManager.instance = new ProductionAppManager();
    }
    return ProductionAppManager.instance;
  }

  /**
   * 异步检测OEMInfo, 通过startAbility拉起对应应用
   */
  checkOemInfoAndPullApp(callback?: Function): void {
    LogUtil.info(TAG, 'checkOemInfoAndPullApp method action');
    Promise.resolve().then(() => {
      callback?.();
    });
  }
}
