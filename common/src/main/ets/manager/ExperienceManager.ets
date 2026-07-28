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
import uiAppearance from '@ohos.uiAppearance';
import settings from '@ohos.settings';
import DataShare from '@ohos.data.dataShare';
import { EnterHomeComponentModel } from '../model/EnterHomeComponentModel';
import { CommonConstant } from '../constant/CommonConstant';
import { SharePreferences } from '../preferences/SharePreferences';
import { SceneType, SceneTypeManager } from '../manager/SceneTypeManager';
import { LogUtil } from '../util/LogUtil';
import { SettingUtil } from '../util/SettingUtil';
import { AbilityManager } from './AbilityManager';

const TAG: string = 'ExperienceManager';

const SETTINGS_URI: string = 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=';
const SWITCH_NAME: string = 'isFirstPageLoaded';

/**
 * Experience管理类
 */
export class ExperienceManager {
  private static instance?: ExperienceManager;
  private isPhone: boolean = false;
  private dataHelper: DataShare.DataShareHelper | null = null;
  private enterHomeComponentModel: EnterHomeComponentModel = new EnterHomeComponentModel();

  private constructor() {
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  static getInstance(): ExperienceManager {
    if (!ExperienceManager.instance) {
      ExperienceManager.instance = new ExperienceManager();
    }
    return ExperienceManager.instance;
  }

  /**
   * 设置isPhone
   */
  public setIsPhone(isPhone: boolean): void {
    this.isPhone = isPhone;
  }

  /**
   * 获取isPhone
   */
  public getIsPhone(): boolean {
    return this.isPhone;
  }

  /**
   * 进入立即体验页时开始监听数据库
   */
  public startListenSettingDataChange(): void {
    // 当前设备是手机等具有小艺建议卡片的设备并且在进入立即体验页面时桌面尚未加载完成
    if (this.isPhone && !this.isDeskAlreadyReady()) {
      this.listenSettingDataChange()
    } else {
      this.enterHomeComponentModel.setButtonVisible(true);
    }
  }

  /**
   * 注销对数据库的监听事件
   */
  public stopListenSettingData(): void {
    this.dataHelper?.off('dataChange', SETTINGS_URI + SWITCH_NAME);
  }

  /**
   * 动画播放完后设置五秒的延时，五秒后显示按钮，注销对数据库的监听
   */
  public waitForSecondsToSetButtonVisible(): void {
    setTimeout(() => {
      if (!this.enterHomeComponentModel.getButtonVisible()) {
        LogUtil.warn(TAG, 'five seconds passed, timeOut');
        this.enterHomeComponentModel.setButtonVisible(true);
        // 延时器触发后注销对数据库的监听事件
        this.dataHelper?.off('dataChange', SETTINGS_URI + SWITCH_NAME);
      }
    }, 5000)
  }

  /**
   * 通过datashare监听settingData数据库中isFirstPageLoaded值变化
   */
  public listenSettingDataChange(): void {
    try {
      LogUtil.info(TAG, 'registerSettingDataListener');
      DataShare.createDataShareHelper(AbilityManager.getInstance().getContext() as Context, SETTINGS_URI + SWITCH_NAME)
        .then((dataHelper) => {
          LogUtil.info(TAG, 'createListener success');
          dataHelper.on('dataChange', SETTINGS_URI + SWITCH_NAME, () => {
            this.onIsFirstPageLoadedChange();
          });
          this.dataHelper = dataHelper;
        });
    } catch (err) {
      LogUtil.error(TAG, `createDataShareHelper err: ${err?.message}`);
    }
  }

  /**
   * 监听到数据库中数据变化后控制按钮显示
   */
  public onIsFirstPageLoadedChange(): void {
    let resultGlobal = SettingUtil.getValueSync(SWITCH_NAME, 'false');
    LogUtil.info(TAG, `received isFirstPageLoaded: ${resultGlobal}`);
    if (resultGlobal === 'true') {
      // 桌面准备完成
      this.enterHomeComponentModel.setButtonVisible(true);
      this.dataHelper?.off('dataChange', SETTINGS_URI + SWITCH_NAME);
    }
  }

  /**
   * 注册用于控制component中按钮显示与否的对象model
   */
  public registerEnterHomeComponentModel(model: EnterHomeComponentModel): void {
    LogUtil.info(TAG, 'registerEnterHomeComponentModel');
    this.enterHomeComponentModel = model
  }

  /**
   * 在开始监听数据库前，先获取一下isFirstPageLoaded，判断是否桌面已经加载完成，可以直接显示按钮
   */
  public isDeskAlreadyReady(): boolean {
    let resultGlobal: string = SettingUtil.getValueSync(SWITCH_NAME, 'false');
    LogUtil.info(TAG, `getValueSync global name:${SWITCH_NAME} value:${resultGlobal}`);
    return resultGlobal === 'true'
  }

  /**
   * 系统字体大小、粗细、深浅色延迟恢复
   */
  public async setCloneDatas(): Promise<void> {
    await this.setDarkModeOnRestart();
    if (SceneTypeManager.getInstance().getSceneType() === SceneType.FIRST_BOOT_SCENE ||
      SceneTypeManager.getInstance().isHmosToNext()) {
      await Promise.all<void>([this.setFontScale(), this.setFontWeightScale(),
        this.setDarkMode()]);
    }
  }

  /**
   * 设置字体大小缩放
   */
  public async setFontScale(): Promise<void> {
    try {
      let backUpFontScale: string = SettingUtil
        .getValueSync(CommonConstant.SETTINGS_DATA_BACKUP_FONT_SIZE_SCALE, '');
      if (backUpFontScale !== '') {
        await uiAppearance.setFontScale(Number(backUpFontScale));
        LogUtil.info(TAG, `uiAppearance.setFontScale: ${backUpFontScale}`);
        SettingUtil.setValueSync(CommonConstant.SETTINGS_DATA_FONT_SIZE_SCALE,
          backUpFontScale, settings.domainName.USER_PROPERTY);
        SettingUtil.setValueSync(CommonConstant.SETTINGS_DATA_BACKUP_FONT_SIZE_SCALE, '');
      }
    } catch (paramError) {
      let code: number = (paramError).code;
      let message: string = (paramError).message;
      LogUtil.error(TAG, `uiAppearance.setFontScale error, error.code: ${code}, error.message: ${message}`);
    }
  }

  /**
   * 设置字体粗细
   */
  public async setFontWeightScale(): Promise<void> {
    try {
      let backUpFontWeightScale: string = SettingUtil
        .getValueSync(CommonConstant.SETTINGS_DATA_BACKUP_FONT_WEIGHT_SCALE, '');
      if (backUpFontWeightScale !== '') {
        await uiAppearance.setFontWeightScale(Number(backUpFontWeightScale));
        LogUtil.info(TAG, `uiAppearance.setFontWeightScale: ${backUpFontWeightScale}`);
        SettingUtil.setValueSync(CommonConstant.SETTINGS_DATA_FONT_WEIGHT_SCALE,
          backUpFontWeightScale, settings.domainName.USER_PROPERTY);
        SettingUtil.setValueSync(CommonConstant.SETTINGS_DATA_BACKUP_FONT_WEIGHT_SCALE, '');
      }
    } catch (paramError) {
      let code: number = (paramError).code;
      let message: string = (paramError).message;
      LogUtil.error(TAG, `uiAppearance.setFontWeightScale error, error.code: ${code}, error.message: ${message}`);
    }
  }

  /**
   * 设置是否深色模式
   */
  private async setDarkMode(): Promise<void> {
    try {
      let backUpNightMode: string = SettingUtil
        .getValueSync(CommonConstant.SETTINGS_DATA_BACKUP_UI_NIGHT_MODE, '');
      if (backUpNightMode !== CommonConstant.DEFAULT_ALLOW_MODE) {
        LogUtil.info(TAG, `setDarkMode backUpNightMode: ${backUpNightMode}`);
        SettingUtil.setValueSync(CommonConstant.SETTINGS_DATA_BACKUP_UI_NIGHT_MODE,
          CommonConstant.DEFAULT_ALLOW_MODE);
        SettingUtil.setValueSync(CommonConstant.SETTINGS_DATA_UI_NIGHT_MODE,
          backUpNightMode, settings.domainName.USER_SECURITY);
        let nightMode = backUpNightMode === CommonConstant.DEFAULT_ALLOW_DARK_MODE ?
          uiAppearance.DarkMode.ALWAYS_DARK : uiAppearance.DarkMode.ALWAYS_LIGHT;
        await uiAppearance.setDarkMode(nightMode);
        LogUtil.info(TAG, `uiAppearance setDarkMode ${nightMode}`);
      }
    } catch (paramError) {
      let code: number = (paramError).code;
      let message: string = (paramError).message;
      LogUtil.info(TAG, `uiAppearance.setNightMode backup error, error.code: ${code}, error.message: ${message}`);
    }
  }

  /**
   * 恢复深色模式和setLightModeOnRestart联合使用
   */
  public async setDarkModeOnRestart(): Promise<void> {
    try {
      const darkModeBackup = await SharePreferences.getInstance().getValue(CommonConstant.DARK_MODE_BACKUP, '');
      if (darkModeBackup === uiAppearance.DarkMode.ALWAYS_DARK) {
        LogUtil.info(TAG, `setDarkModeOnRestart darkModeBackup: ${darkModeBackup}`);
        SharePreferences.getInstance().setValue(CommonConstant.DARK_MODE_BACKUP, CommonConstant.DEFAULT_ALLOW_MODE);
        await uiAppearance.setDarkMode(uiAppearance.DarkMode.ALWAYS_DARK);
        let darkmodeMode: string = await SharePreferences.getInstance()
          .getValue(CommonConstant.DARKMODE_MODE_BACKUP, '') as string;
        if (darkmodeMode) {
          SettingUtil.setValueSync(CommonConstant.SETTINGS_UIAPPEARANCE_DARKMODE_MODE,
            darkmodeMode, settings.domainName.USER_PROPERTY);
          SharePreferences.getInstance().setValue(CommonConstant.DARKMODE_MODE_BACKUP, '')
        }
        LogUtil.info(TAG, `uiAppearance setDarkModeOnRestart ${darkmodeMode}`);
      }
    } catch (e) {
      LogUtil.info(TAG, `setDarkModeOnRestart error ${e}`);
    }
  }

  /**
   * 数据导入完成后在OOBE阶段重启 默认恢复浅色模式
   */
  public async setLightModeOnRestart(): Promise<void> {
    try {
      if (SceneTypeManager.getInstance().isOtaIncomplete()) {
        LogUtil.info(TAG, 'in ota scene,setLightModeOnRestart return');
        return;
      }
      let nightMode: number = uiAppearance.getDarkMode();
      if (nightMode === uiAppearance.DarkMode.ALWAYS_DARK) {
        LogUtil.info(TAG, `setLightModeOnRestart nightMode: ${nightMode}`);
        SharePreferences.getInstance().setValue(CommonConstant.DARK_MODE_BACKUP, uiAppearance.DarkMode.ALWAYS_DARK);
        let darkmodeMode = SettingUtil.getValueSync(CommonConstant.SETTINGS_UIAPPEARANCE_DARKMODE_MODE,
          '', settings.domainName.USER_PROPERTY);
        SharePreferences.getInstance().setValue(CommonConstant.DARKMODE_MODE_BACKUP, darkmodeMode);
        await uiAppearance.setDarkMode(uiAppearance.DarkMode.ALWAYS_LIGHT);
        LogUtil.info(TAG, `uiAppearance setLightModeOnRestart: ${nightMode} ${darkmodeMode}`);
      }
    } catch (paramError) {
      let code: number = (paramError).code;
      let message: string = (paramError).message;
      LogUtil.info(TAG, `uiAppearance.setNightMode error, error.code: ${code}, error.message: ${message}`);
    }
  }
}