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
import { EnhanceServiceUtil, PostMessage } from '@ohos/hwstartupguide.enhanceservice';
import { LogUtil, ServiceEntity } from '@ohos/hwstartupguide.common';
import { ServiceStatementUtil } from '../util/ServiceStatementUtil';

const TAG = 'ServiceStatementWorker';
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param messageEvents message data
 */
workerPort.onmessage = (messageEvents: MessageEvents) => {
  let message: PostMessage = messageEvents.data as PostMessage;
  let src: Object[] = JSON.parse(message.list);
  src.map(item => {
    const serviceEntity: ServiceEntity = new ServiceEntity(item);
    if (serviceEntity.isServiceVisible()) {
      LogUtil.info(TAG, `try save item ${serviceEntity.getServiceName()}`);
      ServiceStatementUtil.updateVersionToSP(serviceEntity, message.context);
      EnhanceServiceUtil.saveServiceCheckStatusSync(message.context, serviceEntity);
    }
  });
  workerPort.postMessage('save data success');
}

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param messageEvents message data
 */
workerPort.onmessageerror = (messageEvents: MessageEvents) => {
  LogUtil.error(TAG, `worker port message error: ${messageEvents?.type}`);
}

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param messageEvents error message
 */
workerPort.onerror = (messageEvents: ErrorEvent) => {
  LogUtil.error(TAG, `worker port error event: ${messageEvents?.message}`);
}