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
import { languageAndRegionModel, LanguageDataSource } from '@ohos/hwstartupguide.languageselect';
import {
  AccessibilityUtil,
  HeadAnimateModifier,
  HeadManager,
  LogUtil,
  ResourceUtil
} from '@ohos/hwstartupguide.common';

const TAG: string = 'LanguageSelectList';
const CLICK_INTERVAL: number = 1500;

/***
 * 语言选择列表组件
 */
@Component
export struct LanguageSelectList {
  @State isTouched: boolean = false;
  @State languageData: LanguageDataSource = new LanguageDataSource(languageAndRegionModel.getSystemLanguages());
  // 当前选中的语言下标
  @State curIndex: number = 0;
  // 是否进入页面首次切换
  @StorageLink('loadingCheck') loadingCheck: boolean = false;
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
        LazyForEach(this.languageData, (item: string, index?: number) => {
          ListItem() {
            this.languageListItem(item, index)
          }
          .id(`language_item_${item}`)
          .accessibilitySelected(index === this.curIndex)
          .accessibilityText(languageAndRegionModel.getSysDisplayLanguage(item))
          .width('100%')
          .margin({
            top: index === 0 ? $r('app.float.wh_value_4') : 0,
            bottom: index === this.languageData.totalCount() - 1 ? $r('app.float.wh_value_4') : 0,
          })
          .onClick(() => {
            LogUtil.info(TAG, `change language to ${item} by user`);
            let latestChangeTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
            if (latestChangeTime - this.cacheTime <= CLICK_INTERVAL && this.languageClickNum > 0) {
              this.loadingCheck = true;
              setTimeout(() => {
                languageAndRegionModel.setSystemLanguage(item);
                this.curIndex = index ? index : 0;
                this.loadingCheck = false;
              }, CLICK_INTERVAL - (latestChangeTime - this.cacheTime));
            } else {
              languageAndRegionModel.setSystemLanguage(item);
              this.curIndex = index ? index : 0;
            }
            this.cacheTime = latestChangeTime;
            this.languageClickNum++;
          })
          .accessibilityDescription(index === this.curIndex ? ' ' : '')
          .onAccessibilityActionIntercept((action: AccessibilityAction) => {
            if (action === AccessibilityAction.ACCESSIBILITY_CLICK &&
              index === this.curIndex) {
              LogUtil.info(TAG, 'language item already selected, intercept');
              AccessibilityUtil.textAnnounced(ResourceUtil.getStringByResource($r('app.string.accessibility_selected_language_item'),
                languageAndRegionModel.getDisplayLanguage(item)));
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
      .borderRadius($r('app.float.radius_value_16'))
      .width('100%')
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .attributeModifier(new HeadAnimateModifier(this.getUIContext(), this.headManager, this.scroller, false, true))
      .height('100%')
    }
    .width('100%')
  }

  @Builder
  languageListItem(item: string, index?: number) {
    Column() {
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }) {
        Row() {
          Text(languageAndRegionModel.getDisplayLanguage(item))
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
    .padding({
      left: $r('app.float.wh_value_4'),
      right: $r('app.float.wh_value_4'),
    })
  }

  aboutToAppear() {
    LogUtil.info(TAG, 'aboutToAppear');
    const languages = languageAndRegionModel.getSystemLanguages();
    this.languageData = new LanguageDataSource(languages);
    this.curIndex = languageAndRegionModel.getCurIndex(languages);
  }

  aboutToDisappear() {
    LogUtil.info(TAG, 'aboutToDisappear');
  }
}