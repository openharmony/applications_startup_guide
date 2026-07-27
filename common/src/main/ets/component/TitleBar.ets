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

import { LogUtil } from '../util/LogUtil';
import { RouterUtils } from '../util/RouterUtils';

const TAG: string = 'TitleBar';

/**
 * titleBar
 */
@Component
export struct TitleBar {
  private title: string | Resource | null = null;
  private showMenu: boolean = false;
  private menuClick: () => void = () => {
  };
  private onBack?: () => boolean;

  @Styles
  normalStyles(): void {
    .backgroundColor(Color.Transparent)
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_xs'))
  }

  @Styles
  pressedStyles(): void {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_xs'))
  }

  build() {
    Flex({ justifyContent: FlexAlign.Start }) {
      Column() {
        Row() {
          Stack({ alignContent: Alignment.Start }) {
            Image($r('app.media.ic_back'))
              .id('TitleBar_Image_ic_back')
              .width($r('app.float.title_bar_icon_width'))
              .height($r('app.float.title_bar_icon_height'))
              .margin($r('sys.float.ohos_id_card_margin_start'))
              .objectFit(ImageFit.Contain)
              .draggable(false)
          }
          .height($r('app.float.title_bar_icon_stack_height'))
          .stateStyles({
            normal: this.normalStyles,
            pressed: this.pressedStyles
          })
        }
          .id('TitleBar_stack')
          .height($r('app.float.title_bar_height'))
          .padding({ left: $r('sys.float.ohos_id_default_padding_start')})
          .onClick(() => {
            let isCanNotBack = this.onBack?.();
            if (isCanNotBack) {
              LogUtil.info(TAG, 'can not router back');
              return;
            }
            LogUtil.info(TAG, 'terminateSelf.');
            RouterUtils.back();
          })

          if (this.title) {
            Text(this.title)
              .fontSize($r('app.float.text_size_title_bar'))
              .fontColor(Color.Black)
              .margin({
                left: $r('app.float.title_bar_text_margin_left'),
              })
              .fontWeight(FontWeight.Medium)
          }
        }.height($r('app.float.title_bar_height'))

      if (this.showMenu) {
        Row() {
          Stack({ alignContent: Alignment.Center }) {
            Image($r('app.media.ic_back'))
              .id('TitleBar_showMenu_Image')
              .width($r('app.float.title_bar_icon_width'))
              .height($r('app.float.title_bar_icon_height'))
              .objectFit(ImageFit.Contain)
              .draggable(false)
          }
          .id('TitleBar_showMenu_stack')
          .height($r('app.float.title_bar_icon_stack_width'))
          .width($r('app.float.title_bar_icon_stack_height'))
          .stateStyles({
            normal: this.normalStyles,
          })
          .margin({
            right: $r('sys.float.ohos_id_max_padding_end'),
          })
          .onClick(() => {
            this.menuClick();
          })
        }.height($r('app.float.title_bar_height'))
      }
    }
  }
}
