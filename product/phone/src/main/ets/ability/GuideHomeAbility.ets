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

import window from '@ohos.window';
import type { BusinessError } from '@ohos.base';
import { Configuration } from '@ohos.app.ability.Configuration';
import { KeyboardAvoidMode } from '@ohos.arkui.UIContext';
import i18n from '@ohos.i18n';
import {
  AbstractGuideAbility,
  CommonConstant,
  GlobalContext,
  LogUtil,
  PageKey,
  ShipModeManager,
  ShutdownManager,
  WindowManager,
  mediaConfigManager,
  pageLayoutManager,
  StyleManager,
  SceneTypeManager,
  ExperienceManager
} from '@ohos/hwstartupguide.common';
import { PageOrderController } from '../controller/PageOrderController';
import { PhoneFooterStyleModel } from '../model/PhoneStyleModel';

const STATUS_CONTENT_COLOR: string = '#000000'; // UX规格：黑色字体
const STATUS_BAR_COLOR: string = '#F1F3F5'; // UX规格：背景颜色

/**
 * 开机向导主ability
 */
export default class GuideHomeAbility extends AbstractGuideAbility {
  protected tag: string = 'GuideHomeAbility';

  onWindowStageCreate(windowStage: window.WindowStage): void {
    StyleManager.getInstance().setFooterStyleModel(new PhoneFooterStyleModel());
    try {
      LogUtil.info(this.tag, 'onWindowStageCreate');
      SceneTypeManager.getInstance().setNeedEduSpace(true);
      // 加载外部应用数据
      Promise.all([
        PageOrderController.getInstance().init(() => {
          ExperienceManager.getInstance().setLightModeOnRestart();
        }),
        // 获取媒体数据
        mediaConfigManager.initMediaConfig(),
        pageLayoutManager.initPageLayoutConfig()
      ]).finally(() => {
        LogUtil.info(this.tag, `onWindowStageCreate then`);
        // 获取首页url
        let pageUrl: string = 'pages/Page';
        AppStorage.setOrCreate('refreshId', 0); // 默认值0
        AppStorage.setOrCreate<boolean>('isoLanguage', i18n.isRTL(i18n.System.getSystemLanguage()));
        // 载入内容
        this.loadContent(windowStage, pageUrl);
      });
      // 注册窗口状态栏监听
      WindowManager.getInstance().registerWindowStage(windowStage);
      // 设置不支持显示大小缩放
      windowStage.setDefaultDensityEnabled(true);
    } catch (e) {
      LogUtil.error(this.tag, `onWindowStageCreate Exception, code:${e?.code}, message:${e?.message}`);
    }
  }

  loadContent(windowStage: window.WindowStage, pageUrl: string): void {
    LogUtil.info(this.tag, `loadContent ${pageUrl}`);
    AppStorage.setOrCreate<window.WindowStage>('windowStage', windowStage);
    GlobalContext.getInstance().setObject('mWindowStage', windowStage);
    this.loadWindowStage(windowStage, pageUrl);
  }

  loadWindowStage(windowStage: window.WindowStage, pageUrl: string) {
    LogUtil.warn(this.tag, `loadWindowStage ${pageUrl}`);
    windowStage?.loadContent(pageUrl).then(() => {
      windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
      windowStage.getMainWindow().then((mainWindow) => {
        mainWindow.setWindowBrightness(1)
        mainWindow.setWindowBackgroundColor(STATUS_BAR_COLOR);
        WindowManager.getInstance().setWindowLayoutFullScreen(true);
        WindowManager.getInstance().setHideNonSystemFloatingWindows(true);
        windowStage.disableWindowDecor();
        this.monitorKeyboardHeightChanged();
      }).catch((error: BusinessError) => {
        LogUtil.error(this.tag, `loadWindowStage failed, code: ${error.code}, message: ${error.message}`);
      });
    }).catch((err: BusinessError) => {
      LogUtil.error(this.tag, 'loadContent：err.code:' + err?.code + 'err.message:' + err?.message);
    });
  }

  /**
   * 配置状态栏及导航栏
   */
  configSystemBar(window: window.Window): void {
    LogUtil.info(this.tag, 'configSystemBar');
  }

  onDestroy(): void {
    super.onDestroy();
    WindowManager.getInstance().unMonitorKeyboardHeightChanged();
  }

  onForeground(): void {
    WindowManager.getInstance().setHideNonSystemFloatingWindows(true);
    ShipModeManager.getInstance().setOobeForeground(true);
    let currentKey: PageKey | undefined = PageOrderController.getInstance().getCurPageController()?.getKey();
    if (currentKey === PageKey.LANGUAGE_SELECT || currentKey === PageKey.WELCOME) {
      const manager = ShipModeManager.getInstance();
      manager.setExitShipMode(false);
      manager.enter();
      ShutdownManager.getInstance().change();
    }
    LogUtil.warn(this.tag, `onForeground currentKey:${currentKey}`);
  }

  onBackground(): void {
    WindowManager.getInstance().setHideNonSystemFloatingWindows(false);
    // 采用同步方式，避免进入后台休眠，导致收不到事件
    ShipModeManager.getInstance().setOobeForeground(false);
    // 直接打印出在哪个界面让OOBE进入的后台，比如数据导入有启用手势，如果在数据导入让OOBE进入后台，则是接入方问题
    let currentKey: PageKey | undefined = PageOrderController.getInstance().getCurPageController()?.getKey();
    let isOobeFinish: boolean = SceneTypeManager.getInstance().getOobeFinish();
    LogUtil.warn(this.tag, `onBackground currentKey:${currentKey}, isOobeFinish:${isOobeFinish}`);
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    // 如果key是uiextention接入的，则有界面刷新风险
    let currentKey: PageKey | undefined = PageOrderController.getInstance().getCurPageController()?.getKey();
    LogUtil.warn(this.tag, `onConfigurationUpdate newConfig ${currentKey}.`);
    super.onConfigurationUpdate(newConfig);
  }

  /**
   * 监听键盘高度
   * @param proxy
   */
  private monitorKeyboardHeightChanged(): void {
    setTimeout(() => {
      WindowManager.getInstance().monitorKeyboardHeightChanged();
    }, CommonConstant.DELAY_TIME);
  }
}
