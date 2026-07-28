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
import { LogUtil } from '../util/LogUtil';
import {
  BreakpointManager,
  BreakpointData,
  BreakpointOrientation,
  BreakpointState
} from './BreakpointManager';

const TAG = 'ScreenStateMonitor';

export enum ScreenState {
  F = 'F',
  M = 'M',
  G = 'G',
  NONE = 'NONE',
}

export enum ScreenOrientation {
  LANDSCAPE = 'landscape',
  PORTRAIT = 'portrait',
}

export interface ScreenStateModel {
  screenState: ScreenState;
  orientation: ScreenOrientation;
  width: number,
  height: number,
}

export type ScreenStateChangeListener = (oldScreenState: ScreenStateModel, screenState: ScreenStateModel) => void;

export class ScreenStateMonitor {
  private static instance: ScreenStateMonitor;
  private screenStateListenerMap: Map<string, ScreenStateChangeListener> = new Map();

  private currentScreenModel: ScreenStateModel | undefined = undefined;

  private constructor() {
    BreakpointManager.getInstance().registerBreakpointDataChange('LauncherScreenSateMonitor',
      (oldData: BreakpointData, newData: BreakpointData) => {
        this.updateBreakpointData(oldData, newData);
      }, 1);
  }

  /**
   * 获取实例
   *
   * @returns 屏幕状态管理类
   */
  public static getInstance(): ScreenStateMonitor {
    if (!ScreenStateMonitor.instance) {
      ScreenStateMonitor.instance = new ScreenStateMonitor();
    }
    return ScreenStateMonitor.instance;
  }

  /**
   * 获取当前屏幕状态模型
   *
   * @returns 获取当前屏幕状态模型
   */
  public getCurrentScreenStateModel(): ScreenStateModel {
    if (this.currentScreenModel === undefined) {
      return this.getScreenStateModel(BreakpointManager.getInstance().getBreakpointData());
    }
    return this.currentScreenModel;
  }

  /**
   * 注册屏幕状态变化监听
   *
   * @param key 注册的key主要用于注销
   * @param listener 回调函数
   */
  public registerScreenStateChangeListener(key: string, listener: ScreenStateChangeListener): void {
    try {
      this.screenStateListenerMap.set(key, listener);
      LogUtil.info(TAG, `registerScreenStateChangeListener succeeded by key: ${key}`);
    } catch (e) {
      LogUtil.error(TAG, `registerScreenStateChangeListener failed by key: ${key}, error message: ${e.message}`);
    }
  }

  /**
   * 取消注册屏幕状态变化监听
   *
   * @param key 取消注册的key
   */
  public unRegisterScreeStateChangeListener(key: string): void {
    try {
      this.screenStateListenerMap.delete(key);
      LogUtil.info(TAG, `unRegisterScreeStateChangeListener succeeded by key: ${key}`);
    } catch (e) {
      LogUtil.error(TAG, `unRegisterScreeStateChangeListener failed by key: ${key}, error message: ${e.message}`);
    }
  }

  /**
   * 更新断点数据
   *
   * @param previousBreakpointData 之前的断点数据
   * @param currentBreakpointData 现在的断点数据
   */
  public updateBreakpointData(previousBreakpointData: BreakpointData, currentBreakpointData: BreakpointData): void {
    if (!previousBreakpointData || !currentBreakpointData) {
      LogUtil.error(TAG, 'breakpoint data is invalid');
      return;
    }
    let previousScreenModel = this.getScreenStateModel(previousBreakpointData);
    this.currentScreenModel = this.getScreenStateModel(currentBreakpointData);
    LogUtil.info(TAG, `prev:${previousScreenModel.screenState}, ${previousScreenModel.orientation}, w: ${
    previousScreenModel.width}, h: ${previousScreenModel.height}; current:${this.currentScreenModel.screenState}, ${
    this.currentScreenModel.orientation}, w: ${this.currentScreenModel.width}, h: ${this.currentScreenModel.height}`);
    Array.from(this.screenStateListenerMap.values()).forEach(callbackFun =>
    callbackFun?.(previousScreenModel, this.currentScreenModel));
  }

  private getScreenStateModel(data: BreakpointData): ScreenStateModel {
    // 设置默认状态
    let screenOrientation = ScreenOrientation.PORTRAIT;
    let state = ScreenState.NONE;
    let width = data.width;
    let height = data.height;
    // 竖屏
    if (data.orientation === BreakpointOrientation.PORTRAIT) {
      if (data.landscape === BreakpointState.SM && data.portrait === BreakpointState.LG) {
        state = ScreenState.F;
      } else if (data.landscape === BreakpointState.MD && data.portrait === BreakpointState.MD) {
        state = ScreenState.M;
      } else if (data.landscape === BreakpointState.MD && data.portrait === BreakpointState.LG) {
        state = ScreenState.G;
      }
    } else {
      screenOrientation = ScreenOrientation.LANDSCAPE;
      if (data.landscape === BreakpointState.MD && data.portrait === BreakpointState.SM) {
        screenOrientation = ScreenOrientation.PORTRAIT;
        [width, height] = [height, width];
        state = ScreenState.F;
      } else if (data.landscape === BreakpointState.MD && data.portrait === BreakpointState.MD) {
        state = ScreenState.M;
      } else if (data.landscape === BreakpointState.LG && data.portrait === BreakpointState.SM) {
        state = ScreenState.G;
      }
    }
    return {
      screenState: state,
      orientation: screenOrientation,
      width: width,
      height: height,
    };
  }
}
