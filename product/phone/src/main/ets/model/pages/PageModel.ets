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
import Window from '@ohos.window';
import MediaQuery from '@ohos.mediaquery';
import {
  AbilityType,
  ColumnSystemManager,
  CommonConstant,
  DeviceUtil,
  FirstDefaultPageManager,
  HiSysEventUtil,
  IPageController,
  LogUtil,
  PageAction,
  PageConfig,
  PageKey,
  pageLayoutManager,
  PowerManager,
  WindowManager,
  SceneType,
  SceneTypeManager,
  FirstPage,
  ScreenState,
  ScreenStateModel,
  ScreenStateMonitor
} from '@ohos/hwstartupguide.common';
import { PageOrderController } from '../../controller/PageOrderController';
import { BaseUtil } from '../../util/BaseUtils';

const TAG: string = 'OOBEPageModel';

export class PageModel {
  protected mComponentLoaderMap: Map<String, ($$: IPageController | null | undefined) => void> =
    new Map<String, ($$: IPageController | null | undefined) => void>();
  public mPageController: IPageController | null = null;
  public mPageConfigs: Array<PageConfig | null | undefined>;
  private preRefreshUI: number[] = [];
  public setComponentLoader: (func: ($$: IPageController | null | undefined) => void) => void =
    (func: ($$: IPageController | null | undefined) => void) => {
    };
  private orientationListener: MediaQuery.MediaQueryListener | undefined = undefined;

  constructor(pageConfigs: Array<PageConfig | null | undefined>, preRefreshUI: number[],
              loaderMap: Map<String, ($$: IPageController | null | undefined) => void>,
              componentLoader: (func: ($$: IPageController | null | undefined) => void) => void) {
    this.mPageConfigs = pageConfigs;
    this.preRefreshUI = preRefreshUI;
    this.mComponentLoaderMap = loaderMap;
    this.setComponentLoader = componentLoader;
  }

  public refreshUI(refreshId: number): boolean {
    if (this.preRefreshUI[0] === refreshId) {
      LogUtil.info(TAG, `refreshUI with refreshId: ${refreshId} they are equal`);
      return false;
    } else {
      this.preRefreshUI[0] = refreshId;
    }
    let pageConfig: PageConfig | undefined | null;
    if (!PageOrderController.getInstance().isReady()) {
      LogUtil.info(TAG, 'pageController init null.');
      HiSysEventUtil.reportErrorEvent(CommonConstant.BS_OPERATION_FAILED, `Init err}`);

      let firstPage: FirstPage | null = FirstDefaultPageManager.getInstance().getDefaultFirstPage();
      if (firstPage === null) {
        LogUtil.warn(TAG, 'firstPage is null');
        return true;
      }
      pageConfig = firstPage.getPageConfig();
      this.mPageController = firstPage.getPageController();
    } else {
      LogUtil.info(TAG, 'pageController init ok');
      this.mPageController = PageOrderController.getInstance().getNextEnableShowPage();
      pageConfig = this.mPageController?.getPageConfig();
    }
    LogUtil.info(TAG, `refreshUI with refreshId: ${refreshId}, pageConfig key: ${pageConfig?.getKey()}`);
    this.initOobeInnerComponent(pageConfig).then(() => {
      this.mPageConfigs.splice(0, this.mPageConfigs.length);
      let params = pageConfig?.getParams();
      if (params) {
        let pageAction = AppStorage.get<number>(CommonConstant.PAGE_ACTION);
        if (!pageAction) {
          pageAction = PageAction.ACTION_DEFAULT;
        }
        params[CommonConstant.PAGE_ACTION] = pageAction;
        pageConfig?.setParams(params);
      }
      this.mPageConfigs.push(pageConfig);
      if (this.mComponentLoaderMap.has(this.mPageConfigs[0]!!.getKey())) {
        this.setComponentLoader(this.mComponentLoaderMap.get(this.mPageConfigs[0]!!.getKey())!!);
      }
      PageConfig.refreshPageConfigsArr(this.mPageConfigs);
    });
    return true;
  }

  /**
   * 调整屏幕方向
   */
  public adjustOrientation(): void {
    this.setOrientation(ScreenStateMonitor.getInstance().getCurrentScreenStateModel());
    ScreenStateMonitor.getInstance().registerScreenStateChangeListener('ORIENTATION',
      (oldScreenState: ScreenStateModel, screenState: ScreenStateModel) => {
        this.setOrientation(screenState);
      });
  }

  /**
   * 设置屏幕方向，Pad暂时强制横屏，F态、M态（包括双折叠机型）强制竖屏，G态可旋转
   *
   * @param screenState 屏幕状态
   */
  public setOrientation(screenState: ScreenStateModel): void {
    if (pageLayoutManager.getPageLayoutConfig().screenState) {
      pageLayoutManager.setOrientationByChange();
      return;
    }
    if (DeviceUtil.isDevicePad()) {
      if (BaseUtil.isPortrait()) {
        WindowManager.setWindowOrientation((AppStorage.get<Window.WindowStage>('windowStage') as Window.WindowStage),
          Window.Orientation.PORTRAIT);
        LogUtil.info(TAG, 'orientation set to PORTRAIT.');
      } else {
        WindowManager.setWindowOrientation((AppStorage.get<Window.WindowStage>('windowStage') as Window.WindowStage),
          Window.Orientation.LANDSCAPE);
        LogUtil.info(TAG, 'orientation set to LANDSCAPE.');
      }
    } else if (screenState.screenState === ScreenState.F || screenState.screenState === ScreenState.M) {
      WindowManager.setWindowOrientation((AppStorage.get<Window.WindowStage>('windowStage') as Window.WindowStage),
        Window.Orientation.PORTRAIT);
      LogUtil.info(TAG, 'orientation set to PORTRAIT.');
    } else if (screenState.screenState === ScreenState.G) {
      WindowManager.setWindowOrientation((AppStorage.get<Window.WindowStage>('windowStage') as Window.WindowStage),
        Window.Orientation.AUTO_ROTATION);
      LogUtil.info(TAG, 'orientation set to AUTO_ROTATION.');
    }
  }

