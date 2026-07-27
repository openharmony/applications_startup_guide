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
 * 数字工具类
 */
export class NumberUtils {
  /**
   * 比较两个浮点数是否相等
   *
   * @param src 待比较的浮点数A
   * @param dst 待比较的浮点数B
   */
  static compare(src: number, dst: number): boolean {
    return Math.abs(src - dst) < Number.EPSILON;
  }

  /**
   * 获取两个数字中的最大值
   *
   * @param src 待比较的数A
   * @param dst 待比较的数B
   */
  static max(src: number | undefined, dst: number | undefined): number | undefined {
    if (!src && !dst) {
      return undefined;
    }
    if (!src) {
      return dst;
    }
    if (!dst) {
      return src;
    }
    return Math.max(src, dst);
  }
}
