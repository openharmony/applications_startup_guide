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

import hilog from '@ohos.hilog';
import {
  FirstDefaultPageManager,
  IPageController,
  PageConfig,
  TitleBar
} from '@ohos/hwstartupguide.common';
import { FirstPage } from '@ohos/hwstartupguide.common/src/main/ets/manager/FirstDefaultPageManager';
import { FooterComponent } from '@ohos/hwstartupguide.common/src/main/ets/component/FooterComponent';
import { HeadComponent } from '../../../../main/ets/components/common/HeadComponent';
import { TextItemComponent } from '../../../../main/ets/components/common/TextItemComponent';
import { PageOrderController } from '../../../../main/ets/controller/PageOrderController';


const TAG: number = 0x0000;

@Entry
@Component
struct Index {
  @State message: string = 'Settings Test';
  private handleClick?: () => boolean;
  protected mPageController?: IPageController | null;
  @State pageConfig: PageConfig | null | undefined = null;
  @State mPageConfigs: Array<PageConfig | null | undefined> = [];

  build() {
    Column() {
      // 公共标题组件
      Row() {
        HeadComponent({
          mHeadName: $r('app.string.footerName'),
          mHeadImage: $r('app.media.icon_basic_and_term'),
          isBackArrowVisible: true,
        })
          .height($r('app.float.distance_216'))
      }


      // 公共TextItem组件
      Row() {
        TextItemComponent(
          {
            mHeadName: $r('app.string.footerName'),
            boomStyle: $r('app.float.distance_4')
          }
        )
      }

      // 公共TitleBar组件
      Row() {
        TitleBar({
          showMenu: true,
          title: $r('app.string.footerName'),
          onBack: () => {
            if (this.handleClick === undefined) {
              return true;
            }
            return this.handleClick?.();
          },
          menuClick: () => {
            return this.handleClick?.();
          }
        })
          .id('titlebar_privacy_back')
      }

      // 公共Footer组件
      Row() {
        FooterComponent({
          buttonName: $r('app.string.footerName'),
          textName: $r('app.string.footerName'),
          buttonOnClick: () => {
          },
          isButtonEnable: true,
        })
      }
    }
  }

  aboutToAppear(): void {
    hilog.info(TAG, 'testTag', '%{public}s', 'TestAbility index aboutToAppear');
    this.refreshUI();
  }

  private refreshUI(): boolean {
    if (!PageOrderController.getInstance().isReady()) {
      let firstPage: FirstPage | null = FirstDefaultPageManager.getInstance().getDefaultFirstPage();
      if (firstPage === null) {
        return true;
      }
      this.pageConfig = firstPage.getPageConfig();
      this.mPageController = firstPage.getPageController();
    } else {
      this.mPageController = PageOrderController.getInstance().getNextEnableShowPage();
      this.pageConfig = this.mPageController?.getPageConfig();
    }
    return true;
  }
}
