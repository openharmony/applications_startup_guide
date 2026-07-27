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

import { systemParameterEnhance } from '@kit.BasicServicesKit';
//import rcs from '@ohos.telephony.rcs';
import call from '@ohos.telephony.call';
import { LogUtil } from './LogUtil';
import { SystemParameterUtil } from './SystemParameterUtil';

const TAG: string = 'ValidatorUtil';

/**
 * Advanced information service tool class, which is used by the OOBE to obtain whether the device supports Advanced
 * information.
 */
export class ValidatorUtil {
  private isChangXiangProduct: string = SystemParameterUtil.getSync('const.multi.device.collaboration.changxiang', 'false');
  private isSupportHml: string = SystemParameterUtil.getSync('const.wifi.hw_hml_support', 'true');

  public isRcsEnable():boolean {
    let rcsStatus: boolean = false;
    let rcsSupport: boolean = false;
    try {
      rcsStatus = true;
      LogUtil.info(TAG, `rcsStatus :${rcsStatus}`);
    } catch (err) {
      LogUtil.error(TAG, `rcsStatus`, err);
    }
    try {
      rcsSupport = true;
      LogUtil.info(TAG, `rcsSupport: ${rcsSupport}`);
    } catch (err) {
      LogUtil.error(TAG, `rcsSupport`, err);
    }
    let rcsVisible: boolean = rcsStatus && rcsSupport;
    LogUtil.info(TAG, `rcsVisible:${rcsVisible}`);
    return rcsVisible;
  }

  /**
   * 获取是否支持蜂窝网络，用于区分蜂窝平板和 wifi-only平板
   *
   * @returns true: 支持蜂窝网络，代表蜂窝平板 false：wifi-only平板
   */
  public isCellularEnable(): boolean {
    let isCellularEnable: boolean = false;
    try {
      isCellularEnable = call.hasVoiceCapability();
      LogUtil.info(TAG, `isCellularEnable :${isCellularEnable}`);
    } catch (err) {
      LogUtil.error(TAG, `isCellularEnable`, err);
    }
    return isCellularEnable;
  }

  /**
   * 多设备协同服务屏蔽不需要字段, 根据ccm中changxiang&hml, 判断是否是畅享系列
   * @returns true:是畅享系列, 需展示定制文本信息, false:不是畅享系列, 默认显示源文本信息
   */
  public isChangXiang = (): boolean => {
    return this.isSupportHml === 'false' || this.isChangXiangProduct ==='true';
  }

  /**
   * 多设备协同服务是否显示源文本信息
   * @returns true: 显示源文本信息，非畅享系列 false：不显示源文本信息，是畅享系列
   */
  public isOriginalCollaboration = (): boolean => {
    return !this.isChangXiang();
  }

  public isEnableGeofence(): boolean {
    try {
      let isSupportGeofence: string = systemParameterEnhance.getSync('const.location.support_geofence', 'true');
      LogUtil.info(TAG, `isSupportGeofence: ${isSupportGeofence}`);
      if (isSupportGeofence === 'false') {
        return false;
      }
    } catch (err) {
      LogUtil.error(TAG, `isSupportGeofence`, err);
    }
    return true;
  }
}