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
import type { BusinessError } from '@ohos.base';
import window from '@ohos.window';
import { AbilityManager } from './AbilityManager';
import { LogUtil } from '../util/LogUtil';

const TAG: string = 'WindowManager';

interface SystemProtectedWindow extends window.Window {
  hideNonSystemFloatingWindows(shouldHide: boolean): Promise<void>;
}

/**
 * 窗口管理类
 */
export class WindowManager {
  private static instance?: WindowManager;
  private callback: ((height: number) => void) | null;
  private windowStage: window.WindowStage | null = null;
  private window: window.Window | null = null;

  private constructor() {
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  static getInstance(): WindowManager {
    if (!WindowManager.instance) {
      WindowManager.instance = new WindowManager();
    }
    return WindowManager.instance;
  }

  /**
   * 设置键盘回调
   * @param value 回调
   */
  public setCallback(callback: ((height: number) => void) | null): void {
    this.callback = callback;
  }

  /**
   * 获取键盘高度
   */
  public async getKeyboardHeight(): Promise<number> {
    LogUtil.info(TAG, 'getKeyboardHeight');
    return new Promise((resolve, reject) => {
      window.getLastWindow(AbilityManager.getInstance().getContext())
        .then((lastWindow) => {
          const avoidArea: window.AvoidArea = lastWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD);
          let keyboardHeight: number = avoidArea.bottomRect.height;
          LogUtil.info(TAG, `keyboardHeight:${keyboardHeight}`);
          resolve(keyboardHeight);
        })
        .catch((error: BusinessError) => {
          LogUtil.error(TAG, `getLastWindow error: ${error?.message}`);
          reject(error);
        });
    });
  }

  /**
   * 监控键盘高度变更
   */
  public monitorKeyboardHeightChanged(): void {
    window.getLastWindow(AbilityManager.getInstance().getContext())
      .then((lastWindow) => {
        lastWindow.on('keyboardHeightChange', (height) => {
          LogUtil.info(TAG, `keyboardHeightChange ${height}`);
          if (this.callback) {
            this.callback(height);
          }
        });
      })
      .catch((error: BusinessError) => {
        LogUtil.error(TAG, `getLastWindow error: ${error?.message}`);
      });
  }

  /**
   * 取消监听键盘高度
   */
  public unMonitorKeyboardHeightChanged(): void {
    window.getLastWindow(AbilityManager.getInstance().getContext())
      .then((lastWindow) => {
        try {
          lastWindow.off('keyboardHeightChange');
        } catch (e) {
          LogUtil.error(TAG, `Failed to disable the listener for keyboard height change: ${e?.message}.`);
        }
      });
  }

  /**
   * 注册状态栏监听
   */
  public registerWindowStage(windowStage: window.WindowStage): void {
    this.windowStage = windowStage;
  }

  /**
   * 设置状态栏属性
   */
  public setSystemBarProperties(properties: window.SystemBarProperties): void {
    this.getWindow().then((win: window.Window) => {
      win.setWindowSystemBarProperties(properties, (err) => {
        if (err.code) {
          return;
        }
      });
    });
  }

  /**
  * 设置屏幕全屏
   *
  * @param isFullScreen true 全屏
  */
  public setWindowLayoutFullScreen(isFullScreen: boolean): void {
    this.getWindow().then((win: window.Window) => {
      win.setWindowLayoutFullScreen(isFullScreen);
      if (isFullScreen) {
        win.maximize();
      }
    }).catch(() => {
      LogUtil.info(TAG, 'setWindowLayoutFullScreen fail');
    });
  }

  /**
   * 是否隐藏状态栏
   *
   * @param hideSystemBar true 隐藏
   */
  public setWindowSystemBarEnable(hideSystemBar: boolean): void {
    let names: Array<'status' | 'navigation'> = hideSystemBar ? ['status'] : [];
    this.getWindow().then((win: window.Window) => {
      win.setWindowSystemBarEnable(names);
    });
  }

  public getWindow(): Promise<window.Window> {
    return new Promise((resolve, reject) => {
      if (this.window) {
        resolve(this.window);
        return;
      }
      if (!this.windowStage) {
        reject(null);
        return;
      }

      this.windowStage.getMainWindow().then((window: window.Window) => {
        resolve(window);
      }).catch(() => {
        reject(null);
      });
    });
  }

  /**
   * 隐藏/恢复非系统浮窗，防止敏感授权界面被恶意浮窗诱导点击（系统 API）
   *
   * @param shouldHide true 隐藏非系统浮窗
   */
  public setHideNonSystemFloatingWindows(shouldHide: boolean): void {
    this.getWindow().then((win: window.Window) => {
      const systemWindow = win as SystemProtectedWindow;
      systemWindow.hideNonSystemFloatingWindows(shouldHide).then(() => {
        LogUtil.info(TAG, `hideNonSystemFloatingWindows ${shouldHide} success`);
      }).catch((err: BusinessError) => {
        LogUtil.error(TAG, `hideNonSystemFloatingWindows failed, code: ${err.code}, message: ${err.message}`);
      });
    }).catch(() => {
      LogUtil.error(TAG, 'setHideNonSystemFloatingWindows getWindow failed');
    });
  }

  /**
   * 请求窗口焦点
   *
   * @param isFocused true 请求焦点
   */
  public requestWindowFocus(isFocused: boolean): void {
    LogUtil.info(TAG, 'requestWindowFocus.');
    this.getWindow().then((win: window.Window) => {
      let promise = win.requestFocus(isFocused);
      promise.then(() => {
        LogUtil.info(TAG, 'Succeeded in requesting focus.');
      }).catch((err: BusinessError) => {
        LogUtil.error(TAG, `Failed to request focus. Cause code: ${err.code}, message: ${err.message}`);
      });
    }).catch((err) => {
      LogUtil.error(TAG, `requestWindowFocus fail. Cause code: ${err.code}, message: ${err.message}`);
    });
  }

  /**
   * 设置窗口的显示方向属性
   *
   * @param stage 窗口管理器
   * @param orientation 窗口显示方向
   */
  static async setWindowOrientation(stage: window.WindowStage, orientation: window.Orientation): Promise<void> {
    if (!stage || !orientation) {
      return;
    }
    try {
      const windowInstance = await stage.getMainWindow();
      windowInstance.setPreferredOrientation(orientation);
    } catch (err) {
      LogUtil.error(TAG, `set window Orientation error message: ${err.message}`);
    }
  }

  /**
   * 获取窗口的显示方向属性
   *
   * @param stage 窗口管理器
   * @param orientation 窗口显示方向
   */
  static async getWindowOrientation(stage: window.WindowStage): Promise<window.Orientation> {
    if (!stage) {
      return window.Orientation.UNSPECIFIED;
    }

    try {
      const windowInstance = await stage.getMainWindow();
      return windowInstance.getPreferredOrientation();
    } catch (err) {
      LogUtil.error(TAG, `get window Orientation error message: ${err.message}`);
    }
    return window.Orientation.UNSPECIFIED;
  }
}
