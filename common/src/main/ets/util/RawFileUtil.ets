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

import { BusinessError } from '@ohos.base';
import util from '@ohos.util';
import resmgr from '@ohos.resourceManager';
import { LogUtil } from './LogUtil';
import { StringUtil } from './StringUtil';
import { AbilityManager } from '../manager/AbilityManager';

const TAG: string = 'RawFileUtil';
const UNICODE: string = 'utf-8';

/**
 * rawFile工具类
 */
export class RawFileUtil {
  /**
   * 获取指定JSON文件的对象
   * @param context 上下文
   */
  public static getStringByFile(fileName: string, rmg?: resmgr.ResourceManager | null): Promise<string> {
    LogUtil.info(TAG, 'getStringByFile start');
    return new Promise((resolve, reject) => {
      LogUtil.info(TAG, `getStringByFile. fileName：${fileName}`);
      if (fileName === null) {
        LogUtil.error(TAG, `getStringByFile failed. resourceManager or fileName is null. fileName:${fileName}`);
        reject();
        return;
      }
      try {
        if (rmg === undefined || rmg === null) {
          rmg = AbilityManager.getInstance().getContext()?.resourceManager;
          LogUtil.info(TAG, `getStringByFile. get resourceManager from ability：${rmg}`);
        }
        if (rmg === undefined || rmg === null) {
          rmg = getContext()?.resourceManager;
          LogUtil.info(TAG, `getStringByFile. get resourceManager from component：${rmg}`);
        }
        rmg.getRawFile(fileName).then((value) => {
          let content = new util.TextDecoder(UNICODE).decode(value);
          resolve(content);
        }).catch((err: BusinessError) => {
          LogUtil.error(TAG, `getStringByFile of ${fileName} failed. ${err?.code} ${err?.message}`);
          reject(err);
        });
      } catch (jsonError) {
        LogUtil.error(TAG, `getStringByFile error:${jsonError?.code} ${jsonError?.message}`);
        reject();
      }
    });
  }

  /**
   * 获取lottie资源
   * @param lottieName lottie的资源名称
   * @param context 上下文
   * @returns lottie资源
   */
  public static getLottieData(lottieName: string): Promise<object> {
    LogUtil.info(TAG, 'getLottieData start');
    return new Promise((resolve, reject) => {
      LogUtil.info(TAG, `getLottieData. lottieName：${lottieName}`);
      if (StringUtil.isEmpty(lottieName)) {
        LogUtil.error(TAG, `getLottieData return. lottieName is null. lottieName:${lottieName}`);
        reject();
        return;
      }
      try {
        let rmg: resmgr.ResourceManager | undefined = AbilityManager.getInstance().getContext()?.resourceManager;
        if (rmg === undefined || rmg === null) {
          rmg = getContext()?.resourceManager;
          LogUtil.info(TAG, `getLottieData. get resourceManager from component：${rmg}`);
        }
        rmg.getRawFile(lottieName).then((value) => {
          let lottieStr = new util.TextDecoder(UNICODE).decode(value);
          let lottieData: object = JSON.parse(lottieStr);
          LogUtil.info(TAG, `getLottieData success. lottieData：${typeof lottieData}`);
          resolve(lottieData);
        }).catch((err: BusinessError) => {
          LogUtil.error(TAG, `getLottieData of ${lottieName} failed. ${err?.code} ${err?.message}`);
          reject(err);
        });
      } catch (err) {
        LogUtil.error(TAG, `getLottieData error:${err?.code} ${err?.message}`);
        reject();
      }
    });
  }
}
