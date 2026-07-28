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

/**
 * 事件码
 */
export enum Event {
  /**
   * 默认空事件
   */
  DEFAULT = 'DEFAULT',

  /**
   * 发送广播中
   */
  BROADCASTING = 'BROADCASTING',

  /**
   * 广播发送成功
   */
  BROADCAST_SUCCESS = 'BROADCAST_SUCCESS',

  /**
   * 广播发送失败
   */
  BROADCAST_FAIL = 'BROADCAST_FAIL',

  /**
   * 查找设备
   */
  DEVICE_DISCOVERING = 'DEVICE_DISCOVERING',

  /**
   * 查找设备成功
   */
  DEVICE_DISCOVER_SUCCESS = 'DEVICE_DISCOVER_SUCCESS',

  /**
   * 查找设备失败
   */
  DEVICE_DISCOVER_FAIL = 'DEVICE_DISCOVER_FAIL',

  /**
   * 停止查找设备
   */
  DEVICE_STOP_DISCOVER = 'DEVICE_STOP_DISCOVER',

  /**
   * 鸿蒙环加载完成，配对成功
   */
  PAIRING_SUCCESS = 'PAIRING_SUCCESS',

  /**
   * 鸿蒙环扫描完成
   */
  PAIRING_SCANNING_SUCCESS = 'PAIRING_SCANNING_SUCCESS',

  /**
   * 鸿蒙环加载完成，拒绝配对
   */
  PAIRING_REJECTED = 'PAIRING_REJECTED',

  /**
   * 等待创建鸿蒙环
   */
  PAIRING_WAITING = 'PAIRING_WAITING',

  /**
   * 鸿蒙环加载完成，配对失败
   */
  PAIRING_FAIL = 'PAIRING_FAIL',

  /**
   * 设备断连未知状态
   */
  DEVICE_CONNECT_UNKNOWN_STATE = 'DEVICE_CONNECT_UNKNOWN_STATE',

  /**
   * 设备未连接上
   */
  DEVICE_CONNECT_FAIL = 'DEVICE_CONNECT_FAIL',

  /**
   * 设备已连接
   */
  DEVICE_CONNECT_SUCCESS = 'DEVICE_CONNECT_SUCCESS',

  /**
   * 设备连接中
   */
  DEVICE_CONNECTING = 'DEVICE_CONNECTING',

  /**
   * 断连设备成功
   */
  DEVICE_DISCONNECT_SUCCESS = 'DEVICE_DISCONNECT_SUCCESS',

  /**
   * 断连设备失败
   */
  DEVICE_DISCONNECT_FAIL = 'DEVICE_DISCONNECT_FAIL',

  /**
   * 设备断连
   */
  DEVICE_DISCONNECTED = 'DEVICE_DISCONNECTED',

  /**
   * 鸿蒙环页面加载成功
   */
  HARMONY_RING_LOADED_SUCCESS = 'HARMONY_RING_LOADED_SUCCESS',

  /**
   * 鸿蒙环页面加载失败
   */
  HARMONY_RING_LOADED_FAIL = 'HARMONY_RING_LOADED_FAIL',

  /**
   * 鸿蒙环和PIN码切换
   */
  HARMONY_RING_SWITCH_PIN_TYPE = 'HARMONY_RING_SWITCH_PIN_TYPE',

  /**
   * 刷新PIN码
   */
  HARMONY_RING_UPDATE_PIN_CODE = 'HARMONY_RING_UPDATE_PIN_CODE',

  /**
   * 校验成功
   */
  AUTH_SUCCESS = 'AUTH_SUCCESS',

  /**
   * 校验失败
   */
  AUTH_FAIL = 'AUTH_FAIL',

  /**
   * 克隆
   */
  RESTORE_SUCCESS = 'RESTORE_SUCCESS',

  /**
   * 克隆失败
   */
  RESTORE_FAIL = 'RESTORE_FAIL',

  /**
   * 快速加载状态
   */
  LOAD_EXTERNAL = 'LOAD_EXTERNAL',

  /**
   * 锁屏
   */
  SCREEN_LOCK = 'SCREEN_LOCK',

  /**
   * 灭屏
   */
  SCREEN_OFF = 'SCREEN_OFF',

  /**
   * 亮屏
   */
  SCREEN_ON = 'SCREEN_ON',

  /**
   * OOBE进入前台
   */
  OOBE_FOREGROUND = 'OOBE_FOREGROUND',

  /**
   * OOBE进入后台
   */
  OOBE_BACKGROUND = 'OOBE_BACKGROUND',

  /**
   * 亮屏
   */
  SCREEN_ON_FEATURE = 'SCREEN_ON_FEATURE',

  /**
   * 灭屏
   */
  SCREEN_OFF_FEATURE = 'SCREEN_OFF_FEATURE',

  /**
   * 非亮灭屏事件的其他事件
   */
  SCREEN_UNKNOWN_EVENT = 'SCREEN_UNKNOWN_EVENT',

  /**
   * 蓝牙状态已打开，可发送广播
   */
  BLUETOOTH_OPENED = 'BLUETOOTH_OPENED',

