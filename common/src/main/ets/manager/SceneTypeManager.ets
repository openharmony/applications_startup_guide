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

import { osAccount } from '@kit.BasicServicesKit';
import settings from '@ohos.settings';
import account_osAccount from '@ohos.account.osAccount';
import { BusinessError } from '@ohos.base';
import { QrCodeUtils } from '../util/QrCodeUtils';
import { DeviceUtil } from '../util/BaseUtils';
import { SharePreferences } from '../preferences/SharePreferences';
import { SystemParameterUtil } from '../util/SystemParameterUtil';
import { CommonConstant } from '../constant/CommonConstant';
import { LogUtil } from '../util/LogUtil';
import { SettingUtil } from '../util/SettingUtil';
import { DataShareUtil } from '../util/DataShareUtils';
import { HiSysEventUtil } from '../util/HiSysEventUtil';
import { OOBEUtil } from '../util/OOBEUtil';

const TAG: string = 'SceneTypeManager';
const FINISH_OTA: string = 'FINISH_OTA';
const PRIVATE_TYPE = 1024;
const EMPTY: string = 'EMPTY';
const EDUCATION_SPACE_SETTING_FLAG: string = 'edu_space_management_id';

/**
 * 场景类型管理类
 */
export class SceneTypeManager {
  private static instance?: SceneTypeManager;
  private type: SceneType = SceneType.FIRST_BOOT_SCENE;
  private deviceProvisioned: string = CommonConstant.STATUS_NO_FINISHED;
  private userSetupComplete: string = CommonConstant.STATUS_NO_FINISHED;
  private isOtaFinished: string = CommonConstant.STATUS_FINISHED; // 注意默认值不一样
  private isPrivateUser: boolean = false;
  private isOobeFinish: boolean = false;
  private upgradeFromDual: string = CommonConstant.UPGRADE_FROM_DUAL_OFF;
  private localId: number = -1;
  private needEduSpace: boolean = false;

  private constructor() {
  }

  public setNeedEduSpace(needEduSpace: boolean): void {
    this.needEduSpace = needEduSpace;
  }

  /**
   * 单例
   *
   * @returns instance
   */
  public static getInstance(): SceneTypeManager {
    if (!SceneTypeManager.instance) {
      SceneTypeManager.instance = new SceneTypeManager();
    }
    return SceneTypeManager.instance;
  }

  /**
   * 初始化
   */
  public async init(): Promise<void> {
    this.initUpgradeFromDual();
    await this.querySettingsData();
    let checkOtaStatus: boolean = this.isOtaIncomplete();
    let isNewSubUser: boolean = this.isNewSubUser();
    if (checkOtaStatus || await this.checkOtaPersist()) {
      // ota场景
      await this.initPrivateUser();
      if (this.isPrivateUser && await this.isMigratePrivacySpaceStatus()) {
        // 隐私空间类型的子用户
        this.type = SceneType.PRIVATE_SPACE_SCENE;
      } else {
        this.type = SceneType.OTA_SCENE;
      }
    } else if (isNewSubUser) {
      let isEduSpace: boolean = false;
      if (this.needEduSpace) {
        isEduSpace = await this.isEduSpace();
      }
      if (isEduSpace) {
        LogUtil.info(TAG, 'isEduSpace enter...');
        this.type = SceneType.EDU_SPACE;
      } else {
        // 创建子用户场景
        LogUtil.info(TAG, 'isNewSubUser enter....');
        this.type = SceneType.SUB_USER_SCENE;
      }
    } else if (DeviceUtil.isDevicePc() && QrCodeUtils.isNeedQrCode()) {
      this.type = SceneType.SN_QRCODE_SCENE;
    } else {
      // 首次开机、恢复出厂设置场景
      this.type = SceneType.FIRST_BOOT_SCENE;
    }
    LogUtil.warn(TAG,
      `initSceneType type:${this.type}, checkOtaStatus:${checkOtaStatus}, isNewSubUser:${isNewSubUser}`);
  }

  /**
   * 初始化双升单信息
   */
  private initUpgradeFromDual() {
    const upgradeFromDual = SettingUtil.getValueSync(CommonConstant.UPGRADE_FROM_DUAL, '',
      settings.domainName.USER_SECURITY);
    if (upgradeFromDual) {
      this.upgradeFromDual = upgradeFromDual;
      return;
    }
    this.upgradeFromDual = SystemParameterUtil.getSync(CommonConstant.UPGRADE_GUIDE_FROM_DUAL,
      CommonConstant.UPGRADE_FROM_DUAL_OFF);
    SettingUtil.setValueSecuritySync(CommonConstant.UPGRADE_FROM_DUAL, this.upgradeFromDual,
      settings.domainName.USER_SECURITY);
  }

  /**
   * 获取场景类型
   *
   * @returns 场景类型
   */
  public getSceneType(): SceneType {
    return this.type;
  }

  /**
   * 是否OTA场景
   *
   * @returns true 是
   */
  public isOtaScene(): boolean {
    return this.type === SceneType.OTA_SCENE;
  }

