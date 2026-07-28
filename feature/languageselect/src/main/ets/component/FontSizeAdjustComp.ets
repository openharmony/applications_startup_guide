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
import emitter from '@ohos.events.emitter';
import settings from '@ohos.settings';
import i18n from '@ohos.i18n';
import {
  FocusUtil,
  GridLayoutComp,
  CommonConstant,
  LogUtil,
  FontSizeAdjustUtil,
  SettingUtil,
  DeviceUtil,
  AccessibilityUtil,
  ResourceStringUtil,
  Event,
  BgVideoPlayerManager
} from '@ohos/hwstartupguide.common';

const IS_DEVICE_PC: boolean = DeviceUtil.isDevicePc();
const TAG: string = 'FontSizeAdjustComponent';
const FONT_SIZE_BUTTON_Z_INDEX = 1;

@Component
export struct FontSizeAdjustComp {
  @StorageProp('footBtnWidth') footBtnWidth: number | Resource = $r('app.float.width_188');
  // 当前语言
  @StorageLink('curLanguage') curLanguage: string = i18n.System.getSystemLanguage();
  // 当前语言是否为镜像语言
  @StorageLink('isoLanguage') isoLanguage: boolean = false;
  @State fontSizeName: Resource = this.getDefaultFontSizeScaleName();
  @State fontSizeScale: number = this.getDefaultFontSizeScale();
  @State fontSizeStepVal: number = this.getDefaultFontSizeScaleVal();
  // 判断设备是否为宽屏设备，UX规格宽屏对话框安全距离为100vp，非宽屏32vp
  @State isWideScreen: boolean = DeviceUtil.isDevicePc() || DeviceUtil.isDevicePad() || DeviceUtil.isFoldExpanded();
  @Link isMainPage: boolean;
  private firstFontSizeStepVal: number = CommonConstant.FONT_STEP_BY_SCALE_MAP.get(this.fontSizeScale) as number;
  private maxFontScale: number = this.curLanguage === 'bo' ? 1.3 : 1.45 // 判断系统语言是否为藏语来调整按钮最大缩放比例
  private safeMargin: Resource = this.isWideScreen ? $r('app.float.wh_value_100') : $r('app.float.wh_value_32');
  private isNeedFocus: boolean = false;
  private fontSizeAdjustCompId: string = 'fontSizeAdjustCompId';
  @State buttonBackgroundColor: ResourceColor = '';
  @Prop buttonType: ButtonType;
  @Prop backButtonBorderRadius: Resource | string = '';
  buttonOnHover: (isHover: boolean) => void = () => {
  };

  private handlePrevButtonClick(): void {
    if (this.fontSizeStepVal === this.firstFontSizeStepVal) {
      this.isMainPage = true;
      BgVideoPlayerManager.getInstance().playVideo(2);
      return;
    }
    this.fontSizeStepVal = this.firstFontSizeStepVal
    this.updateFontSizeConfig();
    this.isMainPage = true;
    BgVideoPlayerManager.getInstance().playVideo(2);
  }

  private confirmButtonClick(): void {
    this.isMainPage = true;
    BgVideoPlayerManager.getInstance().playVideo(2);
  }

  private registerUpdateConfigEvent(): void {
    emitter.on(Event.FONTSIZE_CONFIGURATION_UPDATE, () => {
      LogUtil.info(TAG, 'received config update event');
      this.changeFontName();
    })
    LogUtil.info(TAG, 'registerUpdateConfigEvent');
  }

  private unRegisterUpdateConfigEvent(): void {
    emitter.off(Event.FONTSIZE_CONFIGURATION_UPDATE);
    LogUtil.info(TAG, 'unRegisterUpdateConfigEvent');
  }

  private updateFontSizeConfig(): void {
    this.changeFontSizeScale();
    this.changeFontName();
    FontSizeAdjustUtil.setFontSizeScale(this.fontSizeScale);
  }

  private changeFontName(): void {
    this.fontSizeName = CommonConstant.FONT_NAME_STEP_MAP.get(this.fontSizeStepVal) as Resource;
  }

