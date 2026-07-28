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

@Component
export struct TextItemComponent {
  mHeadName?: ResourceStr;
  @State boomStyle?: Resource = $r('app.float.distance_12');
  @State fontColor?: Resource = $r('sys.color.ohos_id_color_text_primary');
  @State fontSize?: Resource = $r('sys.float.ohos_id_text_size_body1');
  @State lineHeight?: number = -1; // 默认不限制文本高度，自适应大小

  build() {
    Column() {
      // 标题
      Text(this.mHeadName)
        .id('text_textcomponent_title')
        .fontColor(this.fontColor ?? $r('sys.color.ohos_id_color_text_primary'))
        .fontSize(this.fontSize ?? $r('sys.float.ohos_id_text_size_body1'))
        .fontWeight(FontWeight.Regular)
        .margin({
          bottom: this.boomStyle ?? $r('app.float.distance_12'),
        })
        .width('100%')
    }
    .padding({
      left: $r('sys.float.ohos_id_default_padding_start'),
      right: $r('sys.float.ohos_id_default_padding_end'),
    })
    .justifyContent(FlexAlign.Start)
  }
}
