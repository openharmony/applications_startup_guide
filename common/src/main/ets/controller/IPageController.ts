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
import { PageKey } from '../constant/PageKey';
import { Event } from '../event/Event';
import { PageConfig } from '../model/config/PageConfig';
import { PageAction } from '../model/PageAction';
import { IPageOrderController } from './IPageOrderController';

/**
 * 页面控制器接口
 */
export interface IPageController {
  /**
   * 获取控制器名称
   */
  getKey(): PageKey;

  /**
   * 设置指定页是否可见
   */
  setNeedShow(isShow: boolean): void;

  /**
   * 是否需要显示
   */
  isNeedShow(): boolean;

  /**
   * 处理快速克隆
   */
  handleFastClone(): boolean;

  /**
   * 显示页面
   */
  loadPage(pageAction: PageAction): void;

  /**
   * 点击上一页
   */
  handlePrevButtonClick(): void;

  /**
   * 点击下一页
   */
  handleNextButtonClick(): void;

  /**
   * 获取页面顺序控制器
   */
  getPageOrderController(): IPageOrderController;

  /**
   * 获取页面配置
   */
  getPageConfig(): PageConfig | null | undefined;

  /**
   * 发射事件
   */
  emitEvent(event: Event): void;

  /**
   * 初始化页面配置
   */
  initPageConfig(): void;

  /**
   * 设置可见性
   */
  configNeedShow(): void;

  /**
   * 加载页面所需资源
   */
  loadData(): void;

  /**
   * page中的aboutToAppear
   */
  pageAppear(): void;
}