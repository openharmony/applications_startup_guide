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
import emitter from '@ohos.events.emitter';
import { Event } from '../event/Event';
import { PageKey } from '../constant/PageKey';
import { FirstDefaultPageManager, FirstPage } from '../manager/FirstDefaultPageManager';
import { PageAction } from '../model/PageAction';
import { ArrayUtil } from '../util/ArrayUtil';
import { LogUtil } from '../util/LogUtil';
import { OOBEUtil } from '../util/OOBEUtil';
import { StringUtil } from '../util/StringUtil';
import { IPageController } from './IPageController';
import { IPageOrderController } from './IPageOrderController';
import { PageConfigManager } from '../manager/PageConfigManager';
import { GlobalContext } from '../context/GlobalContext';
import { SceneType, SceneTypeManager } from '../manager/SceneTypeManager';

const INDEX_STEP_ONE: number = 1;
const DEFAULT_PAGE_INDEX: number = 0;

/**
 * 页面排序控制器基类
 */
export abstract class BasePageOrderController implements IPageOrderController {
  public mPageIndex: number = DEFAULT_PAGE_INDEX;
  protected mControllerMap: Map<string, IPageController> = new Map<string, IPageController>();
  private mPageControllers: Array<IPageController> = [];
  private isReadyOfControllerArray: boolean = false;
  private isInitOfControllerArray: boolean = false;

  /**
   * 获取TAG标记
   */
  getTag(): string {
    return 'BasePageOrderController';
  }

  /**
   * 初始化
   */
  public async init(callback?: Function): Promise<void> {
    LogUtil.info(this.getTag(), 'init start');
    await SceneTypeManager.getInstance().init();
    if (callback) {
      callback();
    }
    this.initControllerMap();
    if (SceneTypeManager.getInstance().getSceneType() === SceneType.FIRST_BOOT_SCENE) {
      // 优化OOBE启动速度(仅首次刷机场景（controller较多效果明显）,后续视效果逐步放开)
      LogUtil.info(this.getTag(), 'init asyn end');
      return;
    }
    await this.handleControllerArray();
    LogUtil.info(this.getTag(), 'init end');
  }

  /**
   * 初始化页面控制器
   */
  abstract initControllerMap(): void;

  /**
   * 初始化页面控制器
   */
  async handleControllerArray(): Promise<void> {
    LogUtil.info(this.getTag(), `handleControllerArray:${this.isInitOfControllerArray}`);
    if (this.isInitOfControllerArray === true) {
      return;
    } else {
      this.isInitOfControllerArray = true;
      await PageConfigManager.getInstance().loadPageConfigs();
      this.initControllerArray();
    }
  }

  private initControllerArray(): void {
    let pageControllers: IPageController[] = [];
    let keys = PageConfigManager.getInstance().getPageConfigKeys();
    LogUtil.info(this.getTag(), `initControllerArray keys size:${keys.length} `);

    for (let key of keys) {
      let controller = this.mControllerMap.get(key);
      if (controller) {
        controller.initPageConfig();
        controller.configNeedShow();
        controller.loadData();
        pageControllers.push(controller);
      } else {
        LogUtil.warn(this.getTag(), `unExpected keys:${key}`);
      }
    }

    this.mPageControllers = pageControllers;
    GlobalContext.getInstance().setObject('mPageOrderController', this);
    this.isReadyOfControllerArray = true;
    emitter.emit(Event.INIT_CONTROLLER_ARRAY_READY);
    LogUtil.info(this.getTag(), `initControllerArray size:${pageControllers.length},keys:${pageControllers.map(i => i.getKey())
      .toString()}`);
  }

  /**
   * 获取array是否加载完毕
   */
  public isReady(): boolean {
    return this.isReadyOfControllerArray;
  }

  /**
   * 获取指定页的控制器
   */
  getAllPageController(): Array<IPageController> {
    return this.mPageControllers;
  }

