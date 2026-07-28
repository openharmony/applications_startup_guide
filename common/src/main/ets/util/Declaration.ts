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

export class Declaration {
  public title: string;
  public content: string[];
  public type: string;

  constructor(obj: object) {
    Object.assign(this, obj);
  }
}

/**
 * 协议与声明页面 content文本类型
 */
export enum PrivacyStatementType {

  /**
   * 默认类型，不需要添加序号及换行，如软件许可与隐私声明
   */
  DEFAULT_TYPE = '0',

  /**
   * 需要序号及换行，如敏感行为服务声明
   */
  NUMBER_AND_BREAK_LINE = '1'
}