  private changeFontSizeScale(): void {
    this.fontSizeScale = CommonConstant.FONT_SCALE_BY_STEP_MAP.get(this.fontSizeStepVal) as number
  }

  private getDefaultFontSizeScaleName(): Resource {
    try {
      let defaultFontSizeScale: number = Number(SettingUtil
        .getValueSync(CommonConstant.SETTINGS_DATA_FONT_SIZE_SCALE, CommonConstant.DEFAULT_FONT_SIZE_SCALE,
          settings.domainName.USER_PROPERTY));
      LogUtil.info(TAG, `getDefaultFontSizeScaleName By ${defaultFontSizeScale}`);
      if (defaultFontSizeScale <= CommonConstant.TEXT_FONT_SIZE_HUGE) {
        return CommonConstant.FONT_NAME_SCALE_MAP.get(defaultFontSizeScale) as Resource;
      } else {
        return $r('app.string.display_mode_font_size_huge');
      }
    } catch (error) {
      LogUtil.error(TAG, `getDefaultFontSizeScaleName Error ${error}`);
      return CommonConstant.FONT_NAME_SCALE_MAP.get(CommonConstant.TEXT_FONT_SIZE_NORMAL) as Resource;
    }
  }

  private getDefaultFontSizeScaleVal(): number {
    try {
      if (this.fontSizeScale <= CommonConstant.TEXT_FONT_SIZE_HUGE) {
        return CommonConstant.FONT_STEP_BY_SCALE_MAP.get(this.fontSizeScale) as number;
      } else {
        return CommonConstant.TEXT_FONT_SIZE_HUGE_STEP;
      }
    } catch (error) {
      LogUtil.error(TAG, `getDefaultFontSizeScaleVal Error ${error}`);
      return CommonConstant.TEXT_FONT_SIZE_NORMAL_STEP;
    }
  }

  private getDefaultFontSizeScale(): number {
    try {
      let defaultFontSizeScale: number = Number(SettingUtil
        .getValueSync(CommonConstant.SETTINGS_DATA_FONT_SIZE_SCALE, CommonConstant.DEFAULT_FONT_SIZE_SCALE,
          settings.domainName.USER_PROPERTY));
      if (defaultFontSizeScale <= CommonConstant.TEXT_FONT_SIZE_HUGE) {
        return defaultFontSizeScale;
      } else {
        return CommonConstant.TEXT_FONT_SIZE_HUGE;
      }
    } catch (error) {
      LogUtil.error(TAG, `getDefaultFontSizeScale Error ${error}`);
      return CommonConstant.TEXT_FONT_SIZE_NORMAL;
    }
  }

  private changeFontSize(isMin: boolean): void {
    let curStepVal = this.fontSizeStepVal +

      (isMin ? -CommonConstant.FONT_SIZE_STEP_NUM : CommonConstant.FONT_SIZE_STEP_NUM);
    if (isMin) {
      curStepVal = Math.max(curStepVal, CommonConstant.MIN_FONT_SIZE_LEVEL);
    } else {
      curStepVal = Math.min(curStepVal, CommonConstant.MAX_FONT_SIZE_LEVEL);
    }
    AccessibilityUtil.textAnnounced(
      ResourceStringUtil.getStringSync(CommonConstant.FONT_NAME_STEP_MAP.get(curStepVal)));
    if (curStepVal === this.fontSizeStepVal) {
      LogUtil.info(TAG, `The font cannot be changed. [${curStepVal}]`);
      return;
    }
    this.fontSizeStepVal = curStepVal;
    this.updateFontSizeConfig();
  }

  /**
   * 左侧对话框通用样式
   */
  @Styles
  messageLeftBoxStyles() {
    .backgroundColor($r('sys.color.ohos_id_color_list_card_bg'))
    .borderRadius({
      topLeft: this.isoLanguage ? $r('app.float.wh_value_16') : $r('app.float.wh_value_2'),
      topRight: this.isoLanguage ? $r('app.float.wh_value_2') : $r('app.float.wh_value_16'),
      bottomLeft: $r('app.float.wh_value_16'),
      bottomRight: $r('app.float.wh_value_16'),
    })
    .padding({
      top: $r('app.float.wh_value_8'),
      left: $r('app.float.wh_value_10'),
      right: $r('app.float.wh_value_10'),
      bottom: $r('app.float.wh_value_8'),
    })
  }