  /**
   * 获取指定页的控制器
   * @param pageKey 名称
   */
  getPageControllerByName(pageKey: PageKey): IPageController | null {
    let controller = this.getPageControllerFromArray(pageKey);
    if (controller === null) {
      let control = this.mControllerMap.get(pageKey);
      if (control !== undefined) {
        return control;
      } else {
        LogUtil.error(this.getTag(), `getPageControllerByName failed. pageKey:${pageKey}`);
      }
    }
    return controller;
  }

  /**
   * 获取指定页的控制器
   * @param pageKey 名称
   */
  private getPageControllerFromArray(pageKey: string): IPageController | null {
    LogUtil.info(this.getTag(), `getPageControllerByName array ${pageKey}`);
    if (StringUtil.isEmpty(pageKey) || ArrayUtil.isEmpty(this.mPageControllers)) {
      LogUtil.error(this.getTag(), `getPageControllerByName array failed. pageKey:${pageKey}`);
      return null;
    }
    for (let controllerItem of this.mPageControllers) {
      if (controllerItem?.getKey() !== pageKey) {
        continue;
      }
      return controllerItem;
    }
    LogUtil.error(this.getTag(), `do not find page controller. pageKey: ${pageKey}`);
    return null;
  }

  /**
   * 获取指定页的控制器
   * @param pageIndex 下标
   */
  getPageControllerByIndex(pageIndex: number): IPageController | null {
    if (pageIndex === DEFAULT_PAGE_INDEX && !this.isReady()) {
      let firstPage: FirstPage | null = FirstDefaultPageManager.getInstance().getDefaultFirstPage();
      if (firstPage === null) {
        return null;
      }
      return firstPage.getPageController();
    }
    LogUtil.info(this.getTag(), `getPageControllerByIndex pageIndex: ${pageIndex}`);
    if (ArrayUtil.isEmpty(this.mPageControllers) || pageIndex < 0 || pageIndex >= this.mPageControllers.length) {
      LogUtil.error(this.getTag(), `do not find page controller. pageIndex: ${pageIndex}`);
      return null;
    }
    return this.mPageControllers[pageIndex];
  }

  /**
   * 获取当前页面控制器
   */
  getCurPageController(): IPageController | null {
    return this.getPageControllerByIndex(this.mPageIndex);
  }

  /**
   * 获取上一个页面控制器
   */
  getLastPageController(): IPageController | null {
    return this.getPageControllerByIndex(Math.max(0, this.mPageIndex - INDEX_STEP_ONE));
  }

  /**
   * 是否存在下一页
   */
  hasNextPage(): boolean {
    LogUtil.info(this.getTag(), 'hasNextPage');
    let isHasNext = false;
    let pageIndex = this.mPageIndex + INDEX_STEP_ONE;
    let pageController = this.getPageControllerByIndex(pageIndex);
    while (pageController) {
      if (pageController.isNeedShow()) {
        isHasNext = true;
        break;
      }
      pageIndex = pageIndex + INDEX_STEP_ONE;
      pageController = this.getPageControllerByIndex(pageIndex);
    }
    return isHasNext;
  }

  /**
   * 显示下一页
   */
  showNextPage(): void {
    LogUtil.info(this.getTag(), 'showNextPage');
    if (!this.isReady()) {
      LogUtil.error(this.getTag(), 'showNextPage not ready');
      emitter.on(Event.INIT_CONTROLLER_ARRAY_READY, () => {
        // 在第一页上点击继续，但是PageOrderController未初始化，待初始化完毕，继续下一页
        LogUtil.info(this.getTag(), 'showNextPage receive init ready');
        this.showNextPage();
        emitter.off(Event.INIT_CONTROLLER_ARRAY_READY);
      });
      this.handleControllerArray();
      return;
    }
    let pageIndex = this.mPageIndex + INDEX_STEP_ONE;
    let pageController = this.getPageControllerByIndex(pageIndex);
    while (pageController) {
      if (pageController.isNeedShow()) {
        this.mPageIndex = pageIndex;
        LogUtil.info(this.getTag(), `show next page: ${pageController.getKey()}`);
        pageController.loadPage(PageAction.ACTION_NEXT);
        return;
      } else {
        LogUtil.warn(this.getTag(), `next page is invisible for ${pageController.getKey()}`);
      }
      pageIndex = pageIndex + INDEX_STEP_ONE;
      pageController = this.getPageControllerByIndex(pageIndex);
    }
    LogUtil.warn(this.getTag(), `do not have next page to show. pageController is ${pageController}`);
    if (pageController === null) {
      this.finishOOBE();
    }
  }

