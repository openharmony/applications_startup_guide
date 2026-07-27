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

import UIAbility from '@ohos.app.ability.UIAbility';
import { BusinessError } from '@ohos.base';
import { PageAction } from '../model/PageAction';
import { LogUtil } from '../util/LogUtil';
import { HiSysEventUtil } from '../util/HiSysEventUtil';
import { CommonConstant } from '../constant/CommonConstant';
import { PageConfig } from '../model/config/PageConfig';
import { PageConfigManager } from '../manager/PageConfigManager';
import { IPageController } from './IPageController';
import { IPageOrderController } from './IPageOrderController';
import { EventEmitter } from '../event/EventEmitter';
import { Event } from '../event/Event';
import { BgVideoPlayerManager, PlayState } from '../manager/BgVideoPlayerManager';
import { GlobalContext } from '../context/GlobalContext';
import { PageKey } from '../constant/PageKey';
import { RawFileUtil } from '../util/RawFileUtil';
import { OOBEUtil } from '../util/OOBEUtil';

export const ADD_STEP_ONE: number = 1;

/**
 * 页面控制器基类
 */
export abstract class BasePageController implements IPageController {
  protected mUIAbility: UIAbility = GlobalContext.getInstance().getObject('guideHomeAbility') as UIAbility;
  protected mPageOrderController: IPageOrderController;
  protected pageConfig: PageConfig | undefined;
  private controllerKey: PageKey;
  protected mNeedShow: boolean = true;

  /**
   * 构造函数
   * @param pageOrderController 页面顺序控制器
   * @param uiAbility uiAbility
   */
  public constructor(pageOrderController: IPageOrderController, controllerKey: PageKey) {
    this.mPageOrderController = pageOrderController;
    this.controllerKey = controllerKey;
  }

  /**
   * 发射事件
   */
  emitEvent(event: Event): void {
    EventEmitter.getInstance().emit(event);
  }

  /**
   * 初始化页面配置
   */
  initPageConfig(): void {
    this.pageConfig = PageConfigManager.getInstance().getPageConfig(this.controllerKey);
  }

  /**
   * 获取页面配置
   */
  getPageConfig(): PageConfig | undefined | null {
    return this.pageConfig;
  }

  /**
   * 获取控制器配置key
   */
  getKey(): PageKey {
    return this.controllerKey;
  }

  /**
   * 设置可见性
   */
  configNeedShow(): void {
  }

  /**
   * 设置指定页是否可见
   */
  setNeedShow(isShow: boolean): void {
    LogUtil.info(this.getKey(), `set isShow as ${isShow}`);
    this.mNeedShow = isShow;
  }

  /**
   * 是否需要显示
   */
  isNeedShow(): boolean {
    LogUtil.info(this.getKey(), `NeedShow is ${this.mNeedShow}`);
    return this.mNeedShow;
  }

  /**
   * 获取Ability
   */
  getAbility(): UIAbility | null {
    return this.mUIAbility;
  }

  /**
   * 获取页面顺序控制器
   */
  getPageOrderController(): IPageOrderController {
    return this.mPageOrderController;
  }

  /**
   * 点击上一页
   */
  handlePrevButtonClick(): void {
    let currentKey: PageKey | undefined = this.mPageOrderController.getCurPageController()?.getKey();
    if (currentKey !== this.getKey()) {
      // 当前页面不响应其他页面的上一步点击
      LogUtil.warn(this.getKey(), `last key handlePrevButtonClick. current key ${currentKey} do nothing`);
      return;
    }
    LogUtil.info(this.getKey(), 'click prev button.');
    HiSysEventUtil.reportUserEvent(CommonConstant.PRE_PAGE_BUTTON, `${this.getKey()}`);
    if (this.mPageOrderController) {
      this.mPageOrderController.showPrevPage();
    } else {
      LogUtil.error(this.getKey(), 'click prev button failed. mPageOrderController is null.');
      HiSysEventUtil.reportErrorEvent(CommonConstant.PAGE_REDIRECTION_EXCEPTION, 'err: mPageOrderController is null.');
    }
  }

  /**
   * 点击下一页
   */
  handleNextButtonClick(): void {
    let currentKey: PageKey | undefined = this.mPageOrderController.getCurPageController()?.getKey();
    if (currentKey !== this.getKey()) {
      // 当前页面不响应其他页面的下一步点击
      LogUtil.warn(this.getKey(), `last key handleNextButtonClick. current key ${currentKey} do nothing`);
      return;
    }
    LogUtil.info(this.getKey(), 'click next button.');
    OOBEUtil.addPageButtonMap(currentKey, `${currentKey}_${new Date().toString()}`);
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${this.getKey()}`);
    if (this.mPageOrderController === null || this.mPageOrderController === undefined) {
      LogUtil.error(this.getKey(), 'click next button failed. mPageOrderController is null.');
      HiSysEventUtil.reportErrorEvent(CommonConstant.PAGE_REDIRECTION_EXCEPTION, 'err: mPageOrderController is null.');
      return;
    }
    this.mPageOrderController.showNextPage();
  }

  /**
   * 加载当前页面
   * @param pageAction
   */
  loadPage(pageAction: PageAction): void {
    LogUtil.info(this.getKey(), `Load oobe page, pageAction:${pageAction},url:${this.getKey()}`);
    AppStorage.setOrCreate<number>(CommonConstant.PAGE_ACTION, pageAction);
    let value: number | undefined = AppStorage.Get<number>('refreshId');
    AppStorage.Set<number>('refreshId', value !== undefined ? value + ADD_STEP_ONE : ADD_STEP_ONE);
    BgVideoPlayerManager.getInstance()
      .playVideo(pageAction === PageAction.ACTION_PREVIOUS ? PlayState.BACK : PlayState.ENTER, this.getKey());
    AppStorage.setOrCreate<boolean>('isNextClick', pageAction === PageAction.ACTION_PREVIOUS ? false : true);
    AppStorage.setOrCreate<boolean>('isExperiencePage', this.getPageOrderController()?.isExperiencePage());
  }

  handleFastClone(): boolean {
    return false;
  }

  /**
   * 加载页面所需资源
   */
  loadData(): void {
  }

  /**
   * page中的aboutToAppear
   */
  public pageAppear(): void {
    LogUtil.info(this.getKey(), 'controller pageAppear');
  }

  /**
   * page中的aboutToDisappear
   */
  public pageDisappear(): void {
    LogUtil.info(this.getKey(), 'controller pageDisappear');
  }

  /**
   * 加载对应的动画
   *
   * @param lottieName  lottie的json名称
   * @param callback 回调函数
   */
  public loadLottieData(lottieName: string, callback: (value: object) => void): void {
    RawFileUtil.getLottieData(lottieName).then((data: object) => {
      callback(data);
    }).catch((err: BusinessError) => {
      LogUtil.error(this.getKey(), `loadLottieData error:${err.code} ${err.message}`);
    });
  }
}