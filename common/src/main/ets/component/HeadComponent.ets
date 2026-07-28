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
import { uiEffect } from '@kit.ArkGraphics2D';
import { Callback } from '@kit.BasicServicesKit';
import { LengthMetrics } from '@kit.ArkUI';
import { AccessibilityUtil } from '../util/AccessibilityUtil';
import { LogUtil } from '../util/LogUtil';
import { ResourceStringUtil } from '../util/ResourceStringUtil';
import { HeadModel } from '../model/HeadModel';
import { ButtonSystemMaterialModifier } from '../manager/SystemMaterialManager';

const TAG: string = 'TitleComponent';
const BACKWARD_BUTTON_INDEX: number = 999;
const BACKWARD_BUTTON_POSITION: number = 16;
const DELAY_TIME: number = 500;
const SUB_TITLE_HEIGHT: number = 72;
const SUB_TITLE_COVER_HEIGHT: number = 56;
const OPACITY_ONE: number = 1;
const TEXT_HEAD_COMPONENT_TITLE: string = 'text_head_component_title';
const BTN_HEAD_COMPONENT_BACK: string = 'btn_head_component_back';

@Component
export struct HeadComponent {
  @State isArrowEnable: boolean = true;
  @Prop headName: ResourceStr = $r('app.string.empty_string');
  @State headModel: HeadModel = new HeadModel();
  backClick: Callback<void> = () => {};
  isBackArrowVisible: boolean = true;

  @Builder
  backArrowComp(): void {
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
      .attributeModifier(new ButtonSystemMaterialModifier($r('sys.color.ohos_id_color_button_normal')))
      .height($r('app.float.height_40'))
      .width($r('app.float.height_40'))
      .onAppear(() => {
        this.accessibilityFocusOnBack();
      })
      .borderRadius($r('app.float.radius_20'))
      .id(BTN_HEAD_COMPONENT_BACK)
      .accessibilityText($r('app.string.back_string'))
      .onClick(() => {
        LogUtil.info(TAG, `aboutToAppear with isArrowEnable: ${this.isArrowEnable}`);
        if (this.isArrowEnable) {
          this.isArrowEnable = false;
          this.backClick();
          setTimeout(() => {
            this.isArrowEnable = true;
          }, DELAY_TIME);
        }
      })
    }
    .position({
      start: LengthMetrics.vp(BACKWARD_BUTTON_POSITION),
      top: LengthMetrics.vp(BACKWARD_BUTTON_POSITION)
    })
    .zIndex(BACKWARD_BUTTON_INDEX)
    .visibility(this.isBackArrowVisible ? Visibility.Visible : Visibility.Hidden)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  subTitle() {
    Column() {
      Column()
        .width('100%')
        .height(SUB_TITLE_COVER_HEIGHT)
        .compositingFilter(uiEffect.createFilter().radiusGradientBlur(40, {
          fractionStops: [[1, 0], [0, 1]],
          direction: GradientDirection.Bottom
        }))
        .blendMode(BlendMode.SRC_IN);
    }
    .width('calc(100% - 32vp)')
    .height(SUB_TITLE_COVER_HEIGHT)
    .linearGradient({
      angle: 180, colors: [['rgba(0, 0, 0, 1)', 0],
        ['rgba(0, 0, 0, 1)', 0.8],
        ['rgba(0, 0, 0, 0)', 1]]
    })
    .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
    .borderRadius({
      topLeft: $r('app.float.border_radius_32'),
      topRight: $r('app.float.border_radius_32')
    })
    .margin({
      top: $r('app.float.margin_16'),
      left: $r('app.float.margin_16'),
      right: $r('app.float.margin_16')
    })

    Column() {
      Text(this.headName)
        .fontWeight(600)
        .fontSize($r('app.float.head_font_24'))
        .maxFontSize($r('app.float.head_font_24'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(1)
        .textAlign(TextAlign.Start)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
    }
    .padding({
      start: LengthMetrics.vp(this.isBackArrowVisible ? SUB_TITLE_HEIGHT : 16),
      end: LengthMetrics.vp(16),
    })
    .alignItems(this.isBackArrowVisible ? HorizontalAlign.Start : HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .height(SUB_TITLE_HEIGHT)
    .width('100%')
    .opacity(OPACITY_ONE - this.headModel.titleOpacity)
    .borderRadius({
      topLeft: $r('app.float.border_radius_32'),
      topRight: $r('app.float.border_radius_32')
    })
  }

  @Builder
  mainTitle() {
    Column() {
      Column() {
        // 标题
        Text(this.headName)
          .fontWeight(600)
          .fontSize($r('app.float.fix_font_36'))
          .maxFontSize($r('app.float.fix_font_36'))
          .minFontSize($r('app.float.fix_font_20'))
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .maxLines(2)
          .textAlign(TextAlign.Center)
          .width('100%')
          .onAppear(() => {
            this.accessibilityFocusOnTitle();
          })
          .height(LayoutPolicy.fixAtIdealSize)
      }
      .width('100%')
      .height(LayoutPolicy.fixAtIdealSize)
      .padding({
        top: $r('app.float.padding_36'),
        left: $r('app.float.padding_16'),
        right: $r('app.float.padding_16'),
        bottom: $r('app.float.padding_48')
      })
      .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
        if (newValue.height && typeof newValue.height === 'number') {
          this.headModel.maxTitleHeight = newValue.height;
        }
      })
    }
    .margin({
      top: $r('app.float.margin_36')
    })
    .reverse(true)
    .clip(true)
    .height(this.headModel.titleHeight)
    .opacity(this.headModel.titleOpacity)
  }

  @Builder
  title() {
    Column() {
      this.backArrowComp()
      Stack({
        alignContent: Alignment.TopStart
      }) {
        this.mainTitle()
        this.subTitle()
      }
      .accessibilityGroup(true)
      .id(TEXT_HEAD_COMPONENT_TITLE)
      .accessibilityText(ResourceStringUtil.getStringSync(this.headName))
      .accessibilityFocusDrawLevel(FocusDrawLevel.TOP)
    }
  }

  build() {
    this.title()
  }

  accessibilityFocusOnBack(): void {
    if (this.isBackArrowVisible) {
      AccessibilityUtil.getFocusOnlost(BTN_HEAD_COMPONENT_BACK, AccessibilityUtil.BUTTON);
    }
  }

  accessibilityFocusOnTitle(): void {
    if (!this.isBackArrowVisible) {
      AccessibilityUtil.getFocusOnlost(TEXT_HEAD_COMPONENT_TITLE);
    }
  }
}