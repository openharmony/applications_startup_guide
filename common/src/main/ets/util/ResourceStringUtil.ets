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
import I18n from '@ohos.i18n';
import { AbilityManager } from '../manager/AbilityManager';
import { PrivacyStatementType } from './Declaration';
import { LogUtil } from './LogUtil';

const TAG: string = 'ResourceStringUtil';

/**
 * 资源解析替换工具类
 */
export class ResourceStringUtil {
  private static numberUnitFormat: Intl.NumberFormat | null = null;

  /**
   * 同步方式任意数量string类型替换
   * @param resource Resource资源类
   * @param ...numbers 任意数量替换数字
   */
  static getAnyNumFormatStringSync(resource: Resource, ...numbers: Array<number>): string {
    let result = ResourceStringUtil.getStringSync(resource);
    if (!result) {
      LogUtil.error(TAG, 'resource is null');
      return '';
    }
    for (let i: number = 0; i < numbers.length; i++) {
      result = result.replace(new RegExp('%' + (i + 1) + '\\$d', 'gm'), String(numbers[i]));
    }
    return result;
  }

  /**
   * string类型内若干数字变量替换
   * @param str string
   * @param ...numbers 任意数量替换数字
   */
  static getStringOfNumFormat(str: string, ...numbers: Array<number>): string {
    for (let i: number = 0; i < numbers.length; i++) {
      str = str.replace(new RegExp('%' + (i + 1) + '\\$d', 'gm'), String(numbers[i]));
    }
    return str;
  }

  /**
   * 获取指定字串
   * @param name 字符串名
   * @returns 字符串内容
   */
  public static getStringByName(name: string): string {
    let context = AbilityManager.getInstance().getContext();
    try {
      if (context && context.resourceManager) {
        return context.resourceManager.getStringByNameSync(name)
      }
    } catch (error) {
      LogUtil.error(TAG, `getFoldStatus error: ${error?.code}, ${error?.message}`);
    }
    return '';
  }

  /**
   * 获取协议与声明页面待展示字符串
   * @param contents 字符串的name
   * @param statementType 字符串的statementType，是否需要拼接序号以及换行符
   * @returns 处理完成后的字串
   */
  public static getPrivacyStatementContent(contents: string[], statementType: string): string {
    let result: string = '';
    if (!contents) {
      LogUtil.error(TAG, 'strings is null');
      return result;
    }
    ResourceStringUtil.initNumberUnitFormat();
    for (let i = 0; i < contents.length; i++) {
      if (statementType === PrivacyStatementType.DEFAULT_TYPE) {
        result = ResourceStringUtil.getStringByName(contents[i]);
      } else if (statementType === PrivacyStatementType.NUMBER_AND_BREAK_LINE) {
        let indexString: string = ResourceStringUtil.getNumberFormat(i + 1);
        result = result.concat(indexString, '. ', ResourceStringUtil.getStringByName(contents[i]));
        if (i !== contents.length - 1) {
          result = result.concat('\n');
        }
      }
    }
    return result;
  }

  /**
   * 获取string资源值
   * @param resource Resource资源类
   */
  static getStringSync(resource: ResourceStr | undefined): string {
    if (!resource) {
      LogUtil.error(TAG, 'resource is null');
      return '';
    }
    if (typeof resource === 'string') {
      return resource;
    }
    let resourceManager = AbilityManager.getInstance().getContext()?.resourceManager;
    if (!resourceManager) {
      return '';
    }
    try {
      return resourceManager.getStringSync(resource.id);
    } catch (error) {
      LogUtil.error(TAG, `getStringSync failed, error code: ${error?.code}, message: ${error?.message}.`);
      return '';
    }
  }

  /**
   * 初始化NumberFormat对象
   */
  static initNumberUnitFormat() {
    let currentLanguage: string = I18n.System.getSystemLanguage();
    try {
      ResourceStringUtil.numberUnitFormat = new Intl.NumberFormat(currentLanguage);
    } catch (error) {
      LogUtil.error(TAG, `initNumberUnitFormat failed, error code: ${error.code}, message: ${error.message}.`);
    }
  }

  /**
   * 数字国际化接口NumberFormat获取数字，格式化数字
   * @param num 需要格式化的数值
   * @returns string 国际化数字
   */
  static getNumberFormat(num: number): string {
    let formatNum: string = `${num}`;
    if (ResourceStringUtil.numberUnitFormat === null) {
      return formatNum;
    }
    try {
      formatNum = ResourceStringUtil.numberUnitFormat.format(num);
    } catch (error) {
      LogUtil.error(TAG, `getNumberFormat failed, error code: ${error.code}, message: ${error.message}.`);
    }
    return formatNum;
  }
}
