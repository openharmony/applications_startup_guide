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

/**
 * lazyList控件数据源
 */
export abstract class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];

  /**
   * 获取数据项
   * @param index 下标
   * @returns 数据项
   */
  abstract getData(index: number): T;

  /**
   * 获取数目
   * @returns 数目
   */
  public totalCount(): number {
    return 0;
  }

  /**
   * 注册监听
   * @param listener 监听
   */
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  /**
   * 注销监听
   * @param listener 监听
   */
  unregisterDataChangeListener(listener: DataChangeListener): void {
    let pos: number = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  /**
   * 加载通知
   */
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    });
  }

  /**
   * 通知新增
   * @param index 下标
   */
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    });
  }

  /**
   * 变更通知
   * @param index 下标
   */
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    });
  }

  /**
   * 删除通知
   * @param index 下标
   */
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    });
  }

  /**
   * 移动通知
   * @param from  起始下标
   * @param to 终止下标
   */
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    });
  }
}
