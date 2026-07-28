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

import { PageKey } from '../constant/PageKey';
import { LogUtil } from '../util/LogUtil';

/**
 * 切换一次页面所能播放的一段动画时长
 * UX设计一秒60帧，每段切换动画为39帧
 */
export const VIDEO_LENGTH_IN_ONE_SWITCH: number = 650;

/**
 * 顺序播放时用于定位关键帧的视频时间节点序列
 */
export const TIME_ARRAY_FOR_NEXT_PAGE_SWITCH: number[] = [0.88, 1.6, 2.3, 3.3];

/**
 * 返回播放时用于定位关键帧的视频时间节点序列
 */
export const TIME_ARRAY_FOR_PRE_PAGE_SWITCH: number[] = [0.88, 3.3, 2.3, 1.6];

const TAG: string = 'BgVideoPlayerManager';

/**
 * 球背景视频播放管理类
 */
export class BgVideoPlayerManager {
  public isLoadFinished: boolean = false;
  private useStaticBg: boolean = false;
  private currentSecondsKey: number = 0;
  private controller: VideoController = new VideoController();
  private lastestStartTime: number = 0;
  private static instance: BgVideoPlayerManager;

  /**
   * 单例
   *
   * @returns instance
   */
  static getInstance(): BgVideoPlayerManager {
    if (BgVideoPlayerManager.instance === undefined) {
      BgVideoPlayerManager.instance = new BgVideoPlayerManager();
    }
    return BgVideoPlayerManager.instance;
  }

  /**
   * 获取播放控制对象
   *
   * @returns VideoController 对象
   */
  public getBgVideoController(): VideoController {
    return this.controller;
  }

  /**
   * 设置播放控制对象
   * 将外部video组件的controller设置进manager中，
   * 以方便manager中方法对外部video组件进行控制
   * @returns VideoController 对象
   */
  public setBgVideoController(controller: VideoController): void {
    LogUtil.info(TAG, 'setBgVideoController');
    this.controller = controller;
    this.currentSecondsKey = 0;
  }

  public setUseStaticBg(useStatic: boolean): void {
    this.useStaticBg = useStatic;
    LogUtil.info(TAG, `setUseStaticBg: ${useStatic}`);
  }

  /**
   * 获当前视频阶段
   *
   * @returns currentSecondsKey 当前视频所在时间点在关键帧数组中的位置
   */
  public getBgVideoFrame(): number {
    return this.currentSecondsKey;
  }

  /**
   * 顺序播放时定位具体该播放的关键帧
   */
  private playForward(): void {
    let keyFrameTime = TIME_ARRAY_FOR_NEXT_PAGE_SWITCH[this.currentSecondsKey];
    this.controller.setCurrentTime(keyFrameTime, SeekMode.PreviousKeyframe);
    this.currentSecondsKey = this.currentSecondsKey === 3 ? 0 : this.currentSecondsKey + 1;
    LogUtil.info(TAG, 'playVideoStart');
    this.controller.start();
  }

  /**
   * 回切页面时定位具体该播放的关键帧
   */
  private playBackward():void {
    let keyFrameTime = TIME_ARRAY_FOR_PRE_PAGE_SWITCH[this.currentSecondsKey];
    this.controller.setCurrentTime(keyFrameTime, SeekMode.PreviousKeyframe);
    this.currentSecondsKey = this.currentSecondsKey === 0 ? 3 : this.currentSecondsKey - 1;
    LogUtil.info(TAG, 'playVideoStart');
    this.controller.start();
  }

  /**
   * 从关键帧向前播放一段视频
   */
  playForFewFrames(): void {
    LogUtil.info(TAG, 'playForFewFrames');
    this.lastestStartTime = new Date().getTime();
    this.controller.start();
    setTimeout(() => {
      // 确保快速点击时本次点击开始的播放不会被上一次点击后播放完的暂停停住
      let currentTime: number = new Date().getTime();
      if (currentTime - this.lastestStartTime >= VIDEO_LENGTH_IN_ONE_SWITCH) {
        this.controller.pause();
        LogUtil.info(TAG, this.currentSecondsKey.toString());
      }
    }, VIDEO_LENGTH_IN_ONE_SWITCH);
  }

  /**
   * 卡片前后切换时播放一段视频
   * @param playState 枚举状态值 表示卡片切换场景
   * @param pageKey 当前页的key
   */
  public playVideo(playState: PlayState, pageKey?: string): void {
    LogUtil.info(TAG, `playVideo playState:${playState}, pageKey:${pageKey}`);
    if (this.useStaticBg) {
      return;
    }
    if (pageKey === PageKey.EXPERIENCE_NOW) {
      // 立即体验页有自己的视频，不需要播放背景视频了
      LogUtil.info(TAG, `playVideo return. pageKey:${pageKey}`);
      return;
    }
    switch (playState) {
      case PlayState.ENTER:
        this.playForward();
        break;
      case PlayState.BACK:
        this.playBackward();
        break;
    }
  }
}

/**
 * @param playState 枚举状态值 表示卡片切换场景
 * ENTER 枚举状态值 前进进入下一个页面
 * BACK 枚举状态值 后退返回上一个页面
 */
export enum PlayState {
  ENTER = 0,
  BACK = 2,
}