  /**
   * 是否存在上一页
   */
  hasPrevPage(): boolean {
    LogUtil.info(this.getTag(), 'hasPrevPage');
    let isHasPrev = false;
    let pageIndex = this.mPageIndex - INDEX_STEP_ONE;
    let pageController = this.getPageControllerByIndex(pageIndex);
    while (pageController) {
      if (pageController.isNeedShow()) {
        isHasPrev = true;
        break;
      }
      pageIndex = pageIndex - INDEX_STEP_ONE;
      pageController = this.getPageControllerByIndex(pageIndex);
    }
    return isHasPrev;
  }

  /**
   * 是立即体验页
   */
  isExperiencePage(): boolean {
    return this.getCurPageController()?.getKey() === PageKey.EXPERIENCE_NOW;
  }

  /**
   * 显示上一页
   */
  showPrevPage(): void {
    let pageIndex = this.mPageIndex - INDEX_STEP_ONE;
    let pageController = this.getPageControllerByIndex(pageIndex);
    while (pageController) {
      if (pageController.isNeedShow()) {
        this.mPageIndex = pageIndex;
        LogUtil.info(this.getTag(), `show pre page: ${pageController.getKey()}`);
        pageController.loadPage(PageAction.ACTION_PREVIOUS);
        break;
      }
      pageIndex = pageIndex - INDEX_STEP_ONE;
      pageController = this.getPageControllerByIndex(pageIndex);
    }
    if (pageController === null) {
      LogUtil.error(this.getTag(), `can not show prev page. mPageIndex: ${this.mPageIndex}`);
    }
  }

  /**
   * 获取下一个可显示的界面
   */
  getNextEnableShowPage(): IPageController | null {
    while (this.getCurPageController() && !this.getCurPageController()?.isNeedShow()) {
      if (this.adjustPageIndex(1)) {
        break;
      }
    }
    if (!this.getCurPageController()) {
      LogUtil.warn(this.getTag(), `getNextEnableShowPage current controller is null`);
      return null;
    }
    return this.getCurPageController();
  }

  /**
   * 调整PageIndex
   */
  adjustPageIndex(step: number): boolean {
    let lastPageIndex = this.mPageIndex;
    let pageIndex = this.mPageIndex + step;
    this.mPageIndex = Math.max(0, Math.min(pageIndex, this.mPageControllers.length - 1));
    LogUtil.info(this.getTag(), `adjustPageIndex from ${lastPageIndex} to ${this.mPageIndex}`);
    // 出现过：从0调整成0，死循环
    return this.mPageIndex === lastPageIndex ? true : false;
  }

  /**
   * 结束开机向导
   */
  finishOOBE(): void {
    OOBEUtil.finishOOBE();
  }

  /**
   * 结束开机向导 删除子用户
   */
  finishOOBEWithDelSubUser(): void {
    OOBEUtil.finishOOBEWithDelSubUser();
  }

