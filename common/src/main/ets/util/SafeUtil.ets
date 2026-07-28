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

import { StringUtil } from './StringUtil';

/**
 * 安全打印工具类
 *
 * @since 2023-12-19
 */

/**
 * 匿名化处理符号
 */
const ANONYMIZATION_SYMBOL = '***';

/**
 * 单个匿名化符号
 */
const ANONYMIZATION_SYMBOL_SINGLE = '*';

/**
 * 最小长度
 */
const MIN_LENGTH = 4;

/**
 * 保留位数
 */
const RESERVED_NUMBER = 3;

export class SafeUtil {

  /**
   * 匿名化打印设备id
   * @param source 设备id
   * @returns 匿名化处理后的设备id
   */
  public static replaceDeviceIdSensitive(source: string): string {
    if (StringUtil.isEmpty(source)) {
      return source;
    }
    let length = source.length;
    if (length < MIN_LENGTH) {
      return ANONYMIZATION_SYMBOL;
    }
    const head = source.slice(0, RESERVED_NUMBER);
    const tail = source.slice(-RESERVED_NUMBER);
    const middle = ANONYMIZATION_SYMBOL_SINGLE.repeat(source.length - MIN_LENGTH);
    return head + middle + tail;
  }
}