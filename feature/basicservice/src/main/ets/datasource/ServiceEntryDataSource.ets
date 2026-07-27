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
import { CommonConstant, HiSysEventUtil, LogUtil, ServiceEntity } from '@ohos/hwstartupguide.common';
import { BasicDataSource } from './BasicDataSource';

const TAG: string = 'ServiceEntryDataSource';
/**
 * 协议lazyList控件数据源
 */
export class ServiceEntryDataSource extends BasicDataSource<ServiceEntity> {
  private dataArray: ServiceEntity[] = [];

  /**
   * 构造器
   * @param mServiceEntities 协议列表
   */
  constructor(mServiceEntities: Array<ServiceEntity>) {
    super();
    this.dataArray = mServiceEntities;
    HiSysEventUtil.reportUserEvent(CommonConstant.NEXT_PAGE_BUTTON, `init basic services, size: ${this.dataArray.length}`);
  }

  /**
   * 获取数目
   * @returns 数目
   */
  public totalCount(): number {
    return this.dataArray?.length;
  }

  /**
   * 获取数据项
   * @param index 下标
   * @returns 数据项
   */
  public getData(index: number): ServiceEntity {
    LogUtil.info(TAG, 'getData');
    if (!this.dataArray) {
      this.dataArray = [];
    }
    if (index < 0 || index >= this.dataArray.length) {
      return new ServiceEntity();
    }
    return this.dataArray[index];
  }

  /**
   * 获取数据项
   * @param index 下标
   * @param data 协议项
   */
  public addData(index: number, data: ServiceEntity): void {
    LogUtil.info(TAG, 'addData');
    if (!this.dataArray) {
      this.dataArray = [];
    }
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  /**
   * 添加数据项
   * @param index 下标
   * @returns 数据项
   */
  public pushData(data: ServiceEntity): void {
    LogUtil.info(TAG, 'pushData');
    if (data) {
      if (!this.dataArray) {
        this.dataArray = [];
      }
      this.dataArray.push(data);
      this.notifyDataAdd(this.dataArray.length - 1);
    }
  }

  /**
   * 添加数据项
   * @param index 下标
   * @returns 数据列表
   */
  public pushDataList(data: Array<ServiceEntity>): void {
    LogUtil.info(TAG, 'pushDataList');
    if (data) {
      if (!this.dataArray) {
        this.dataArray = [];
      }
      for (let element of data) {
        if (this.dataArray.indexOf(element) > -1) {
          continue;
        }
        this.dataArray.push(element);
      }
      this.notifyDataAdd(this.dataArray.length - 1);
    }
  }

  /**
   * 添加所有服务项
   * @param data 服务项数组
   */
  public addAllData(data: Array<ServiceEntity>): void {
    this.dataArray = data;
    this.notifyDataReload();
  }
}
