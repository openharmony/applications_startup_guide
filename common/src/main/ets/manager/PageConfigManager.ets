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
import { BusinessError } from '@ohos.base';
import { PageKey } from '../constant/PageKey';
import { PageConfig } from '../model/config/PageConfig';
import { AbilityAction } from '../model/PageAction';
import { ArrayUtil } from '../util/ArrayUtil';
import { ConfigParseUtil } from '../util/ConfigParseUtil';
import { LogUtil } from '../util/LogUtil';

const TAG: string = 'PageConfigManager';

/**
 * 重试次数
 */
const RETRY_LIMIT: number = 2;

/**
 * 页面信息管理类
 */
export class PageConfigManager {
  private static instance?: PageConfigManager;
  private localPageConfigs: Map<string, PageConfig> = new Map();
  private retryTime: number = 0;

  private constructor() {
  }

  /**
   * 单例
   *
   * @returns instance
   */
  static getInstance(): PageConfigManager {
    if (!PageConfigManager.instance) {
      PageConfigManager.instance = new PageConfigManager();
    }
    return PageConfigManager.instance;
  }

  /**
   * 解析页面信息配置
   */
  public async loadPageConfigs(): Promise<void> {
    if (this.retryTime++ >= RETRY_LIMIT) {
      LogUtil.info(TAG, 'loadPageConfigs failed after retry');
      return;
    }
    LogUtil.info(TAG, `loadPageConfigs start ${this.retryTime}`);
    try {
      await ConfigParseUtil.parseLocalPageConfigs(this.localPageConfigs)
        .then(localPageConfigs => {
          LogUtil.info(TAG, `parseLocalPageConfigs: ${this.localPageConfigs?.size}`);
          return ConfigParseUtil.loadCcmConfigs();
        })
        .then(ccmPageConfigs => {
          return this.combinePageConfigs(ccmPageConfigs);
        })
        .then(localPageConfigs => {
          LogUtil.info(TAG, `loadPageConfigs finish,size:${this.localPageConfigs?.size}`);
        })
        .catch((e: BusinessError) => {
          LogUtil.error(TAG, `loadPageConfigs e:${e.code} ${e.message}`);
          this.loadPageConfigs();
        });
    } catch (err) {
      LogUtil.error(TAG, `loadPageConfigs exception: ${err?.code} ${err?.message}`);
      this.loadPageConfigs();
    }
  }

  /**
   * 获取全量页面配置key
   */
  public getPageConfigKeys(): string[] {
    if (ArrayUtil.isMapEmpty(this.localPageConfigs)) {
      LogUtil.info(TAG, 'localPageConfigs is empty,start to load pageConfigs');
    }
    return Array.from(this.localPageConfigs?.keys());
  }

  /**
   * 添加页面配置
   *
   * @param pageKey 页面key
   * @param pageConfig 页面配置信息
   */
  public addPageConfig(pageKey: string, pageConfig: PageConfig): void {
    if (!pageKey || !pageConfig) {
      LogUtil.error(TAG, 'add page config failed');
      return;
    }
    this.localPageConfigs.set(pageKey, pageConfig);
  }

  /**
   * 判断是否存在指定页面
   * @param key 页面的key
   * @returns 是否存在该页面
   */
  public hasPage(key: string): boolean {
    return this.localPageConfigs?.has(key);
  }

  /**
   * 获取单项页面配置项
   */
  public getPageConfig(key: string): PageConfig | undefined {
    return this.localPageConfigs?.get(key);
  }

  /**
   * 合并CCM&本地page配置文件
   * @param ccmPageConfigs
   */
  public combinePageConfigs(ccmPageConfigs: Map<string, PageConfig>): Promise<Map<string, PageConfig>> {
    LogUtil.info(TAG, 'combinePageConfigs start');
    return new Promise((resolve, reject) => {
      LogUtil.info(TAG, `combinePageConfigs CcmConfigs size:${ccmPageConfigs?.size},localPageConfigs size:${this.localPageConfigs?.size}`);
      if (ArrayUtil.isMapEmpty(ccmPageConfigs)) {
        LogUtil.info(TAG, `ccm ${ArrayUtil.isMapNotEmpty(ccmPageConfigs) ? 'fail' : 'is empty'}`);
        resolve(this.localPageConfigs);
        return;
      }
      if (ArrayUtil.isMapEmpty(this.localPageConfigs)) {
        this.localPageConfigs = new Map<string, PageConfig>();
      }
      ccmPageConfigs.forEach(item => {
        // 如果CCM有添加企业账号页面配置，则删除添加本地用户页面配置
        if (item.getKey() === PageKey.ENTERPRISE_ACCOUNT) {
          LogUtil.info(TAG, 'ccm has enterprise_account , localpageconfig will delete local_user');
          this.localPageConfigs.delete(PageKey.LOCAL_USER);
        }
        if (this.localPageConfigs.has(item.getKey()) && item.getAction() === AbilityAction.DELETE) {
          this.localPageConfigs.delete(item.getKey());
        } else if (item.getAction() !== AbilityAction.DELETE) {
          this.localPageConfigs.set(item.getKey(), item);
        }
      });
      ArrayUtil.sortPageConfigs(this.localPageConfigs);
      LogUtil.info(TAG, `combinePageConfigs over ,size ${this.localPageConfigs?.size}`);
      resolve(this.localPageConfigs);
    });
  }
}