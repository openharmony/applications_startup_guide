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

import common from '@ohos.app.ability.common';
import {
  BasePageController,
  IPageOrderController,
  PageKey,
  LogUtil
} from '@ohos/hwstartupguide.common';
import { RegionSelectUtil } from '../util/RegionSelectUtil';

const TAG: string = 'RegionSelectPageController';

/**
 * 基础服务声明控制器
 */
export class RegionSelectPageController extends BasePageController {
  /**
   * 构造函数
   * @param pageOrderController 页面顺序控制器
   * @param controllerKey 控制器key
   */
  public constructor(pageOrderController: IPageOrderController) {
    super(pageOrderController, PageKey.REGION_SELECT);
  }

  /**
   * 点击下一页
   */
  handleNextButtonClick(): void {
    super.handleNextButtonClick();
    this.saveSelectRegionData();
  }

  /**
   * 存储地区选择数据
   */
  saveSelectRegionData(): void {
    LogUtil.info(TAG, 'saveSelectRegionData');
    RegionSelectUtil.readSelectRegionFromSP(this.getAbility()?.context as common.UIAbilityContext).then((region) => {
      RegionSelectUtil.saveSelectRegionToSetting(region);
    });
  }

  /**
   * 获取地区选择状态
   */
  async readSelectRegionAgreed(): Promise<string> {
    LogUtil.info(TAG, 'readSelectRegionAgreed');
    let isHasRegionValue = await RegionSelectUtil.isHasSelectRegionFromSP(getContext(this));
    if (isHasRegionValue) {
      const region = await RegionSelectUtil.readSelectRegionFromSP(getContext(this));
      return region;
    } else {
      return RegionSelectUtil.readSelectRegionFromSettings();
    }
  }
}
