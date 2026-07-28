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

import { LogUtil } from '../util/LogUtil';
import emitter from '@ohos.events.emitter';
import { Event } from '../event/Event';

const TAG: string = 'FastCloneSceneManager';

/**
 * 快速克隆场景管理类
 */
export class FastCloneSceneManager {
  private static instance?: FastCloneSceneManager;
  private fastCloneScene: boolean = false;
  private skipPageForFastClone: boolean = false;
  private cloneWlan: boolean = false;
  private waitNetConnected: boolean = false;
  private requestTypFast: boolean = false;
  private networkId: string = '';
  private authToken: Uint8Array = new Uint8Array([]);

  private constructor() {
  }

  /**
   * 单例
   *
   * @returns instance
   */
  public static getInstance(): FastCloneSceneManager {
    if (!FastCloneSceneManager.instance) {
      FastCloneSceneManager.instance = new FastCloneSceneManager();
    }
    return FastCloneSceneManager.instance;
  }

  /**
   * 设置是否快速克隆场景
   */
  public setFastCloneScene(isFastCloneScene: boolean): void {
    LogUtil.info(TAG, `set fast clone scene: ${isFastCloneScene}`);
    this.fastCloneScene = isFastCloneScene;
  }

  /**
   * 是否快速克隆（用于控制鸿蒙环到正在设置过程中界面的显示）
   */
  public isFastCloneScene(): boolean {
    return this.fastCloneScene;
  }

  /**
   * 设置快速克隆跳过此页
   */
  public setSkipPageForFastClone(isSkipPageForFastClone: boolean): void {
    LogUtil.info(TAG, `set Skip Page For Fast Clone: ${isSkipPageForFastClone}`);
    this.skipPageForFastClone = isSkipPageForFastClone;
  }

  /**
   * 是否因为快速克隆跳过此页，
   */
  public isSkipPageForFastClone(): boolean {
    return this.skipPageForFastClone;
  }

  /**
   * 设置networkId
   *
   * @param id networkId
   */
  public setNetworkId(id: string): void {
    // 隐私数据，不可打印
    LogUtil.info(TAG, 'setNetworkId');
    this.networkId = id;
  }

  /**
   * 获取networkId
   *
   * @param id networkId
   */
  public getNetworkId(): string {
    return this.networkId;
  }

  /**
   * 设置是否克隆过wlan信息
   */
  public setCloneWlan(cloneWlan: boolean): void {
    LogUtil.info(TAG, `set clone wlan: ${cloneWlan}`);
    this.cloneWlan = cloneWlan;
  }

  /**
   * 是否克隆过wlan信息
   */
  public isCloneWlan(): boolean {
    return this.cloneWlan;
  }

  /**
   * 设置是否等待连接网络
   */
  public setWaitNetConnected(waitNetConnected: boolean): void {
    LogUtil.info(TAG, `set wait net connected: ${waitNetConnected}`);
    this.waitNetConnected = waitNetConnected;
  }

  /**
   * 是否等待连接网络
   */
  public isWaitNetConnected(): boolean {
    return this.waitNetConnected;
  }

  /**
   * 设置华为账号的快速还是普通登录
   *
   * @param isFast 快速登录为true
   */
  public setRequestTypFast(isFast: boolean): void {
    LogUtil.info(TAG, `set account_login request type: ${isFast}`);
    this.requestTypFast = isFast;
  }

  /**
   * 是否华为账号的快速登录
   */
  public isRequestTypFast(): boolean {
    return this.requestTypFast;
  }

  /**
   * 设置authToken
   *
   * @param id authToken
   */
  public setAuthToken(id: Uint8Array): void {
    // 可能涉密，不要打印出来
    LogUtil.info(TAG, 'setAuthToken');
    this.authToken = id;
  }

  /**
   * 获取authToken
   *
   * @returns authToken
   */
  public getAuthToken(): Uint8Array {
    return this.authToken;
  }
}
