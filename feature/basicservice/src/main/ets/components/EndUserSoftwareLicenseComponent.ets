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
import webview from '@ohos.web.webview';
import i18n from '@ohos.i18n';
import { LogUtil, ServiceEntityUtil } from '@ohos/hwstartupguide.common';
import { BasicServiceConstant } from '../constant/BasicServiceConstant';
import { BasicServiceUtil } from '../util/BasicServiceUtil';

const TAG: string = 'EndUserSoftwareLicenseComponent';
const LOADINGSIZE: number = 72;

/**
 * 隐私声明视图组件
 *
 */
@Component
export struct EndUserSoftwareLicenseComponent {
  private controller: webview.WebviewController = new webview.WebviewController();
  @StorageLink('isPortraitOrientation') isPortraitOrientation: boolean = false;
  // web内文字缩放百分比
  @StorageLink('textZoomRatio') textZoomRatio: number = 100;
  @State htmlFile: string = '';
  @State htmlName: string | undefined = '';
  @State isLoading: boolean = true;
  @Prop paddingBottom: Length = $r('app.float.wh_value_24');

  @Builder
  buildWebContent(): void {
    Column() {
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .size({ width: LOADINGSIZE, height: LOADINGSIZE })
            .color($r('sys.color.icon_tertiary'))
        }
        .height('100%')
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      
      Scroll() {
        Web({
          src: $rawfile(this.htmlFile),
          controller: this.controller,
        })
          .onPageBegin(() => {
            // 页面开始加载时，显示 loading
            this.isLoading = true;
          })
          .onPageEnd(() => {
            // 页面加载完成（包括所有资源），隐藏 loading
            this.isLoading = false;
          })
          .onErrorReceive((event) => {
            if (event) {
              LogUtil.error(TAG, `onErrorReceive, errorInfo: ${event.error.getErrorInfo()}`);
            }
            this.isLoading = false;
          })
          .zoomAccess(false)
          .id('web_privacy')
          .javaScriptAccess(true)
          .geolocationAccess(false)
          .fileAccess(false)
          .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
          .height('100%')
          .width('100%')
          .onLoadIntercept((event) => {
            if (!event || !event.data) {
              LogUtil.warn(TAG, `onLoadIntercept error, event is null`);
              return false;
            }
            LogUtil.info(TAG, `is file equals target ${event.data.getRequestUrl().endsWith(this.htmlFile)}`);
            return !event.data.getRequestUrl().endsWith(this.htmlFile);
          })
          .textZoomRatio(this.textZoomRatio)
      }
    }
  }

  build(): void {
    Column() {
      this.buildWebContent();
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .padding({
      top: $r('app.float.wh_value_64'),
      bottom: this.paddingBottom,
    })
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToAppear');
    let curLanguage: string = i18n.System.getSystemLanguage();
    let curRegion: string = i18n.System.getSystemRegion();
    this.htmlFile = ServiceEntityUtil.getDetailUrlByPrivacyWant(this.htmlName, curLanguage, curRegion);
    if (BasicServiceUtil.isSupportVersionType()) {
      this.htmlFile = this.htmlFile.replace(BasicServiceConstant.DEFAULT_PRIVACY_STATEMENT,
        BasicServiceConstant.TOB_PRIVACY_STATEMENT);
    }
  }
}
