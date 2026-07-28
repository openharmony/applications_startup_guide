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

/**
 * 数据存储处理接口
 */
export interface ISaveDataHandler {
  /**
   * 存储数据
   */
  saveData(context: Context, saveRuleStr: string, checkStatus: boolean): void;

  /**
   * 获取数据
   */
  getData(context: Context, queryRuleStr: string): string | null;
}