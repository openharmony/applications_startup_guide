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
import connection from '@ohos.net.connection';
import { LogUtil } from '../util/LogUtil';
import { EventEmitter } from '../event/EventEmitter';
import { Event } from '../event/Event';
import { FastCloneSceneManager } from './FastCloneSceneManager';
import { TimeOutUtil } from '../util/TimeOutUtil';

const TAG: string = 'InternetManager';
const NET_CAPABILITY_VALIDATED: number = 16; // 表示该网络访问Internet的能力被网络管理成功验证
const NET_CAPABILITY_PORTAL: number = 17; // 表示系统发现该网络存在强制网络门户，需要用户登陆认证
const NET_CAPABILITY_CHECKING_CONNECTIVITY: number = 31; // 表示还在探测中
const DELAY_TIMEOUT: number = 8 * 1000; // XX秒定时器

/**
 * 网络管理类
 */
export class InternetManager {
  private static instance?: InternetManager;
  private netConnection: connection.NetConnection;
  private isRegistered: boolean = false;
  private isConnected = false;
  private isValidated: boolean = false;
  private timeOutUtil: TimeOutUtil = new TimeOutUtil(DELAY_TIMEOUT, (): void => {
    // 31表示网络正在验证中，如果定时器内，一直未收到不含31的，则认为网络不通，露出WLAN
    LogUtil.warn(TAG, 'wait net validate time out. jump to wlan page');
    this.isValidated = false;
    this.netChangeEvent();
  }, TAG);

  private constructor() {
  }

  /**
   * 单例
   *
   * @returns instance
   */
  public static getInstance(): InternetManager {
    if (!InternetManager.instance) {
      InternetManager.instance = new InternetManager();
    }
    return InternetManager.instance;
  }

  /**
   * 是否可访问Internet
   */
  public isNetConnected(): boolean {
    LogUtil.info(TAG, `isConnected: ${this.isConnected}, isValidated: ${this.isValidated}`);
    return this.isConnected && this.isValidated;
  }

  /**
   * 初始化
   */
  public init(): void {
    this.hasDefaultNet();
    this.register();
  }

  /**
   * 注销监听
   */
  public unRegister(): void {
    if (!this.isRegistered) {
      LogUtil.error(TAG, 'unRegister not');
      return;
    }
    try {
      // 使用unregister接口取消订阅
      this.netConnection.unregister(function (error) {
        LogUtil.info(TAG, 'unRegister');
      });
    } catch (error) {
      LogUtil.error(TAG, `unsubscribe error, code is ${error.code}, message is ${error.message}.`);
    }
  }

  private hasDefaultNet(): void {
    try {
      connection.hasDefaultNet((error, has) => {
        LogUtil.info(TAG, `hasDefaultNet: ${has}`);
        this.setConnectedChange(has);
      });
    } catch (err) {
      LogUtil.error(TAG, `hasDefaultNet error:${err?.message} }`);
    }
  }

  private register(): void {
    LogUtil.info(TAG, 'register');
    if (this.isRegistered) {
      LogUtil.info(TAG, 'already register listener');
      return;
    }
    this.netConnection = connection.createNetConnection();

    const netCon = this.netConnection;
    netCon.register(function (error?) {
      LogUtil.info(TAG, 'register network notify result: ' + (error ? error?.message : 'success'));
    });

    netCon.on('netAvailable', () => {
      LogUtil.info(TAG, 'net available');
      this.setConnectedChange(true);
    });

    netCon.on('netUnavailable', () => {
      LogUtil.info(TAG, 'net not available');
      this.setConnectedChange(false);
    });

    netCon.on('netLost', () => {
      LogUtil.info(TAG, 'net lost');
      this.setConnectedChange(false);
    });

    // 订阅网络能力变化事件
    netCon.on('netCapabilitiesChange', (data) => {
      this.handleNetCapabilitiesChange(data);
    });

    LogUtil.info(TAG, 'register end');
  }

  private handleNetCapabilitiesChange(data): void {
    let caps = data?.netCap?.networkCap;
    LogUtil.info(TAG, `net capabilities change: ${caps?.join(',')}`);
    if (caps?.includes(NET_CAPABILITY_CHECKING_CONNECTIVITY) as boolean === true) {
      // 忽略正在探测中的结果
      return;
    }
    this.timeOutUtil.clearTimeout();
    this.isValidated = caps?.includes(NET_CAPABILITY_VALIDATED) as boolean;
    this.netChangeEvent();
  }

  private setConnectedChange(isInternetConnected: boolean): void {
    if (this.isConnected !== isInternetConnected) {
      // 切换了网络，要重新验证访问Internet能力
      this.isValidated = false;
      if (isInternetConnected === true) {
        // 等待网络验证，取消上一个定时器（等待网络连接）
        EventEmitter.getInstance().emit(Event.WAIT_NET_VALIDATED);
        this.timeOutUtil.setTimeout();
      }
    }
    this.isConnected = isInternetConnected;
  }

  private netChangeEvent(): void {
    if (FastCloneSceneManager.getInstance().isWaitNetConnected()) {
      EventEmitter.getInstance().emit(Event.SETTING_UP_WAIT_NET_END);
    }
  }
}
