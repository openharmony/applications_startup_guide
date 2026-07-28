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

// instrument ignore file
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { CommonConstant, FocusUtil, LogUtil, WantUtil } from '@ohos/hwstartupguide.common';

const TAG: string = 'PermissionInfoDialog';

/**
 * 权限说明弹框
 */
@CustomDialog
export struct PermissionInfoDialog {
  @Link privacyWant: Want | null;
  @Link maskShow: boolean;
  dialogWidth: string | Resource = '100%';
  dialogController?: CustomDialogController;

  @Builder
  buildPageContent(): void {
    Column() {
      if (this.privacyWant && WantUtil.isValidPrivacyWant(this.privacyWant) &&
        WantUtil.isOobePrivacyWant(this.privacyWant)) {
        // 权限说明页面Component
        UIExtensionComponent({
          bundleName: this.privacyWant.bundleName,
          abilityName: this.privacyWant.abilityName,
          parameters: this.privacyWant.parameters,
        }, {
          dpiFollowStrategy: DpiFollowStrategy.FOLLOW_HOST_DPI
        })
          .width('100%')
          .height('100%')
          .onError((error: BusinessError) => {
            LogUtil.error(TAG, `UIExtensionComponent onError, message=${error?.message}.`);
            this.closeDialog();
          })
          .onRelease((code: number) => {
            LogUtil.info(TAG, `UIExtensionComponent onRelease, code=${code}.`);
            this.closeDialog();
          })
          .onRemoteReady(() => {
            FocusUtil.requestFocus(this.privacyWant?.bundleName, this.getUIContext());
          })
          .onKeyEvent((event?: KeyEvent) => {
            if (!event) {
              return;
            }
            if (event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_ESCAPE) {
              this.closeDialog();
            }
          })
      }
    }
    .width('100%')
    .height('100%')
    .clip(true)
    .id(this.privacyWant?.bundleName)
  }

  /**
   * 关闭协议弹框
   */
  private closeDialog() {
    if (this.dialogController) {
      LogUtil.info(TAG, 'close privacy dialog');
      this.dialogController.close();
      this.resetPrivacyState();
      this.maskShow = false;
      FocusUtil.requestFocus(CommonConstant.FOOTER_COMPONENT_ID);
    }
  }

  /**
   * 重置协议状态
   */
  private resetPrivacyState(): void {
    AppStorage.set<Want>('privacyWant', {});
  }

  build() {
    Column() {
      this.buildPageContent();
    }
    .width(this.dialogWidth)
    .height('100%')
  }
}