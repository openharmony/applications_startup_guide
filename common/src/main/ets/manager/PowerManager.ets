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
import { LogUtil } from '../util/LogUtil';
import { CommonConstant } from '../constant/CommonConstant';
import { Event } from '../event/Event';
import { EventEmitter } from '../event/EventEmitter';
import { PasswordUtil } from '../util/PasswordUtil';
import { WindowManager } from '../manager/WindowManager';

const TAG: string = 'PowerManager';

/**
 * 电源管理类
 */
export class PowerManager {
  private static instance?: PowerManager;
  private prevState: Event = Event.DEFAULT;
  private curState: Event = Event.DEFAULT;
  private subscriber?: commonEventManager.CommonEventSubscriber;
  private isRegistered: boolean = false;
  private isNeedFocus: boolean = false;

  private constructor() {
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  static getInstance(): PowerManager {
    if (!PowerManager.instance) {
      PowerManager.instance = new PowerManager();
    }
    return PowerManager.instance;
  }

  /**
   * 注册亮灭屏状态监听
   */
  registerListener(isNeedFocus?: boolean): void {
    if (this.isRegistered) {
      return;
    }
    if(isNeedFocus){
      this.isNeedFocus = isNeedFocus;
    }
    try {
      commonEventManager.createSubscriber({
        events: [
          commonEventManager.Support.COMMON_EVENT_SCREEN_ON,
          commonEventManager.Support.COMMON_EVENT_SCREEN_OFF,
          commonEventManager.Support.COMMON_EVENT_SCREEN_LOCKED,
          commonEventManager.Support.COMMON_EVENT_SCREEN_UNLOCKED,
        ],
        publisherPermission: CommonConstant.PUBLISH_SYSTEM_COMMON_EVENT_PERMISSION,
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
    LogUtil.info(TAG, 'register to screen turn-on and turn-off events end.');
  }

  /**
   * 注销亮灭屏状态监听
   */
  unregisterListener(): void {
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
      })
    } catch (error) {
      LogUtil.error(TAG, `unsubscribe error, code is ${error.code}, message is ${error.message}.`);
    }
  }

  /**
   * 订阅亮灭屏事件监听
   */
  subscribeEvent(): void {
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
        case commonEventManager.Support.COMMON_EVENT_SCREEN_ON:
          if (PasswordUtil.isPinAvailable()) {
            LogUtil.info(TAG, `ignore COMMON_EVENT_SCREEN_ON when user set lock screen`);
            return;
          }
        case commonEventManager.Support.COMMON_EVENT_SCREEN_UNLOCKED:
          LogUtil.info(TAG, `screen turn on!`);
          this.updatePowerState(Event.SCREEN_ON);
          if(this.isNeedFocus) {
            WindowManager.getInstance().requestWindowFocus(true);
          }
          break;
        case commonEventManager.Support.COMMON_EVENT_SCREEN_OFF:
          if (PasswordUtil.isPinAvailable()) {
            LogUtil.info(TAG, `ignore COMMON_EVENT_SCREEN_OFF when user set lock screen`);
            return;
          }
        case commonEventManager.Support.COMMON_EVENT_SCREEN_LOCKED:
          LogUtil.info(TAG, `screen turn off!`);
          this.updatePowerState(Event.SCREEN_OFF);
          break;
        default:
          LogUtil.error(TAG, `unKnow event: ${data.event}`);
          this.updatePowerState(Event.SCREEN_UNKNOWN_EVENT);
          break;
      }
      this.checkPowerStateChange();
    });
  }

  /**
   * 获取当前亮灭屏状态
   */
  getState(): Event {
    return this.curState;
  }

  /**
   * 通知状态机处理亮灭屏事件
   */
  private checkPowerStateChange(): void {
    if (this.curState !== this.prevState) {
      AppStorage.setOrCreate('isScreenOn', this.curState === Event.SCREEN_ON);
      EventEmitter.getInstance().emit(this.curState); // 发射电源状态事件
      this.prevState = this.curState;
      LogUtil.info(TAG, `state changes to ${this.curState}`);
    } else {
      LogUtil.info(TAG, 'ignore as state not changed');
    }
  }

  /**
   * 更新亮灭屏状态
   */
  updatePowerState(event: Event): void {
    this.curState = event;
  }
}