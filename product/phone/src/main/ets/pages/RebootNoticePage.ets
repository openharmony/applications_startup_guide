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
import power from '@ohos.power';
import { process } from '@kit.ArkTS';
import { display } from '@kit.ArkUI';
import { DeviceUtil, LogUtil, WindowManager } from '@ohos/hwstartupguide.common';
import { OuterPageComponent } from '../components/common/OuterPageComponent';

const TAG: string = 'RebootNoticePage';
const IS_DEVICE_FOLD: boolean = DeviceUtil.isFold();
const IS_DEVICE_SMALL_FOLD: boolean = DeviceUtil.isSmallFoldScreen();

@Entry
@Component
struct RebootNoticePage {
  @State externalPageVisible: Visibility = Visibility.None;

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        Text($r('app.string.reboot_device_title'))
          .fontWeight('65ST')
          .fontSize('20')
          .fontColor(Color.Black)
          .lineHeight('6.69')
          .width('67.7%')
          .height('3.4%')
          .position({ x: '6.6%', y: '7%' })

        Image($r('app.media.ic_openharmony_logo'))
          .width('62%')
          .height('5.1%')
          .objectFit(ImageFit.Contain)
          .draggable(false)
          .position({ x: '19%', y: '33.30%' })

        Text($r('app.string.reboot_device_tips'))
          .fontWeight(FontWeight.Regular)
          .fontSize('14')
          .fontColor(Color.Black)
          .lineHeight('20')
          .opacity(0.6)
          .width('83%')
          .height('20')
          .position({ x: '8.5%', y: '48.7%' })
          .textAlign(TextAlign.Center)

        Button() {
          Text($r('app.string.reboot_device_button'))
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_on_primary'))
            .lineHeight('22')
        }
        .width('86.6%')
        .height('5.1%')
        .backgroundColor($r('app.color.blue_default'))
        .position({ x: '6.7%', y: '90%' })
        .onClick(() => {
          this.rebootDevice();
        })
      }
      .backgroundColor($r('app.color.page_background'))
      .width('100%')
      .height('100%')

      this.loadOuterPageComponent()
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToAppear');
    if (IS_DEVICE_SMALL_FOLD) {
      this.addSmallFoldedListener();
    }
    this.outerPageControl();
  }

  aboutToDisappear(): void {
    LogUtil.info(TAG, 'aboutToDisappear');
    if (IS_DEVICE_SMALL_FOLD) {
      try {
        display.off('foldStatusChange');
        LogUtil.info(TAG, 'unregister fold status display monitor.');
      } catch (error) {
        LogUtil.error(TAG, 'aboutToDisappear -> try unregister display monitor. error:', error);
      }
    }
  }

  private addSmallFoldedListener() {
    try {
      display.on('foldStatusChange', () => {
        LogUtil.info(TAG, 'foldStatusChange');
        this.outerPageControl();
      })
      LogUtil.info(TAG, 'register fold status display monitor.');
    } catch (error) {
      LogUtil.error(TAG, 'addFoldedListener. error:', error);
    }
  }

  private outerPageControl(): void {
    let isFolded = false;
    const isSmallFoldDevice = IS_DEVICE_FOLD && IS_DEVICE_SMALL_FOLD;
    try {
      if (isSmallFoldDevice) {
        isFolded = display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_FOLDED;
      }
    } catch (error) {
      LogUtil.error(TAG, `externalPageControl error: ${error?.code}, ${error?.message}`);
    }
    if (isFolded) {
      this.externalPageVisible = Visibility.Visible;
      WindowManager.getInstance().setWindowSystemBarEnable(true);
    } else {
      this.externalPageVisible = Visibility.None;
      WindowManager.getInstance().setWindowSystemBarEnable(false);
    }
  }

  private rebootDevice() {
    power.reboot('BYOOBE');
    let pro = new process.ProcessManager();
    pro.exit(0);
  }

  @Builder
  loadOuterPageComponent(): void {
    // 外屏提示页Component
    OuterPageComponent({ externalPageVisible: this.externalPageVisible })
  }
}