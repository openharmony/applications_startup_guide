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

import preferences from '@ohos.data.preferences';
import type { BusinessError } from '@ohos.base';
import { contextConstant } from '@kit.AbilityKit';
import { LogUtil } from '../util/LogUtil';
import { StringUtil } from '../util/StringUtil';
import { AbilityManager } from '../manager/AbilityManager';

/**
 * 基础Preferences类
 */
export abstract class BasePreferences {
  private mPreferences: preferences.Preferences | null = null;
  private mFileName: string;

  /**
   * 构造函数
   * @param fileName 文件名称
   */
  protected constructor(fileName: string) {
    this.mFileName = fileName;
  }

  /**
   * 获取TAG名称
   */
  abstract getTag(): string;

  /**
   * 批量删除键为key的首选项值
   * @param keyList 待删除的首选项值的key列表
   * @returns 返回值为void的Promise对象
   */
  public async deleteValueAsync(keyList: string[]): Promise<void> {
    try {
      let prefObj: preferences.Preferences = await this.getPreferences();
      keyList.forEach((value) => {
        prefObj.deleteSync(value);
      });
      await prefObj.flush();
      LogUtil.info(this.getTag(), `deleteSync success. key:${JSON.stringify(keyList)}`);
    } catch (e) {
      LogUtil.error(this.getTag(), `deleteSync failed. key:${JSON.stringify(keyList)}`, e);
    }
  }

  /**
   * 判断preferences中是否存在指定key的值
   * @param context context
   * @param key key
   */
  public async hasValue(key: string): Promise<boolean> {
    if (StringUtil.isEmpty(key)) {
      LogUtil.error(this.getTag(), 'getValue error. key is empty.');
      return false;
    }
    let prefObj: preferences.Preferences = await this.getPreferences();
    const value = await prefObj.has(key);
    return value;
  }

  /**
   *获取preferences中指定key值
   * @param context context
   * @param key key
   * @param defValue 默认值
   */
  public async getValue(key: string, defValue: preferences.ValueType): Promise<preferences.ValueType> {
    if (StringUtil.isEmpty(key)) {
      LogUtil.error(this.getTag(), 'getValue error. key is empty.');
      return defValue;
    }
    let prefObj: preferences.Preferences = await this.getPreferences();
    const value = await prefObj.get(key, defValue);
    return value;
  }

  /**
   * 设置preferences中指定key值
   * @param context context
   * @param key key
   * @param value 值
   */
  public async setValue(key: string, value: preferences.ValueType, context?: Context): Promise<void> {
    LogUtil.info(this.getTag(), 'setValue start');
    if (StringUtil.isEmpty(key)) {
      LogUtil.error(this.getTag(), 'setValue failed. key is empty.');
      return Promise.reject();
    }
    LogUtil.info(this.getTag(), `setValue key:${key}`);
    try {
      const prefObj = await this.getPreferences(context);
      await prefObj.put(key, value);
      await prefObj.flush();
      LogUtil.info(this.getTag(), `setValue success. key:${key}`);
    } catch (err) {
      LogUtil.error(this.getTag(), `setValue failed. key:${key}`, err);
      throw err;
    }
  }

  /**
   * 获取Preferences对象
   * @param context context
   */
  public async getPreferences(context?: Context): Promise<preferences.Preferences> {
    LogUtil.info(this.getTag(), 'getPreferences start');
    return new Promise((resolve, reject) => {
      if (this.mPreferences) {
        resolve(this.mPreferences);
        return;
      }
      if (!context) {
        context = AbilityManager.getInstance().getContext();
      }
      if (context === null) {
        LogUtil.error(this.getTag(), 'Context is null.');
        reject();
      } else {
        // 存储在EL1,开机才能访问
        context.area = contextConstant.AreaMode.EL1;
      }
      try {
        preferences.getPreferences(context, this.mFileName).then((result) => {
          this.mPreferences = result;
          resolve(this.mPreferences);
        }).catch((err: BusinessError) => {
          LogUtil.error(this.getTag(), `getPreferences error.err${err?.code} ${err.message}`);
          reject();
        });
      } catch (error) {
        LogUtil.error(this.getTag(), `getPreferences error: ${error?.code} ${error.message}`);
        reject();
      }
    });
  }
}
