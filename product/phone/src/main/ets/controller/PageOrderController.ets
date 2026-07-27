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
  BasePageController,
  BasePageOrderController,
  FirstDefaultPageManager,
  LogUtil,
  PageKey,
  SceneType,
  SceneTypeManager
} from '@ohos/hwstartupguide.common';
import { BasicServicePageController } from '@ohos/hwstartupguide.basicservice';
import { EnhanceServicePageController } from '@ohos/hwstartupguide.enhanceservice';
import { RegionSelectPageController } from '@ohos/hwstartupguide.regionselect';
import { LanguageSelectPageController } from '@ohos/hwstartupguide.languageselect';
import { WelcomePageController } from '@ohos/hwstartupguide.welcome';
import {
  ExperiencePageController,
} from '@ohos/hwstartupguide.experience';
import { WlanPageController } from './external/WlanPageController';
import { LoadingPageController } from '@ohos/hwstartupguide.upgradeguide';

/**
 * 页面控制器
 */
export class PageOrderController extends BasePageOrderController {
  private static instance?: PageOrderController;

  private constructor() {
    super();
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  public static getInstance(): PageOrderController {
    if (!PageOrderController.instance) {
      PageOrderController.instance = new PageOrderController();
    }
    return PageOrderController.instance;
  }

  /**
   * 获取this.getTag()标记
   */
  getTag(): string {
    return 'PageOrderController';
  }

  /**
   * 初始化页面控制器Map
   */
  initControllerMap(): void {
    LogUtil.info(this.getTag(), 'initControllerMap start');
    this.mControllerMap = new Map<string, BasePageController>();
    let type = SceneTypeManager.getInstance().getSceneType();
    if (type === SceneType.FIRST_BOOT_SCENE) {
      this.initFirstBootSceneMap();
    } else if (type === SceneType.SUB_USER_SCENE) {
      LogUtil.info(this.getTag(), 'sub user scenario');
      this.initSubUserSceneMap();
    } else if (type === SceneType.OTA_SCENE) { // ota场景
      LogUtil.info(this.getTag(), 'ota scenario');
      this.mControllerMap.set(PageKey.LOADING, new LoadingPageController(this));
      this.mControllerMap.set(PageKey.BASIC_SERVICE, new BasicServicePageController(this));
      // 判断OTA升级协议是否变更，若变更则显示协议变更界面
      this.mControllerMap.set(PageKey.SERVICE_CHANGED, new EnhanceServicePageController(this));
      this.mControllerMap.set(PageKey.EXPERIENCE_NOW, new ExperiencePageController(this));
    } else {
      LogUtil.info(this.getTag(), 'initControllerMap not match');
    }
  }

  /**
   * 首次开机、恢复出厂设置场景
   */
  private initFirstBootSceneMap(): void {
    LogUtil.info(this.getTag(), 'first boot scene');
    let firstController: BasePageController = new WelcomePageController(this, PageKey.WELCOME);
    FirstDefaultPageManager.getInstance().setDefaultFirstPage(PageKey.WELCOME, firstController);
    this.mControllerMap.set(PageKey.WELCOME, firstController);
    this.mControllerMap.set(PageKey.LANGUAGE_SELECT, new LanguageSelectPageController(this));
    this.mControllerMap.set(PageKey.REGION_SELECT, new RegionSelectPageController(this));
    this.mControllerMap.set(PageKey.BASIC_SERVICE, new BasicServicePageController(this));
    this.mControllerMap.set(PageKey.ENHANCED_SERVICE, new EnhanceServicePageController(this));
    this.mControllerMap.set(PageKey.WLAN_KEY, new WlanPageController(this));
    this.mControllerMap.set(PageKey.EXPERIENCE_NOW, new ExperiencePageController(this));
  }

  /**
   * 新建子用户 / 切换子用户场景：复用首启页面流程。
   * 不注册 OTA 专用的 loading / service_changed，避免地区页与协议页之间闪过加载页，
   * 以及协议页返回时落到 loading 又自动前进导致无法返回。
   */
  private initSubUserSceneMap(): void {
    LogUtil.info(this.getTag(), 'sub user scene');
    this.initFirstBootSceneMap();
  }
}

