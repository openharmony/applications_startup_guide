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
import { display } from '@kit.ArkUI';
import { LogUtil } from '../util/LogUtil';

const TAG = 'BreakpointManager';

export enum BreakpointState {
  XS = 'xs',
  SM = 'sm',
  MD = 'md',
  LG = 'lg',
  XL = 'xl',
}

export enum BreakpointOrientation {
  LANDSCAPE = 'landscape',
  PORTRAIT = 'portrait',
}

export interface BreakpointData {
  landscape: BreakpointState;
  portrait: BreakpointState;
  orientation: BreakpointOrientation;
  width: number;
  height: number;
}

interface BreakpointListenerValue {
  callback: BreakpointEventListener;
  index: number;
  key: string;
}

const BREAKPOINT_SM_MIN_VALUE: number = 320;
const BREAKPOINT_MD_MIN_VALUE: number = 600;
const BREAKPOINT_LG_MIN_VALUE: number = 840;
const BREAKPOINT_XL_MIN_VALUE: number = 1440;

const BREAKPOINT_MD_MIN_RATIO: number = 0.8;
const BREAKPOINT_LG_MIN_RATIO: number = 1.2;

/**
 * 断点事件分发回调函数
 *
 * @param oldData 旧的断点数据
 * @param newData 新的断点数据
 */
export type BreakpointEventListener = (oldData: BreakpointData, newData: BreakpointData) => void;

export class BreakpointManager {

  private static readonly BREAKPOINT_RUN_TRACE = 'breakpointRunTrace';

  private static instance: BreakpointManager;
  private breakpointListenerMap: Map<string, BreakpointListenerValue> = new Map();

  private breakpointData: BreakpointData = this.getCurrentBreakpointData();

  private constructor() {
    let breakpointData = this.getCurrentBreakpointData();
    this.setCurrentBreakpointData(breakpointData);
    this.monitorWindowSizeChange();
  }

  private setCurrentBreakpointData(breakpointData: BreakpointData): void {
    this.breakpointData = breakpointData;
  }

  public static getInstance(): BreakpointManager {
    if (!BreakpointManager.instance) {
      BreakpointManager.instance = new BreakpointManager();
    }
    return BreakpointManager.instance;
  }

  private getWindowWidthBreakpoint(width: number): BreakpointState {
    let breakpoint: BreakpointState = BreakpointState.XS;
    if (width >= BREAKPOINT_SM_MIN_VALUE && width < BREAKPOINT_MD_MIN_VALUE) {
      breakpoint = BreakpointState.SM;
    } else if (width >= BREAKPOINT_MD_MIN_VALUE && width < BREAKPOINT_LG_MIN_VALUE) {
      breakpoint = BreakpointState.MD;
    } else if (width >= BREAKPOINT_LG_MIN_VALUE && width < BREAKPOINT_XL_MIN_VALUE) {
      breakpoint = BreakpointState.LG;
    } else if (width >= BREAKPOINT_XL_MIN_VALUE) {
      breakpoint = BreakpointState.XL;
    }
    return breakpoint;
  }

  private getWindowHeightBreakpoint(ratio: number): BreakpointState {
    let breakpoint: BreakpointState = BreakpointState.SM;
    if (ratio >= BREAKPOINT_MD_MIN_RATIO && ratio < BREAKPOINT_LG_MIN_RATIO) {
      breakpoint = BreakpointState.MD;
    } else if (ratio >= BREAKPOINT_LG_MIN_RATIO) {
      breakpoint = BreakpointState.LG;
    }
    return breakpoint;
  }

  private getCurrentBreakpointData(): BreakpointData {
    try {
      const defaultDisplay: display.Display = display.getDefaultDisplaySync();
      const width = px2vp(defaultDisplay.width);
      const height = px2vp(defaultDisplay.height);
      const rotation: number = defaultDisplay.orientation;
      let ratio: number = height / width;
      const landscapeBreakpoint = this.getWindowWidthBreakpoint(width);
      const portraitBreakpoint = this.getWindowHeightBreakpoint(ratio);
      let orientation: BreakpointOrientation = BreakpointOrientation.PORTRAIT;
      if (rotation === display.Orientation.LANDSCAPE || rotation === display.Orientation.LANDSCAPE_INVERTED) {
        orientation = BreakpointOrientation.LANDSCAPE;
      }
      return {
        landscape: landscapeBreakpoint,
        portrait: portraitBreakpoint,
        orientation: orientation,
        width: defaultDisplay.width,
        height: defaultDisplay.height
      };
    } catch (e) {
      LogUtil.error(TAG, `getCurrentBreakpointData failed: ${e}`);
    }
    return this.breakpointData;
  }

  private getBreakpointListenerArray(): BreakpointListenerValue[] {
    return Array.from(this.breakpointListenerMap.values()).sort(
      (one: BreakpointListenerValue, two: BreakpointListenerValue) => {
        return two.index - one.index;
      });
  }

  private breakpointDataEqual(breakpointData: BreakpointData): boolean {
    return breakpointData.landscape === this.breakpointData.landscape &&
      breakpointData.portrait === this.breakpointData.portrait &&
      breakpointData.orientation === this.breakpointData.orientation;
  }

  private monitorWindowSizeChange(): void {
    const callback = (): void => {
      const newBreakpointData: BreakpointData = this.getCurrentBreakpointData();
      if (!this.breakpointDataEqual(newBreakpointData)) {
        LogUtil.info(TAG, `old landscapeState: ${this.breakpointData.landscape}, portraitState ${
        this.breakpointData.portrait}, orientation: ${this.breakpointData.orientation}, width: ${
        this.breakpointData.width}, height: ${this.breakpointData.height}`);
        LogUtil.info(TAG, `new landscapeState: ${newBreakpointData.landscape}, portraitState ${
        newBreakpointData.portrait}, orientation: ${newBreakpointData.orientation}, width: ${
        newBreakpointData.width}, height: ${newBreakpointData.height}`);
        const oldBreakpointData: BreakpointData = this.breakpointData;
        this.setCurrentBreakpointData(newBreakpointData);
        const breakpointListenerArray: BreakpointListenerValue[] = this.getBreakpointListenerArray();
        breakpointListenerArray.forEach((item: BreakpointListenerValue) => {
          LogUtil.info(TAG, `callback key: ${item.key}, index: ${item.index}`);
          item?.callback?.(oldBreakpointData, newBreakpointData);
        });
      }
    };
    try {
      display.on('change', callback);
    } catch (e) {
      LogUtil.error(TAG, `Monitoring failed: ${e}`);
    }
  }

  public getBreakpointData(): BreakpointData {
    return this.breakpointData;
  }

  /**
   * 注册断点数据改变监听
   *
   * @param key 注册的key主要用于注销
   * @param callback 回调函数
   * @param index 监听断点状态改变时分发数据的优先级，越大优先级越高，越早被通知
   */
  public registerBreakpointDataChange(key: string, callback: BreakpointEventListener, index: number = 0): void {
    LogUtil.info(TAG, `register key: ${key}, exist: ${this.breakpointListenerMap.has(key)}`);
    this.breakpointListenerMap.set(key, {
      callback: callback,
      index: index,
      key: key
    });
  }

  /**
   * 取消注册断点数据改变监听
   *
   * @param key 取消注册的key
   */
  public unregisterBreakpointDataChange(key: string): void {
    LogUtil.info(TAG, `unregister key: ${key}`);
    if (this.breakpointListenerMap.has(key)) {
      LogUtil.info(TAG, `unregister success key: ${key}`);
      this.breakpointListenerMap.delete(key);
    }
  }
}