  /**
   * 跳转特定页
   * @param pageKey 页面key
   */
  jumpToPage(pageKey: PageKey) {
    LogUtil.info(this.getTag(), `try jumpToPage ${pageKey}`);
    if (this.getCurPageController()?.getKey() === pageKey) {
      LogUtil.warn(this.getTag(), `cur page is already ${pageKey}`);
      return;
    }
    let mPageController: IPageController | null = this.getPageControllerByName(pageKey);
    if (!mPageController) {
      LogUtil.warn(this.getTag(), `try jumpToPage failed. can not find pageController ${pageKey}, return`);
      return;
    }
    if (!mPageController.isNeedShow()) {
      LogUtil.warn(this.getTag(), `try jumpToPage failed. ${pageKey} isNeedShow is false. show next page`);
      this.showNextPage();
      return;
    }
    let pageAction: PageAction = this.mapNewIndex(pageKey);
    LogUtil.info(this.getTag(), `jumpToPage to ${pageKey}  pageIndex: ${this.mPageIndex}`);
    mPageController.loadPage(pageAction);
  }

  /**
   * 调整内部index,与pageKey保持一致
   * @param pageKey 页面key
   * @returns 上一页/下一页
   */
  mapNewIndex(pageKey: string): PageAction {
    let pageAction: PageAction = PageAction.ACTION_NEXT;
    if (StringUtil.isEmpty(pageKey) || ArrayUtil.isEmpty(this.mPageControllers)) {
      LogUtil.error(this.getTag(), `mapNewIndex failed. pageKey:${pageKey}`);
      return pageAction;
    }
    let index: number = 0;
    for (let controllerItem of this.mPageControllers) {
      if (controllerItem?.getKey() === pageKey) {
        break;
      }
      index++;
    }
    if (index < this.mPageIndex) {
      // 即将跳转的index，如果小于 当前的index，说明是往前跳转，则界面切换动效为返回动效
      pageAction = PageAction.ACTION_PREVIOUS;
    }
    LogUtil.info(this.getTag(), `mapNewIndex ${pageKey} is ${index}. pageAction:${pageAction}`);
    // 更新计数
    this.mPageIndex = index;
    return pageAction;
  }

  /**
   * 移除basePageKey对应的页面后的指定OOBE页面
   * @param pageKeys 希望移除的OOBE页面key值列表
   * @param basePageKey 可选参数, 不填时可移除任意页面,填写错误时不移除任何页面
   */
  public removePageControllers(pageKeys: string[], basePageKey?: string): void {
    let baseControllerIndex: number = Number.NEGATIVE_INFINITY;
    let useBaseIndex = false;
    if (basePageKey) {
      const controllerIndex = this.mControllerMap.get(basePageKey)?.getPageConfig()?.getIndex();
      if (controllerIndex != null) {
        baseControllerIndex = controllerIndex;
        useBaseIndex = true;
      } else {
        LogUtil.error(this.getTag(), `removePageControllers get baseControllerIndex is null`);
        return;
      }
      LogUtil.info(this.getTag(), `removePageControllers baseControllerIndex: ${baseControllerIndex}`);
    }
    const filteredControllers = this.mPageControllers.filter(controller => {
      const key = controller.getKey();
      if (!pageKeys.includes(key)) {
        return true;
      }
      if (useBaseIndex) {
        const controllerIndex = controller.getPageConfig()?.getIndex();
        if (controllerIndex == null) {
          return true;
        }
        return controllerIndex <= baseControllerIndex;
      }
      return false;
    });
    this.mPageControllers = filteredControllers;
    LogUtil.info(this.getTag(), `removePageControllers controller size: ${this.mPageControllers.length}`);
  }


  /**
   * 调换两个页面顺序
   * @param pageOne 页面1的page key
   * @param pageTwo 页面2的page key
   */
  public exchangePage(pageOne: PageKey, pageTwo: PageKey): void {
    let indexOne: number = this.getPageIndex(pageOne);
    let indexTwo = this.getPageIndex(pageTwo);
    if (indexOne > this.mPageIndex && indexTwo > this.mPageIndex) {
      let tempController: IPageController = this.mPageControllers[indexOne];
      this.mPageControllers[indexOne] = this.mPageControllers[indexTwo];
      this.mPageControllers[indexTwo] = tempController;
    }
  }

  private getPageIndex(key: PageKey): number {
    let controller: IPageController | undefined = this.mControllerMap.get(key);
    return controller ? this.mPageControllers.indexOf(controller) : -1;
  }
}
