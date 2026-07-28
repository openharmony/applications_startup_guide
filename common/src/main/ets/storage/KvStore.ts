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

import distributedKVStore from '@ohos.data.distributedKVStore';
import type common from '@ohos.app.ability.common';
import bundleManager from '@ohos.bundle.bundleManager';
import { AbilityManager } from '../manager/AbilityManager';
import { LogUtil } from '../util/LogUtil';

const TAG: string = 'KvStore';
const STORE_NAME: string = 'startupGuideKvStore';

/**
 * KvStore manager class
 *
 * @since 2023-09-27
 */
export class KvStore {
  private static instance?: KvStore;
  private store: distributedKVStore.SingleKVStore | null = null;

  private constructor() {
  }

  /**
   * 单例
   *
   * @returns instance
   */
  static getInstance(): KvStore {
    if (!KvStore.instance) {
      KvStore.instance = new KvStore();
    }
    return KvStore.instance;
  }

  private async getStoreInner(): Promise<distributedKVStore.SingleKVStore | null> {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager
      .getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
    if (this.store === null) {
      let kvManager = distributedKVStore.createKVManager({
        bundleName: bundleInfo.name,
        context: AbilityManager.getInstance().getContext() as common.BaseContext
      });
      let options: distributedKVStore.Options = {
        createIfMissing: true,
        encrypt: true, // 敏感数据加密存储，密钥由系统 KV 加密模块托管
        backup: false,
        autoSync: false,
        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
        securityLevel: distributedKVStore.SecurityLevel.S2, // 用户偏好/协议状态等个人信息
      };
      this.store = await kvManager.getKVStore<distributedKVStore.SingleKVStore>(STORE_NAME, options)
        .catch((err) => {
          LogUtil.error(TAG, `kvManager.getKvStore`, err);
          return null;
        });
    }
    return this.store;
  }

  async getEntries(keyPrefix: string): Promise<distributedKVStore.Entry[]> {
    let store: distributedKVStore.SingleKVStore | null = await this.getStoreInner();
    return store?.getEntries(keyPrefix)
      .catch((err) => {
        LogUtil.error(TAG, `store.getEntries`, err);
        return [];
      });
  }


  async put(key: string, value: Uint8Array | string | number | boolean): Promise<void> {
    let store: distributedKVStore.SingleKVStore | null = await this.getStoreInner();
    return store?.put(key, value)
      .catch((err) => {
        LogUtil.error(TAG, `store.put`, err);
      });
  }

  async get(key: string): Promise<Uint8Array | string | number | boolean | undefined> {
    let store: distributedKVStore.SingleKVStore | null = await this.getStoreInner();
    return store?.get(key)
      .catch((err) => {
        LogUtil.error(TAG, `store.get`, err);
        return undefined;
      });
  }

  async delete(key: string): Promise<void> {
    let store: distributedKVStore.SingleKVStore | null = await this.getStoreInner();
    return store?.delete(key)
      .catch((err) => {
        LogUtil.error(TAG, `store.delete`, err);
      });
  }
}