  /**
   * 缓存OobeInnerComponent
   * @param pageConfig 页面配置
   * @returns 是否缓存成功
   */
  public async initOobeInnerComponent(pageConfig: PageConfig | null | undefined): Promise<boolean> {
    if (!pageConfig || !pageConfig.getKey()) {
      LogUtil.error(TAG, 'Invalid pageConfig');
      return false;
    }

    if (pageConfig.getType() === AbilityType.EXTERNAL_ABILITY) {
      LogUtil.info(TAG, 'External pageConfig.');
      return true;
    }

    if (this.mComponentLoaderMap.get(pageConfig.getKey())) {
      return true;
    }

    await this.initComponentLoaderMap(pageConfig);
    return this.mComponentLoaderMap.get(pageConfig.getKey()) !== null && this.mComponentLoaderMap
      .get(pageConfig.getKey()) !== undefined;
  }

  private async initComponentLoaderMap(pageConfig: PageConfig): Promise<void> {
    // TipsInnerFilm相关组件已被删除，移除相关代码
    // Let, import 只支持字符常量,所以不能使用map之类的变量。
    if (pageConfig.getKey() === PageKey.REGION_SELECT) {
      let regionSelectComponent = await import('../../components/regionselect/RegionSelectComponent');
      this.mComponentLoaderMap.set(PageKey.REGION_SELECT, regionSelectComponent.RegionSelectComponentLoader);
    } else if (pageConfig.getKey() === PageKey.LANGUAGE_SELECT) {
      let languageSelectComponent = await import('../../components/languageselect/LanguageSelectComponent');
      this.mComponentLoaderMap.set(PageKey.LANGUAGE_SELECT,
        languageSelectComponent.LanguageSelectComponentLoader);
    } else if (pageConfig.getKey() === PageKey.EXPERIENCE_NOW) {
      let experienceComponent = await import('../../components/experience/ExperienceComponent');
      this.mComponentLoaderMap.set(PageKey.EXPERIENCE_NOW, experienceComponent.ExperienceComponentLoader);
    } else if (pageConfig.getKey() === PageKey.BASIC_SERVICE) {
      let basicServiceComponent = await import('../../components/basicservice/BasicServiceComponent');
      this.mComponentLoaderMap.set(PageKey.BASIC_SERVICE, basicServiceComponent.BasicServiceComponentLoader);
    } else if (pageConfig.getKey() === PageKey.ENHANCED_SERVICE) {
      let enhancedServiceComponent = await import('../../components/enhanceservice/EnhanceServiceComponent');
      this.mComponentLoaderMap.set(PageKey.ENHANCED_SERVICE,
        enhancedServiceComponent.EnhanceServiceComponentLoader);
    } else if (pageConfig.getKey() === PageKey.WELCOME) {
      let welcomeComponent = await import('../../components/welcome/WelcomeComponent');
      this.mComponentLoaderMap.set(PageKey.WELCOME, welcomeComponent.WelcomeComponentLoader);
    } else if (pageConfig.getKey() === PageKey.LOADING) {
      let loadingComponent = await import('../../components/upgradeguide/LoadingComponent');
      this.mComponentLoaderMap.set(PageKey.LOADING, loadingComponent.LoadingComponentLoader);
    } else if (pageConfig.getKey() === PageKey.SERVICE_CHANGED) {
      let serviceStatementComponent = await import('../../components/enhanceservice/EnhanceServiceComponent');
      this.mComponentLoaderMap.set(PageKey.SERVICE_CHANGED,
        serviceStatementComponent.EnhanceServiceComponentLoader);
    } else {
      LogUtil.warn(TAG, `Invalid key:${pageConfig.getKey()}`);
    }
  }

  public addOrientationListener(): void {
    this.orientationListener = MediaQuery.matchMediaSync('(orientation: landscape)');
    this.orientationListener.on('change', (res) => {
      if (res.matches) {
        AppStorage.setOrCreate('isPortraitOrientation', false);
      } else {
        AppStorage.setOrCreate('isPortraitOrientation', true);
      }
    })
  }

  public aboutToAppear(refreshId: number): void {
    this.adjustOrientation();
    // 添加平板页面横竖屏监听器
    if (DeviceUtil.isDevicePad()) {
      this.addOrientationListener();
    }
    ColumnSystemManager.getInstance().registerMediaQuery();
    PowerManager.getInstance().registerListener();
    this.refreshUI(refreshId);
  }

  aboutToDisappear(): void {
    // 销毁平板页面横竖屏监听器
    if (DeviceUtil.isDevicePad()) {
      this.orientationListener?.off('change');
    }
    ColumnSystemManager.getInstance().unregisterMediaQuery();
    PowerManager.getInstance().unregisterListener();
    ScreenStateMonitor.getInstance().unRegisterScreeStateChangeListener('ORIENTATION');
  }
}

