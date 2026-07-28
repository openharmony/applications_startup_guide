/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
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

import type { AsyncCallback } from '@ohos.base';
import type Context from '@ohos.application.BaseContext';

/**
 * Provides the capabilities and methods for obtaining Rich Communication Service (RCS) management objects.
 *
 * @namespace rcs
 * @syscap SystemCapability.Telephony.Rcs
 * @since 4.1.0(11)
 */
declare namespace rcs {
  /**
   * Checks whether RCS feature is enabled.
   *
   * @returns { boolean } The flag whether RCS feature is enabled or not.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function isRcsEnabled(): boolean;

  /**
   * Checks whether SIM card of specific slot id supports RCS feature.
   *
   * @param { number } slotId - Slot id of SIM card. If this parameter doesn't present, default value is slot id of
   *                            mobile data channel. Only SIM card of China Mobile supports RCS, others don't support.
   * @returns { boolean } The flag whether SIM card with the specific slotId supports RCS.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100001 - No sim card exist.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function isRcsSupported(slotId?: number): boolean;

  /**
   * Turns on RCS feature and starts to login RCS service.
   *
   * @permission ohos.permission.SET_TELEPHONY_STATE
   * @param { RcsConfig } config - Configuration of RCS.
   * @param { AsyncCallback<void> } callback - The callback for getting the result of starting RCS.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100001 - No sim card exist.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @throws { BusinessError } 1005100004 - SIM card with the specific slotId doesn't support RCS.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function startRcs(config: RcsConfig, callback: AsyncCallback<void>): void;

  /**
   * Turns on RCS feature and starts to login RCS service.
   *
   * @permission ohos.permission.SET_TELEPHONY_STATE
   * @param { RcsConfig } config - Configuration of RCS.
   * @returns { Promise<void> } The promise indicates the result of starting RCS.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100001 - No sim card exist.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @throws { BusinessError } 1005100004 - SIM card with the specific slotId doesn't support RCS.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function startRcs(config: RcsConfig): Promise<void>;

  /**
   * Turns off RCS feature and starts to logout RCS service.
   *
   * @permission ohos.permission.SET_TELEPHONY_STATE
   * @param { AsyncCallback<void> } callback - The callback for getting the result of stopping RCS.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function stopRcs(callback: AsyncCallback<void>): void;

  /**
   * Turns off RCS feature and starts to logout RCS service.
   *
   * @permission ohos.permission.SET_TELEPHONY_STATE
   * @returns { Promise<void> } The promise indicates the result of stopping RCS.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function stopRcs(): Promise<void>;

  /**
   * Checks whether device has been successfully login to RCS server.
   *
   * @permission ohos.permission.GET_TELEPHONY_STATE
   * @returns { boolean } The login status of RCS.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function isRcsLoggedIn(): boolean;

  /**
   * Sends OTP (one-time-password) information to RCS server.
   *
   * @permission ohos.permission.SET_TELEPHONY_STATE
   * @param { string } otp - otp information. If device is using WLAN network and login to RCS server first time,
   *                         RCS server will send opt information to device. Once received OTP, device should sent
   *                         opt back to server to complete authentication.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function sendOtpInfo(otp: string): void;

  /**
   * Sets read receipt setting of RCS service.
   *
   * @permission ohos.permission.SET_TELEPHONY_STATE
   * @param { boolean } readReceiptEnabled - Indicates the status of read receipt setting. If this setting is true,
   *                                         when new arrived RCS message has been read, device will automatically
   *                                         send read receipt to peer device.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function setReadReceipt(readReceiptEnabled: boolean): void;

  /**
   * Gets read receipt setting of RCS service.
   *
   * @permission ohos.permission.GET_TELEPHONY_STATE
   * @returns { boolean } The flag of read receipt sent.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function getReadReceipt(): boolean;

  /**
   * Sends read receipt to peer RCS service
   *
   * @permission ohos.permission.SET_TELEPHONY_STATE
   * @param { string } msgId - Indicates the index of message in RCS service.
   * @param { AsyncCallback<void> } callback - The callback for getting the result of sending read receipt.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function sendReadReceipt(msgId: string, callback: AsyncCallback<void>): void;

  /**
   * Sends read receipt to peer RCS service
   *
   * @permission ohos.permission.SET_TELEPHONY_STATE
   * @param { string } msgId - Indicates the index of message in RCS service.
   * @returns { Promise<void> } The promise indicates the result of sending read receipt.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function sendReadReceipt(msgId: string): Promise<void>;

  /**
   * Creates a RCS message instance with specific message id and saves the message in database.
   *
   * @permission ohos.permission.SEND_MESSAGES
   * @param { string } msgId - Indicates the index of message in RCS service.
   * @param { AsyncCallback<RcsMessage> } callback - The callback for getting a message instance.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function createMessage(msgId: string, callback: AsyncCallback<RcsMessage>): void;

  /**
   * Creates a RCS message instance with specific message id and saves the message in database.
   *
   * @permission ohos.permission.SEND_MESSAGES
   * @param { string } msgId - Indicates the index of message in RCS service.
   * @returns { Promise<RcsMessage> } The promise indicates a message instance.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function createMessage(msgId: string): Promise<RcsMessage>;

  /**
   * Sends a text message to peer device through RCS channel and saves message in database.
   *
   * @permission ohos.permission.SEND_MESSAGES
   * @param { RcsSendOptions } options - The parameters for sending the RCS message.
   * @param { AsyncCallback<RcsSendResultInfo> } callback - The callback for getting the result of sending message.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function sendMessage(options: RcsSendOptions, callback: AsyncCallback<RcsSendResultInfo>): void;

  /**
   * Sends a text message to peer device through RCS channel and saves message in database.
   *
   * @permission ohos.permission.SEND_MESSAGES
   * @param { RcsSendOptions } options - The parameters for sending the RCS message.
   * @returns { Promise<RcsSendResultInfo> } The promise indicates the result of sending message.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function sendMessage(options: RcsSendOptions): Promise<RcsSendResultInfo>;

  /**
   * Resends a text message with specific message id to peer device through RCS channel.
   *
   * @permission ohos.permission.SEND_MESSAGES
   * @param { string } msgId - Indicates the index of message.
   * @param { AsyncCallback<void> } callback - The callback for getting the result of re-sending message.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function resendMessage(msgId: string, callback: AsyncCallback<void>): void;

  /**
   * Resends a text message with specific message id to peer device through RCS channel.
   *
   * @permission ohos.permission.SEND_MESSAGES
   * @param { string } msgId - Indicates the index of message.
   * @returns { Promise<boolean> } The promise indicates the result of re-sending message.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function resendMessage(msgId: string): Promise<void>;

  /**
   * Deletes multiple RCS messages with the specific message id and deletes them from database.
   *
   * @permission ohos.permission.SEND_MESSAGES
   * @param { string } msgId - Indicates the index of message.
   * @param { AsyncCallback<void> } callback - The callback for getting the result of deleting message.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function deleteMessages(msgIds: Array<string>, callback: AsyncCallback<void>): void;

  /**
   * Deletes multiple RCS messages with the specific message ids and deletes them from database.
   *
   * @permission ohos.permission.SEND_MESSAGES
   * @param { string } msgId - Indicates the index of message.
   * @returns { Promise<void> } The promise indicates the result of deleting message.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function deleteMessages(msgIds: Array<string>): Promise<void>;

  /**
   * Deletes all messages of the specific conversation and deletes them from the database.
   *
   * @permission ohos.permission.SEND_MESSAGES
   * @param { string } peerName - Indicates the peer phone number.
   * @param { AsyncCallback<void> } callback - The callback for getting the result of deleting conversation.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function deleteConversation(peerName: string, callback: AsyncCallback<void>): void;

  /**
   * Deletes all messages of the specific conversation and deletes them from the database.
   *
   * @permission ohos.permission.SEND_MESSAGES
   * @param { string } peerName - Indicates the peer phone number.
   * @returns { Promise<void> } The promise indicates the result of deleting conversation.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  function deleteConversation(peerName: string): Promise<void>;

  /**
   * Registers event callback of RCS service.
   *
   * @permission ohos.permission.SET_TELEPHONY_STATE
   * @param { 'event' } type Indicates event changed.
   * @param { function } callback
   *        The callback function for RCS status change event
   *        @param { RcsEvent } event - RCS changed event and its arguments.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @since 4.1.0(11)
   */
  function on(type: 'event', callback: (event: RcsEvent) => void): void;

