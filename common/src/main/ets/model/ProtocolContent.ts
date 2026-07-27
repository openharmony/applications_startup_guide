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

import type Want from '@ohos.application.Want';

/**
 * 参数
 */
export class Param {
  name: string;
  value: string;

  constructor(name?: string, value?: string) {
    this.name = name;
    this.value = value;
  }
}

export class Value {
  bundleName: string;
  abilityName: string;

  constructor(bundleName?: string, abilityName?: string) {
    this.bundleName = bundleName;
    this.abilityName = abilityName;
  }
}

/**
 * Ability
 */
export class Ability {
  key: string;
  value: Want;

  constructor(key?: string, value?: Want) {
    this.key = key;
    this.value = value;
  }
}

/**
 * ProtocolContent
 */
export class ProtocolContent {
  serviceName?: string;
  packageName?: string;
  moduleName?: string;
  serviceType?: string;
  customizedDefaultCheckStatus?: boolean;

  version: string;
  title: string;
  content: string;
  params: Param[];
  abilities: Ability[];
  visibleRules: string[];

  /**
   * 构造函数
   * @param jsonObj json对象
   */
  constructor(jsonObj: Object) {
    Object.assign(this, jsonObj);
  }
}