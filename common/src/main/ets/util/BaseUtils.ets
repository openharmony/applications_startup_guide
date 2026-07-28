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
import deviceInfo from '@ohos.deviceInfo';
import display from '@ohos.display';
import Display from '@ohos.display';
import systemParameter from '@ohos.systemParameterEnhance';
import systemparameter from '@ohos.systemParameterEnhance';
import i18n from '@ohos.i18n';
import { LogUtil } from './LogUtil';
import { FoldScreenTypePrefix } from '../constant/FoldScreenTypePrefix';
import { ScreenState, ScreenStateModel } from '../manager/ScreenStateMonitor';
import { SystemParameterUtil } from './SystemParameterUtil';

const TAG: string = 'BaseUtils';
const DEVICE_TYPE_PHONE = 'phone';
const DEVICE_TYPE_PC = '2in1';
const DEVICE_TYPE_PAD = 'tablet';
const FOLD_SCREEN_PRODUCT_PROPERTY: string = 'const.window.foldscreen.type';
const QINGYUN_CCM: string = 'const.thermal.qingyun_enable';
/**
 * License管理特性使能开关
 */
const PC_SECURITY_LICENSE_ENABLE: string = 'const.pc_security.license_enable';

/**
 * 网络连接跳过使能开关
 */
const PC_SECURITY_NETWORK_CONNECT_ALLOW_SKIP: string = 'const.pc_security.network_connect_allow_skip';


const TIPS_INNER_FILM_SHOW: string = 'const.oobe.tipsinnerfilm.show';

const JUSTIFY_LANGUAGE: Set<string> = new Set(['zh-Hans', 'zh-Hant', 'ja', 'ko']);

  /**
 * 设备类型类
 *
 * @since 2023-12-09
 */
export class DeviceUtil {
  /**
   * 判断当前设备是否为手机
   *
   * @return true: 手机  false: 非手机
   */
  static isDevicePhone(): boolean {
    return deviceInfo.deviceType === DEVICE_TYPE_PHONE;
  }

  static isDevicePc(): boolean {
    return deviceInfo.deviceType === DEVICE_TYPE_PC;
  }

  static isDevicePad(): boolean {
    return deviceInfo.deviceType === DEVICE_TYPE_PAD;
  }

  /**
   * 是否为折叠屏
   *
   * @returns true 是，false 不是
   */
  static isFold(): boolean {
    let isFold: boolean = false;
    try {
      isFold = display.isFoldable();
    } catch (error) {
      LogUtil.error('isFold -> isFoldable try error:', error);
    }
    return isFold;
  }

  /**
   * 获取产品属性const.window.foldscreen.type的取值
   *
   * @returns 产品属性取值
   */
  static getFoldScreenProperty(): string {
    let tmpProperty: string = '';
    try {
      tmpProperty = systemParameter.getSync(FOLD_SCREEN_PRODUCT_PROPERTY);
    } catch (e) {
      LogUtil.error(TAG, 'get unexpected error.');
    }
    return tmpProperty;
  }

  /**
   * 判断当前设备是否是小折叠屏设备
   *
   * @returns ture:是小折叠屏,false:非小折叠
   */
  public static isSmallFoldScreen(): boolean {
    return DeviceUtil.isVerde() || DeviceUtil.isSmallFoldWithoutVde();
  }

  /**
   * 判断当前设备是否是verde以外的小折叠设备，如psd，lem
   * 2开头的折叠设备 display.isFoldable() 失效
   *
   * @returns ture:是,false:否
   */
  public static isSmallFoldWithoutVde(): boolean {
    let productProperty: string = DeviceUtil.getFoldScreenProperty();
    LogUtil.info(TAG, `product property:${productProperty}`);
    return productProperty.startsWith(FoldScreenTypePrefix.SMALL_FOLD);
  }

  /**
   * 判断当前设备是否是verde设备
   *
   * @returns ture:是verde,false:非verde
   */
  public static isVerde(): boolean {
    let productProperty: string = DeviceUtil.getFoldScreenProperty();
    LogUtil.info(TAG, `product property:${productProperty}`);
    let isVerde: boolean = false;
    if (productProperty.startsWith(FoldScreenTypePrefix.SMALL_FOLD_NEW_FORM)) {
      isVerde = true;
    }
    return DeviceUtil.isFold() && isVerde;
  }

  /**
   * 判断当前设备是否是三折叠设备
   *
   * @returns ture:是,false:否
   */
  public static isTripleFold(): boolean {
    let productProperty: string = DeviceUtil.getFoldScreenProperty();
    LogUtil.info(TAG, `product property:${productProperty}`);
    let isTripleFold: boolean = productProperty.startsWith(FoldScreenTypePrefix.TRIPLE_FOLD);
    return DeviceUtil.isFold() && isTripleFold;
  }

  /**
   * 判断当前设备是否是双折叠设备
   *
   * @returns ture:是,false:否
   */
  public static isDoubleFold(): boolean {
    let productProperty: string = DeviceUtil.getFoldScreenProperty();
    LogUtil.info(TAG, `product property:${productProperty}`);
    let isDoubleFold: boolean = productProperty.startsWith(FoldScreenTypePrefix.LARGE_FOLD);
    return DeviceUtil.isFold() && isDoubleFold;
  }

  /**
   * 是否为折叠屏展开态
   *
   * @returns true 是，false 不是
   */
  static isFoldExpanded(): boolean {
    let isFoldExpanded: boolean = false;
    try {
      isFoldExpanded = display.isFoldable() && display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED;
    } catch (error) {
      LogUtil.error('isFoldExpanded -> try error:', error);
    }
    return isFoldExpanded;
  }

