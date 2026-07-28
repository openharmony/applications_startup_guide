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

import type ability from '@ohos.ability.ability';
import type { BusinessError } from '@ohos.base';
import { LogUtil } from './LogUtil';
import { EMPTY_IDENTIFY } from './StringUtil';

const TAG: string = 'CommonUtils';
/**
 * 接口工具
 *
 * @since 2023-08-25
 */
export namespace CommonUtils {
  /**
   * ts封装 将map对象转换为数组
   *
   * @param content 字符串内容
   * @returns [K, V][] | null 数组对象
   */
  export function mapConvertToArray<K, V>(map: Map<K, V> | null): [K, V][] | null {
    if (!map) {
      return null;
    }
    try {
      return Array.from<[K, V]>(map);
    } catch (exception) {
      LogUtil.error('TAG', 'Array.from failed !!');
      return null;
    }
  }

  /**
   * 判空处理
   *
   * @param value 值
   * @return 是否为空
   */
  export function isEmpty<T>(value: T): boolean {
    return value === null || value === undefined;
  }

  /**
   * string判空处理
   *
   * @param value string值
   * @return 是否为空
   */
  export function isStringEmpty(value: string | null | undefined): boolean {
    return value === null || value === undefined || value === '' || value === EMPTY_IDENTIFY;
  }

  /**
   * 获取一个对象中所有可枚举属性的键值
   *
   * @param obj
   * @returns Array<string> 键值数组
   */
  export function getKeys(obj: Object | Record<string, Object> | null | undefined): Array<string> {
    if (obj === null || obj === undefined) {
      return [];
    }
    return Object.keys(obj);
  }

  /**
   * JSON.stringify方法封装
   *
   * @param value JS对象
   * @return json字符串
   */
  export function stringify<T>(value: T): string {
    if (value) {
      try {
        return JSON.stringify(value);
      } catch (exception) {
        LogUtil.error(TAG, 'JSON.stringify failed !');
        return '';
      }
    }
    return '';
  }

  /**
   * JSON.stringify元组类方法封装
   *
   * @param value JS对象
   * @return json字符串
   */
  export function stringifyTuple<K, V>(value: [K, V][] | null): string {
    if (value) {
      try {
        return JSON.stringify(value);
      } catch (exception) {
        LogUtil.error(TAG, 'JSON.stringify failed !');
        return '';
      }
    }
    return '';
  }

  /**
   * ts封装 json字符串解析
   *
   * @param content json字符串
   * @return T | null 解析后返回值
   */
  export function parseJson<T>(content: string | null): T {
    if (!content) {
      return null;
    }
    try {
      return JSON.parse(content) as T;
    } catch (exception) {
      LogUtil.error(TAG, 'parseJson failed !');
    }
    return null;
  }

  /**
   * 将一个字符串转换为浮点类型数
   *
   * @param string 待转换字符串
   */
  export function parseToFloat(string: string | null): number {
    if (!string) {
      return 0;
    }
    return parseFloat(string);
  }

  export function assign<T extends {}, U>(target: T, source: U): T & U {
    return Object.assign(target, source);
  }

  export function hasKey<T extends Record<string, unknown>>(record: T, key: string): boolean {
    return key in record;
  }
}

/**
 * 拉起外部应用回调
 */
export interface AbilityCallback {
  /**
   * 结果
   */
  (err: BusinessError<string> | null, result: ability.AbilityResult | null): void;
}
