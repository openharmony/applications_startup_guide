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

import {
  BasePageController,
  CommonConstant,
  Event,
  EventEmitter,
  FastCloneSceneManager,
  IPageOrderController,
  LogUtil,
  PageKey,
  ServiceEntity,
  SceneTypeManager,
  SceneType
} from '@ohos/hwstartupguide.common';
import { BasicServiceUtil } from '../util/BasicServiceUtil';

/**
 * 基础服务声明控制器
 */
export class BasicServicePageController extends BasePageController {
  private mConfigFileName: string = 'basic_service_statements.json';
  private mBasicServiceList: Array<ServiceEntity> = [];
  private mCurrentVersion: string = '';
  private isInit: boolean = false;

  /**
   * 构造函数
   * @param pageOrderController 页面顺序控制器
   * @param controllerKey 控制器key
   */
  public constructor(pageOrderController: IPageOrderController) {
    super(pageOrderController, PageKey.BASIC_SERVICE);
  }

  public async configNeedShow(): Promise<void> {
    let previousVersion = await BasicServiceUtil.loadVersionFromSP();
    let basicService = await BasicServiceUtil.genBasicServiceFromFile(this.mConfigFileName);
    this.mCurrentVersion = basicService.statementVersion;
    LogUtil.info(this.getKey(), `previousVersion ${previousVersion}, currentVersion ${this.mCurrentVersion}`);
    // 1、仅当在OTA场景时，当前的协议版本和已有的协议版本不同时，才需要展示协议与声明页面
    // 2、当基础协议内容发生变更时，需要手动更新basic_service_statements.json中的statementVersion字段
    this.setNeedShow(this.mCurrentVersion !== previousVersion || SceneTypeManager.getInstance().getSceneType() !==
    SceneType.OTA_SCENE);
  }

  /**
   * 点击上一页
   */
  handlePrevButtonClick(): void {
    LogUtil.info(this.getKey(), 'handlePrevButtonClick');
    if (FastCloneSceneManager.getInstance().isFastCloneScene()) {
      this.showExitDialog();
    } else {
      super.handlePrevButtonClick();
      this.emitEvent(Event.USER_BASIC_SERVICE_LEFT_ARROW);
    }
  }

  /**
   * 点击下一页
   */
  handleNextButtonClick(): void {
    if (FastCloneSceneManager.getInstance().isFastCloneScene()) {
      this.emitEvent(Event.BASIC_SERVICE_STATE_NEXT);
    } else {
      super.handleNextButtonClick();
    }
    this.saveBasicServiceData();
  }

  /**
   * 存储基础服务声明数据和最新一次的协议版本
   */
  saveBasicServiceData(): void {
    LogUtil.info(this.getKey(), 'saveBasicServiceData');
    SceneTypeManager.getInstance().saveAgreedStatusToSetting(true);
    BasicServiceUtil.saveBasicStatementsToSP(this.mBasicServiceList);
    BasicServiceUtil.saveVersionToSP(this.mCurrentVersion);
  }

  /**
   * 获取基础服务声明
   */
  getBasicServiceList(): Array<ServiceEntity> {
    return this.mBasicServiceList;
  }

  /**
   * 初始化基础服务声明
   */
  async initBasicServiceList(): Promise<void> {
    if (this.isInit) {
      LogUtil.info(this.getKey(), 'init success.')
      return;
    }
    LogUtil.info(this.getKey(), 'initBasicServiceList');
    let basicService = await BasicServiceUtil.genBasicServiceFromFile(this.mConfigFileName);
    this.mBasicServiceList = basicService.statementLists;
    this.isInit = true;
  }

  public confirmExit(): void {
    // 弹框二次确认，确认返回上一步，回到上一个常态界面
    EventEmitter.getInstance().emit(Event.BACK_PRE_NORMAL_PAGE);
  }

  showExitDialog() {
    LogUtil.info(this.getKey(), 'showExitDialog');
    AppStorage.setOrCreate(CommonConstant.SHOW_EXIT_DIALOG, true);
  }
}