  /**
   * 右侧对话框通用样式
   */
  @Styles
  messageRightBoxLeftStyles() {
    .backgroundColor($r('app.color.font_size_message_bg_color'))
    .borderRadius({
      topLeft: this.isoLanguage ? $r('app.float.wh_value_2') : $r('app.float.wh_value_16'),
      topRight: this.isoLanguage ? $r('app.float.wh_value_16') : $r('app.float.wh_value_2'),
      bottomLeft: $r('app.float.wh_value_16'),
      bottomRight: $r('app.float.wh_value_16'),
    })
    .padding({
      top: $r('app.float.wh_value_8'),
      left: $r('app.float.wh_value_10'),
      right: $r('app.float.wh_value_10'),
      bottom: $r('app.float.wh_value_8'),
    })
  }

  @Builder
  bodyComponent(): void {
    Column() {
      Column() {
        this.headComponent();
        Column() {
          this.buildFontSizeItem();
        }
        .layoutWeight(1)
      }
      .borderColor($r('app.color.card_border_color'))
      .borderWidth(1)
      .borderRadius(IS_DEVICE_PC ? $r('app.float.wh_value_16') : $r('app.float.wh_value_32'))
      .borderStyle(BorderStyle.Solid)
      .backdropBlur(500)
      .width('100%')
      .height('100%')
      .shadow({ radius: 8, offsetX: 0, offsetY: 0, color: '#19000000' })
      .backgroundColor($r('app.color.card_bg_color'))
      .padding({
        bottom: IS_DEVICE_PC ? $r('app.float.wh_value_32') : $r('app.float.wh_value_16'),
      })
    }
    .width( IS_DEVICE_PC ? $r('app.float.wh_value_680') : '100%')
    .height('100%')
    .padding({
      top: IS_DEVICE_PC ? $r('app.float.wh_value_144') : $r('app.float.wh_value_56'),
      bottom: IS_DEVICE_PC ? $r('app.float.wh_value_144') : $r('app.float.wh_value_132'),
      left: IS_DEVICE_PC ? 0 : $r('app.float.wh_value_16'),
      right: IS_DEVICE_PC ? 0 : $r('app.float.wh_value_16'),
    })
  }

  @Builder
  headComponent(): void {
    Column() {
      // 返回箭头
      Button() {
        SymbolGlyph($r('sys.symbol.chevron_backward'))
          .id('img_headcomponent_back')
          .height($r('app.float.wh_value_24'))
          .width($r('app.float.wh_value_24'))
          .fontColor([$r('sys.color.ohos_id_color_titlebar_icon')])
          .fontSize($r('app.float.wh_value_24'))
          .draggable(false)
      }
      .backgroundColor(this.buttonBackgroundColor)
      .type(this.buttonType)
      .height($r('app.float.wh_value_40'))
      .width($r('app.float.wh_value_40'))
      .borderRadius(this.backButtonBorderRadius)
      .id('btn_headcomponent_back')
      .accessibilityText(ResourceStringUtil.getStringSync($r('app.string.back_string')))
      .onHover((isHover: boolean) => {
        this.buttonOnHover(isHover);
      })
      .onClick(() => {
        this.handlePrevButtonClick();
      })
    }
    .width('100%')
    .padding($r('app.float.wh_value_16'))
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)

