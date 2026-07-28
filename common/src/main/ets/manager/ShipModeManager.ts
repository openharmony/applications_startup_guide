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

import commonEventManager from '@ohos.commonEventManager';
import BatteryInfo from '@ohos.batteryInfo';
import power from '@ohos.power';
import type { BusinessError } from '@ohos.base';
import { SystemParameterUtil } from '../util/SystemParameterUtil';
import { TimeOutUtil } from '../util/TimeOutUtil';
import { ShutdownManager } from '../timer/ShutdownManager';
import { PageKey } from '../constant/PageKey';
import { IPageOrderController } from '../controller/IPageOrderController';
import { GlobalContext } from '../context/GlobalContext';
import { LogUtil } from '../util/LogUtil';
import { SharePreferences } from '../preferences/SharePreferences';

const TAG: string = 'ShipModeManager';
const DELAY_TIMEOUT: number = 30 * 1000;
const CHARGING_INFO_ACCURACY: string = 'ship_mode';
const COMMAND_OPEN_CHARGING_INFO_ACCURACY: string = 'hi' + 'dl 2';
const DEFAULT_SOFT_SHIP_MODE_TIMES: number = 1;
const MAX_SOFT_SHIP_MODE_TIMES: number = 3;
const OOBE_SHIP_MODE_TIMES_KEY: string = 'oobe_ship_mode_times_key';
const OHOS_BOOT_SHIPMODE: string = 'ohos.boot.shipmode';
const IS_FIRST_BOOT: string = '1';
const DEFAULT_CHARGING: boolean = true;

/**
 * ShipMode管理类
 */
export class ShipModeManager {
  private static instance?: ShipModeManager;
  private times: number = 0;
  private isPage: boolean = false;
  private isCharging: boolean = DEFAULT_CHARGING;
  private isRegistered: boolean = false;
  private subscriber?: commonEventManager.CommonEventSubscriber;
  // OOBE是否在前台
  private isOobeForeground: boolean = false;
  private timeOutUtil: TimeOutUtil = new TimeOutUtil(DELAY_TIMEOUT, (): void => {
    this.setShipMode();
  }, TAG);
  private exitShipMode: boolean = false;

