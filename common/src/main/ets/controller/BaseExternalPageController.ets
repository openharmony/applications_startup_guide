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
import ability from '@ohos.ability.ability';
import { BusinessError } from '@ohos.base';
import { PageAction } from '../model/PageAction';
import { HiSysEventUtil } from '../util/HiSysEventUtil';
import { CommonConstant } from '../constant/CommonConstant';
import { WindowManager } from '../manager/WindowManager';
import { BgVideoPlayerManager, PlayState } from '../manager/BgVideoPlayerManager';
import { PageKey } from '../constant/PageKey';
import { FastCloneSceneManager } from '../manager/FastCloneSceneManager';
import { EventEmitter } from '../event/EventEmitter';
import { Event } from '../event/Event';
import { BasePageController } from './BasePageController';
import { LogUtil } from '../util/LogUtil';
import { IPageOrderController } from './IPageOrderController';
import { AbilityUtil } from '../util/AbilityUtil';
import { WantUtil } from '../util/WantUtil';

/**
 * 默认下一页结果码
 */
export const NEXT_ACTION_CODE: number = 100;

/**
 * 默认上一页结果码
 */
export const PRE_ACTION_CODE: number = 101;

/**
 * 默认外部页面中切换下一页结果码
 */
export const SUBPAGE_NEXT_ACTION_CODE: number = 200;

/**
 * 默认外部页面中切换上一页结果码
 */
export const SUBPAGE_PRE_ACTION_CODE: number = 201;

/**
 * 接入界面闪退结果码
 */
export const EXTERNAL_CRASH_CODE: number = -1;

/**
 * 结果码
 */
export const RESULT_CODE: string = 'resultCode';

/**
 * 外部页面切换页面结果码
 */
export const SWITCH_RESULT_CODE: string = 'switchCode';

/**
 * 外部页面控制器基类
 */
export abstract class BaseExternalPageController extends BasePageController {
  // OOBE向UIExtensionAbility应用发送数据代理。框架开放，供接入应用使用。非冗余字段，勿commit。
  protected dataSendProxy: UIExtensionProxy | null = null;

  /**
   * 构造函数
   * @param pageOrderController 页面顺序控制器
   * @param uiAbility uiAbility
   */
  public constructor(pageOrderController: IPageOrderController, controllerKey: PageKey) {
    super(pageOrderController, controllerKey);
  }

  /**
   * 设置应用发送数据代理
   * @param proxy
   */
  setDataSendProxy(proxy: UIExtensionProxy): void {
    this.dataSendProxy = proxy;
  }

  /**
   * 发送数据给数据代理
   *
   * @param info 要发送的数据
   */
  sendDataByProxy(info: string): void {
  }

  /**
   * 监听键盘高度
   * @param proxy
   */
  monitorKeyboardHeightChanged(proxy: UIExtensionProxy): void {
    WindowManager.getInstance().getKeyboardHeight()
      .then((keyboardHeight: number) => {
        proxy.send({ 'keyboardHeight': keyboardHeight });
      })
      .catch((err: BusinessError) => {
        LogUtil.error(this.getKey(), `getKeyboardHeight exception: ${err?.message}.`);
      });
    WindowManager.getInstance().setCallback((keyboardHeight: number) => {
      proxy.send({ 'keyboardHeight': keyboardHeight });
    });
  }

  /**
   * 取消键盘
   */
  unMonitorKeyboardHeightChanged(): void {
    WindowManager.getInstance().setCallback(null);
  }

  /**
   * 处理拉起Ability失败时的业务逻辑
   * 默认操作：调整index+1，拉起下一个应用
   * 如业务需实现其他逻辑，需覆写此逻辑
   */
  handleLoadAbilityError(errCode: number): void {
    LogUtil.error(this.getKey(), `load external component exception:${errCode}`);
    this.handleErrorOrCrash();
    HiSysEventUtil.reportErrorEvent(CommonConstant.PAGE_REDIRECTION_EXCEPTION, `err: load external page ${this.getKey()} error ${errCode}`);
  }

  private handleErrorOrCrash(): void {
    let currentKey: PageKey | undefined = this.mPageOrderController.getCurPageController()?.getKey();
    if (currentKey !== this.getKey()) {
      // 有多个uiextention接入，这里是异步调用，只响应当前页，不应该响应别的页
      LogUtil.warn(this.getKey(), `last key crash. current key ${currentKey} do noting`);
      return;
    }
    if (FastCloneSceneManager.getInstance().isFastCloneScene()) {
      // 快速启用状态机过程中，接入界面crash，回到上一个常态页面
      EventEmitter.getInstance().emit(Event.BACK_PRE_NORMAL_PAGE);
    } else {
      // 之前的逻辑是下一页，但是下一页有跳过激活锁，如果接入是最后一页甚至有完成OOBE风险
      this.mPageOrderController?.showPrevPage();
    }
  }

