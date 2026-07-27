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
  AbilityType,
  BgVideoPlayerManager,
  DeviceUtil,
  IPageController,
  LogUtil,
  PageConfig,
  PageKey,
  TimeOutUtil,
  mediaConfigManager,
  MediaConfigConstants,
  WindowManager,
  pageLayoutManager,
  ScreenStateModel,
  ScreenStateMonitor
} from '@ohos/hwstartupguide.common';
import { ExternalPageComponent } from '../components/common/ExternalPageComponent';
import { PageModel } from '../model/pages/PageModel';
import { PageOrderController } from '../controller/PageOrderController';
import { OuterPageComponent } from '../components/common/OuterPageComponent';

const TAG: string = 'OOBE_Page';
const IS_DEVICE_FOLD: boolean = DeviceUtil.isFold();
const IS_DEVICE_SMALL_FOLD: boolean = DeviceUtil.isSmallFoldScreen();
const OFFSET_DISTANCE: number = 10;
const ANIMATOR_TIME: number = 2500;
const ANIMATOR_TOTAL_TIME: number = 15000;

@Builder
export function dummyFunction() {
}

@Entry
@Component
struct Page {
  // 控制内外屏显隐
  @State externalPageVisible: Visibility = Visibility.None;
  // 页面刷新依赖于此成员变量
  @State mPageConfigs: Array<PageConfig | null | undefined> = [new PageConfig('')];
  @State bgTranslate: number = -OFFSET_DISTANCE;
  @State bgImagePath: Resource | string = '';
  @StorageLink('refreshId') refreshId: number = 1;
  @StorageLink('isPortraitOrientation') isPortraitOrientation: boolean = false;
  @StorageLink('isScreenOn') @Watch('playConditionChange')isScreenOn: boolean = true;
  // 是否打开半模态弹窗，弹窗打开时背景微动效暂停
  @StorageLink('isBindSheetOff') @Watch('playConditionChange')isBindSheetOff: boolean = true;

  private preRefreshUI: number[] = [-1];
  private loaderMap: Map<String, ($$: IPageController | null | undefined) => void> =
    new Map<String, ($$: IPageController | null | undefined) => void>();
  @BuilderParam currentComponentLoader: ($$: IPageController | null | undefined) => void = dummyFunction;
  private pageModel: PageModel | undefined = undefined;
  private timeOutUtil: TimeOutUtil = new TimeOutUtil(ANIMATOR_TOTAL_TIME, (): void => {
    this.playAnim(false)
  }, TAG)

  /**
   * 背景微动效播放条件变更时触发
   */
  private playConditionChange(): void {
    LogUtil.info(TAG, `playConditionChange isScreenOn :${this.isScreenOn}, isBindSheetOff :${this.isBindSheetOff}`);
    if (this.isScreenOn && this.isBindSheetOff) {
      return;
    } else {
      this.playAnim(false);
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      this.loadBgImageComponent();
      // 业务页面Component
      this.loadPageComponent();
      this.loadOuterPageComponent();
    }
    // 为了触发刷新
    .visibility(this.refreshId && this.pageModel?.refreshUI(this.refreshId) ? Visibility.Visible : Visibility.Visible)
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    // 添加折叠屏展开监听器
    if (IS_DEVICE_FOLD) {
      this.addFoldedListener();
    }
    this.setBgImagePath(ScreenStateMonitor.getInstance().getCurrentScreenStateModel());
    this.externalPageControl();
    BgVideoPlayerManager.getInstance().setUseStaticBg(true);
    PageOrderController.getInstance().handleControllerArray();
    this.pageModel = new PageModel(this.mPageConfigs, this.preRefreshUI, this.loaderMap,
      (func: ($$: IPageController | null | undefined) => void) => {
      LogUtil.info(TAG, `set component loader ${this.mPageConfigs[0]?.getKey()}`);
      this.currentComponentLoader = func;
    });
    LogUtil.info(TAG, `aboutToAppear with refreshId:${this.refreshId}`);
    this.pageModel?.aboutToAppear(this.refreshId);
  }

