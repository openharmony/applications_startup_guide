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
import settings from '@ohos.settings';
import { LogUtil, SettingUtil, CommonConstant } from '@ohos/hwstartupguide.common';

const TAG: string = 'AssistedReadingDetailComponent : ';

@Component
export struct AssistedReadingDetailComponent {
  @State effect: TransitionEffect | undefined = undefined;
  @Link isMainPage: boolean;

  build() {
    Column() {
      UIExtensionComponent({
        bundleName: 'com.ohos.openharmony.settings',
        abilityName: 'OobeAssistedReadingAbility',
        parameters: {
          'ability.want.params.uiExtensionType': 'sys/commonUI'
        }
      }, {
        dpiFollowStrategy: DpiFollowStrategy.FOLLOW_HOST_DPI
      })
        .size({ width: '100%', height: '100%' })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP])
        .onReceive((data) => {
          LogUtil.info(TAG, 'onReceive data');
          if (data) {
            LogUtil.info(TAG, 'current data is not empty');
            if (data['action'] === 'backSheet') {
              LogUtil.info(TAG, 'Go back to the previous level' + data['action']);
              this.effect = TransitionEffect.OPACITY.combine(TransitionEffect.move(TransitionEdge.END));
              animateTo({ duration: CommonConstant.TRANSACTION_TIME }, () => {
                this.isMainPage = true;
              })
              this.setFontScale();
            }
          }
        })
        .onTerminated((result: TerminationInfo) => {
          LogUtil.warn(TAG, `onTerminated code: ${result?.code}, abilityName: ${result?.want?.abilityName}.`);
          this.isMainPage = true;
        })
        .onError((error: BusinessError) => {
          LogUtil.info(TAG, `onError, message=${error?.message}.`);
          this.isMainPage = true;
        })
        .accessibilityUseSamePage(AccessibilitySamePageMode.FULL_SILENT)
    }
    .transition(this.effect)
  }

  private setFontScale(): void {
    let fontSizeScale: number = Number(SettingUtil
      .getValueSync(CommonConstant.SETTINGS_DATA_FONT_SIZE_SCALE, CommonConstant.DEFAULT_FONT_SIZE_SCALE,
        settings.domainName.USER_PROPERTY));
    LogUtil.info(TAG, `adjusted font size: ${fontSizeScale}`);
    AppStorage.setOrCreate<number>('textZoomRatio', fontSizeScale * 100);
  }
}