    Column() {
      // 标题
      Text($r('app.string.vision_settings'))
        .id('text_headcomponent_title')
        .fontWeight(600)
        .fontSize($r('app.float.fix_font_36'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(2)
        .textAlign(TextAlign.Center)
        .width('100%')
    }
    .margin({ bottom: $r('app.float.wh_value_48') })
    .width(IS_DEVICE_PC ? $r('app.float.wh_value_560') : '100%')
  }

  @Builder
  buildFontSizeItem(): void {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Center
    }) {
      Scroll() {
        this.messageCompItem()
      }
      .flexGrow(1)
      Column() {
        this.sliderComponent()
      }
      .flexShrink(0)
      .padding({
        left: IS_DEVICE_PC ? 0 : $r('app.float.wh_value_16'),
        right: IS_DEVICE_PC ? 0 : $r('app.float.wh_value_16'),
      })
    }
    .width(IS_DEVICE_PC ? $r('app.float.wh_value_560') : '100%')
    .constraintSize({ minHeight: '100%' })
  }

  @Builder
  footerComponent(): void {
    Column() {
      Button({ type: ButtonType.Normal }) {
        Text($r('app.string.confirm_button'))
          .width('100%')
          .height('100%')
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .align(Alignment.Center)
          .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
          .fontSize($r('app.float.font_16'))
          .maxFontScale(this.maxFontScale)
      }
      .width(this.footBtnWidth)
      .id(this.fontSizeAdjustCompId)
      .onAppear(() => {
        if (this.isNeedFocus) {
          FocusUtil.requestFocus(this.fontSizeAdjustCompId, this.getUIContext());
        }
      })
      .height($r('app.float.wh_value_40'))
      .borderRadius(IS_DEVICE_PC ? $r('sys.float.ohos_id_corner_radius_icon') :
        $r('sys.float.ohos_id_corner_radius_button'))
      .backgroundColor($r('app.color.btn_color'))
      .align(Alignment.Center)
      .onClick(() => {
        this.confirmButtonClick();
      });
    }
    .width('100%')
    .padding({
      top: $r('app.float.wh_value_24'),
      bottom: IS_DEVICE_PC ? $r('app.float.wh_value_80') : $r('app.float.wh_value_68')
    })
    .alignItems(HorizontalAlign.Center)
  }

  /**
   * 演示对话框组件
   */
  @Builder
  messageCompItem(): void {
    Column() {
      Text($r('app.string.setting_font_size'))
        .fontSize($r('app.float.font_16'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .textAlign(TextAlign.Center)
      Column() {
        Column() {
          Text($r('app.string.setting_font_size_content1'))
            .fontSize($r('app.float.font_16'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
            .textAlign(TextAlign.Start)
        }
        .stateStyles({ normal: this.messageRightBoxLeftStyles })
      }
      .alignItems(HorizontalAlign.End)
      .width('100%')
      .padding({
        left: this.isoLanguage ? 0 : this.safeMargin,
        right: this.isoLanguage ? this.safeMargin : 0,
      })
      .margin({
        top: $r('app.float.wh_value_48'),
        bottom: $r('app.float.wh_value_16')
      })
      Column() {
        Column() {
          Text($r('app.string.setting_font_size_content2'))
            .fontSize($r('app.float.font_16'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .textAlign(TextAlign.Start)
        }
        .stateStyles({ normal: this.messageLeftBoxStyles })
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .padding({
        left: this.isoLanguage ? this.safeMargin : 0,
        right: this.isoLanguage ? 0 : this.safeMargin,
      })
    }
    .padding({
      left: IS_DEVICE_PC ? 0 : $r('app.float.wh_value_16'),
      right: IS_DEVICE_PC ? 0 : $r('app.float.wh_value_16'),
    })
    .constraintSize({ minHeight: '100%' })
  }

  /**
   * 设置字体大小的滑动条
   */
  @Builder
  sliderComponent(): void {
    Column() {
      Row() {
        this.fontSizeTextItem();
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height($r('app.float.wh_value_48'))

      this.sliderItem();
    }
    .backgroundColor($r('app.color.list_bg_color'))
    .borderRadius($r('app.float.wh_value_16'))
    .height($r('app.float.wh_value_96'))
    .width('100%')
    .padding({
      left: $r('app.float.wh_value_12'),
      right: $r('app.float.wh_value_12')
    })
    .margin({ top: $r('app.float.wh_value_16') })
  }

  @Builder
  fontSizeTextItem(): void {
    Text($r('app.string.screen_zoom_text_size'))
      .fontSize($r('app.float.font_16'))
      .fontWeight(FontWeight.Medium)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .textAlign(TextAlign.Start)
    Text(this.fontSizeName)
      .fontSize($r('app.float.font_14'))
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .fontWeight(FontWeight.Regular)
  }

  @Builder
  sliderItem(): void {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Button({ type: ButtonType.Normal }) {
        SymbolGlyph($r('sys.symbol.character'))
          .width($r('app.float.wh_value_24'))
          .height($r('app.float.wh_value_24'))
          .draggable(false)
          .fontColor([$r('sys.color.ohos_id_color_text_primary')])
          .fontWeight(FontWeight.Regular)
          .fontSize($r('app.float.wh_value_24'))
      }
      .stateEffect(false)
      .backgroundColor(Color.Transparent)
      .accessibilityText(ResourceStringUtil.getStringSync($r('app.string.reduce_font_size')))
      .zIndex(FONT_SIZE_BUTTON_Z_INDEX)
      .onClick(() => {
        this.changeFontSize(true)
      })

      Column() {
        Slider({
          style: SliderStyle.InSet,
          value: this.fontSizeStepVal,
          step: CommonConstant.FONT_SIZE_STEP_NUM,
          max: CommonConstant.MAX_FONT_SIZE_LEVEL,
          min: CommonConstant.MIN_FONT_SIZE_LEVEL
        })
          .blockColor($r('app.color.start_window_background'))
          .height($r('app.float.wh_value_20'))
          .showSteps(true)
          .onChange((value: number) => {
            LogUtil.info(TAG, `font size slider val ${value}`);
            let valInteger: number = Number.parseInt(value.toString());
            if (this.fontSizeStepVal === valInteger) {
              LogUtil.info(TAG, 'font size slider val not change');
              return;
            }
            this.fontSizeStepVal = valInteger;
            this.updateFontSizeConfig();
          });
      }
      .height($r('app.float.wh_value_40'))
      .padding({
        top: $r('app.float.wh_value_10'),
        left: $r('app.float.wh_value_6'),
        right: $r('app.float.wh_value_4'),
        bottom: $r('app.float.wh_value_10'),
      })

      Button({ type: ButtonType.Normal }) {
        SymbolGlyph($r('sys.symbol.character'))
          .width($r('app.float.wh_value_28'))
          .height($r('app.float.wh_value_28'))
          .fontColor([$r('sys.color.ohos_id_color_text_primary')])
          .fontSize($r('app.float.wh_value_28'))
          .fontWeight(FontWeight.Medium)
          .draggable(false)
      }
      .stateEffect(false)
      .backgroundColor(Color.Transparent)
      .accessibilityText(ResourceStringUtil.getStringSync($r('app.string.enlarge_font_size')))
      .zIndex(FONT_SIZE_BUTTON_Z_INDEX)
      .onClick(() => {
        this.changeFontSize(false)
      })
    }
    .height($r('app.float.wh_value_48'))
    .padding({
      bottom: $r('app.float.wh_value_8')
    })
  }

  build() {
    Stack() {
      if (!IS_DEVICE_PC) {
        GridLayoutComp({ buildContent: () => this.bodyComponent() })
      } else {
        this.bodyComponent()
      }
      Column() {
        this.footerComponent()
      }
    }
    .width('100%')
    .height('100%')
    .align(Alignment.End)
    .alignContent(Alignment.Bottom)
    .transition(TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({ duration: CommonConstant.TRANSACTION_TIME })
        .combine(TransitionEffect.move(TransitionEdge.END)),
      TransitionEffect.OPACITY.animation({ duration: CommonConstant.TRANSACTION_TIME })
        .combine(TransitionEffect.move(TransitionEdge.END))))
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToappear');
    this.registerUpdateConfigEvent();
    AccessibilityUtil.getFocusOnlost('btn_headcomponent_back', AccessibilityUtil.BUTTON);
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
    this.unRegisterUpdateConfigEvent();
  }
}