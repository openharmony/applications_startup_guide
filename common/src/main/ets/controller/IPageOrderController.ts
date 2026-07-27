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

import { PageKey } from '../constant/PageKey';
import { IPageController } from './IPageController';

/**
 *
 * 开机向导页面排序控制器
 */
export interface IPageOrderController {
  /**
   * 获取TAG标记
   */
  getTag(): string;

  /**
   * 获取所有页面的控制器
   */
  getAllPageController(): Array<IPageController>;

  /**
   * 获取指定页的控制器
   */
  getPageControllerByName(pageName: string): IPageController | null;

  /**
   * 获取当前页面控制器
   */
  getCurPageController(): IPageController | null;

  /**
   * 获取上一个页面控制器
   */
  getLastPageController(): IPageController | null;

  /**
   * 是否存在下一页
   */
  hasNextPage(): boolean;

  /**
   * 显示下一页
   */
  showNextPage(): void;

  /**
   * 是否存在上一页
   */
  hasPrevPage(): boolean;

  /**
   * 显示上一页
   */
  showPrevPage(): void;

  /**
   * 获取下一个可显示的界面
   */
  getNextEnableShowPage(): IPageController | null;

  /**
   * 调整PageIndex
   */
  adjustPageIndex(step: number): void;

  /**
   * 结束开机向导
   */
  finishOOBE(): void;

  /**
   * 结束开机向导 删除子用户
   */
  finishOOBEWithDelSubUser(): void;

  /**
   * 跳转特定页
   * @param pageKey 页面key
   */
  jumpToPage(pageKey: string): void;

  /**
   * 调整内部index,与pageKey保持一致
   * @param pageKey 页面key
   */
  mapNewIndex(pageKey: string): void;

  /**
   * 是立即体验页
   */
  isExperiencePage(): boolean;

  /**
   * 调换两个页面顺序
   * @param pageOne 页面1的page key
   * @param pageTwo 页面2的page key
   */
  exchangePage(pageOne: PageKey, pageTwo: PageKey): void;
}
