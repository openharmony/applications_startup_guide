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

import { ArrayUtil } from '../../util/ArrayUtil';
import { LogUtil } from '../../util/LogUtil';

const TAG: string = 'PageConfig';
/**
 * 页面配置类
 */
export class PageConfig {
  /**
   * 页面唯一标识,与controller对应
   */
  private key: string = '';

  /**
   * 差异页面action，'add','delete','alter'
   */
  private action: string = '';

  /**
   * 页面类型，0：内部页面，1：外部页面
   */
  private type: number = 0;

  /**
   * 页面顺序
   */
  private index: number = 0.0;

  /**
   * 待拉起外部页面的bundleName
   */
  private bundleName: string = '';

  /**
   * 待拉起外部页面的abilityName
   */
  private abilityName: string = '';

  /**
   * 跳转外部页面的参数
   */
  private params: { [key: string]: Object };

  constructor(jsonObj?: Object) {
    Object.assign(this, jsonObj);
  }

  public getKey(): string {
    return this.key;
  }

  public getType(): number {
    return this.type;
  }

  public getIndex(): number {
    return this.index;
  }

  public getAction(): string {
    return this.action;
  }

  public getBundleName(): string {
    return this.bundleName;
  }

  public getAbilityName(): string {
    return this.abilityName;
  }

  public getParams(): { [key: string]: Object } {
    return this.params;
  }

  public setKey(key: string): void {
    this.key = key;
  }

  public setType(type: number): void {
    this.type = type;
  }

  public setIndex(index: number): void {
    this.index = index;
  }

  public setAction(action: string): void {
    this.action = action;
  }

  public setBundleName(bundleName: string): void {
    this.bundleName = bundleName;
  }

  public setAbilityName(abilityName: string): void {
    this.abilityName = abilityName;
  }

  public setParams(params: { [key: string]: Object }): void {
    this.params = params;
  }

  /**
   * 获取拷贝对象数组
   */
  public static refreshPageConfigsArr(pageConfigsList: Array<PageConfig | null | undefined>): void {
    if (ArrayUtil.isEmpty(pageConfigsList)) {
      LogUtil.info(TAG, 'PageConfigsList is empty.');
      return;
    }
    for (let index = 0; index < pageConfigsList.length; index++) {
      if (pageConfigsList[index] === null) {
        continue;
      }
      pageConfigsList[index] = pageConfigsList[index].getCopyObject();
    }
  }

  /**
   * 获取拷贝对象
   */
  private getCopyObject(): PageConfig | null | undefined {
    let pageConfig: PageConfig = new PageConfig({});
    Object.assign(pageConfig, this);
    return pageConfig;
  }
}

/**
 * 页面类型
 */
export enum AbilityType {
  /**
   * OOBE内部页面
   */
  OOBE_PAGE = 0,

  /**
   * 外部应用接入OOBE页面
   */
  EXTERNAL_ABILITY = 1,
}
