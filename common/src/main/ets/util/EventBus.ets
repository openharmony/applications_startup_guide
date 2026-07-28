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
import HashMap from '@ohos.util.HashMap';
import { LogUtil } from './LogUtil';

type SafeType =
  | string
  | number
  | boolean
  | object
  | null
  | undefined
  | void;

export type EventCallback<T extends SafeType[] = []> = (...args: T) => void;

const TAG: string = 'EventBus';

export class EventBus {
  private static instance: EventBus;
  private listenerMap: HashMap<string, Set<EventCallback<SafeType[]>>> = new HashMap();

  private constructor() {
  }

  /**
   * 单例获取事件总线
   *
   * @returns EventBus
   */
  public static getInstance(): EventBus {
    if (!EventBus.instance) {
      EventBus.instance = new EventBus();
    }
    return EventBus.instance;
  }

  /**
   * 注册事件
   *
   * @param eventName 事件名称
   * @param callback 回调函数
   */
  public on<T extends SafeType[]>(eventName: string, callback: EventCallback<T>): void {
    this.registerListener(eventName, callback);
  }

  /**
   * 注销事件
   *
   * @param eventName 事件名称
   */
  public off(eventName: string): void {
    this.die(eventName);
  }

  /**
   * 注销eventName事件中callback回调
   *
   * @param eventName 事件名称
   * @param callback 回调函数
   */
  public detach<T extends SafeType[]>(eventName: string, callback: EventCallback<T>): void {
    this.unRegisterListener(eventName, callback);
  }

  /**
   * 发送消息
   *
   * @param eventName 事件名称
   * @param args 参数
   * @returns 是否执行成功
   */
  public emit<T extends SafeType[]>(eventName: string, ...args: T): boolean {
    if (!this.hasListeners(eventName)) {
      return false;
    }
    try {
      const listeners = this.listenerMap.get(eventName);
      if (listeners.size === 0) {
        LogUtil.info(TAG, `event ${eventName} has no subscribers`);
        return false;
      }

      listeners.forEach((callback) => {
        if (callback) {
          callback(...args);
        }
      });
      return true;
    } catch (error) {
      LogUtil.error(TAG, `emit error ${error?.code} ${error?.message}`);
    }
    return false;
  }

  private die(eventName: string): void {
    try {
      this.listenerMap.remove(eventName);
    } catch (error) {
      LogUtil.error(TAG, `remove error ${error?.code} ${error?.message}`);
    }
  }

  private registerListener(eventName: string, callback: EventCallback): void {
    if (!this.hasListeners(eventName)) {
      try {
        this.listenerMap.set(eventName, new Set<EventCallback<SafeType[]>>());
      } catch (error) {
        LogUtil.error(TAG, `registerListener error ${error?.code} ${error?.message}`);
      }
    }
    try {
      this.listenerMap.get(eventName).add(callback);
    } catch (error) {
      LogUtil.error(TAG, `registerListener get error ${error?.code} ${error?.message}`);
    }
  }

  private unRegisterListener(eventName: string, callback: EventCallback): void {
    if (!this.hasListeners(eventName)) {
      return;
    }
    try {
      let listeners = this.listenerMap.get(eventName);
      listeners.delete(callback);

      if (listeners.size === 0) {
        this.die(eventName);
      }
    } catch (error) {
      LogUtil.error(TAG, `unRegisterListener error ${error?.code} ${error?.message}`);
    }
  }

  private hasListeners(eventName: string): boolean {
    try {
      return this.listenerMap.hasKey(eventName);
    } catch (error) {
      LogUtil.error(TAG, `hasListeners error`);
    }
    return false;
  }
}