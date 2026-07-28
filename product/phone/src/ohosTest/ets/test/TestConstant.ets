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

export class TestConstant {
  /**
   * UI测试中的一般延迟时间
   */
  static readonly NORMAL_DELAY: number = 1000;
  /**
   * UI测试中的长延迟时间，用于界面间切换涉及网络加载的场景
   */
  static readonly LONG_DELAY: number = 3000;
}