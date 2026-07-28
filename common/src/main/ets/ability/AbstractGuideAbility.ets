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
import errorManager from '@ohos.app.ability.errorManager';
import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import { BusinessError } from '@ohos.base';
import emitter from '@ohos.events.emitter';
import { Configuration } from '@ohos.app.ability.Configuration';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { AbilityManager } from '../manager/AbilityManager';
import { FontSizeAdjustUtil } from '../util/FontSizeAdjustUtil';
import { LogUtil } from '../util/LogUtil';
import { HiSysEventUtil } from '../util/HiSysEventUtil';
import { CommonConstant } from '../constant/CommonConstant';
import { GlobalContext } from '../context/GlobalContext';
import { Event } from '../event/Event';

const INVALID_ID: number = -1;

/**
 * 开机向导抽象父ability
 */
export abstract class AbstractGuideAbility extends UIAbility {
  private errorObserverId: number = INVALID_ID;
  private systemLanguage: string | undefined = '';
  protected tag: string = 'AbstractGuideAbility';
  private isAppHasBeenStarted: boolean = false;

  onCreate(): void {
    LogUtil.info(this.tag, 'onCreate');
    if (!this.generalProcess()) {
      return;
    }
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
    } catch (error) {
      LogUtil.error(this.tag, `setColorMode error ${error?.code}`);
    }
    FontSizeAdjustUtil.setFontSizeScaleOnRestart();
    LogUtil.info(this.tag, 'onCreate over');
  }

  generalProcess(): boolean {
    if (this.isAppHasBeenStarted === true) {
      LogUtil.warn(this.tag, 'onCreate return. Ability has been started');
      return false;
    }
    this.isAppHasBeenStarted = true;
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, 'oobe started');
    this.context.area = 0;
    AbilityManager.getInstance().setContext(this.context);
    GlobalContext.getInstance().setObject('guideHomeAbility', this);
    this.registerErrorObserver();
    return true;
  }

  /**
   * 配置状态栏及导航栏
   */
  abstract configSystemBar(window: window.Window): void;

  onWindowStageDestroy(): void {
    LogUtil.warn(this.tag, 'onWindowStageDestroy');
    AbilityManager.getInstance().setContext(null);
    GlobalContext.getInstance().setObject('mPageOrderController', null);
  }

  onForeground(): void {
    LogUtil.info(this.tag, 'onForeground');
  }

  onBackground(): void {
    LogUtil.info(this.tag, 'onBackground');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.EVENT_LANGUAGE_CHANGED} ${newConfig.language}`);
    if (newConfig?.language !== this.systemLanguage) {
      emitter.emit(Event.LANGUAGE_CONFIGURATION_UPDATE);
    }
    this.systemLanguage = newConfig.language;
  }

  onDestroy(): void {
    LogUtil.info(this.tag, 'onDestroy');
    emitter.off(Event.LANGUAGE_CONFIGURATION_UPDATE);
    this.unregisterErrorObserver();
  }

  private registerErrorObserver(): void {
    let observer: errorManager.ErrorObserver = {
      onUnhandledException(errorMsg) {
        LogUtil.error(this.tag, `onUnhandledException`, errorMsg);
        HiSysEventUtil.reportErrorEvent(CommonConstant.RUN_SERVIVCES_FAILED, `onUnhandledException err:${errorMsg}`);
      },
      onException(errorObj) {
        LogUtil.error(this.tag, `onException`, errorObj);
        HiSysEventUtil.reportErrorEvent(CommonConstant.RUN_SERVIVCES_FAILED, `onException err: name:${errorObj?.name}, message:${errorObj?.message}`);
        if (typeof (errorObj?.stack) === 'string') {
          LogUtil.debug(this.tag, `onException, stack:${errorObj?.stack}`);
        }
      }
    };

    try {
      this.errorObserverId = errorManager.on('error', observer);
    } catch (paramError) {
      LogUtil.error(this.tag, `error: ${paramError?.code}, ${paramError?.message}`);
      HiSysEventUtil.reportErrorEvent(CommonConstant.RUN_SERVIVCES_FAILED,
        `registerErrorObserver err: ${paramError?.code}, ${paramError?.message}`);
    }
  }

  private unregisterErrorObserver(): void {
    if (this.errorObserverId !== INVALID_ID) {
      try {
        errorManager.off('error', this.errorObserverId)
          .then((data) => {
            LogUtil.info(this.tag, 'unregisterErrorObserver success');
          })
          .catch((err: BusinessError) => {
            LogUtil.error(this.tag, `unregisterErrorObserver fail errMsg:${err.message} errCode:${err.code}`);
          });
      } catch (paramError) {
        LogUtil.error(this.tag, `error: ${paramError?.code}, ${paramError?.message}`);
        HiSysEventUtil.reportErrorEvent(CommonConstant.RUN_SERVIVCES_FAILED,
          `registerErrorObserver err: ${paramError?.code}, ${paramError?.message}`);
      }
    }
  }
}
