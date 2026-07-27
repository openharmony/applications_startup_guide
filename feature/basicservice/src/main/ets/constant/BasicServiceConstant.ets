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
 * 基础服务申明常量类
 *
 * @since 2023-01-02
 */
export class BasicServiceConstant {

  /**
   * 基础服务声明同意key值（preferences存储）
   */
  public static KEY_BASIC_SERVICE_AGREE_STATE: string = 'basic_service_check_state';

  /**
   * ToC默认隐私声明文件名
   */
  public static DEFAULT_PRIVACY_STATEMENT: string = 'OpenHarmony_privacy_statement';

  /**
   * ToB隐私声明文件名
   */
  public static TOB_PRIVACY_STATEMENT: string = 'OpenHarmony_privacy_statement_2b';

  /**
   * 是否ToB PC
   */
  public static LICENSE_ENABLE_CCM_CONFIG: string = 'const.pc_security.license_enable';
}