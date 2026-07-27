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
import commonEventManager from '@ohos.commonEventManager';
import { BusinessError } from '@ohos.base';
import { LogUtil } from '../util/LogUtil';

const TAG: string = 'CommonEvent';

/**
 * 发送公共事件
 */
export class CommonEvent {
  /**
   * 发送公共事件
   *
   * @param event 事件名称
   * @param eventPublishData 公共事件所携带数据
   */
  public static async publish(event: string, eventPublishData: commonEventManager.CommonEventPublishData):
    Promise<void> {
    LogUtil.info(TAG, 'publish event start!');
    try {
      commonEventManager.publish(event, eventPublishData, (err: BusinessError) => {
        if (err) {
          LogUtil.error(TAG, 'publish common event error');
        } else {
          LogUtil.warn(TAG, 'publish common event success');
        }
      });
    } catch (err) {
      LogUtil.error(TAG, `publish common event catch exception.`, err);
    }
  }
}