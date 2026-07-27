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
import { BasePageController } from '../controller/BasePageController';
import { pageLayoutManager } from '../manager/PageLayoutManager';
import { PageLayoutModel } from '../model/PageLayoutModel';
import { LogUtil } from '../util/LogUtil';

const DELAY_TIME: number = 500;
const TAG: string = 'CardContainerView';

@Builder
function dummyFunction() {
};

/**
 * 5.0新样式片卡片组件
 */
@Component
export struct CardNonGridComponent {
  @BuilderParam bodyContent: () => void = dummyFunction;
  @State mHeadName: ResourceStr = $r('app.string.empty_string');
  @State pageLayoutModel: PageLayoutModel = pageLayoutManager.getPageLayoutConfig();
  @State isArrowEnable: boolean = true;
  @State isArrowHover: boolean | undefined = false;
  @State buttonIsHover: boolean = false

  mBasePageController: BasePageController | null = null;
  isBackArrowVisible: boolean = true;
  isUseTitle: boolean = true;
  backClick?: () => void;

  build() {
    Column() {
      Column() {
        Column() { // 返回箭头
          Column() {
            Button() {
              SymbolGlyph($r('sys.symbol.chevron_backward'))
                .id('img_headcomponent_back')
                .height($r('app.float.wh_value_24'))
                .width($r('app.float.wh_value_24'))
                .enabled(this.isArrowEnable)
                .fontColor([$r('sys.color.ohos_id_color_titlebar_icon')])
                .fontSize($r('app.float.wh_value_24'))
                .draggable(false)
            }
            .backgroundColor((this.buttonIsHover) ? $r('sys.color.ohos_id_color_button_normal') : Color.Transparent)
            .type(ButtonType.Normal)
            .height($r('app.float.wh_value_40'))
            .width($r('app.float.wh_value_40'))
            .borderRadius($r('sys.float.ohos_id_corner_radius_icon'))
            .onHover((isHover: boolean) => {
              if (isHover) {
                this.buttonIsHover = true;
              } else {
                this.buttonIsHover = false;
              }
            })
            .onClick(() => {
              LogUtil.info(TAG, `aboutToAppear with isArrowEnable: ${this.isArrowEnable}`);
              if (this.isArrowEnable) {
                this.isArrowEnable = false;
                if(this.backClick) {
                  this.backClick();
                }
                this.mBasePageController?.handlePrevButtonClick();
                setTimeout(() => {
                  this.isArrowEnable = true;
                }, DELAY_TIME);
              }
            })
          }
          .padding($r('app.float.wh_value_16'))
          .visibility(this.isBackArrowVisible ? Visibility.Visible : Visibility.Hidden)
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        // 标题
        Column() {
          // 标题
          Text(this.mHeadName)
            .id('text_headcomponent_title')
            .fontWeight(600)
            .fontSize($r('app.float.fix_font_36'))
            .maxFontSize($r('app.float.fix_font_36'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .maxLines(2)
            .textAlign(TextAlign.Center)
            .width('100%')
        }
        .margin({ bottom: $r('app.float.distance_48') })
        .width($r('app.float.wh_value_560'))
        .visibility(this.isUseTitle ? Visibility.Visible : Visibility.None)

        // 主体
        if (this.bodyContent) {
          Column() {
            this.bodyContent()
          }
          .layoutWeight(1)
        }
      }
      .borderColor($r('app.color.card_border_color'))
      .borderWidth(1)
      .borderRadius(16)
      .borderStyle(BorderStyle.Solid)
      .backdropBlur(500)
      .width('100%')
      .height('100%')
      .shadow({ radius: 100, offsetX: 0, offsetY: 0, color: '#0C000000' })
      .backgroundColor($r('app.color.card_bg_color'))
      .padding({ bottom: this.pageLayoutModel.cardViewPaddingBottom })
    }
    .width($r('app.float.wh_value_680'))
    .margin({
      top: $r('app.float.margin_144'),
      bottom: $r('app.float.margin_144'),
    })
    .layoutWeight(1)
  }
}