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
import { Event, EventCallbackListener } from './Event';
import { EventReceiver } from './EventReceiver';

const TAG: string = 'EventEmitter';
const DEFAULT_KEY: string = 'default_eventCallListener_key';

/**
 * 事件发射器
 */
export class EventEmitter {
  private static instance?: EventEmitter;
  eventReceiverList: Array<EventReceiver> = [];
  private eventListeners: Map<string, Set<EventCallbackListener>> = new Map();

  private constructor() {
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  static getInstance(): EventEmitter {
    if (!EventEmitter.instance) {
      EventEmitter.instance = new EventEmitter();
    }
    return EventEmitter.instance;
  }

  /**
   * 增加参数
   * @param param 参数
   */
  addEventReceiver(eventReceiver: EventReceiver): void {
    this.eventReceiverList.push(eventReceiver);
  }

  /**
   * 发射事件
   *
   * @param event 事件
   * @param key 事件元素标识
   */
  emit(event: Event, key?: string): void {
    LogUtil.info(TAG, `emit event: ${event}`);
    if (key) {
      const listeners = this.eventListeners.get(key);
      listeners?.forEach(listener => this.triggerEventStart(event, listener));
    }
    this.eventListeners.get(DEFAULT_KEY)?.forEach(listener => this.triggerEventStart(event, listener));
    this.eventReceiverList?.forEach(receiver => {
      receiver.receive(event);
    });
  }

  /**
   * 注册事件状态监听
   *
   * @param listener 事件监听器
   * @param key 事件元素标识
   */
  public registerEventListener(listener: EventCallbackListener, key?: string): void {
    if (!listener) {
      LogUtil.error(TAG, 'register error with empty listener');
      return;
    }

    let realKey: string = key ?? DEFAULT_KEY;
    let listeners: Set<EventCallbackListener> | undefined = this.eventListeners.get(realKey);
    if (!listeners) {
      let set: Set<EventCallbackListener> = new Set();
      set.add(listener);
      this.eventListeners.set(realKey, set);
      return;
    }
    if (listeners.has(listener)) {
      LogUtil.warn(TAG, 'register interrupt with repeated listener');
      return;
    }
    listeners.add(listener);
  }

  /**
   * 反注册事件状态监听
   *
   * @param listener 事件监听器
   * @param key 事件元素标识
   */
  public unregisterEventListener(listener: EventCallbackListener, key?: string): void {
    if (!listener) {
      LogUtil.error(TAG, 'unregister error with empty listener');
      return;
    }

    let realKey: string = key ?? DEFAULT_KEY;
    let value: Set<EventCallbackListener> | undefined = this.eventListeners.get(realKey);
    if (!value) {
      LogUtil.warn(TAG, 'unregister interrupt with unregistered listener');
      return;
    }
    value.delete(listener);
    if (value.size === 0) {
      this.eventListeners.delete(realKey);
    }
  }

  /**
   * 触发监听器回调
   *
   * @param event 事件信息
   * @param listener 监听器
   */
  private triggerEventStart(event: Event, listener: EventCallbackListener): void {
    if (!listener.eventStart) {
      LogUtil.error(TAG, 'listener eventStart callback is null');
      return;
    }
    try {
      listener.eventStart(event);
    } catch (err) {
      LogUtil.error(TAG, `notifyEventStart err id:${listener.id} code:${err.code} msg:${err.message}`);
    }
  }
}
