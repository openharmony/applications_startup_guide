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

import deviceInfo from '@ohos.deviceInfo';
import bundle from '@ohos.bundle';
import commonEventManager from '@ohos.commonEventManager';
import account_osAccount from '@ohos.account.osAccount';
import { BusinessError } from '@ohos.base';
import { AbilityUtil } from './AbilityUtil';
import { CommonConstant } from '../constant/CommonConstant';
import { LogUtil } from './LogUtil';
import { HiSysEventUtil } from './HiSysEventUtil';
import { MeeTimeEnhanceService } from './MeeTimeEnhanceService';
import { SubUserUtil } from './SubUserUtil';
import { EventEmitter } from '../event/EventEmitter';
import { Event } from '../event/Event';
import { SceneType, SceneTypeManager } from '../manager/SceneTypeManager';
import { ExperienceManager } from '../manager/ExperienceManager';
import { SystemParameterUtil } from './SystemParameterUtil';
import { InternetManager } from '../manager/InternetManager';
import { ServiceExtensionManager } from '../manager/ServiceExtensionManager';
import { oobeFinishWants } from '../manager/WantManager';
import { CommonEvent } from '../event/CommonEvent';
import { SharePreferences } from '../preferences/SharePreferences';

const TAG: string = 'OOBEUtil';
const DELAY_TIME: number = 4;

/**
 * 开机向导工具类
 */
export class OOBEUtil {
  public static isMeeTimeEnhanceService: boolean = false;
  private static isFinishOOBE: boolean = false;
  private static pageButtonMap: Map<string, string> = new Map();

  /**
   * 添加点位信息
   *
   * @param pageKey 页面key
   * @param eventInfo 页面点位信息
   */
  public static addPageButtonMap(pageKey: string, eventInfo: string): void {
    if (!pageKey || !eventInfo) {
      LogUtil.warn(TAG, 'addPageButtonMap failed!');
      return;
    }
    OOBEUtil.pageButtonMap.set(pageKey, eventInfo);
  }

