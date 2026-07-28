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
import type { ICopyable } from './ICopyable';
import { ArrayUtil } from '../util/ArrayUtil';
import { StringUtil } from '../util/StringUtil';
import { LogUtil } from '../util/LogUtil';
import { ObjectUtils } from './ObjectUtils';

const TAG: string = 'ServiceEntity';

/**
 * 服务申明模型
 * @since 2022-11-15
 */
@Observed
export class ServiceEntity implements ICopyable<ServiceEntity> {
  /**
   * 服务类型
   */
  private serviceType: string = '';
  /**
   * 服务申明名称
   */
  private serviceName: string = '';
  /**
   * 包名
   */
  private packageName: string = '';
  /**
   * 模块名
   */
  private moduleName: string = '';
  /**
   * 设置默认勾选状态
   */
  private defaultCheckStatus: boolean = true;
  /**
   * 显示检查规则
   */
  private validatorList: Array<string> = [];
  /**
   * 勾选状态规则
   */
  private checkboxList: Array<string> = [];
  /**
   * 数据存储规则
   */
  private saveDataList: Array<string> = [];
  /**
   * 标题
   */
  private title: string = '';
  /**
   * 内容
   */
  private content: string = '';
  /**
   * 版本
   */
  private version: number = 0.0;
  /**
   * 参数
   */
  private params: Map<string, string> = new Map<string, string>();
  /**
   * abilities
   */
  private abilities: Map<string, Want> = new Map<string, Want>();
  /**
   * 是否可见
   */
  private isVisible: boolean = true;
  /**
   * 勾选状态是否不可操作
   */
  private switchDisabled: boolean = true;
  /**
   * 是否选中
   */
  public isChecked: boolean = false;
  /**
   * 服务content是否超长展开（3行）
   */
  private isExpanded: boolean = false;

  /**
   * 保存时间
   */
  private agreeTime: string = '';

  /**
   * 保存版本
   */
  private agreeVersion: string = '';

  /**
   * 自动引导配置项
   */
  private customizedCheckStatusConfig: boolean = false;

  /**
   * (自动引导)自定义显示规则集合
   */
  private customizedVisibleCRules: Array<string> = [];

  /**
   * (自动引导)自定义开关状态
   */
  private customizedDefaultCheckStatus: boolean | undefined = undefined;

  /**
   * 构造函数
   * @param jsonObj json对象
   */
  constructor(jsonObj?: Object) {
    if (jsonObj) {
      ObjectUtils.assign(this, jsonObj);
    }
  }

  /**
   * 获取(自动引导)自定义开关状态
   *
   * @returns (自动引导)自定义开关状态
   */
  getCustomizedDefaultCheckStatus(): boolean | undefined {
    return this.customizedDefaultCheckStatus;
  }

  /**
   * 设置(自动引导)自定义开关状态
   *
   * @param status 自定义开关状态
   */
  setCustomizedDefaultCheckStatus(status: boolean): void {
    this.customizedDefaultCheckStatus = status;
  }

  /**
   * 获取名称
   */
  getServiceName(): string {
    return this.serviceName;
  }

  setServiceName(serviceName: string): void {
    this.serviceName = serviceName;
  }

  /**
   * 获取包名
   */
  getPackageName(): string {
    return this.packageName;
  }

  setPackageName(packageName: string): void {
    this.packageName = packageName;
  }

  /**
   * 获取模块名
   */
  getModuleName(): string {
    return this.moduleName;
  }

  setModuleName(moduleName: string): void {
    this.moduleName = moduleName;
  }

  /**
   * 获取设置默认勾选规则
   */
  getDefaultCheckStatus(): boolean {
    return this.defaultCheckStatus;
  }

  /**
   * 获取显示检查规则
   */
  getValidatorList(): Array<string> {
    return this.validatorList;
  }

  setValidatorList(validatorList: Array<string>): void {
    this.validatorList = validatorList;
  }

  /**
   * 获取勾选状态规则
   */
  getCheckboxList(): Array<string> {
    return this.checkboxList;
  }

  setCheckboxList(checkboxList: Array<string>): void {
    this.checkboxList = checkboxList;
  }

  /**
   * 获取存储数据规则
   */
  getSaveDataListList(): Array<string> {
    return this.saveDataList;
  }

  setSaveDataListList(saveDataList: Array<string>): void {
    this.saveDataList = saveDataList;
  }

  /**
   * 获取标题
   */
  getTitle(): string {
    return this.getShowString(this.title);
  }

  /**
   * 设置标题
   * @param title 标题
   */
  setTitle(title: string): void {
    this.title = title;
  }

  /**
   * 获取内容
   */
  getContent(): string {
    return this.getShowString(this.content);
  }

  /**
   * 设置内容
   * @param content 内容
   */
  setContent(content: string): void {
    this.content = content;
  }

  /**
   * 获取版本号
   */
  getVersion(): number {
    return this.version;
  }

  /**
   * 设置版本号
   * @param version 版本号
   */
  setVersion(version: number): void {
    this.version = version;
  }

