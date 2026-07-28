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
import { BusinessError } from '@kit.BasicServicesKit';
import {
  DeviceUtil,
  LogUtil,
  ParseStrategy,
  ServiceEntity,
  BaseText,
  LinkText,
  CommonConstant,
  AbilityUtil,
  BoldText,
  SheetData,
  SheetManager,
  SystemMaterialManager,
  WantUtil
} from '@ohos/hwstartupguide.common';
import { PrivacyComponent, PermissionInfoDialog, TitleCheckBox } from '@ohos/hwstartupguide.enhanceservice';
import { EnhanceServiceItemModel } from '../../model/enhanceservice/EnhanceServiceItemModel';

const TAG: string = 'EnhanceServiceItemComp';
const DROI_TONG: string = 'com.droi.tong';

/**
 *增强服务声明条目组件
 */
@Component
export struct EnhanceServiceItemComp {
  @StorageLink('privacyWant') privacyWant: Want | null = null;
  @ObjectLink @Watch('onServiceEntityChange') mServiceEntity: ServiceEntity;
  @State isServiceChecked: boolean = false;
  @State isModeFrameShow: boolean = false;
  @State maskShow: boolean = false;
  @State sheetData: SheetData = SheetManager.getInstance().getSheetData();
  private model: EnhanceServiceItemModel = new EnhanceServiceItemModel();
  mOnCheckStatusChange?: (isOn: boolean) => void;
  private mFontSize: Resource = $r('sys.float.ohos_id_text_size_body3');
  private mLinkColor: Resource = $r('app.color.blue_default');
  private isNeedJustify: boolean = DeviceUtil.isNeedJustify();
  public permissionInfoDialogController: CustomDialogController = new CustomDialogController({
    builder: PermissionInfoDialog({
      privacyWant: this.privacyWant,
      maskShow: this.maskShow
    }),
    customStyle: true,
    cancel: this.closeDialog,
    gridCount: CommonConstant.GRID_NUM_FOUR,
  });

  // 半模态框组件
  @Builder
  modeFrameComponent() {
    Column() {
      PrivacyComponent({
        paddingBottom: this.sheetData.sheetPreferType === SheetType.CENTER ? $r('app.float.wh_value_24') : 0
      })
    }
  }

  @Builder
  RichTextComponent(textItem: BaseText) {
    if (textItem instanceof LinkText) {
      Span(textItem.getText())
        .id(`linktext_richtext_${this.mServiceEntity?.getServiceName()}`)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.mLinkColor)
        .onClick(() => {
          this.clickEnhanceServiceItem(textItem);
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
  }

  private clickEnhanceServiceItem(textItem: LinkText) {
    let linkWant = textItem.getWant();
    if (linkWant?.bundleName === DROI_TONG) {
      LogUtil.info(TAG,
        `textItem bundle name:${linkWant?.bundleName},ability name is:${linkWant?.abilityName}`);
      if (!WantUtil.isExplicitStartWant(linkWant)) {
        LogUtil.error(TAG, 'clickEnhanceServiceItem rejected: implicit want');
        return;
      }
      AbilityUtil.startAbilityByContext(linkWant.bundleName as string, linkWant.abilityName as string,
        linkWant.parameters).catch((err: BusinessError) => {
        LogUtil.error(TAG, 'error code:' + err?.code + 'err.message:' + err?.message);
      });
    } else {
      this.openModeFrame(linkWant);
    }
  }

  build() {
    Column() {
      TitleCheckBox({
        mTitle: this.mServiceEntity?.getTitle(),
        mEnabled: this.mServiceEntity?.getSwitchDisabled(),
        isOn: $isServiceChecked,
        mOnChange: (isOn: boolean) => {
          if (this.mOnCheckStatusChange) {
            this.mOnCheckStatusChange(isOn);
          }
        }
      }).margin({ bottom: $r('app.float.distance_8') })

      Text() {
        ForEach(ParseStrategy.getInstance().parseText(this.mServiceEntity), (textItem: BaseText) => {
          this.RichTextComponent(textItem)
        })
      }
      .id(`text_richtext_${this.mServiceEntity?.getServiceName()}`)
      .fontSize(this.mFontSize)
      .align(Alignment.Start)
      .width('100%')
      .padding({
        left: $r('app.float.padding_12'),
        right: $r('app.float.padding_12'),
      })
      .textAlign(this.isNeedJustify ? TextAlign.JUSTIFY : TextAlign.Start)
    }
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .backgroundColor(SystemMaterialManager.listBackgroundColor())
    .padding({
      top: $r('app.float.padding_16'),
      bottom: $r('app.float.padding_16'),
    })
    .bindSheet($$this.isModeFrameShow, this.modeFrameComponent(), {
      height: this.sheetData.sheetHeight,
      preferType: this.sheetData.sheetPreferType,
      onDisappear: () => {
        AppStorage.setOrCreate<boolean>('isBindSheetOff', true);
      }
    })
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, `aboutToAppear. ${this.mServiceEntity?.getServiceName()} isOn:${this.mServiceEntity?.isServiceChecked()}`);
    this.isServiceChecked = this.mServiceEntity?.isServiceChecked();
    this.model.permissionInfoDialogController = this.permissionInfoDialogController;
    this.model.setBindsheetOpen = (val: boolean) => {
      this.isModeFrameShow = val;
    };
  }

  onServiceEntityChange(): void {
    LogUtil.info(TAG, `onServiceEntityChange. ${this.mServiceEntity?.getServiceName()} isOn:${this.mServiceEntity?.isServiceChecked()}`);
    this.isServiceChecked = this.mServiceEntity?.isServiceChecked();
  }

  private openModeFrame(want?: Want): void {
    AppStorage.setOrCreate<boolean>('isBindSheetOff', false);
    this.model.openDialog(want);
  }

  private closeDialog(): void {
    this.model.closeDialog();
  }
}