  aboutToDisappear(): void {
    // 销毁折叠屏展开监听器
    if (IS_DEVICE_FOLD) {
      ScreenStateMonitor.getInstance().unRegisterScreeStateChangeListener(TAG);
      LogUtil.info(TAG, 'unregister fold status display monitor.');
    }
    this.pageModel?.aboutToDisappear();
  }

  private addFoldedListener(): void {
    ScreenStateMonitor.getInstance().registerScreenStateChangeListener(TAG,
      (oldScreenState: ScreenStateModel, screenState: ScreenStateModel) => {
        this.setBgImagePath(screenState);
        this.externalPageControl();
        pageLayoutManager.updateByStatusChanged();
      });
  }

  private playAnim(isPlay: boolean): void {
    LogUtil.info(TAG, `playAnim isPlay: ${isPlay}`);
    let currentKey: PageKey | undefined = PageOrderController.getInstance().getCurPageController()?.getKey();
    LogUtil.info(TAG, `playAnim currentKey: ${currentKey}`);
    if (isPlay) {
      animateTo({
        duration: ANIMATOR_TIME,
        curve: Curve.Linear,
        playMode: PlayMode.Alternate,
        iterations: -1,
      },
        () => {
          this.bgTranslate = OFFSET_DISTANCE;
        });
    } else {
      animateTo({
        duration: 0,
      },
        () => {
          this.bgTranslate = -OFFSET_DISTANCE;
        });
    }
  }

  /**
   * 统一静态背景图（竖版）
   */
  @Builder
  loadBgImageComponent(): void {
    Column() {
      Image(this.bgImagePath)
        .width('100%')
        .height('100%')
        .scale({
          x: 1.1,
          y: 1.1
        })
        .translate({
          x: this.bgTranslate,
          y: this.bgTranslate
        })
        .objectFit(ImageFit.Cover)
        .accessibilityLevel('no-hide-descendants')
        .onComplete(() => {
          LogUtil.info(TAG, 'background image loaded');
          BgVideoPlayerManager.getInstance().isLoadFinished = true;
        })
        .onError(() => {
          LogUtil.warn(TAG, 'background image load error');
          PageOrderController.getInstance().handleControllerArray();
        })
    }
    .focusable(false)
    .width('100%')
    .height('100%')
  }

  /*
   * Original ball video background (requires ball_bg_*.mp4 in rawfile):
   *
   * loadBallVideoBgComponent() { Video({ src: this.videoPath, controller: this.controller }) ... }
   */

  /**
   * 设置统一竖版背景图资源
   */
  private setBgImagePath(screenState: ScreenStateModel): void {
    this.bgImagePath = mediaConfigManager.getMediaResource(MediaConfigConstants.BACKGROUND,
      MediaConfigConstants.PORTRAIT_SCREEN);
    LogUtil.info(TAG, `screenStateChange! use portrait background image, screenState: ${screenState.screenState}`);
  }

  /**
   * 控制内外屏进场时机 & 控制状态栏的显隐
   */
  private externalPageControl(): void {
    let isFolded = false;
    const isSmallFoldDevice = IS_DEVICE_FOLD && IS_DEVICE_SMALL_FOLD;
    try {
      if (isSmallFoldDevice) {
        isFolded = display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_FOLDED;
      }
    } catch (error) {
      LogUtil.error(TAG, `externalPageControl error: ${error?.code}, ${error?.message}`);
    }
    if (isFolded) {
      this.externalPageVisible = Visibility.Visible;
      WindowManager.getInstance().setWindowSystemBarEnable(false);
    } else {
      this.externalPageVisible = Visibility.None;
      WindowManager.getInstance().setWindowSystemBarEnable(true);
    }
  }

  @Builder
  loadPageComponent(): void {
      ForEach(this.mPageConfigs, (pageConfig: PageConfig) => {
        if (pageConfig.getType() !== AbilityType.EXTERNAL_ABILITY) {
          // OOBE内部页面Component
          this.currentComponentLoader(this.pageModel?.mPageController);
        } else if (pageConfig) {
          // 外部接入页面Component
          ExternalPageComponent({
            pageConfig: this.mPageConfigs[0],
            mPageController: this.pageModel?.mPageController,
          });
        }
      })
  }

  @Builder
  loadOuterPageComponent(): void {
    OuterPageComponent({ externalPageVisible: this.externalPageVisible })
  }
}