  /**
   * 检查是否是新建的子用户
   */
  public isNewSubUser(): boolean {
    return this.deviceProvisioned === CommonConstant.STATUS_FINISHED &&
      this.userSetupComplete === CommonConstant.STATUS_NO_FINISHED;
  }

  /**
   * 检查当前OTA是否完成
   *
   * @returns true-OTA完成
   */
  public isOtaIncomplete(): boolean {
    return this.isOtaFinished === CommonConstant.STATUS_NO_FINISHED; // 如果为0.即此时处于ota流程中
  }

  private async checkOtaPersist(): Promise<boolean> {
    let isToNextSp = await SharePreferences.getInstance().getValue(CommonConstant.HMOS_2_NEXT_FLAG, EMPTY);
    if (isToNextSp === EMPTY &&
      SystemParameterUtil.getSync(CommonConstant.HMOS_2_NEXT_FLAG, undefined) === CommonConstant.IS_HMOS_2_NEXT) {
      await SharePreferences.getInstance()
        .setValue(CommonConstant.HMOS_2_NEXT_FLAG, CommonConstant.IS_HMOS_2_NEXT)
        .catch((err: BusinessError) => {
          LogUtil.error(TAG, 'checkOtaPersist flag error', err);
        });
      await SettingUtil.setValue(CommonConstant.DEVICE_PROVISIONED, CommonConstant.STATUS_FINISHED);
      await SettingUtil.setValue(CommonConstant.SECURE_IS_OTA_FINISHED, CommonConstant.STATUS_NO_FINISHED,
        settings.domainName.USER_SECURITY);
      LogUtil.info(TAG, `checkOtaPersist return ture isToNextSp:${isToNextSp}`);
      return true;
    }
    LogUtil.info(TAG, `checkOtaPersist return false isToNextSp:${isToNextSp}`);
    return false;
  }

  /**
   * 是否双升单
   */
  public isHmosToNext(): boolean {
    LogUtil.info(TAG, `upgrade from dual: ${this.upgradeFromDual}`);
    return this.upgradeFromDual === CommonConstant.UPGRADE_FROM_DUAL_ON;
  }

  /**
   * 完成双升单
   */
  public async finishDualData(): Promise<void> {
    if (this.isHmosToNext()) {
      LogUtil.warn(TAG, 'Complete double to single, update upgrade_from_dual start!');
      await SettingUtil.setValueSecurity(CommonConstant.UPGRADE_FROM_DUAL, CommonConstant.UPGRADE_FROM_DUAL_OFF,
        settings.domainName.USER_SECURITY);
      LogUtil.warn(TAG, 'update upgrade_from_dual end!');
    }
  }

  /**
   * 完成OOBE时，修改settingsdata中的标记位
   */
  public async updateSettingsData(): Promise<void> {
    LogUtil.warn(TAG, 'finish oobe, updateSettingsData start!');
    this.isOobeFinish = true;
    // 开机向导完成标记位
    let result: boolean = await SettingUtil.setValue(CommonConstant.DEVICE_PROVISIONED, CommonConstant.STATUS_FINISHED);
    LogUtil.warn(TAG, 'update device_provisioned end!');
    HiSysEventUtil.reportUserEvent(CommonConstant.FINISH_OOBE, `save ${CommonConstant.DEVICE_PROVISIONED},
     result:${result}`);

    // 用户设置完成状态
    result = await SettingUtil.setValue(CommonConstant.SECURE_USER_SETUP_COMPLETE, CommonConstant.STATUS_FINISHED,
      settings.domainName.USER_SECURITY);
    LogUtil.warn(TAG, 'update user_setup_complete end!');
    HiSysEventUtil.reportUserEvent(CommonConstant.FINISH_OOBE, `save ${CommonConstant.SECURE_USER_SETUP_COMPLETE},
     result: ${result}`);

    // 构造版本信息
    await SettingUtil.setValue(CommonConstant.SECURE_BUILD_VERSION_RELEASE, OOBEUtil.getDisplayVersion(),
      settings.domainName.USER_SECURITY);
    LogUtil.warn(TAG, 'update buildversionrelease end!');

    await this.finishOtaProcess();

    if (this.getSceneType() === SceneType.OTA_SCENE || this.getSceneType() === SceneType.PRIVATE_SPACE_SCENE) {
      // OTA和隐私空间没有基础协议界面去写入这个字段，需要在完成OOBE的时候补齐这个字段
      this.saveAgreedStatusToSetting(true);
    }
  }

  /**
   * 获取OOBE是否完成
   *
   * @returns true-OOBE完成
   */
  public getOobeFinish() {
    return this.isOobeFinish;
  }

