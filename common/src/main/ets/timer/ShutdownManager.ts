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
import { systemDateTime } from '@kit.BasicServicesKit';
import { GlobalContext } from '../context/GlobalContext';
import { LogUtil } from '../util/LogUtil';
import { TimeOutUtil } from '../util/TimeOutUtil';
import { ShipModeManager } from '../manager/ShipModeManager';
import { TsTimerImpl } from './TsTimerImpl';
import { IPageOrderController } from '../controller/IPageOrderController';
import { PageKey } from '../constant/PageKey';

const TAG: string = 'ShutdownManager';
const DEFAULT_TIMEID: number = 0;
const DELAY_TIMEOUT: number = 5 * 1000; // 过滤一段时间内的反复操作
const SHUTDOWN_TIMEOUT: number = 30 * 60 * 1000;

/**
 * 30分钟定时关机管理类
 */
export class ShutdownManager {
  private static instance?: ShutdownManager;
  private mTimerId: number = DEFAULT_TIMEID;
  private timeOutUtil: TimeOutUtil = new TimeOutUtil(DELAY_TIMEOUT, (): void => {
    this.handleDelay();
  }, TAG);

  private constructor() {
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  static getInstance(): ShutdownManager {
    if (!ShutdownManager.instance) {
      ShutdownManager.instance = new ShutdownManager();
    }
    return ShutdownManager.instance;
  }

  /**
   * 进入/离开指定的页面
   */
  public change(): void {
    LogUtil.info(TAG, 'enter or leave the page');
    this.timeOutUtil.setTimeout();
  }

  private async handleDelay(): Promise<void> {
    let pageOrderController = GlobalContext.getInstance().getObject('mPageOrderController') as IPageOrderController;
    let currentKey = pageOrderController?.getCurPageController()?.getKey();
    if (currentKey === PageKey.LANGUAGE_SELECT || currentKey === PageKey.WELCOME) {
      LogUtil.info(TAG, `enter the page ${currentKey}`);
      if (this.mTimerId !== DEFAULT_TIMEID) {
        LogUtil.info(TAG, 'destroy Timer for clear timerId');
        await TsTimerImpl.getInstance().stopTimer(this.mTimerId);
      }
      LogUtil.info(TAG, 'create Timer to shutdown');

      let currentRealTime: number = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
      this.mTimerId = await TsTimerImpl.getInstance().startTimer({
        endTime: currentRealTime + SHUTDOWN_TIMEOUT,
        onTimer: () => {
          this.setShutdown();
        }
      });
    } else {
      LogUtil.info(TAG, `destroy Timer for enter others page:${currentKey}`);
      TsTimerImpl.getInstance().stopTimer(this.mTimerId);
    }
  }

  private setShutdown(): void {
    if (ShipModeManager.getInstance().getChargingStatus()) {
      LogUtil.warn(TAG, 'time is up to shutdown');
      ShipModeManager.getInstance().setShipModeNoTimes();
    } else {
      LogUtil.warn(TAG, 'shut down return for charging');
    }
  }
}