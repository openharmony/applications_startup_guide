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

import { FooterStyleModel } from '../model/StyleModel';

/**
 * 样式管理类
 */
export class StyleManager {
  private static instance: StyleManager;
  private footerStyleModel: FooterStyleModel | undefined;
  public isGrid: boolean = true;

    /**
   * 获取StyleManager单例
   *
   * @returns StyleManager对象
   */
  public static getInstance(): StyleManager {
    if (!StyleManager.instance) {
      StyleManager.instance = new StyleManager();
    }
    return StyleManager.instance;
  }

  /**
   * 设置Footer组件样式模型
   *
   * @param footerStyleModel Footer组件样式模型
   */
  public setFooterStyleModel(footerStyleModel: FooterStyleModel) {
    this.footerStyleModel = footerStyleModel;
  }

  /**
   * 获取Footer组件样式模型
   *
   * @returns Footer组件样式模型
   */
  public getFooterStyleModel(): FooterStyleModel | undefined {
    return this.footerStyleModel;
  }
}