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
import { BusinessError, systemTimer } from '@kit.BasicServicesKit';
import { LogUtil } from '../util/LogUtil';
import { TimerParam, TsTimer } from './TsTimer';


const TAG: string = 'TsTimerImpl';

/**
 * Ts内部定时器管理类具体实现，单例对象试用
 */
export class TsTimerImpl implements TsTimer {
  private static instance?: TsTimerImpl;
  /**
   * 内部维护的已经启动的定时器Id数据集，用于取消全部定时器
   */
  private timerIds: Set<number> = new Set();

  private constructor() {
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  static getInstance(): TsTimerImpl {
    if (!TsTimerImpl.instance) {
      TsTimerImpl.instance = new TsTimerImpl();
    }
    return TsTimerImpl.instance;
  }

  async startTimer(timerParam: TimerParam): Promise<number> {
    let options: systemTimer.TimerOptions = {
      // 精确定时唤醒，采用开机时长
      type: systemTimer.TIMER_TYPE_WAKEUP | systemTimer.TIMER_TYPE_EXACT | systemTimer.TIMER_TYPE_REALTIME,
      // 一次性不重复
      repeat: false,
      // 定时回调
      callback: timerParam.onTimer
    };
    try {
      // 创建定时器
      let timerId: number = await systemTimer.createTimer(options);
      // 启动定时器（Id，定时器到期时间）
      await systemTimer.startTimer(timerId, timerParam.endTime);
      // 添加到id数据集中
      this.timerIds.add(timerId);
      // 返回定时器Id
      LogUtil.info(TAG, `Start timer success`);
      return timerId;
    } catch (e) {
      // 创建或者启动定时器失败
      let error: BusinessError = e as BusinessError;
      LogUtil.warn(TAG, `Start timer failed , message: ${error.message}, code: ${error.code}`);
      return undefined;
    }
  }

  async stopTimer(timerId: number): Promise<boolean> {
    try {
      // 停止定时器
      await systemTimer.stopTimer(timerId);
      // 销毁定时器
      await systemTimer.destroyTimer(timerId);
      // 添加到Id数据集中
      this.timerIds.delete(timerId);
      // 返回定时器Id
      LogUtil.info(TAG, `Stop timer success`);
      return true;
    } catch (e) {
      // 创建或者启动定时器失败
      let error: BusinessError = e as BusinessError;
      LogUtil.warn(TAG, `Stop timer failed , message: ${error.message}, code: ${error.code}`);
      return false;
    }
  }

  cleanTimer(): void {
    // 遍历清除
    this.timerIds.forEach((item) => {
      this.stopTimer(item).then(result => LogUtil.info(TAG, `Clean timer , ${item} = ${result}`));
    });
  }
}
