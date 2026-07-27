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
import worker, { ThreadWorkerGlobalScope, MessageEvents, ErrorEvent } from '@ohos.worker';
import { LogUtil, ServiceEntity } from '@ohos/hwstartupguide.common';
import { EnhanceServiceUtil } from '../util/EnhanceServiceUtil';
import { PostMessage } from '../controller/EnhanceServicePageController';

const TAG = 'EnhanceServiceWorker';
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = (e: MessageEvents) => {
  let message: PostMessage = e.data as PostMessage;
  let src:ServiceEntity[] = JSON.parse(message.list) as ServiceEntity[];
  let dst:ServiceEntity[] = [];
  src.map(item => {
    dst.push(new ServiceEntity(item));
  });
  dst.map(item => {
    if (item.isServiceVisible()) {
      LogUtil.info(TAG, `try save item ${item.getServiceName()}`);
      EnhanceServiceUtil.saveServiceCheckStatusSync(message.context, item);
    }
  });
  EnhanceServiceUtil.saveEnhanceStatementsToSP(message.context, dst);
  workerPort.postMessage('save data success');
}

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = (e: MessageEvents) => {
  LogUtil.error(TAG, `worker port message error: ${e?.type}`);
}

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = (e: ErrorEvent) => {
  LogUtil.error(TAG, `worker port error event: ${e?.message}`);
}