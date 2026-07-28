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

import { PageConfigManager, pageLayoutManager } from '@ohos/hwstartupguide.common';
import { FooterStyleModel } from '@ohos/hwstartupguide.common/src/main/ets/model/StyleModel';

/**
 * 手机Footer组件样式模型
 */
export class PhoneFooterStyleModel implements FooterStyleModel {
  /**
   * 按钮类型
   */
  public buttonType: ButtonType = ButtonType.Capsule;

  /**
   * 按钮圆角
   */
  public buttonBorderRadius: ResourceStr = $r('sys.float.ohos_id_corner_radius_button');

  /**
   * 按钮Loading效果尺寸
   */
  public buttonLoadingProgressSize: ResourceStr = $r('app.float.wh_value_35');

  /**
   * 同意按钮组件底部外边距
   */
  public agreeBtnBottomMargin: ResourceStr = $r('app.float.wh_value_68');

  /**
   * 跳过按钮组件底部外边距
   */
  public skipBtnBottomMargin: ResourceStr = $r('app.float.wh_value_16');

  /**
   * Footer组件是否需要自动获焦
   */
  public isNeedFocus: boolean = false;

  /**
   * Footer组件文本溢出处理方式
   */
  public textOverflow: TextOverflow = TextOverflow.Ellipsis;

  /**
   * 按钮宽度是否固定
   */
  public isButtonWidthFixed: boolean = false;
}