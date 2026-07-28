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
 * 折叠屏类型前缀
 */
export enum FoldScreenTypePrefix {
  /**
   * 大折（内折）叠屏产品类型前缀，如ALTB、ICL
   */
  LARGE_FOLD = '1,',

  /**
   * 小折（内折）叠屏产品类型前缀，如LEM、PSD
   */
  SMALL_FOLD = '2,',

  /**
   * 小折叠屏新形态产品类型前缀，如VDE
   */
  SMALL_FOLD_NEW_FORM = '4,',

  /**
   * 内折叠屏幕PC，如HPR
   */
  INNER_FOLD_SCREEN_PC = '5',

  /**
   * 三折叠屏产品类型前缀，如GRL
   */
  TRIPLE_FOLD = '6,'
}