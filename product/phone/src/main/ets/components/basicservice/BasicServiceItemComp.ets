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
import {
  ParseStrategy,
  ServiceEntity,
  DeviceUtil,
  BaseText,
  LinkText,
  BoldText,
  SheetData,
  SheetManager
} from '@ohos/hwstartupguide.common';
import {
  EndUserSoftwareLicenseComponent
} from '@ohos/hwstartupguide.basicservice/src/main/ets/components/EndUserSoftwareLicenseComponent';

const IS_DEVICE_PAD: boolean = DeviceUtil.isDevicePad();

/***
 * 基础服务声明条目组件
 * @since 2022-11-15
 */
@Component
export struct BasicServiceItemComp {
  mServiceEntity: ServiceEntity = new ServiceEntity(new Object());
  isDetailVisible?: boolean = false;
  mFontSize: Resource = $r('sys.float.ohos_id_text_size_body3');
  mLinkColor: Resource = $r('app.color.blue_default');
  isNeedJustify: boolean = DeviceUtil.isNeedJustify();
  @StorageLink('isoLanguage') isoLanguage: boolean = false;
  @State isModeFrameShow: boolean = false;
  @State showDragBar: boolean = true;
  @State htmlName: string | undefined = '';
  @State sheetData: SheetData = SheetManager.getInstance().getSheetData();

  // 半模态框组件
  @Builder
  modeFrameComponent() {
    Column() {
      EndUserSoftwareLicenseComponent({
        htmlName: this.htmlName,
        paddingBottom: this.getSoftwareLicensePaddingBottom()
      })
    }
  }

  getSoftwareLicensePaddingBottom(): Length {
    return this.sheetData.sheetPreferType === SheetType.CENTER ? $r('app.float.wh_value_24') : 0;
  }

  build() {
    Column() {
      Column() {
        // 子项的Title
        Text(this.mServiceEntity?.getTitle())
          .id(`text_basic_service_item_${this.mServiceEntity?.getServiceName()}`)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .textAlign(TextAlign.Start)
          .margin({
            bottom: $r('app.float.wh_value_8'),
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      // 子项的Content
      Column() {
        Text() {
          ForEach(ParseStrategy.getInstance().parseText(this.mServiceEntity), (textItem: BaseText) => {
            if (textItem instanceof LinkText) {
              Span(textItem.getText())
                .id(`linktext_richtext_${this.mServiceEntity?.getServiceName()}`)
                .fontWeight(FontWeight.Medium)
                .fontColor(this.mLinkColor)
                .onClick(() => {
                  this.openModeFrame(textItem.getWant());
                })
            } else if (textItem instanceof BoldText) {
              Span(textItem.getText())
                .id(`boldtext_richtext_${this.mServiceEntity?.getServiceName()}`)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.ohos_id_alpha_content_secondary'))
            } else {
              Span(textItem.getText())
                .id(`normaltext_richtext_${this.mServiceEntity?.getServiceName()}`)
                .fontWeight(FontWeight.Regular)
                .fontColor($r('app.color.ohos_id_alpha_content_secondary'))
            }
          })
        }
        .id(`text_richtext_${this.mServiceEntity?.getTitle()}`)
        .fontSize(this.mFontSize)
        .align(Alignment.Start)
        .width('100%')
        .textAlign(this.isNeedJustify ? TextAlign.JUSTIFY : TextAlign.Start)
        .responseRegion({ x: 0, y: 0, width: '100%', height: '100%' })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .margin({
      bottom: IS_DEVICE_PAD ? $r('app.float.margin_32') : $r('app.float.margin_36'),
    })
    .bindSheet($$this.isModeFrameShow, this.modeFrameComponent(), {
      height: this.sheetData.sheetHeight,
      preferType: this.sheetData.sheetPreferType,
      onDisappear: () => {
        AppStorage.setOrCreate<boolean>('isBindSheetOff', true);
      }
    })
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
  }

  private openModeFrame(want?: Want): void {
    if (!want) {
      return;
    }
    AppStorage.setOrCreate<boolean>('isBindSheetOff', false);
    this.htmlName = want.uri;
    this.isModeFrameShow = true;
  }
}