  /**
   * 结束OOBE
   */
  public static async finishOOBE(): Promise<void> {
    LogUtil.info(TAG, `finish oobe scene type is ${SceneTypeManager.getInstance().getSceneType()}`);
    if (OOBEUtil.isFinishOOBE) {
      LogUtil.error(TAG, 'finish OOBE already called');
      return;
    }
    OOBEUtil.isFinishOOBE = true;
    OOBEUtil.reportPageEvent();
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, 'finish OOBE');
    OOBEUtil.disableSelf();
    EventEmitter.getInstance().emit(Event.EVENT_FINISH_OOBE);
    InternetManager.getInstance().unRegister();
    await SceneTypeManager.getInstance().updateSettingsData();
    await SceneTypeManager.getInstance().finishDualData();
    if (OOBEUtil.isMeeTimeEnhanceService) {
      LogUtil.info(TAG, 'MeeTimeEnhanceService initProcessConditions');
      MeeTimeEnhanceService.initProcessConditions();
    }
    await ServiceExtensionManager.startServiceExtensionAbilities(oobeFinishWants);
    await OOBEUtil.emitOobeFinishEvent();
    await ExperienceManager.getInstance().setDarkModeOnRestart();
    await SharePreferences.getInstance().setValue(CommonConstant.VERSION_FOR_TIPS, deviceInfo.displayVersion);
    LogUtil.warn(TAG, 'terminateSelf');
    AbilityUtil.terminateSelf()
      .catch((err: BusinessError) => {
        HiSysEventUtil.reportErrorEvent(CommonConstant.SERVICE_EXITION_EXCEPTION,
          `Terminate OOBE err. errMsg: ${err.code}  ${err.message}`);
      }).then(() => {
      setTimeout(() => {
        LogUtil.info(TAG, `do after ${DELAY_TIME}ms delay`);
        HiSysEventUtil.reportUserEvent(CommonConstant.FINISH_OOBE, 'OOBE finish.');
      }, DELAY_TIME);
    });
  }

  /**
   * 批量上报点位信息
   */
  private static reportPageEvent(): void {
    LogUtil.info(TAG, `pageButtonMap size:${OOBEUtil.pageButtonMap.size}`);
    for (let eventInfo of OOBEUtil.pageButtonMap.values()) {
      HiSysEventUtil.reportClickPageButtonEvent(CommonConstant.CLICK_PAGE_BUTTON, eventInfo,
        SceneTypeManager.getInstance().getSceneType());
    }
  }

  private static async emitOobeFinishEvent() {
    let isSubUserScene: boolean = SceneTypeManager.getInstance().getSceneType() === SceneType.SUB_USER_SCENE;
    let isOtaScene: boolean = SceneTypeManager.getInstance().getSceneType() === SceneType.OTA_SCENE;
    let isFirstBootScene: boolean = SceneTypeManager.getInstance().getSceneType() === SceneType.FIRST_BOOT_SCENE;
    let options: commonEventManager.CommonEventPublishData = {
      // PC：子用户场景、预置场景、OTA(目前不使用)
      subscriberPermissions: [CommonConstant.HWSTARTUPGUIDE_ACCESS_PERMISSION],
      parameters: {
        'subUserScene': isSubUserScene,
        'ota': isOtaScene,
        'firstBoot': isFirstBootScene
      }
    };
    await CommonEvent.publish(CommonConstant.HWSTARTUPGUIDE_FINISHED_EVENT, options);
  }

  /**
   * 结束开机向导 删除子用户
   */
  public static finishOOBEWithDelSubUser(): void {
    LogUtil.info(TAG, 'finish oobe with del sub user');
    OOBEUtil.disableSelf();

    AbilityUtil.terminateSelf()
      .catch((err: BusinessError) => {
        HiSysEventUtil.reportErrorEvent(CommonConstant.SERVICE_EXITION_EXCEPTION,
          `Terminate OOBE err. errMsg: ${err.code}  ${err.message}`);
      }).then(() => {
      setTimeout(() => {
        SubUserUtil.getCurrentAccountInfo().then((info: account_osAccount.OsAccountInfo) => {
          SubUserUtil.removeAccount(info.localId);
          LogUtil.info(TAG, `do after ${DELAY_TIME}ms delay`);
          HiSysEventUtil.reportUserEvent(CommonConstant.FINISH_OOBE, 'OOBE finish.');
        });
      }, DELAY_TIME);
    });
  }

  private static disableSelf() {
    OOBEUtil.disableOOBE(CommonConstant.HW_STARTUP_GUIDE_PKG_NAME, CommonConstant.HW_STARTUP_GUIDE_MAIN_ABILITY)
      .catch((err: BusinessError) => {
        HiSysEventUtil.reportErrorEvent(CommonConstant.SERVICE_EXITION_EXCEPTION,
          `Disable OOBE err. errMsg: ${err.code}  ${err.message}`);
        LogUtil.error(TAG, `disable OOBE err. errMsg: ${err.code}  ${err.message}`);
      });
  }

  public static getDisplayVersion(): string {
    let displayVersion: string = ''; // 默认版本信息为空
    displayVersion = OOBEUtil.getSysParamVersion();
    if (displayVersion) {
      return displayVersion;
    } else { // 当系统参数查询不到的时候，则查询设备信息
      LogUtil.info(TAG, `get displayVersion by deviceInfo.displayVersion is ${deviceInfo.displayVersion}`);
      return deviceInfo.displayVersion;
    }
  }

  public static getSysParamVersion(): string {
    let physicalVersionInfo = SystemParameterUtil.getSync(CommonConstant.DISPLAY_VERSION_PARAM, '');
    LogUtil.info(TAG, `get displayVersion by const.build.ver.physical is ${physicalVersionInfo}`);
    return physicalVersionInfo;
  }

  /**
   * 禁用ability
   * @param bundleName 包名
   * @param abilityName ability名称
   */
  public static disableOOBE(bundleName: string, abilityName: string): Promise<void> {
    LogUtil.info(TAG, 'disableOOBE start');
    return new Promise((resolve, reject) => {
      bundle.getAbilityInfo(bundleName, abilityName).then((abilityInfo) => {
        bundle.setAbilityEnabled(abilityInfo, false).then(() => {
          LogUtil.info(TAG, `setAbilityEnabled success. abilityName：${abilityName}`);
          resolve();
        }).catch((error: BusinessError) => {
          LogUtil.error(TAG, `setAbilityEnabled failed. abilityName：${abilityName}  errMsg:${error.code} ${error.message} `);
          reject(error);
        })
      }).catch((error: BusinessError) => {
        LogUtil.error(TAG, `getAbilityInfo failed. abilityName：${abilityName} errMsg:${error.code} ${error.message} `);
        reject(error);
      });
    });
  }
}