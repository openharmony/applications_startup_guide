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

import { LogUtil } from './LogUtil';

const TAG: string = 'QrCodeUtils';

/**
 * QrCode工具类
 */
export class QrCodeUtils {
  /**
   * 检查是否是要展示二维码
   */
  public static isNeedQrCode(): boolean {
    return false;
  }

  /**
   * 根据type获取sn/bsn
   * @param type sn/bsn类型
   * @returns sn/bsn号
   */
  public static getSnOrBsnByType(type: number): string {
    LogUtil.debug(TAG, 'getSnOrBsnByType not supported in open-source OpenHarmony');
    return '';
  }
}