  /**
   * Unregister event callback of RCS service.
   *
   * @permission ohos.permission.SET_TELEPHONY_STATE
   * @param { 'event' } type Indicates event changed.
   * @param { function } callback
   *        The callback function for RCS status change event
   *        @param { RcsEvent } event - RCS changed event and its arguments.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Invalid parameter.
   * @throws { BusinessError } 1005100002 - General operation error.
   * @throws { BusinessError } 1005100003 - Cannot connect to service.
   * @syscap SystemCapability.Telephony.Rcs
   * @since 4.1.0(11)
   */
  function off(type: 'event', callback?: (event: RcsEvent) => void): void;

  /**
   * Defines the configuration for turn on/off RCS feature.
   *
   * @interface RcsConfig
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  export interface RcsConfig {
    /**
     * Indicates slot id of the SIM card.
     *
     * @type { number }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    slotId: number;

    /**
     * Indicates read receipt setting.
     *
     * @type { boolean }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    readReceiptEnabled: boolean;
  }

  /**
   * Defines a RCS message instance.
   *
   * @interface RcsMessage
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  export interface RcsMessage {
    /**
     * Indicates the RCS message id of database in RCS service.
     *
     * @type { string }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    msgId: string;

    /**
     * Indicates the slotId of the received text message through RCS channel.
     *
     * @type { number }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    slotId: number;

    /**
     * Indicates the sender address of the received text message through RCS channel.
     *
     * @type { string }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    address: string;

    /**
     * Indicates the timestamp of the received text message through RCS channel.
     *
     * @type { string }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    date: string;

    /**
     * Indicates message content of the received text message through RCS channel.
     *
     * @type { string }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    content: string;

    /**
     * Indicates the extra data (JSON object) of the received text message through RCS channel.
     *
     * @type { object }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    extraData?: object;
  }

  /**
   * Provides the options for sending text message through RCS channel.
   *
   * @interface RcsSendOptions
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  export interface RcsSendOptions {
    /**
     * Indicates the address where the text message is sent.
     *
     * @type { string }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    destination: string;

    /**
     * Indicates the content what to be sent.
     *
     * @type { string }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    content: string;

    /**
     * Indicates the extra parameters (JSON object) for sending RCS message.
     *
     * @type { object }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    extraParam?: object;
  }

  /**
   * Defines result information for sending text message through RCS channel.
   *
   * @interface RcsSendResultInfo
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  export interface RcsSendResultInfo {
    /**
     * Indicates the result for sending text message through RCS channel.
     *
     * @type { RcsSendResult }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    result: RcsSendResult;

    /**
     * Indicates the message id which identified the message saved in database.
     *
     * @type { string }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    msgId: string;
  }

  /**
   * Enumerates RCS sending results.
   *
   * @enum { number }
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */
  export enum RcsSendResult {
    /**
     * Indicates that the RCS message is successfully sent.
     *
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    RCS_SEND_SUCCESS = 0,
  
    /**
     * Indicates that the RCS message is sending.
     *
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    RCS_SEND_RUNNING = 1,

    /**
     * Indicates that fail to send the text message.
     *
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    RCS_SEND_FAILURE = 2,
  }

  /**
   * Defines the event structure of RCS service.
   *
   * @interface RcsEvent
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */  
  export interface RcsEvent {
    /**
     * Indicates event type of RCS service.
     *
     * @type { RcsEventType }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    type: RcsEventType;

    /**
     * Indicates extra parameter (JSON object) of RCS event.
     *
     * @type { object }
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */    
    params?: object;
  }

  /**
   * Enumerates RCS event type.
   *
   * @enum { RcsEventType }
   * @syscap SystemCapability.Telephony.Rcs
   * @systemapi Hide this for inner system use.
   * @since 4.1.0(11)
   */  
  export enum RcsEventType {
    /**
     * Indicates that fails to login RCS service or logout RCS service.
     *
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    RCS_OFFLINE = 0,

    /**
     * Indicates that device has successfully login RCS service.
     *
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    RCS_ONLINE = 1,

    /**
     * Indicates that requires to receive OTP information when RCS service login in WLAN network.
     *
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    RCS_OTP_MISSING = 2,

    /**
     * Indicates that requires to receive MSISDN information when RCS service login.
     *
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    RCS_MSISDN_MISSING = 3,

    /**
     * Indicates that receives RCS text from RCS service.
     *
     * @syscap SystemCapability.Telephony.Rcs
     * @systemapi Hide this for inner system use.
     * @since 4.1.0(11)
     */
    RCS_RECEIVE_TEXT = 4,
  }
}

export default rcs;