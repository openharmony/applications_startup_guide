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
import {
  IPageController,
  LogUtil,
  DeviceUtil,
  ResourceUtil,
  StringUtil,
  ProductionAppManager,
  UpdatingInTheAirManager
} from '@ohos/hwstartupguide.common';
import {
  WelcomePageController,
  WelcomeComp,
  EnterpriseDeviceManager,
  OfflineTriggerType
} from '@ohos/hwstartupguide.welcome';
// import { languageAndRegionModel } from '@ohos/hwstartupguide.languageselect';

const TAG: string = 'WelcomeComponent';
const IS_DEVICE_PAD: boolean = DeviceUtil.isDevicePad();

@Builder
export function WelcomeComponentLoader($$: IPageController | null | undefined): void {
  WelcomeComponent({ mPageController: $$ as WelcomePageController });
}

/**
 * 开机向导欢迎页
 */
@Component
export struct WelcomeComponent {
  protected mPageController: WelcomePageController | null = null;

  build() {
    WelcomeComp({
      firstSrcPath: '',
      secondSrcPath: '',
      yHeight: '86.0%',
      isAutoPlaySecond: false,
      accessibilityReadingText: ResourceUtil.getStringByResource($r('app.string.continue')),
      buttonOnClick: () => {
        if (!StringUtil.isFastClick()) {
          this.continue();
        }
      }
    })
      .onTouch((event?: TouchEvent) => {
      if (event) {
        if (event.type === TouchType.Up && event.source === SourceType.TouchScreen) {
          EnterpriseDeviceManager.getInstance().handleOfflineTrigger(OfflineTriggerType.Touch);
        }
      }
    })
  }

  private continue(): void {
    if (IS_DEVICE_PAD) {
      UpdatingInTheAirManager.getInstance().stop();
    }
    this.mPageController?.handleNextButtonClick();
  }

  /*
   * Original welcome page video background (requires welcome_*.mp4 in rawfile):
   *
   * fullSrcPath from mediaConfigManager FIRST_WELCOME_ONE/TWO
   * setVideoPath(screenState) + fold screen listener
   */

  aboutToAppear(): void {
    ProductionAppManager.getInstance().checkOemInfoAndPullApp(() => {
    });
    LogUtil.info(TAG, 'aboutToAppear');
    if (IS_DEVICE_PAD) {
      UpdatingInTheAirManager.getInstance().start();
    }
    EnterpriseDeviceManager.getInstance().registerKeysIntercept();
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
    EnterpriseDeviceManager.getInstance().unRegisterKeyIntercept();
    EnterpriseDeviceManager.getInstance().clearTimers();
  }
}
