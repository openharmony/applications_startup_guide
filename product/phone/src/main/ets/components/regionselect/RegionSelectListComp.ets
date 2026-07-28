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

import { systemDateTime } from '@kit.BasicServicesKit';
import { LanguageAndRegion, RegionDataSource } from '@ohos/hwstartupguide.regionselect';
import {
  AccessibilityUtil,
  HeadAnimateModifier,
  HeadManager,
  LogUtil,
  ResourceUtil
} from '@ohos/hwstartupguide.common';
import { RegionSelectListModel } from '@ohos/hwstartupguide.regionselect';

const TAG: string = 'RegionSelectListComp';
const CLICK_INTERVAL: number = 1500;
const NOT_FOUND: number = -1;

/***
 * 地区选择列表组件
 */
@Component
export struct RegionSelectListComp {
  @State isTouched: boolean = false;
  @State regionData: RegionDataSource = new RegionDataSource(LanguageAndRegion.getSystemRegions())
  @State regionArr: string[] = new RegionDataSource(LanguageAndRegion.getSystemRegions()).regionList as Array<string>;
  @State selectRegion: string = LanguageAndRegion.getDisplayRegion('zh-CN');
  // 当前选中的地区下标
  @State curIndex: number = 0;
  private model?: RegionSelectListModel;
  // 是否进入页面首次切换
  @StorageLink('loadingFlag') loadingFlag: boolean = false;
  // 是否进入页面首次切换
  @State languageClickNum: number = 0;
  // 上次点击的时间
  @State cacheTime: number = 0;
  scroller: Scroller = new Scroller();
  headManager?: HeadManager;

  @Styles
  pressedStyles(): void {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
  }

  @Styles
  normalStyles(): void {
    .backgroundColor('')
  }

  build() {
    Row() {
      List({ scroller: this.scroller }) {
        LazyForEach(this.regionData, (item: string, index?: number) => {
          ListItem() {
            this.regionListItem(item, index)
          }
          .id(`region_item_${item}`)
          .accessibilitySelected(index === this.curIndex)
          .accessibilityText(item)
          .padding({
            left: $r('app.float.wh_value_4'),
            right: $r('app.float.wh_value_4'),
          })
          .margin({
            top: index === 0 ? $r('app.float.wh_value_4') : 0,
            bottom: index === this.regionData.totalCount() - 1 ? $r('app.float.wh_value_4') : 0,
          })
          .width('100%')
          .onClick(() => {
            let latestChangeTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
            if (latestChangeTime - this.cacheTime <= CLICK_INTERVAL && this.languageClickNum > 0) {
              this.loadingFlag = true;
              setTimeout(() => {
                this.onSelectRegionClick(item);
                this.model?.applyRegionChange(this.curIndex);
                this.loadingFlag = false;
              }, CLICK_INTERVAL - (latestChangeTime - this.cacheTime));
            } else {
              this.onSelectRegionClick(item);
              this.model?.applyRegionChange(this.curIndex);
            }
            this.cacheTime = latestChangeTime;
            this.languageClickNum++;
          })
          .accessibilityDescription(index === this.curIndex ? ' ' : '')
          .onAccessibilityActionIntercept((action: AccessibilityAction) => {
            if (action === AccessibilityAction.ACCESSIBILITY_CLICK && index === this.curIndex) {
              LogUtil.info(TAG, 'region item already selected, intercept');
              AccessibilityUtil.textAnnounced(ResourceUtil.getStringByResource($r('app.string.accessibility_selected_language_item'), item));
              return AccessibilityActionInterceptResult.ACTION_INTERCEPT;
            } else {
              return AccessibilityActionInterceptResult.ACTION_CONTINUE;
            }
          })
        }, (item: string) => item + Math.random());
      }
      .width('100%')
      .constraintSize({
        minHeight: '100%'
      })
      .scrollBar(BarState.Off)
      .divider({
        color: $r('app.color.list_divider_color'),
        startMargin: $r('app.float.wh_value_12'),
        endMargin: $r('app.float.wh_value_12'),
        strokeWidth: px2vp(1),
      })
      .clip(true)
      .borderRadius('16vp')
      .width('100%')
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .attributeModifier(new HeadAnimateModifier(this.getUIContext(), this.headManager, this.scroller, false, true))
      .height('100%')
    }
    .width('100%')
  }

  @Builder
  regionListItem(item: string, index?: number) {
    Column() {
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }) {
        Row() {
          Text(item)
            .fontSize($r('app.float.font_16'))
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)
            .margin({
              top: $r('app.float.wh_value_16'),
              bottom: $r('app.float.wh_value_16'),
            })
        }
        .width('calc(100% - 36vp)')

        // 判断是否选择
        if (index === this.curIndex) {
          Checkbox()
            .select(true)
            .shape(CheckBoxShape.CIRCLE)
            .accessibilityLevel('no')
            .hitTestBehavior(HitTestMode.None)
        }
      }
      .padding({
        left: $r('app.float.wh_value_8'),
        right: $r('app.float.wh_value_8'),
      })
      .width('100%')
      .borderRadius($r('app.float.wh_value_12'))
      .stateStyles({
        normal: this.normalStyles,
        pressed: this.pressedStyles,
      })
    }
    .width('100%')
  }

  onSelectRegionClick(item: string) {
    let index: number = this.regionData.regionList.indexOf(item);
    if (NOT_FOUND === index) {
      let selectRegionId: string = this.regionData.getCountry(item);
      LogUtil.error(TAG, `region list does not contain ${selectRegionId}, return`);
      return;
    }
    this.curIndex = index;
  }

  aboutToAppear() {
    LogUtil.info(TAG, 'aboutToAppear');
    this.model = new RegionSelectListModel();

    this.model.getRegionData = () => {
      return this.regionData;
    };

    this.model.updateRegionListToUI = (regionData: RegionDataSource) => {
      this.regionData.copyFrom(regionData);
    };

    this.model.init();

    this.curIndex = this.model.getCurrentIndex();
  }

  aboutToDisappear() {
    LogUtil.info(TAG, 'aboutToDisappear');
    this.model?.applyRegionChange(this.curIndex);
  }
}