  /**
   * 存储基础服务声明状态（存储到Settings表中）
   * @param isAgreed 是否同意基础服务申明
   */
  public saveAgreedStatusToSetting(isAgreed: boolean): void {
    let valueStr: string = isAgreed ? CommonConstant.STATUS_ON : CommonConstant.STATUS_OFF;
    LogUtil.warn(TAG, 'update basic_statement_agreed to setting start!');
    let result = SettingUtil.setValueSync(CommonConstant.BASIC_STATEMENT_AGREED_KEY, valueStr,
      settings.domainName.USER_SECURITY);
    LogUtil.warn(TAG, 'update basic_statement_agreed to setting end!');
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `save basic statement agreed ${result}`);
  }

  /**
   * 完成OTA，修改数据库状态
   */
  private async finishOtaProcess(): Promise<void> {
    // 完成OOBE，将is_ota_finished置为1，供其它模块通过数据库判断OOBE阶段
    let result: boolean = await SettingUtil.setValue(CommonConstant.SECURE_IS_OTA_FINISHED,
      CommonConstant.STATUS_FINISHED, settings.domainName.USER_SECURITY);
    LogUtil.warn(TAG, 'update is_ota_finished end');
    HiSysEventUtil.reportUserEvent(CommonConstant.FINISH_OOBE, `save ${CommonConstant.SECURE_IS_OTA_FINISHED},
     result: ${result}`);

    if (this.isOtaIncomplete()) {
      HiSysEventUtil.reportUserEvent(FINISH_OTA, 'OTA finish.');
    }
  }

  private async querySettingsData(): Promise<void> {
    this.deviceProvisioned = await SettingUtil.getValue(CommonConstant.DEVICE_PROVISIONED,
      CommonConstant.STATUS_NO_FINISHED);
    // 数据兼容阶段，勿 argue & comment
    // sceneboard 适配完成后，该值默认应修改为 STATUS_FINISHED，当前无法从SECURE读取，因此默认为STATUS_NO_FINISHED，保证可以拉起
    this.userSetupComplete = await SettingUtil.getValue(CommonConstant.SECURE_USER_SETUP_COMPLETE,
      CommonConstant.STATUS_NO_FINISHED, settings.domainName.USER_SECURITY);

    // ota状态默认为1，完成或关闭状态
    this.isOtaFinished = await DataShareUtil.getValueByDataShare(CommonConstant.SECURE_IS_OTA_FINISHED,
      CommonConstant.STATUS_FINISHED, settings.domainName.USER_SECURITY);
  }

  private async isMigratePrivacySpaceStatus(): Promise<boolean> {
    // OTA升级过来后如果有这个字段，表示存在隐私空间，如果值为1则表示未进行迁移。切换到隐私空间后需要拉起OOBE走迁移流程，如果为0则表示已经迁移过，不需要走OOBE
    let migratePrivacySpaceStatus: string = await SettingUtil.getValue(CommonConstant.MIGRATE_PRIVACY_SPACE_STATUS,
      CommonConstant.MIGRATE_PRIVACY_SPACE_STATUS_OFF);
    return migratePrivacySpaceStatus === CommonConstant.MIGRATE_PRIVACY_SPACE_STATUS_ON
  }

  /**
   * 是否隐私用户
   */
  private async initPrivateUser(): Promise<void> {
    let accountManager: account_osAccount.AccountManager = account_osAccount.getAccountManager();
    try {
      await accountManager.getOsAccountType().then((type: account_osAccount.OsAccountType) => {
        LogUtil.info(TAG, `is private account: ${type === PRIVATE_TYPE}`);
        if (type === PRIVATE_TYPE) {
          this.isPrivateUser = true;
        }
      }).catch((err: BusinessError) => {
        LogUtil.error(TAG, `getOsAccountType errInfo: ${err?.message}.`);
      });
    } catch (e) {
      LogUtil.error(TAG, `getOsAccountType exception: ${e?.message}.`);
    }
  }

  private async isEduSpace(): Promise<boolean> {
    let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
    try {
      let accountInfo: osAccount.OsAccountInfo = await accountManager.queryOsAccount();
      this.localId = accountInfo.localId;
      if (this.localId === null || this.localId === undefined) {
        return false;
      }
      //获取教育空间标识
      let userId: string = await SettingUtil.getValue(EDUCATION_SPACE_SETTING_FLAG, '', settings.domainName.DEVICE_SHARED);
      return userId === String(this.localId);
    } catch (e) {
      const err = e as BusinessError;
      LogUtil.error(TAG,`queryOsAccount exception: code is ${err.code}, message is ${err.message}`);
    }
    return false;
  }

}

export enum SceneType {
  /**
   * 首次开机、恢复出厂设置场景
   */
  FIRST_BOOT_SCENE = 1,

  /**
   * 创建子用户场景
   */
  SUB_USER_SCENE = 2,

  /**
   * ota场景
   */
  OTA_SCENE = 3,

  /**
   * 隐私空间场景
   */
  PRIVATE_SPACE_SCENE = 4,

  /**
   * 整机SN二维码场景
   */
  SN_QRCODE_SCENE = 5,

  /**
   * 非中控屏
   */
  NON_CENTRAL_CONTROL_SCREEN = 6,

  /**
   * 教育空间场景
   */
  EDU_SPACE = 7,
}