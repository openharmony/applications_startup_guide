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

import { BusinessError } from '@ohos.base';
import {
  AbilityType,
  AbilityUtil,
  BaseExternalPageController,
  CommonConstant,
  HiSysEventUtil,
  IPageController,
  LogUtil,
  PageComponent,
  PageConfig,
  PageKey,
} from '@ohos/hwstartupguide.common';

const TAG: string = 'ExternalPageComponent';

/**
 * 接入的外部业务页面
 */
@Component
export struct ExternalPageComponent {
  private pageConfig: PageConfig | null | undefined;
  private mPageController: IPageController | null = null;
  screeHeight: number = 0;

  build() {
    PageComponent({
      content: () => {
        this.loadExternalPageComponent(this.pageConfig);
      },
      onPageShow: () => {
        if (this.onPageShow) {
          this.onPageShow();
        }
      },
      onHidden: () => {
        if (this.onPageHide) {
          this.onPageHide();
        }
      }
    })
  }

  /**
   * 加载外部业务页面
   * @param pageConfig 页面配置
   */
  @Builder
  loadExternalPageComponent(pageConfig: PageConfig | null | undefined): void {
    // 新老框架兼容阶段，不要commit。适配SR000IFK6D 【OOBE】页面接入框架整改
    if (pageConfig && !AbilityUtil.isUIAbility(pageConfig.getAbilityName())) {
      UIExtensionComponent({
        bundleName: pageConfig?.getBundleName(),
        abilityName: pageConfig?.getAbilityName(),
        parameters: pageConfig?.getParams(),
      }, {
        dpiFollowStrategy: DpiFollowStrategy.FOLLOW_HOST_DPI
      })
        .expandSafeArea(
          pageConfig?.getKey() === PageKey.ACCOUNT_LOGIN ?
            [SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM] :
            [SafeAreaType.SYSTEM, SafeAreaType.CUTOUT, SafeAreaType.KEYBOARD],
          pageConfig.getKey() === PageKey.ACCOUNT_LOGIN ?
            [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP] :
            [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM, SafeAreaEdge.START, SafeAreaEdge.END])
        .width('100%')
        .height('100%')
        .visibility(pageConfig.getType() === AbilityType.EXTERNAL_ABILITY ? Visibility.Visible : Visibility.Hidden)
        .onRemoteReady((proxy: UIExtensionProxy) => {
          if (this.mPageController instanceof BaseExternalPageController) {
            let controller = this.mPageController as BaseExternalPageController;
            controller.setDataSendProxy(proxy);
            controller.monitorKeyboardHeightChanged(proxy);
            try {
              this.getUIContext().getFocusController().requestFocus(`key_${pageConfig?.getKey()}`);
            } catch (e) {
              LogUtil.error(TAG, `Failed to requestFocus, key: ${pageConfig?.getKey()}`);
            }
          } else {
            LogUtil.error(TAG, 'mPageController is not instanceof BaseExternalPageController');
          }
        })
        .id(`key_${pageConfig?.getKey()}`)
        .onReceive((data: Record<string, Object>) => {
          LogUtil.info(TAG, `onReceiveData ${pageConfig?.getKey()}.`);
          if (this.mPageController instanceof BaseExternalPageController) {
            let controller = this.mPageController as BaseExternalPageController;
            controller.handleReceivedData(data);
          } else {
            LogUtil.error(TAG, 'mPageController is not instanceof BaseExternalPageController');
          }
        })
        .onError((error: BusinessError) => {
          LogUtil.error(TAG, `onError exception ${pageConfig?.getKey()}:${error.code}  ${error.message}`);
          if (this.mPageController instanceof BaseExternalPageController) {
            let controller = this.mPageController as BaseExternalPageController;
            controller.unMonitorKeyboardHeightChanged();
            controller.handleLoadAbilityError(error.code);
          } else {
            LogUtil.error(TAG, 'mPageController is not instanceof BaseExternalPageController');
          }
        })
        .onTerminated((result: TerminationInfo) => {
          LogUtil.info(TAG, `onTerminated ${pageConfig?.getKey()}, code: ${result?.code}, abilityName: ${result?.want?.abilityName}.`);
          if (this.mPageController instanceof BaseExternalPageController) {
            let controller = this.mPageController as BaseExternalPageController;
            controller.handleAbilityResult({
              resultCode: result.code,
              want: result.want,
            });
            controller.unMonitorKeyboardHeightChanged();
          } else {
            LogUtil.error(TAG, 'mPageController is not instanceof BaseExternalPageController');
          }
        })
    }
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, `aboutToAppear ${this.pageConfig?.getKey()}`);
    let controller = this.mPageController as BaseExternalPageController;
    controller.pageAppear();
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.COMPONENT_APPEAR}, ${this.pageConfig?.getKey()}`);
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, `aboutToDisappear ${this.pageConfig?.getKey()}`);
    let controller = this.mPageController as BaseExternalPageController;
    controller.pageDisappear();
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `${CommonConstant.COMPONENT_DISAPPEAR}, ${this.pageConfig?.getKey()}`);
  }
}

