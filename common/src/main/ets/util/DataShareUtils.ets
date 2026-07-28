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
import dataShare from '@ohos.data.dataShare';
import settings from '@ohos.settings';
import type common from '@ohos.app.ability.common';
import { dataSharePredicates, ValuesBucket } from '@kit.ArkData';
import { LogUtil } from './LogUtil';
import { AbilityManager } from '../manager/AbilityManager';
import { AccountUtil } from './AccountUtil'

const TAG: string = 'DataShareUtil';
const SETTINGS_URI: string = 'datashare:///com.ohos.settingsdata/entry/settingsdata/';
const KEYWORD: string = 'KEYWORD';
const VALUE: string = 'VALUE';

/**
 * dataShare工具类
 *
 * @since 2024-11-01
 */
export class DataShareUtil {
  private static getUri(name: string, userId: number, tableName?: string): string {
    let uri = '';
    if (tableName === settings.domainName.USER_SECURITY) {
      uri = SETTINGS_URI + 'USER_SETTINGSDATA_SECURE_' + userId + '?Proxy=true&key=' + name;
    } else if (tableName === settings.domainName.USER_PROPERTY) {
      uri = SETTINGS_URI + 'USER_SETTINGSDATA_' + userId + '?Proxy=true&key=' + name;
    } else {
      uri = SETTINGS_URI + 'SETTINGSDATA?Proxy=true&key=' + name;
    }
    LogUtil.info(TAG, `uri is : ${uri}`);
    return uri;
  }

  private static async createDataHelper(uri: string): Promise<dataShare.DataShareHelper | null> {
    let pageContext: common.Context | null = AbilityManager.getInstance().getContext();
    if (!pageContext) {
      LogUtil.error(TAG, 'context is null');
      return null;
    }
    try {
      let dsProxyHelper = await dataShare.createDataShareHelper(pageContext, uri);
      if (dsProxyHelper === null) {
        LogUtil.error(TAG, 'dsProxyHelper: is null');
        return null;
      }
      return dsProxyHelper;
    } catch (err) {
      LogUtil.error(TAG, `createDataShareHelper err: ${err?.message}`);
      return null;
    }
  }

  /**
   * 依据tableName和userId通过dataShare查询数据
   * @param name 名称
   * @param defValue 默认值
   * @param tableName 表名
   * @return 值
   */
  public static async getValueByDataShare(name: string, defValue: string, tableName?: string): Promise<string> {
    let userId: number = await AccountUtil.getInitUserId();
    let uri: string = DataShareUtil.getUri(name, userId, tableName);
    let predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(KEYWORD, name);
    try {
      let dsProxyHelper = await DataShareUtil.createDataHelper(uri);
      if (dsProxyHelper === null) {
        LogUtil.error(TAG, 'dsProxyHelper: is null');
        return defValue;
      }
      let result = await dsProxyHelper.query(uri, predicates, [VALUE]);
      if (result) {
        if (result.goToFirstRow()) {
          let val: string = result.getString(result.getColumnIndex(VALUE));
          LogUtil.info(TAG, `result rowCount: ${result?.rowCount}, result is ${val}, name is ${name}`);
          result.close();
          return val;
        }
        result.close();
      }
    } catch (err) {
      LogUtil.error(TAG, `query data err: ${err?.message}`);
    }
    return defValue;
  }

  /**
   * 依据tableName和userId通过dataShare更新数据
   * @param name 名称
   * @param value 值
   * @param tableName 表名
   * @return 是否成功
   */
  public static async setValueByDataShare(name: string, value: string, tableName?: string): Promise<boolean> {
    let userId: number = await AccountUtil.getInitUserId();
    let uri: string = DataShareUtil.getUri(name, userId, tableName);
    let predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(KEYWORD, name);
    let va: ValuesBucket = {
      VALUE: value,
    }
    try {
      let dsProxyHelper = await DataShareUtil.createDataHelper(uri);
      if (dsProxyHelper === null) {
        LogUtil.error(TAG, 'dsProxyHelper: is null');
        return false;
      }
      let rowCount: number = await (dsProxyHelper as dataShare.DataShareHelper).update(uri, predicates, va);
      if (rowCount <= 0) {
        LogUtil.info(TAG, `update data rowCount is ${rowCount}`);
        va = {
          KEYWORD: name,
          VALUE: value,
        }
        rowCount = await (dsProxyHelper as dataShare.DataShareHelper).insert(uri, va);
        if (rowCount <= 0) {
          LogUtil.error(TAG, `insert data failed rowCount is ${rowCount}`);
          return false;
        }
      }
    } catch (err) {
      LogUtil.error(TAG, `update data err: ${err?.message}`);
      return false;
    }
    LogUtil.info(TAG, `update data success, name is ${name}, value is ${value}`);
    return true;
  }
}