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
/**
 * 标题复选框
 */
@Component
export struct TitleCheckBox {
  @Link isOn: boolean;
  private mEnabled: boolean = true;
  mTitle: ResourceStr = $r('app.string.empty_string');
  mOnChange: (isOn: boolean) => void = (isOn: boolean) => {
  };

  build() {
    Column() {
      Row() {
        Text(this.mTitle)
          .size({ width: 'calc(100% - 60vp)' })
          .id(`text_title_check_box_${this.mTitle}`)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .textAlign(TextAlign.Start)
          .maxLines(3)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .accessibilityLevel('yes')
        Toggle({ type: ToggleType.Switch, isOn: this.isOn })
          .id(`toggle_title_check_box_${this.mTitle}`)
          .margin(0)// 规避控件的默认margin
          .onChange(this.mOnChange)
          .enabled(this.mEnabled)
          .hoverEffect(HoverEffect.None)
      }
      .width('100%')
      .align(Alignment.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .accessibilityLevel('no')
      .onClick(() => {
        if (!this.mEnabled) {
          return;
        }
        this.isOn = !this.isOn;
        if (this.mOnChange) {
          this.mOnChange(this.isOn);
        }
      });
    }
    .width('100%')
    .borderRadius($r('app.float.distance_16'))
    .padding({
      left: $r('app.float.padding_12'),
      right: $r('app.float.padding_12'),
    });
  }
}
