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
 * 常量类
 */
export class EnhanceServiceConstant {
  /**
   * 前缀类
   */
  public static PREFIX: string = 'settings=';

  /**
   * 增强服务声明同意key值（preferences存储）
   */
  public static KEY_ENHANCE_SERVICE_AGREE_STATE: string = 'enable_all_enhance_service';

  /**
   * rcs状态关键字
   */
  public static RCSTATUS: string = 'isRcsEnable';

  /**
   * rcs serviceName
   */
  public static RCSERVICENAME: string = 'rcs_enhance_statement';

  /**
   * HiViewX serviceName
   */
  public static HIVIEWXSERVICENAME: string = 'hiviewpage_enhance_statement';

  /**
   * 增强服务同意信息前缀
   */
  public static AGREE_INFO_PREFIX: string = 'agree_info_';

  /**
   * validator sysparameter
   */
  public static VALIDATOR_SYS_PARAMETER: string = 'sysparameter';

  /**
   * validator settings
   */
  public static VALIDATOR_SETTINGS: string = 'settings';

  /**
   * validator custom
   */
  public static VALIDATOR_CUSTOM: string = 'custom';
}
