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
import display from '@ohos.display';
import {
  CommonConstant,
  EnterHomeComponent,
  IPageController,
  LogUtil,
  ExperiencePageComponent,
  StringUtil,
  DeviceUtil,
  ScreenSizeUtil,
  HiSysEventUtil,
  ExperienceManager,
  mediaConfigManager,
  MediaConfigConstants,
  ScreenState,
  ScreenStateModel,
  ScreenStateMonitor
} from '@ohos/hwstartupguide.common';
import { ExperiencePageController } from '@ohos/hwstartupguide.experience';
import { BaseUtil } from '../../util/BaseUtils';

const TAG: string = 'ExperienceComponent';
const IS_DEVICE_PAD: boolean = DeviceUtil.isDevicePad();
const IS_DEVICE_FOLD: boolean = DeviceUtil.isFold();
const IS_DEVICE_SMALL_FOLD: boolean = DeviceUtil.isSmallFoldScreen();

@Builder
export function ExperienceComponentLoader($$: IPageController | null | undefined): void {
  ExperienceComponent({ mPageController: $$ as ExperiencePageController });
}

/**
 * 立即体验
 */
@Component
export struct ExperienceComponent {
  protected mPageController: ExperiencePageController | null = null;
  @State videoPath: Resource | string = '';
  @State backgroundPath: Resource | string = '';
  @State mLogoWidth: number = 0;
  @State logoPosition: string = '45%';

  build() {
    ExperiencePageComponent({
      content: () => {
        this.buildPageContent();
      },
      onPageShow: () => {
        if (this.onPageShow) {
          this.onPageShow();
        }
      },
      onHidden: () => {
        if (this.onPageHide) {
          this.onPageHide();
        }
      },
    })
  }

  @Builder
  buildPageContent(): void {
    Stack() {
      EnterHomeComponent({
        // mLogoWidth: this.mLogoWidth + 'px', // 原 NEXT 横条 Logo 按屏宽像素计算
        mLogoWidth: this.mLogoWidth > 0 ? this.mLogoWidth + 'px' : '40%',
        srcPath: this.backgroundPath,
        logoPosition: this.logoPosition,
        // mLogoImage: $r('app.media.ic_next_logo_6'),
        mLogoImage: $r('app.media.ic_openharmony_logo'),
        buttonOnClick: () => {
          if (!StringUtil.isFastClick()) {
            this.continue();
          }
        }
      })
    }
    .width('100%')
    .height('100%')
    .align(Alignment.End)
    .alignContent(Alignment.Bottom)
  }

  private addFoldedListener(): void {
    ScreenStateMonitor.getInstance().registerScreenStateChangeListener(TAG,
      (oldScreenState: ScreenStateModel, screenState: ScreenStateModel) => {
        this.setBackgroundPath(screenState);
        this.setLogoWidth(screenState);
        this.getPosition(screenState);
      });
  }

  private getPosition(screenState?: ScreenStateModel): void {
    //竖屏平板
    if (BaseUtil.isPortrait() && DeviceUtil.isDevicePad()) {
      this.logoPosition = '36%';
      return;
    }
    //三折叠G态竖屏
    if (screenState?.screenState === ScreenState.G && ScreenSizeUtil.isScreenPortraitOrientation()) {
      this.logoPosition = '32%';
      return;
    }
    // this.logoPosition = '22%'; // 原固定 22% 导致 Logo 偏上
    this.logoPosition = '45%';
  }

  setVideoPath(screenState: ScreenStateModel): void {
    if (DeviceUtil.isUseLandscapeResource(screenState)) {
      // 平板设备、手机设备中小折叠屏的折叠状态、大折叠屏的展开状态、GL M态、GL G态用横屏资源
      this.videoPath = mediaConfigManager.getMediaResource(MediaConfigConstants.ENTER_HOME,
        MediaConfigConstants.LANDSCAPE_SCREEN);
      LogUtil.info(TAG, 'use landscape resource');
    } else {
      // 直板机、小折叠屏的展开状态、大折叠屏的收起状态、GL F态用竖屏资源
      this.videoPath = mediaConfigManager.getMediaResource(MediaConfigConstants.ENTER_HOME,
        MediaConfigConstants.PORTRAIT_SCREEN);
      LogUtil.info(TAG, 'use portrait resource');
    }
  }

  setBackgroundPath(screenState: ScreenStateModel): void {
    if (DeviceUtil.isUseLandscapeResource(screenState)) {
      this.backgroundPath = mediaConfigManager.getMediaResource(MediaConfigConstants.BACKGROUND,
        MediaConfigConstants.LANDSCAPE_SCREEN);
      LogUtil.info(TAG, 'use landscape background');
    } else {
      this.backgroundPath = mediaConfigManager.getMediaResource(MediaConfigConstants.BACKGROUND,
        MediaConfigConstants.PORTRAIT_SCREEN);
      LogUtil.info(TAG, 'use portrait background');
    }
  }

  private setLogoWidth(screenState: ScreenStateModel): void {
    if (BaseUtil.isPortrait() && IS_DEVICE_PAD) {
      this.mLogoWidth = 0;
      return;
    }
    // 双折叠、三折叠
    const isBigFoldDevice = IS_DEVICE_FOLD && !IS_DEVICE_SMALL_FOLD;
    let isUseExpandedScreen: boolean = false;
    try {
      if (isBigFoldDevice) {
        let foldStatus: display.FoldStatus = display.getFoldStatus();
        isUseExpandedScreen = foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED ||
          foldStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED;
        this.mLogoWidth = 0;
      } else {
        this.mLogoWidth = 0;
      }
      LogUtil.info(TAG,
        `isBigFoldDevice: ${isBigFoldDevice}, isUseExpandedScreen: ${isUseExpandedScreen}, setLogoWidth: ${this.mLogoWidth}`);
    } catch (error) {
      LogUtil.error(TAG, `setLogoWidth error: ${error?.code}, ${error?.message}`);
    }
  }

  @Builder
  componentContent(): void {
  }

  private continue(): void {
    this.mPageController?.handleNextButtonClick();
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToAppear');
    // 添加折叠屏展开监听器
    if (IS_DEVICE_FOLD) {
      this.addFoldedListener();
    }
    const screenState = ScreenStateMonitor.getInstance().getCurrentScreenStateModel();
    this.setBackgroundPath(screenState);
    this.setLogoWidth(screenState);
    this.getPosition(screenState);
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.COMPONENT_APPEAR}, ${TAG}`);
    ExperienceManager.getInstance().setIsPhone(true);
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.COMPONENT_DISAPPEAR}, ${TAG}`);
    ScreenStateMonitor.getInstance().unRegisterScreeStateChangeListener(TAG);
  }
}