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
@Component
export struct GridLayoutComp {
  /**
   * 自定义内容区域
   */
  @BuilderParam buildContent?: () => void;

  /**
   * 栅格配置：按照屏幕横向像素分成N栅格
   *
   * xs: 0~600vp 4栅格
   * sm: 600vp~1080vp 8栅格
   * md: 1080vp~无穷 12栅格
   */
  private gridRowColumnOption: GridRowColumnOption = { xs: 4, sm: 8, md: 12 };

  /**
   * 占栅格组件的列数，默认占满全部栅格
   */
  private columnSpanConfig: GridColColumnOption = { xs: 4, sm: 6, md: 6 };

  /**
   * 相对于前一个栅格偏移的列数，表示从第几个栅格开始布局，默认从第0个栅格开始
   */
  private columnOffsetConfig: GridColColumnOption = { xs: 0, sm: 1, md: 3 };

  /**
   * 栅格之间的间距
   */
  private gutter: GutterOption = {x: { xs: 16, sm: 16, md: 16 } };

  /**
   * 断点，设置0-600vp,600vp-1080vp,1080vp-无穷三挡
   */
  private breakpointsConfig: BreakPoints = { value: ['600vp', '1080vp']}

  build(): void {
    GridRow({
      columns: this.gridRowColumnOption,
      gutter: this.gutter,
      direction: GridRowDirection.Row,
      breakpoints: this.breakpointsConfig
    }) {
      GridCol({
        span: this.columnSpanConfig,
        offset: this.columnOffsetConfig,
      }) {
        this.buildContent?.();
      }
    }
  }
}