  /**
   * 增加参数
   * @param param 参数
   */
  addParamValue(paramKey: string, paramValue: string): void {
    if (this.params === null) {
      this.params = new Map<string, string>();
    }
    this.params.set(paramKey, paramValue);
  }

  /**
   * 获取指定参数值
   * @param paramName 参数名称
   */
  getParamValue(paramKey: string | null | undefined): string | undefined {
    if (StringUtil.isEmpty(paramKey) || ArrayUtil.isMapEmpty(this.params)) {
      LogUtil.info(TAG, 'paramKey or params is empty.');
      return '';
    }
    return this.params.get(paramKey ?? '');
  }

  /**
   * 增加跳转ability
   * @param key key值
   * @param want 跳转want对象
   */
  addAbility(key: string, want: Want): void {
    if (this.abilities === null) {
      this.abilities = new Map<string, Want>();
    }
    this.abilities.set(key, want);
  }

  /**
   * 添加(自动引导)自定义显示规则集合
   *
   * @param rule 自定义显示规则
   */
  addVisibleRules(rule: string): void {
    if (this.customizedVisibleCRules === null) {
      this.customizedVisibleCRules = [];
    }
    this.customizedVisibleCRules.push(rule);
  }

  /**
   * 获取(自动引导)自定义显示规则集合
   *
   * @returns (自动引导)自定义显示规则集合
   */
  getVisibleRules(): Array<string> {
     return this.customizedVisibleCRules;
  }

  /**
   * 获取指定ability跳转信息
   * @param key 指定ability的key值
   */
  getAbility(key: string): Want | undefined {
    if (StringUtil.isEmpty(key) || ArrayUtil.isMapEmpty(this.abilities)) {
      LogUtil.info(TAG, 'Key or abilities is empty.');
      return undefined;
    }
    return this.abilities.get(key);
  }

  /**
   * 获取ability跳转信息
   */
  getAbilities(): Map<string, Want> {
    return this.abilities;
  }

  /**
   * 获取服务申明类型
   */
  getServiceType(): ServiceType {
    return this.serviceType === 'basic' ? ServiceType.BASIC : ServiceType.ENHANCE;
  }

  setServiceType(serviceType: string): void {
    this.serviceType = serviceType;
  }

  /**
   * 获取服务是否可见
   */
  isServiceVisible(): boolean {
    return this.isVisible;
  }

  /**
   * 设置服务的可见性
   * @param isVisible true：可见；false：不可见
   */
  setServiceVisible(isVisible: boolean): void {
    this.isVisible = isVisible;
  }

  /**
   * 获取服务勾选状态是否不可操作
   */
  getSwitchDisabled(): boolean {
    return this.switchDisabled;
  }

  setSwitchDisabled(switchDisabled: boolean): void {
    this.switchDisabled = switchDisabled;
  }

  /**
   * 获取服务是否勾选
   */
  isServiceChecked(): boolean {
    return this.isChecked;
  }

  /**
   * 设置服务的勾选状态
   * @param isChecked true：勾选；false：不勾选
   */
  setServiceChecked(isChecked: boolean): void {
    this.isChecked = isChecked;
  }

  /**
   * 获取服务content是否超长展开
   */
  isServiceExpanded(): boolean {
    return this.isExpanded;
  }

  /**
   * 设置服务content是否超长展开
   * @param isExpanded true：展开；false：收缩
   */
  setServiceExpanded(isExpanded: boolean): void {
    this.isExpanded = isExpanded;
  }

  /**
   * 获取保存时间
   */
  getAgreeTime(): string {
    return this.agreeTime;
  }

  /**
   * 设置保存时间
   * @param saveTime 保存时间
   */
  setAgreeTime(agreeTime: string): void {
    this.agreeTime = agreeTime;
  }

  /**
   * 获取保存版本号
   */
  getAgreeVersion(): string {
    return this.agreeVersion;
  }

  /**
   * 设置保存版本号
   * @param saveTime 保存时间
   */
  setAgreeVersion(agreeVersion: string): void {
    this.agreeVersion = agreeVersion;
  }

  /**
   * 获取自动引导配置项
   *
   * @returns true/false
   */
  getCustomizedCheckStatusConfig(): boolean {
    return this.customizedCheckStatusConfig;
  }

  /**
   * 获取浅拷贝对象
   */
  getCopyObject(): ServiceEntity {
    let serviceEntity: ServiceEntity = new ServiceEntity(new Object());
    ObjectUtils.assign(serviceEntity, this);
    return serviceEntity;
  }

  private getShowString(str: string): string {
    if (ArrayUtil.isMapEmpty(this.params)) {
      LogUtil.info(TAG, 'Params is empty.');
      return str;
    }
    this.params.forEach((paramValue, paramKey) => {
      let key = '${' + paramKey + '}';
      let index = str.indexOf(key);
      while (index >= 0) {
        str = str.replace(key, paramValue);
        index = str.indexOf(key);
      }
    });
    return str;
  }
}

/**
 * 服务申明类型
 */
export enum ServiceType {
  /**
   * 基础协议
   */
  BASIC = 1,

  /**
   * 增强协议
   */
  ENHANCE = 2,
}