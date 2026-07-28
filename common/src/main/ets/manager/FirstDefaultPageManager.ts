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

import { IPageController } from '../controller/IPageController';
import { PageConfig } from '../model/config/PageConfig';


const TAG: string = 'FirstDefaultPageManager';

/**
 * 默认首页管理类
 */
export class FirstDefaultPageManager {
  private static instance?: FirstDefaultPageManager;
  private firstDefaultPage: FirstPage | null = null;

  private constructor() {
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  static getInstance(): FirstDefaultPageManager {
    if (!FirstDefaultPageManager.instance) {
      FirstDefaultPageManager.instance = new FirstDefaultPageManager();
    }
    return FirstDefaultPageManager.instance;
  }

  /**
   * 设置默认的第一页
   */
  public setDefaultFirstPage(key: string, pageController: IPageController): void {
    let config: PageConfig = new PageConfig({});
    config.setKey(key);
    config.setIndex(1);
    config.setType(0);
    this.firstDefaultPage = new FirstPage(config, pageController);
  }

  /**
   * 设置默认的第一页
   */
  public setDefaultFirstPageByConfig(config: PageConfig, pageController: IPageController): void {
    this.firstDefaultPage = new FirstPage(config, pageController);
  }

  /**
   * 获取默认的首页
   */
  public getDefaultFirstPage(): FirstPage | null {
    return this.firstDefaultPage;
  }
}

export class FirstPage {
  private pageController: IPageController | null;
  private pageConfig: PageConfig;

  constructor(pageConfig: PageConfig, pageController: IPageController | null) {
    this.pageConfig = pageConfig;
    this.pageController = pageController;
  }

  public getPageController(): IPageController | null {
    return this.pageController;
  }

  public getPageConfig(): PageConfig {
    return this.pageConfig;
  }
}
