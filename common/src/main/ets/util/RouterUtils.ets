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

import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import { LogUtil } from './LogUtil';

const TAG: string = 'RouterUtils';

/**
 * 路由工具类
 */
export namespace RouterUtils {

  /**
   * 往路由中push页面url
   *
   * @param options 路由配置项
   */
  export function pushUrl(options: router.RouterOptions): void {
    if (options) {
      try {
        router
          .pushUrl(options)
          .catch((error: BusinessError) => {
            LogUtil.error(TAG, `pushUrl failed, error: ${error?.message}`);
          });
      } catch (error) {
        LogUtil.error(TAG, `pushUrl failed, error: ${error?.message}`);
      }
    }
  }

  /**
   * 返回到上一页面
   */
  export function back(): void {
    try {
      router.back();
    } catch (error) {
      LogUtil.error(TAG, `back failed, error: ${error?.message}`);
    }
  }
}
