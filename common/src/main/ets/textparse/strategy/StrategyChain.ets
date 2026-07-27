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

import { IParser } from '../parser/IParser';
import { BaseText } from '../parser/TextModel';
import { LogUtil } from '../../util/LogUtil';

const TAG: string = 'ParseStrategy';

/**
 * 解析策略责任链
 */
export class StrategyChain {
  /**
   * 当前解析器
   */
  private mCurParser: IParser;

  /**
   * 下一个解析策略
   */
  private mNextStrategy: StrategyChain | null = null;

  /**
   * 构造函数
   * @param parser
   */
  constructor(parser: IParser) {
    this.mCurParser = parser;
  }

  /**
   * 解析文本集合
   * @param textArr 待解析文本集合
   */
  parseText(textArr: BaseText[]): BaseText[] {
    if (this.mCurParser === null) {
      LogUtil.error(TAG, 'mCurParser is empty');
      return textArr;
    }
    let curResult: BaseText[] = this.mCurParser.parseText(textArr);
    if (this.mNextStrategy === null) {
      return curResult;
    }
    return this.mNextStrategy.parseText(curResult);
  }

  /**
   * 设置下一个解析策略
   * @param nextStrategy 下一个解析策略
   */
  setNextStrategy(nextStrategy: StrategyChain): void {
    this.mNextStrategy = nextStrategy;
  }
}
