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
import { SheetData } from '../model/SheetData';
import { DeviceUtil, ScreenSizeUtil } from '../util/BaseUtils';
import { LogUtil } from '../util/LogUtil';
import { BreakpointManager, BreakpointState } from './BreakpointManager';
import { ScreenState, ScreenStateModel, ScreenStateMonitor } from './ScreenStateMonitor';

const TAG: string = 'SheetManager';
const SHEET_MAX_HEIGHT: string = '100%';

export class SheetManager {
  private static instance?: SheetManager;
  private ratio: number = 0.9;
  private sheetData: SheetData = new SheetData();

  constructor() {
    this.init();
  }

  private init(): void {
    if (DeviceUtil.isTripleFold() || DeviceUtil.isFold()) {
      const currentScreenModel = ScreenStateMonitor.getInstance().getCurrentScreenStateModel();
      this.screenState2SheetData(currentScreenModel);
      ScreenStateMonitor.getInstance().registerScreenStateChangeListener(TAG, this.screenStateChange);
    } else if (DeviceUtil.isDevicePad()) {
      const shortSide = ScreenSizeUtil.getScreenShortSide();
      let sheetHeight: number | string = SHEET_MAX_HEIGHT;
      if (shortSide) {
        sheetHeight = shortSide * this.ratio;
      }
      this.sheetData.setData(sheetHeight, SheetType.CENTER);
    } else {
      this.sheetData.setData(SheetSize.LARGE, SheetType.POPUP);
    }
  }

  private screenStateChange = (oldScreenState: ScreenStateModel, screenState: ScreenStateModel) => {
    this.screenState2SheetData(screenState);
  }

  private screenState2SheetData(screenState: ScreenStateModel): void {
    if (screenState.screenState === ScreenState.NONE) {
      LogUtil.warn(TAG, `ScreenState error ${screenState.width} ${screenState.height} ${screenState.orientation}`);
      const data = BreakpointManager.getInstance().getBreakpointData();
      if (data.landscape === BreakpointState.SM && data.portrait === BreakpointState.LG) {
        this.sheetData.setData(SheetSize.LARGE, SheetType.POPUP);
      }
      return;
    }
    if (screenState.screenState === ScreenState.F) {
      this.sheetData.setData(SheetSize.LARGE, SheetType.POPUP);
      return;
    }
    const sheetHeight = Math.min(screenState.width, screenState.height) * this.ratio;
    this.sheetData.setData(sheetHeight, SheetType.CENTER);
  }

  /**
   * 单例获取SheetManager类
   *
   * @returns 返回SheetManager单例类
   */
  public static getInstance(): SheetManager {
    if (!SheetManager.instance) {
      SheetManager.instance = new SheetManager();
    }
    return SheetManager.instance;
  }

  /**
   * 获取SheetData类
   *
   * @returns 返回SheetData
   */
  public getSheetData(): SheetData {
    return this.sheetData;
  }
}