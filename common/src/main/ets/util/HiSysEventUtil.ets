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
import { BusinessError } from '@ohos.base';
import hiSysEvent from '@ohos.hiSysEvent';
import { LogUtil } from './LogUtil';
import { SharePreferences } from '../preferences/SharePreferences';
import { CommonConstant } from '../constant/CommonConstant';
import { SceneType } from '../manager/SceneTypeManager';

const TAG: string = 'HiSysEventUtil';
const USER_IMPROVEMENT_PLAN_AGREE_STATE: string = 'user_improvement_plan_agree_plan';
const HWSTARTUPGUIDE_DOMAIN_UE: string = 'STARTUPGUIDE_UE';
const HWSTARTUPGUIDE_DOMAIN: string = 'STARTUPGUIDE';
const CON_PNAMEID: string = CommonConstant.HW_STARTUP_GUIDE_PKG_NAME;
const CON_PVERSIONID: string = 'Prototype2.0';
const EXCEPTION_OCCUR_EVENT: string = 'EXCEPTION_OCCUR_EVENT';
const UPGRADEGUIDE_RESULT_EVENT: string = 'UPGRADEGUIDE_RESULT_STATIC';
const ENHANCED_SERVICE_EVENT: string = 'ENHANCED_SERVICE_EVENT';

/**
 * 应用打点工具类
 * @since 2022-11-8
 */
export class HiSysEventUtil {
  private static reportEvent(eventDomain: string, eventName: string, msg: Object, eventType: number): void {
    LogUtil.info(TAG, `event_name: ${eventName};`);
    hiSysEvent.write({
      domain: eventDomain,
      name: eventName,
      eventType: eventType,
      params: msg,
    }).then((val) => {
      LogUtil.info(TAG, `${eventName} success.`);
    }
    ).catch((err: BusinessError) => {
      LogUtil.error(TAG, `event_name: ${eventName} error. code:${err.code}  message:${err.message}`);
    });
  }

  /**
   * 判断用户体验改进计划是否勾选状态（Preferences存储）
   */
  public static async isAgreedFromSP(): Promise<boolean> {
    let value = await SharePreferences.getInstance()
      .getValue(USER_IMPROVEMENT_PLAN_AGREE_STATE, true);
    LogUtil.info(TAG, 'isAgreedFromSP checked');
    return value === true;
  }

  static reportErrorEvent(name: string, value: string): void {
    LogUtil.info(TAG, 'reportErrorEvent start');
    HiSysEventUtil.isAgreedFromSP()
      .then(result => {
        if (result) {
          let params: Params = {
            PNAMEID: CON_PNAMEID,
            PVERSIONID: CON_PVERSIONID,
            NAME: name,
            VALUE: value,
          };
          HiSysEventUtil.reportEvent(HWSTARTUPGUIDE_DOMAIN, EXCEPTION_OCCUR_EVENT, params, hiSysEvent.EventType.FAULT);
        }
      });
  }

  static reportUserEvent(eventName: string, value: string, status?: Boolean | string): void {
    LogUtil.info(TAG, 'reportUserEvent start');
    HiSysEventUtil.isAgreedFromSP()
      .then(result => {
        if (result) {
          let params: Params = {
            PNAMEID: CON_PNAMEID,
            PVERSIONID: CON_PVERSIONID,
            VALUE: value,
            STATUS: status ?? undefined,
          };
          HiSysEventUtil.reportEvent(HWSTARTUPGUIDE_DOMAIN_UE, eventName, params, hiSysEvent.EventType.BEHAVIOR);
        } else {
          LogUtil.info(TAG, 'reportUserEvent skipped: user improvement plan not agreed');
        }
      });
  }

  static reportEnhancedServiceEvent(serviceName: string, isOpen: boolean): void {
    LogUtil.info(TAG, 'reportEnhancedServiceEvent start');
    HiSysEventUtil.isAgreedFromSP()
      .then(result => {
        if (result) {
          let params: EnhancedServiceParams = {
            PNAMEID: CON_PNAMEID,
            PVERSIONID: CON_PVERSIONID,
            STATUS: isOpen ? 1 : 0,
            SERVICE_NAME: serviceName
          };
          HiSysEventUtil.reportEvent(HWSTARTUPGUIDE_DOMAIN_UE, ENHANCED_SERVICE_EVENT,
            params, hiSysEvent.EventType.BEHAVIOR);
        } else {
          LogUtil.info(TAG, 'reportEnhancedServiceEvent skipped: user improvement plan not agreed');
        }
      });
  }

  /**
   * 用户点击页面按钮上报打点
   *
   * @param eventName 点位事件
   * @param value 打点信息
   * @param sceneType 场景信息
   */
  static reportClickPageButtonEvent(eventName: string, value: string, sceneType: SceneType): void {
    LogUtil.info(TAG, 'reportClickPageButtonEvent start');
    HiSysEventUtil.isAgreedFromSP()
      .then(result => {
        if (result) {
          let params: Params = {
            PNAMEID: CON_PNAMEID,
            PVERSIONID: CON_PVERSIONID,
            VALUE: value,
            SCENE_TYPE: sceneType
          };
          HiSysEventUtil.reportEvent(HWSTARTUPGUIDE_DOMAIN_UE, eventName, params, hiSysEvent.EventType.BEHAVIOR);
        } else {
          LogUtil.info(TAG, 'reportClickPageButtonEvent skipped: user improvement plan not agreed');
        }
      });
  }

  static reportUpgradeGuideEvent(eventId?: string, bundleName?: string, abilityName?: string): void {
    LogUtil.info(TAG, 'reportUpgradeGideEvent start');
    HiSysEventUtil.isAgreedFromSP()
      .then(result => {
        if (result) {
          let params: Params = {
            EVENT_ID: eventId,
            BUNDLENAME: bundleName,
            ABILITYNAME: abilityName,
          };
          HiSysEventUtil.reportEvent(HWSTARTUPGUIDE_DOMAIN, UPGRADEGUIDE_RESULT_EVENT, params,
            hiSysEvent.EventType.STATISTIC);
        }
      });
  }
}

interface Params {
  PNAMEID?: string;
  PVERSIONID?: string;
  NAME?: string;
  VALUE?: string;
  STATUS?: Boolean | undefined | string;
  EVENT_ID?: string;
  BUNDLENAME?: string;
  ABILITYNAME?: string;
  SCENE_TYPE?: SceneType;
}

interface EnhancedServiceParams {
  PNAMEID: string;
  PVERSIONID: string;
  SERVICE_NAME: string;
  STATUS: number;
}
