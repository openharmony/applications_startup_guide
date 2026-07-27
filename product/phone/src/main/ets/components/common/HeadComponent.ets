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

import { BasePageController, DeviceUtil, LogUtil } from '@ohos/hwstartupguide.common';

const DELAY_TIME: number = 500;

const TAG: string = 'HeadComponent';
const IS_DEVICE_PAD: boolean = DeviceUtil.isDevicePad();

/**
 * 标题组件
 */
@Component
export struct HeadComponent {
  @StorageLink('isPortraitOrientation') isPortraitOrientation: boolean = false;
  @State mHeadImage: Resource = $r('app.media.icon_basic_and_term');
  @State mHeadName: Resource = $r('app.string.empty_string');
  @Prop mHeadNameStr: string | null = null; // 默认为空
  private mBasePageController: BasePageController | null = null;
  private isBackArrowVisible?: boolean = true;
  @State isArrowEnable: boolean = true;

  @Styles
  normalStyles(): void {
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .opacity(1)
  }

  @Styles
  pressedStyles(): void {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_xs'))
    .opacity(1)
  }

  build() {
    Column() {
      // 返回箭头
      Column() {
        Column() {
          Column() {
            Image($r('app.media.ic_back'))
              .id('img_headcomponent_back')
              .width($r('app.float.distance_24'))
              .height($r('app.float.distance_24'))
              .enabled(this.isArrowEnable)
              .draggable(false)
              .margin($r('sys.float.ohos_id_card_margin_start'))
          }
          .stateStyles({
            normal: this.normalStyles,
            pressed: this.pressedStyles
          })
          .height($r('app.float.distance_48'))
          .onClick(() => {
            LogUtil.info(TAG, `aboutToAppear with isArrowEnable: ${this.isArrowEnable}`);
            if (this.isArrowEnable) {
              this.isArrowEnable = false;
              this.mBasePageController?.handlePrevButtonClick();
              setTimeout(() => {
                this.isArrowEnable = true;
              }, DELAY_TIME);
            }
          })
        }
        .height($r('app.float.distance_56'))
        .visibility(this.isBackArrowVisible ? Visibility.Visible : Visibility.Hidden)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
      }
      .padding({
        left: $r('sys.float.ohos_id_default_padding_start'),
      })
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      GridRow((IS_DEVICE_PAD && !this.isPortraitOrientation) ? { columns: 12, gutter: 12 } :
        { columns: 8, gutter: 12 }) { // UX栅格规格
        GridCol({ span: { sm: 8, md: 6, lg: 8 }, offset: { sm: 0, md: 1, lg: 2 } }) {
          Column() {
            // Icon
            Image(this.mHeadImage)
              .id('img_headcomponent_icon')
              .width($r('app.float.distance_48'))
              .height($r('app.float.distance_48'))
              .draggable(false)
              .margin({
                top: (IS_DEVICE_PAD && this.isPortraitOrientation) ? $r('app.float.margin_60') : $r('app.float.margin_12'),
                bottom: $r('app.float.margin_12'),
              })
            // 标题
            Text(this.mHeadNameStr ?? this.mHeadName)
              .id('text_headcomponent_title')
              .fontWeight(FontWeight.Medium)
              .fontSize($r('sys.float.ohos_id_text_size_headline6'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .maxLines(2)
              .lineHeight(
                $r('app.float.distance_40')
              )
              .textAlign(TextAlign.Center)
              .width('100%')
          }.padding({
            left: IS_DEVICE_PAD ? $r('sys.float.ohos_id_default_padding_start') :
            $r('sys.float.ohos_id_max_padding_start'),
            right: IS_DEVICE_PAD ? $r('sys.float.ohos_id_default_padding_start') :
            $r('sys.float.ohos_id_max_padding_end'),
          })
          .margin({
            bottom: $r('app.float.distance_48'),
          })
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
      }
      .margin({
        left: IS_DEVICE_PAD ? $r('sys.float.ohos_id_default_padding_start') : 0,
        right: IS_DEVICE_PAD ? $r('sys.float.ohos_id_default_padding_end') : 0,
      })
    }
  }
}
