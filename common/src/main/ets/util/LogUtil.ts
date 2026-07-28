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
import hilog from '@ohos.hilog';

/**
 * 日志工具类
 *
 * @since 2022-11-12
 */

const TAG: string = 'HwStartupGuide';
const DOMAIN: number = 0x0501; // 日志标识符

export class LogUtil {
  public static debug(tag: string, format: string): void {
    hilog.debug(DOMAIN, TAG, `${tag}:${format}`);
  }

  public static info(tag: string, format: string): void {
    hilog.info(DOMAIN, TAG, `${tag}:${format}`);
  }

  public static warn(tag: string, format: string): void {
    hilog.warn(DOMAIN, TAG, `${tag}:${format}`);
  }

  public static error(tag: string, format: string, ...logs: unknown[]): void {
    hilog.error(DOMAIN, TAG, `${tag}:${format} ${this.format(logs)}`);
  }

  /**
   * Format log content
   */
  private static format(logs: unknown[]): string {
    const message = logs.map((log) => {
      try {
        return this.formatLog(log);
      } catch {
        return log;
      }
    }).join(' ');

    return message;
  }

  private static formatLog(log): string {
    if (typeof log === 'string') {
      return log;
    }

    if (log instanceof Error) {
      let errorMessage = 'error: ';
      if (Object.prototype.hasOwnProperty.call(log, 'code')) {
        const code = (log as Error & { code: number }).code;
        errorMessage += code !== undefined ? `[${code}]` : '';
      }
      errorMessage += log.message;
      // 这里控制是否打印堆栈 + (log.stack ? '\n' + log.stack : '');
      return errorMessage;
    }

    return JSON.stringify(log);
  }
}
