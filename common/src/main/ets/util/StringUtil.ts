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
import { LogUtil } from './LogUtil';

const TAG: string = 'StringUtil';
const CLICK_TIMER: number = 500;
export const EMPTY_IDENTIFY: string = 'empty'; // 空字符串标识符

/**
 * 字符串工具类
 */
export class StringUtil {
  private static lastClickTime: number = 0;

  /**
   * 判断字串是否是空字串
   * @param stringValue 字符串
   */
  public static isEmpty(stringValue: string | null | undefined): boolean {
    return stringValue === undefined || stringValue === null || stringValue.length === 0;
  }

  /**
   * 判断字串是否是非空字串
   * @param stringValue 字符串
   */
  public static isNotEmpty(stringValue: string | null | undefined): boolean {
    return stringValue !== undefined && stringValue !== null && stringValue.length !== 0;
  }

  /**
   * 判断资源字符是否是非空字串
   * @param stringValue 字符串
   */
  public static isNotEmptyRes(stringValue: string | null | undefined): boolean {
    return StringUtil.isNotEmpty(stringValue) && stringValue !== EMPTY_IDENTIFY;
  }

  /**
   * 防止快速点击
   *
   * @returns true/false
   */
  public static isFastClick(): boolean {
    let currentTime: number = new Date().getTime();
    let diffTime: number = currentTime - this.lastClickTime;
    if (diffTime > 0 && diffTime < CLICK_TIMER) {
      LogUtil.error(TAG, 'click to fast, so return');
      return true;
    }
    this.lastClickTime = currentTime;
    return false;
  }
}
