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

import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { CommonConstant } from '../constant/CommonConstant';
import { ServiceEntity } from '../model/ServiceEntity';
import { BaseText, BoldText, LinkText } from '../textparse/parser/TextModel';
import { AbilityUtil } from '../util/AbilityUtil';
import { WantUtil } from '../util/WantUtil';
import { HiSysEventUtil } from '../util/HiSysEventUtil';
import { LogUtil } from '../util/LogUtil';


const TAG: string = 'RichTextComp';
const SHRINK_STATUS_LINE: number = 3;
const EXPAND_STATUS_LINE: number = 100;
const TEXT_LINE_HEIGHT: number = 12 * 1.4;

/**
 * 富文本组件
 */
@Component
export struct RichTextComp {
  mServiceEntity?: ServiceEntity;
  mTextArr: Array<BaseText> = [];
  mFontSize: Resource = $r('sys.float.ohos_id_text_size_body3');
  mNormalColor: Resource | string = $r('sys.color.ohos_id_color_text_secondary');
  mLinkColor: Resource = $r('app.color.blue_default');
  mFocusable: boolean = false;
  @State overflow: TextOverflow = TextOverflow.None;
  @State maxLines: number = EXPAND_STATUS_LINE;
  private isExpandVisible?: boolean = false;
  private isHyperLinkClicked = false;

  build() {
    Text() {
      ForEach(this.mTextArr, (textItem: BaseText) => {
        if (textItem instanceof BoldText) {
          Span(textItem.getText())
            .id(`boldtext_richtext_${this.mServiceEntity?.getServiceName()}`)
            .fontWeight(FontWeight.Regular)
            .fontColor(this.mNormalColor)
        } else if (textItem instanceof LinkText) {
          Span(textItem.getText())
            .id(`linktext_richtext_${this.mServiceEntity?.getServiceName()}`)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.mLinkColor)
            .onClick(() => {
              this.isHyperLinkClicked = true;
              this.jumpToPrivacyStatement(textItem.getWant());
            })
        } else {
          Span(textItem.getText())
            .id(`normaltext_richtext_${this.mServiceEntity?.getServiceName()}`)
            .fontWeight(FontWeight.Regular)
            .fontColor(this.mNormalColor)
        }
      })
    }
    .id(`text_richtext_${this.mServiceEntity?.getServiceName()}`)
    .fontSize(this.mFontSize)
    .onClick(() => {
      if (this.isExpandVisible) {
        if (!this.isHyperLinkClicked) {
          this.mServiceEntity?.setServiceExpanded(!this.mServiceEntity.isServiceExpanded());
          this.overflow = this.overflow === TextOverflow.None ? TextOverflow.Ellipsis : TextOverflow.None;
          this.maxLines = this.maxLines === SHRINK_STATUS_LINE ? EXPAND_STATUS_LINE : SHRINK_STATUS_LINE;
        }
        this.isHyperLinkClicked = false;
      }
    })
    .textOverflow({ overflow: this.overflow })
    .align(Alignment.Start)
    .lineHeight(TEXT_LINE_HEIGHT)
    .width('100%')
    .focusable(this.mFocusable)
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToAppear');
    if (this.isExpandVisible) {
      if (this.mServiceEntity?.isServiceExpanded()) {
        this.overflow = TextOverflow.None;
        this.maxLines = EXPAND_STATUS_LINE;
      } else {
        this.overflow = TextOverflow.Ellipsis;
        this.maxLines = SHRINK_STATUS_LINE;
      }
    }
  }

  /**
   * 新老框架兼容阶段，不要commit。适配SR000IFK6D 【OOBE】页面接入框架整改
   * UIAbility，startAbility跳转；UIExtensionAbility,UIExtension拉起
   * @param abilityName
   * @returns boolean
   */
  private jumpToPrivacyStatement(want?: Want): void {
    if (!want) {
      return;
    }
    LogUtil.info(TAG, `jumpToPrivacyStatement bundleName: ${want.bundleName} abilityName: ${want.abilityName} uri: ${want.uri}`);
    if (AbilityUtil.isUIAbility(want.abilityName)) {
      if (!WantUtil.isExplicitStartWant(want)) {
        LogUtil.error(TAG, 'jumpToPrivacyStatement rejected: implicit want without bundleName/abilityName');
        return;
      }
      AbilityUtil.startAbilityByContext(want.bundleName as string, want.abilityName as string, want.parameters)
        .catch((err: BusinessError) => {
        HiSysEventUtil.reportErrorEvent(CommonConstant.PAGE_REDIRECTION_EXCEPTION,
          `Start ability err. errMsg: ${err.code} ${err.message}`);
      });
    } else if (want.bundleName) {
      AppStorage.set<Want>('privacyWant', {
        bundleName: want.bundleName,
        abilityName: want.abilityName,
        parameters: want.parameters,
        uri: want.uri,
      });
    } else if (want.uri) {
      AppStorage.set<Want>('privacyWant', {
        uri: want.uri,
      });
    } else {
      LogUtil.info(TAG, 'jumpToPrivacyStatement do not set privacyWant');
    }
  }
}