  /**
   * 处理跳转的结果
   * 如业务需实现其他逻辑，请覆写此函数
   * @param result 跳转的结果
   */
  handleAbilityResult(result: ability.AbilityResult | null): void {
    LogUtil.info(this.getKey(), `resultCode: ${result?.resultCode}, abilityName: ${result?.want?.abilityName}.`);
    if (result?.resultCode === NEXT_ACTION_CODE) {
      this.handleNextButtonClick();
    } else if (result?.resultCode === PRE_ACTION_CODE) {
      this.handlePrevButtonClick();
    } else if (result?.resultCode === EXTERNAL_CRASH_CODE) {
      LogUtil.error(this.getKey(), 'handleAbilityResult external page crash');
      this.handleErrorOrCrash();
    } else {
      LogUtil.error(this.getKey(), 'handleAbilityResult err');
    }
  }

  /**
   * 处理外接页面中内部页面跳转的结果
   * @param switch_result 跳转的结果
   */
  handleAbilitySwitchResult(switchResult: number): void {
    LogUtil.info(this.getKey(), `handleAbilitySwitchResult:${switchResult}`);
    if (switchResult === SUBPAGE_NEXT_ACTION_CODE) {
      BgVideoPlayerManager.getInstance().playVideo(PlayState.ENTER, this.getKey());
    } else if (switchResult === SUBPAGE_PRE_ACTION_CODE) {
      BgVideoPlayerManager.getInstance().playVideo(PlayState.BACK, this.getKey());
    } else {
      LogUtil.error(this.getKey(), 'handleAbilitySwitchResult err');
    }
  }

  /**
   * 处理外部业务传递给OOBE的数据
   * 可选特性，业务按需处理。覆写时，请保留下方当前函数处理临时动效的逻辑。
   * 临时特性：因华为账号要求，页面切换动效由“淡入淡出”调整为“左进右出”。5.0后调整回原动效。
   * 请各业务适配调整，具体请参考”单框架-页面接入OOBE“WIKI-”临时动效“。
   * 非冗余接口，勿commit。
   * @param data OOBE接收到的数据
   */
  handleReceivedData(data: Record<string, Object>): void {
    LogUtil.info(this.getKey(), 'handleReceivedData.');
    try {
      this.handleAbilityResult({ resultCode: (data[RESULT_CODE] as number) });
      this.handleAbilitySwitchResult(data[SWITCH_RESULT_CODE] as number);
    } catch (err) {
      LogUtil.error(this.getKey(), `handleReceivedData error: ${err?.message}.`);
    }
  }

  /**
   * OOBE向外部业务传递数据
   * 调用dataSendProxy.send接口
   * 可选特性，业务按需处理
   * 非冗余接口，勿commit。
   */
  sendData(): void {
    LogUtil.info(this.getKey(), `send data to ${this.getKey()}`);
  }

  /**
   * 加载当前页面
   * @param pageAction
   */
  loadPage(pageAction: PageAction): void {
    super.loadPage(pageAction);
    // 新老框架兼容阶段，不要commit。适配SR000IFK6D 【OOBE】页面接入框架整改
    if (this.pageConfig && AbilityUtil.isUIAbility(this.pageConfig.getAbilityName())) {
      if (!WantUtil.isExplicitPageConfig(this.pageConfig)) {
        LogUtil.error(this.getKey(), 'loadPage rejected: pageConfig missing explicit bundleName/abilityName');
        this.handleLoadAbilityError(100);
        return;
      }
      LogUtil.info(this.getKey(), `start to load external ability ${this.pageConfig?.getAbilityName()}.`);
      AbilityUtil.startAbilityForResult(
        this.pageConfig.getBundleName(),
        this.pageConfig.getAbilityName(),
        this.pageConfig.getParams(),
        (err, result) => {
        if (err) {
          LogUtil.info(this.getKey(), `load external ability err: ${err.code} ${err.message}`);
          HiSysEventUtil.reportErrorEvent(CommonConstant.RUN_SERVIVCES_FAILED,
            `load external ability err: ${err.code} ${err.message}`);
          this.handleLoadAbilityError(err?.code);
          return;
        }
        // 执行正常业务
        this.handleAbilityResult(result);
      });
    }
  }

  /**
   * 查询Ability是否存在,设置可见性
   * 如业务需实现其他逻辑，需保留包存在性判断，此函数基础上添加定制逻辑
   */
  public async configNeedShow(): Promise<void> {
    try {
      let isAbilityAvailable = await AbilityUtil.isAbilityAvailable(this.pageConfig);
      this.setNeedShow(isAbilityAvailable);
    } catch (err) {
      let error = err as BusinessError;
      LogUtil.error(this.getKey(),
        `${this.pageConfig?.getBundleName()} isAbilityAvailable err:${error.code} ${error.message}`);
      this.setNeedShow(false);
    }
  }

  /**
   * page中的aboutToAppear
   */
  public pageAppear(): void {
    super.pageAppear();
  }

  /**
   * page中的aboutToDisappear
   */
  public pageDisappear(): void {
    super.pageDisappear();
  }

  /**
   * 处理快速克隆
   * @returns true-成功，可以跳过；false-失败，不可跳过
   */
  handleFastClone(): boolean {
    return false;
  }
}