  private constructor() {
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  static getInstance(): ShipModeManager {
    if (!ShipModeManager.instance) {
      ShipModeManager.instance = new ShipModeManager();
    }
    return ShipModeManager.instance;
  }

  public setExitShipMode(exitShipMode: boolean): void {
    this.exitShipMode = exitShipMode;
  }

  /**
   * 进入指定的页面
   */
  public enter(): boolean {
    if (this.exitShipMode) {
      return false;
    }
    LogUtil.info(TAG, 'enter the page');
    this.isPage = true;
    this.initCharging();
    this.mayShipMode();
    return true;
  }

  /**
   * 离开指定的页面
   */
  public leave(): boolean {
    LogUtil.info(TAG, 'leave the page');
    this.isPage = false;
    this.timeOutUtil.clearTimeout();
    this.unregisterListener();
    return true;
  }

  /**
   * 设置充电状态  for DT
   * @param isCharging 充电状态
   */
  public setChargingForDT(isCharging: boolean): void {
    this.isCharging = isCharging;
  }

  private initCharging(): void {
    this.registerListener();
    this.isCharging = !this.getChargingStatus();
    LogUtil.info(TAG, `initCharging isCharging: ${this.isCharging}`);
  }

  /**
   * 获取充电状态
   * @returns 是否充电
   */
  public getChargingStatus(): boolean {
    let status = BatteryInfo.chargingStatus;
    LogUtil.info(TAG, `getChargingStatus chargingStatus: ${status}`);
    return status === BatteryInfo.BatteryChargeState.DISABLE || status === BatteryInfo.BatteryChargeState.NONE;
  }

  /**
   * 注销电池充电监听
   */
  private unregisterListener(): void {
    if (!this.isRegistered && !this.subscriber) {
      LogUtil.error(TAG, 'subscribe is null or undefined.');
      return;
    }
    try {
      commonEventManager.unsubscribe(this.subscriber, (error) => {
        if (error) {
          LogUtil.error(TAG, `unsubscribe callback error, code is ${error.code}, message is ${error.message}.`);
          return;
        }
        this.isRegistered = false;
        LogUtil.info(TAG, 'unsubscribe to screen turn-on and turn-off events end.');
      });
    } catch (error) {
      LogUtil.error(TAG, `unsubscribe error, code is ${error.code}, message is ${error.message}.`);
    }
  }

  /**
   * 注册电池充电监听
   */
  private registerListener(): void {
    if (this.isRegistered) {
      LogUtil.info(TAG, 'already register listener');
      return;
    }
    try {
      commonEventManager.createSubscriber({
        events: [
          commonEventManager.Support.COMMON_EVENT_CHARGING,
          commonEventManager.Support.COMMON_EVENT_DISCHARGING,
        ],
        publisherPermission: 'ohos.permission.PUBLISH_SYSTEM_COMMON_EVENT',
      }, (error, commonEventSubscriber): void => {
        if (error) {
          LogUtil.error(TAG, `create subscriber callback error, code is ${error.code}, message is ${error.message}.`);
          return;
        }
        this.isRegistered = true;
        this.subscriber = commonEventSubscriber;
        this.subscribeEvent();
      });
    } catch (error) {
      LogUtil.error(TAG, `create subscriber error, code is ${error.code}, message is ${error.message}.`);
    }
    LogUtil.info(TAG, 'registerListener end');
  }


  /**
   * 订阅电池充电监听
   */
  private subscribeEvent(): void {
    if (!this.subscriber) {
      LogUtil.error(TAG, 'subscribe is null or undefined.');
      return;
    }
    commonEventManager.subscribe(this.subscriber, (error, data): void => {
      if (error) {
        LogUtil.error(TAG, `subscribe callback error, error = ${error?.message}.`);
        return;
      }
      switch (data.event) {
        case commonEventManager.Support.COMMON_EVENT_DISCHARGING:
          LogUtil.info(TAG, 'discharging!');
          this.isCharging = false;
          break;
        case commonEventManager.Support.COMMON_EVENT_CHARGING:
          LogUtil.info(TAG, 'charging!');
          this.isCharging = true;
          break;
        default:
          LogUtil.error(TAG, `unknown event: ${data.event}`);
          this.isCharging = DEFAULT_CHARGING;
          break;
      }
      let pageOrderController = GlobalContext.getInstance().getObject('mPageOrderController') as IPageOrderController;
      let currentKey = pageOrderController?.getCurPageController()?.getKey();
      if (currentKey === PageKey.LANGUAGE_SELECT || currentKey === PageKey.WELCOME) {
        this.mayShipMode();
        ShutdownManager.getInstance().change();
      }
    });
  }

  private isFirstBoot(): boolean {
    let isFirstBoot: string = SystemParameterUtil.getSync(OHOS_BOOT_SHIPMODE, '');
    LogUtil.warn(TAG, `is first boot: ${isFirstBoot}`);
    return isFirstBoot === IS_FIRST_BOOT;
  }

  private async isLessTimes(): Promise<boolean> {
    LogUtil.info(TAG, 'isLessTimes');
    let times = await SharePreferences.getInstance()
      .getValue(OOBE_SHIP_MODE_TIMES_KEY, DEFAULT_SOFT_SHIP_MODE_TIMES);
    this.times = times as number;
    LogUtil.info(TAG, `isLessTimes times: ${times}, thistimes: ${this.times}`);
    return times > MAX_SOFT_SHIP_MODE_TIMES;
  }

  public async mayShipMode(): Promise<void> {
    LogUtil.info(TAG, 'mayShipMode start');
    if (!this.isPage) {
      LogUtil.info(TAG, 'mayShipMode return: not specified page');
      this.timeOutUtil.clearTimeout();
      return;
    }
    if (this.isCharging) {
      LogUtil.info(TAG, 'mayShipMode return: is charging');
      this.timeOutUtil.clearTimeout();
      return;
    }
    if (!this.isFirstBoot()) {
      LogUtil.info(TAG, 'mayShipMode return: not first factory reset');
      this.timeOutUtil.clearTimeout();
      return;
    }
    if (await this.isLessTimes()) {
      LogUtil.info(TAG, 'mayShipMode return: exceeded times');
      this.timeOutUtil.clearTimeout();
      return;
    }
    this.timeOutUtil.setTimeout();
  }

  public async setShipModeNoTimes(): Promise<void> {
    try {
      if (!this.isOobeForeground) {
        LogUtil.info(TAG, 'shutdown return for oobe background');
        return;
      }
      let res: number = BatteryInfo.setBatteryConfig(CHARGING_INFO_ACCURACY, COMMAND_OPEN_CHARGING_INFO_ACCURACY);
      LogUtil.info(TAG, `set battery config res: ${res}`);
    } catch (err) {
      LogUtil.error(TAG, `set battery config error: ${err?.message}.`);
    }
    try {
      LogUtil.warn(TAG, `shutdown by oobe shipmode`);
      power.shutdown('shutdown_by_oobe');
    } catch (err) {
      LogUtil.error(TAG, `shutdown error: ${err?.message}.`);
    }
  }

  private async setShipMode(): Promise<void> {
    try {
      if (!this.isOobeForeground) {
        LogUtil.info(TAG, 'shutdown return for oobe background');
        return;
      }
      let res: number = BatteryInfo.setBatteryConfig(CHARGING_INFO_ACCURACY, COMMAND_OPEN_CHARGING_INFO_ACCURACY);
      LogUtil.info(TAG, `set battery config res: ${res}`);
    } catch (err) {
      LogUtil.error(TAG, `set battery config error: ${err?.message}.`);
    }
    await this.recordTimes(this.times + 1);
    try {
      LogUtil.warn(TAG, `shutdown by factoryoobe shipmode`);
      power.shutdown('shutdown_by_factoryoobe');
    } catch (err) {
      this.recordTimes(this.times - 1);
      LogUtil.error(TAG, `shutdown error: ${err?.message}.`);
    }
  }

  private async recordTimes(times: number): Promise<void> {
    await SharePreferences.getInstance()
      .setValue(OOBE_SHIP_MODE_TIMES_KEY, times)
      .catch((err: BusinessError) => {
        LogUtil.error(TAG, `record times error:  ${err?.message}.`);
      });
    LogUtil.info(TAG, `record times: ${times}`);
  }

  /**
   * 设置OOBE是否在前台
   * @param isOobeForeground OOBE是否在前台
   */
  public setOobeForeground(isOobeForeground: boolean): void {
    this.isOobeForeground = isOobeForeground;
  }
}