  /**
   * 是否支持快速启用
   */
  static isSupportFastClone(): boolean {
    return !DeviceUtil.isRetailMode() && !DeviceUtil.isHwItVersion();
  }

  /**
   * 是否需要两端对齐布局
   *
   * @returns true： 是； false：否
   */
  static isNeedJustify(): boolean {
    let currentLanguage: string = i18n.System.getSystemLanguage();
    return JUSTIFY_LANGUAGE.has(currentLanguage);
  }

  /**
   * oobe是否展示重要提醒
   *
   * @returns true 展示，false 不展示
   */
  static isOOBEShowImportantTips(): boolean {
    return DeviceUtil.isSmallFoldScreen() || DeviceUtil.isDoubleFold() || DeviceUtil.isTripleFold();
  }

  /**
   * 判断是否门店版本
   */
  static isRetailMode(): boolean {
    let isRetailModeVersion: boolean = false;
    try {
      isRetailModeVersion = systemparameter.getSync('const.dfx.enable_retail') === 'true';
      LogUtil.info(TAG, `whether to startCurState: ${isRetailModeVersion}`);
    } catch (error) {
      LogUtil.error(TAG, `getSync unexpected error: ${error}, will startCurState`);
    }
    return isRetailModeVersion;
  }

  /**
   * 判断是否华为IT定制版本PC
   *
   * @returns 是否华为IT定制版本PC
   */
  static isHwItVersion(): boolean {
    let isHwItVersion: boolean = false;
    try {
      let custVendor = systemparameter.getSync('const.cust.vendor', '');
      isHwItVersion = custVendor === 'hwit';
      LogUtil.info(TAG, `custVendor is ${custVendor}, isHwItVersion is : ${isHwItVersion}`);
    } catch (error) {
      LogUtil.error(TAG, `getSync unexpected error: ${error}, will startCurState`);
    }
    return isHwItVersion;
  }

  /**
   * 是否使用横屏视频资源，平板设备、手机设备中小折叠屏的折叠状态、大折叠屏的展开状态、GL M态、GL G态用横屏资源
   *
   * @param screenState 屏幕状态
   * @returns true 使用，false 不使用
   */
  static isUseLandscapeResource(screenState: ScreenStateModel): boolean {
    if (DeviceUtil.isDevicePad() && !ScreenSizeUtil.isScreenPortraitOrientation()) {
      return true;
    }
    const IS_DEVICE_SMALL_FOLD: boolean = DeviceUtil.isSmallFoldScreen();
    // 是否是折叠屏
    let isFoldDevice = DeviceUtil.isFold();
    try {
      if (isFoldDevice) {
        // 折叠屏是否折叠
        let isFoldDeviceFolded = display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_FOLDED;
        LogUtil.info(TAG, `isFoldDeviceFolded: ${isFoldDeviceFolded}`);
        if (IS_DEVICE_SMALL_FOLD && isFoldDeviceFolded || screenState.screenState === ScreenState.M ||
          screenState.screenState === ScreenState.G) {
          return true;
        }
      }
    } catch (error) {
      LogUtil.error(TAG, `aboutToAppear error: ${error?.code}, ${error?.message}`);
    }
    return false;
  }

  /**
   * 是否为ToBBasicPC
   *
   * @returns 是否为ToBBasicPC
   */
  static isToBBasicPC(): boolean {
    return SystemParameterUtil.getSync(PC_SECURITY_LICENSE_ENABLE) === 'true';
  }

  /**
   * 是否需要展示重要提醒页面
   *
   * @returns true 展示，false 不展示
   */
  public static isNeedShowTips(): boolean {
    return SystemParameterUtil.getSync(TIPS_INNER_FILM_SHOW) === 'true';
  }

  /**
   * 网络连接跳过使能开关
   *
   * @returns true 允许跳过，false 不允许
   */
  public static isNetworkConnectAllowSkip(): boolean {
    return SystemParameterUtil.getSync(PC_SECURITY_NETWORK_CONNECT_ALLOW_SKIP) === 'true';
  }

  /**
   * 是否为青云产品
   *
   * @returns 是否为青云产品
   */
  public static isQingyun(): boolean {
    return SystemParameterUtil.getSync(QINGYUN_CCM, 'false') === 'true';
  }
}

/**
 * 设备屏幕尺寸类
 *
 * @since 2023-12-09
 */
export class ScreenSizeUtil {
  /**
   * 判断当前屏幕是否为竖屏
   *
   * @return true: 竖屏  false: 横屏
   */
  static isScreenPortraitOrientation(): boolean {
    let display: Display.Display | null = null;
    try {
      display = Display.getDefaultDisplaySync();
    } catch (err) {
      LogUtil.error(TAG, `get display failed: ${err.message}`);
    }
    const orientation = display?.orientation;
    if (orientation === Display.Orientation.LANDSCAPE || orientation === Display.Orientation.LANDSCAPE_INVERTED) {
      return false;
    } else {
      return true;
    }
  }

  /**
   * 获取当前设备屏幕宽度
   *
   * @returns 当前设备屏幕宽度
   */
  static getScreenWidth(): number {
    let display: Display.Display | null = null;
    try {
      display = Display.getDefaultDisplaySync();
    } catch (err) {
      LogUtil.error(TAG, `get display failed: ${err.message}`);
    }
    return px2vp(display?.width?? 0);
  }

  /**
   * 获取屏幕短边
   *
   * @returns 屏幕短边
   */
  static getScreenShortSide(): number {
    try {
      const display = Display.getDefaultDisplaySync();
      return Math.min(display.height, display.width);
    } catch (err) {
      LogUtil.error(TAG, `getScreenShortSide failed: ${err.message}`);
    }
    return 0;
  }
}