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
import resmgr from '@ohos.resourceManager';
import i18n from '@ohos.i18n';
import { LogUtil } from '../util/LogUtil';
import { CommonConstant } from '../constant/CommonConstant';
import { FocusUtil } from '../util/FocusUtil';
import { FooterStyleModel } from '../model/StyleModel';
import { StyleManager } from '../manager/StyleManager';
import { pageLayoutManager } from '../manager/PageLayoutManager';
import { PageLayoutModel } from '../model/PageLayoutModel';

const TAG: string = 'FooterComponent';

const DELAY_TIME: number = 500;

/**
 * 页脚组件
 */
@Component
export struct FooterComponent {
  @StorageProp('footBtnWidth') footBtnWidth: number | Resource = $r('app.float.width_188');
  @State pageLayoutModel: PageLayoutModel = pageLayoutManager.getPageLayoutConfig();
  // 当前语言
  @StorageLink('curLanguage') @Watch('curLanguageChange') curLanguage: string = i18n.System.getSystemLanguage();
  @StorageLink('isFolded') isFolded: boolean = false;
  @State buttonName: resmgr.Resource = $r('app.string.empty_string');
  @State textName: resmgr.Resource = $r('app.string.empty_string');
  @Prop accessibilityReadingText: string = '';
  buttonOnClick: () => void = () => {
  };
  @Prop isButtonEnable: boolean = true;
  @Prop buttonLoadingFlag: boolean = false;
  textOnClick?: () => void = () => {
  };
  @State isTextClickEnable: boolean = true;
  @State textFontColor?: Resource = $r('sys.color.ohos_id_color_text_primary_activated');
  @State textFontWeight?: FontWeight = FontWeight.Regular;
  @State maxFontScale: number = this.curLanguage === 'bo' ? 1.3 : 1.45;
  private isButtonShow: boolean = true;
  private footerStyleModel: FooterStyleModel | undefined = StyleManager.getInstance().getFooterStyleModel();
  private isButtonClickEnable: boolean = true;

  aboutToAppear(): void {
    LogUtil.info(TAG, `aboutToAppear with isButtonEnable:${this.isButtonEnable}`);
  }

  curLanguageChange(): void {
    this.maxFontScale = this.curLanguage === 'bo' ? 1.3 : 1.45;
  }

  build() {
    Column() {
      Button() {
        if (this.buttonLoadingFlag) {
          LoadingProgress()
            .width(this.footerStyleModel?.buttonLoadingProgressSize)
            .height(this.footerStyleModel?.buttonLoadingProgressSize)
            .color($r('sys.color.ohos_id_color_primary_contrary'))
        } else {
          Text(this.buttonName)
            .maxFontScale(this.maxFontScale)
            .textOverflow({ overflow: this.footerStyleModel?.textOverflow })
            .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
            .textStyle()
        }
      }
      .id(`button_footercomponent_${this.buttonName}`)
      .width(this.pageLayoutModel.isSpecialStyle ? this.pageLayoutModel.btnWidth : this.footBtnWidth)
      .padding({
        left: $r('app.float.margin_16'),
        right: $r('app.float.margin_16'),
      })
      .margin({
        bottom: this.pageLayoutModel.isSpecialStyle ? this.pageLayoutModel.agreeBtnMarginBottom :
          this.footerStyleModel?.agreeBtnBottomMargin
      })
      .height($r('app.float.height_40'))
      .backgroundColor($r('app.color.btn_color'))
      .type(this.footerStyleModel?.buttonType)
      .borderRadius(this.footerStyleModel?.buttonBorderRadius)
      .align(Alignment.Center)
      .visibility(this.isButtonShow ? Visibility.Visible : Visibility.None)
      .enabled(this.isButtonEnable && !this.buttonLoadingFlag)
      .accessibilityText(this.accessibilityReadingText)
      .onClick(() => {
        LogUtil.info(TAG, `aboutToAppear with isButtonEnable: ${this.isButtonEnable}`);
        if (this.buttonOnClick && this.isButtonEnable && this.isButtonClickEnable) {
          this.isButtonClickEnable = false;
          this.buttonOnClick();
          setTimeout(() => {
            this.isButtonClickEnable = true;
          }, DELAY_TIME);
        }
      });

      Button() {
        Text(this.textName)
          .fontColor(this.textFontColor ?? $r('sys.color.ohos_id_color_text_primary'))
          .maxFontScale(this.maxFontScale)
          .textOverflow({ overflow: this.footerStyleModel?.textOverflow })
          .textStyle()
      }
      .id(`text_footercomponent_${this.textName}`)
      .height($r('app.float.height_40'))
      .width(this.pageLayoutModel.isSpecialStyle ? this.pageLayoutModel.btnWidth : this.footBtnWidth)
      .align(Alignment.Center)
      .type(this.footerStyleModel?.buttonType)
      .backgroundColor(!this.isFolded && this.pageLayoutModel.isSpecialStyle ?
        $r('sys.color.comp_background_tertiary') :
        Color.Transparent)
      .visibility(!this.isButtonShow ? Visibility.Visible : Visibility.None)
      .margin({
        bottom: this.pageLayoutModel.isSpecialStyle ? this.pageLayoutModel.skipBtnMarginBottom :
          this.footerStyleModel?.skipBtnBottomMargin
      })
      .borderRadius(this.footerStyleModel?.buttonBorderRadius)
      .onClick(() => {
        LogUtil.info(TAG, `aboutToAppear with isTextClickEnable: ${this.isTextClickEnable}`);
        if (this.textOnClick && this.isTextClickEnable) {
          this.isTextClickEnable = false;
          this.textOnClick();
          setTimeout(() => {
            this.isTextClickEnable = true;
          }, DELAY_TIME);
        }
      });
    }
    .id(CommonConstant.FOOTER_COMPONENT_ID)
    .onAppear(() => {
      if (this.footerStyleModel?.isNeedFocus) {
        FocusUtil.requestFocus(CommonConstant.FOOTER_COMPONENT_ID, this.getUIContext());
      }
    })
    .width('100%')
    .accessibilityLevel('no')
  }
}

@Extend(Text)
function textStyle(){
  .height('100%')
  .fontWeight(FontWeight.Medium)
  .textAlign(TextAlign.Center)
  .fontSize($r('sys.float.ohos_id_text_size_button1'))
  .minFontSize($r('app.float.font_9'))
  .maxFontSize($r('app.float.font_16'))
  .maxLines(1)
}