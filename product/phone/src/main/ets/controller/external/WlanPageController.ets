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

import {
  BaseExternalPageController,
  Event,
  FastCloneSceneManager,
  InternetManager,
  IPageOrderController,
  LogUtil,
  PageKey,
  CommonConstant,
  SceneTypeManager
} from '@ohos/hwstartupguide.common';

/**
 * WLAN业务声明控制器
 */
export class WlanPageController extends BaseExternalPageController {
  /**
   * 构造函数
   * @param pageOrderController 页面顺序控制器
   * @param controllerKey 控制器key
   */
  public constructor(pageOrderController: IPageOrderController) {
    super(pageOrderController, PageKey.WLAN_KEY);
  }

  isNeedShow(): boolean {
    if (FastCloneSceneManager.getInstance().isCloneWlan()) {
      // 如果走过快速克隆并迁移过wlan，则wlan界面是否显示，取决于有无网络
      let isNetConnected: boolean = InternetManager.getInstance().isNetConnected();
      let res: boolean = super.isNeedShow() && !isNetConnected;
      LogUtil.info(this.getKey(), `NeedShow is ${res},isNetConnected is ${isNetConnected}`);
      return res;
    } else {
      // 常规流程，原逻辑
      return super.isNeedShow();
    }
  }

  /**
   * 点击下一页
   */
  handleNextButtonClick(): void {
    LogUtil.info(this.getKey(), 'handleNextButtonClick');
    if (FastCloneSceneManager.getInstance().isFastCloneScene()) {
      this.emitEvent(Event.SETTING_UP_JUMP_WLAN_CONTINUE);
    } else {
      super.handleNextButtonClick();
    }
  }

  /**
   * 点击上一页
   */
  handlePrevButtonClick(): void {
    LogUtil.info(this.getKey(), 'handlePrevButtonClick');
    if (FastCloneSceneManager.getInstance().isFastCloneScene()) {
      this.emitEvent(Event.SETTING_UP_JUMP_WLAN_BACK);
    } else {
      super.handlePrevButtonClick();
    }
  }

  /**
   * page中的aboutToAppear
   */
  public pageAppear(): void {
    let params = this.pageConfig?.getParams();
    if (params) {
      params[CommonConstant.SCENE_TYPE] = SceneTypeManager.getInstance().getSceneType();
      let isFastCloneScene = FastCloneSceneManager.getInstance().isFastCloneScene();
      LogUtil.info(this.getKey(), `isFastCloneScene:  ${isFastCloneScene}`);
      params['isFastCloneScene'] = isFastCloneScene;
      this.pageConfig?.setParams(params);
    }
  }
}