  /**
   * 蓝牙已关闭
   */
  BLUETOOTH_CLOSED = 'BLUETOOTH_CLOSED',

  /**
   * 蓝牙其他状态，不可发送广播
   */
  BLUETOOTH_OTHER = 'BLUETOOTH_OTHER',

  /**
   * 用户选择跳过快速设置
   */
  USER_CHOOSE_NORMAL = 'USER_CHOOSE_NORMAL',

  /**
   * 鸿蒙环页面，用户点击左上角
   */
  USER_HARMONY_LEFT_ARROW = 'USER_HARMONY_LEFT_ARROW',

  /**
   * 协议与声明页面，用户点击左上角
   */
  USER_BASIC_SERVICE_LEFT_ARROW = 'USER_BASIC_SERVICE_LEFT_ARROW',

  /**
   * 旧机用户取消
   */
  HARMONY_BACKTRACE = 'HARMONY_BACKTRACE',

  /**
   * 返回到上一个OOBE常态页面
   */
  BACK_PRE_NORMAL_PAGE = 'BACK_PRE_NORMAL_PAGE',

  /**
   * 有锁屏密码
   */
  PIN_LOCK = 'PIN_LOCK',

  /**
   * 没有锁屏密码
   */
  NO_PIN_LOCK = 'NO_PIN_LOCK',

  /**
   * 校验锁屏密码成功
   */
  PIN_LOCK_SUCCESS = 'PIN_LOCK_SUCCESS',

  /**
   * 正在设置结束（第二次拉起克隆服务结束）
   */
  SETTING_UP_END = 'SETTING_UP_END',

  /**
   * 正在设置页的克隆接口失败
   */
  SETTING_UP_CLONE_FAIL = 'SETTING_UP_CLONE_FAIL',

  /**
   * 设置语言页的克隆接口失败
   */
  SET_LANGUAGE_CLONE_FAIL = 'SET_LANGUAGE_CLONE_FAIL',

  /**
   * 正在设置界面停留超时
   */
  SETTING_UP_PAGE_TIME_OUT = 'SETTING_UP_PAGE_TIME_OUT',

  /**
   * 正在设置语言界面停留超时
   */
  SET_LANGUAGE_PAGE_TIME_OUT = 'SET_LANGUAGE_PAGE_TIME_OUT',

  /**
   * 正在设置语言界面停留了足够的时间
   */
  SET_LANGUAGE_PAGE_STAY_ENOUGH = 'SET_LANGUAGE_PAGE_STAY_ENOUGH',

  /**
   * 正在设置跳转到WLAN，点继续
   */
  SETTING_UP_JUMP_WLAN_CONTINUE = 'SETTING_UP_JUMP_WLAN_CONTINUE',

  /**
   * 正在设置跳转到WLAN，点返回
   */
  SETTING_UP_JUMP_WLAN_BACK = 'SETTING_UP_JUMP_WLAN_BACK',

  /**
   * 正在设置过程中网络已连接(克隆触发WLAN扫描后，自动连接上)
   */
  SETTING_UP_WAIT_NET_END = 'SETTING_UP_WAIT_NET_END',

  /**
   * 正在设置过程中，连上网络后，等待验证网络
   */
  WAIT_NET_VALIDATED = 'WAIT_NET_VALIDATED',

  /**
   * 华为账号快速克隆处理结束
   */
  ACCOUNT_LOGIN_FAST_CLONE_END = 'ACCOUNT_LOGIN_FAST_CLONE_END',

  /**
   * 协议与声明上一步
   */
  BASIC_SERVICE_STATE_BACK = 'BASIC_SERVICE_STATE_BACK',

  /**
   * 协议与声明上下一步
   */
  BASIC_SERVICE_STATE_NEXT = 'BASIC_SERVICE_STATE_NEXT',

  /**
   * OOBE结束
   */
  EVENT_FINISH_OOBE = 'EVENT_FINISH_OOBE',

  /**
   * 初始化完毕
   */
  INIT_CONTROLLER_ARRAY_READY = 'INIT_CONTROLLER_ARRAY_READY',

  /**
   * 退出快速克隆
   */
  EVENT_EXIT_QUICK_SETUP = 'EXIT_QUICK_SETUP',

  /**
   * 设置语言后的onConfigurationUpdate回调
   */
  LANGUAGE_CONFIGURATION_UPDATE = 'LANGUAGE_CONFIGURATION_UPDATE',

  /**
   * 设置字体大小后的onConfigurationUpdate回调
   */
  FONTSIZE_CONFIGURATION_UPDATE = 'FONTSIZE_CONFIGURATION_UPDATE',

  /**
   * 同步流程结束
   */
  EVENT_SYNC_PROCESS_END = 'EVENT_SYNC_PROCESS_END',
}

/**
 * 事件回调监听器
 */
export interface EventCallbackListener {
  /**
   * 监听器id
   */
  id: string;

  /**
   * 事件开始回调
   *
   * @param event 事件信息
   */
  eventStart?: (event: Event) => void;

  /**
   * 事件结束回调
   *
   * @param event 事件信息
   */
  eventEnd?: (event: Event) => void;
}
