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

import Want from '@ohos.app.ability.Want';
import { LogUtil } from '@ohos/hwstartupguide.common';

const TAG: string = 'EnhanceServiceItemModel';

export class EnhanceServiceItemModel {
  /**
   * 权限说明弹框Controller
   */
  public permissionInfoDialogController: CustomDialogController = new CustomDialogController({
    builder: {}
  })
  /**
   * 声明一个打开半模态框的方法，并由EnhanceServiceItemComp来实现
   */
  public setBindsheetOpen: (val: boolean) => void = (val: boolean) => {
  };

  constructor() {
  }

  /**
   * 开启隐私或权限说明弹框
   * @param want 跳转want对象
   * @returns number 无特殊意义仅用于DT测试
   */
  public openDialog(want?: Want): number {
    if (!want || !want.bundleName) {
      LogUtil.error(TAG, 'openDialog do not set privacyWant');
      return 0;
    }
    AppStorage.set<Want>('privacyWant', {
      bundleName: want.bundleName,
      abilityName: want.abilityName,
      parameters: want.parameters,
      uri: want.uri,
    });
    LogUtil.info(TAG, `openDialog bundleName: ${want.bundleName} abilityName: ${want.abilityName}`);
    if (want.parameters && want.parameters.type === 'permissionStatement' ) {
      this.permissionInfoDialogController.open();
      return 1;
    } else {
      this.setBindsheetOpen(true)
      return 2;
    }
  }

  /**
   * 关闭对话框
   */
  public closeDialog(): void {
    LogUtil.info(TAG, 'close dialog');
    this.permissionInfoDialogController.close();
  }
}