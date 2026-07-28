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
import { LogUtil } from '../util/LogUtil';

const TAG: string = 'SystemMaterialManager';
const BORDER_WIDTH: number = 1;
const BACKDROP_BLUR: number = 150;

export class SystemMaterialManager {
  private static instance: SystemMaterialManager;
  private isNewMaterialSupported: boolean = false;

  private constructor() {
    LogUtil.warn(TAG, `isNewMaterialSupported: ${this.isNewMaterialSupported}`);
  }

  /**
   * 获取SystemMaterialManager单例
   *
   * @returns SystemMaterialManager对象
   */
  public static getInstance(): SystemMaterialManager {
    if (!SystemMaterialManager.instance) {
      SystemMaterialManager.instance = new SystemMaterialManager();
    }
    return SystemMaterialManager.instance;
  }

  /**
   * 获取是否支持新材质
   *
   * @returns true 支撑新材质，false 不支持新材质
   */
  public getIsNewMaterialSupported(): boolean {
    return this.isNewMaterialSupported;
  }

  /**
   * 获取列表背景颜色，新材质内容背景颜色值调整
   *
   * @returns 列表背景颜色
   */
  public static listBackgroundColor(): ResourceColor {
    return $r('app.color.list_bg_color');
  }
}

/**
 * 卡片新材质属性
 */
export class CardSystemMaterialModifier implements AttributeModifier<ColumnAttribute> {
  /**
   * 应用标准样式
   *
   * @param instance ColumnAttribute
   */
  applyNormalAttribute(instance: ColumnAttribute): void {
    instance.backgroundColor($r('app.color.card_bg_color'))
      .borderColor($r('app.color.card_border_color'))
      .borderWidth(BORDER_WIDTH)
      .borderStyle(BorderStyle.Solid)
      .backdropBlur(BACKDROP_BLUR);
  }
}

/**
 * 卡片返回按钮新材质属性
 */
export class ButtonSystemMaterialModifier implements AttributeModifier<ButtonAttribute> {
  private backgroundColor: ResourceColor;

  constructor(backgroundColor: ResourceColor) {
    this.backgroundColor = backgroundColor;
  }

  /**
   * 应用标准样式
   *
   * @param instance ButtonAttribute
   */
  applyNormalAttribute(instance: ButtonAttribute): void {
    instance.backgroundColor(this.backgroundColor);
  }
}
