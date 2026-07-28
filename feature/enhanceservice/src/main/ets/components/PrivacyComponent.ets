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
import { BusinessError } from '@ohos.base';
import Want from '@ohos.app.ability.Want';
import { LogUtil, CommonConstant, WantUtil } from '@ohos/hwstartupguide.common';

const TAG: string = 'PrivacyComponent';
/**
 * 加载协议组件
 */
@Component
export struct PrivacyComponent {
  @StorageLink('privacyWant') privacyWant: Want | null = null;
  @Prop paddingBottom: Resource | number = 0;

  build() {
    Column() {
      if (this.privacyWant && WantUtil.isValidPrivacyWant(this.privacyWant) &&
        WantUtil.isOobePrivacyWant(this.privacyWant)) {
        UIExtensionComponent({
          bundleName: this.privacyWant.bundleName,
          abilityName: this.privacyWant.abilityName,
          parameters: this.privacyWant.parameters,
        }, {
          dpiFollowStrategy: DpiFollowStrategy.FOLLOW_HOST_DPI
        })
          .width('100%')
          .height('100%')
          .transition(TransitionEffect.OPACITY.animation({ duration: CommonConstant.TRANSACTION_TIME, }))
          .onRelease((code: number) => {
            LogUtil.info(TAG, `onRelease,code=${code}`);
            AppStorage.Set<Want>('privacyWant', {});
          })
          .onError((error: BusinessError) => {
            LogUtil.info(TAG, `onError, message=${error?.message}.`);
            AppStorage.Set<Want>('privacyWant', {});
          })
          .accessibilityUseSamePage(AccessibilitySamePageMode.FULL_SILENT)
      }
    }
    .width('100%')
    .height('100%')
    .padding({
      bottom: this.paddingBottom,
    })
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToAppear');
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
  }
}
