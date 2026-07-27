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

import { BoldTextParser } from '../parser/BoldTextParser';
import { LinkTextParser } from '../parser/LinkTextParser';
import { BaseText } from '../parser/TextModel';
import { StrategyChain } from './StrategyChain';
import { StringUtil } from '../../util/StringUtil';
import { HtmlParser } from '../parser/HtmlParser';
import { ServiceEntity } from '../../model/ServiceEntity';
import { LogUtil } from '../../util/LogUtil';

const TAG: string = 'ParseStrategy';

/**
 * 解析策略链
 */
export class ParseStrategy {
  private static instance?: ParseStrategy;
  /**
   * 解析责任链
   */
  private mStrategyChain: StrategyChain | null = null;

  /**
   * 构造函数
   */
  private constructor() {
    let htmlTextParser: StrategyChain = new StrategyChain(HtmlParser.getInstance());
    let boldTextParser: StrategyChain = new StrategyChain(BoldTextParser.getInstance());
    let linkTextParser: StrategyChain = new StrategyChain(LinkTextParser.getInstance());
    htmlTextParser.setNextStrategy(boldTextParser);
    boldTextParser.setNextStrategy(linkTextParser);
    this.mStrategyChain = htmlTextParser;
  }

  /**
   * 获取单例
   *
   * @returns instance
   */
  public static getInstance(): ParseStrategy {
    if (!ParseStrategy.instance) {
      ParseStrategy.instance = new ParseStrategy();
    }
    return ParseStrategy.instance;
  }

  /**
   * 解析文本
   * @param text 待解析文本
   */
  public parseText(mServiceEntity: ServiceEntity): Array<BaseText> {
    LogUtil.info(TAG, `parseText ServiceName:${mServiceEntity?.getServiceName()}`);
    this.init(mServiceEntity);
    let text: string = mServiceEntity?.getContent();
    if (StringUtil.isEmpty(text)) {
      return [];
    }
    HtmlParser.getInstance().init(text);
    return (this.mStrategyChain as StrategyChain).parseText([]);
  }

  /**
   * 配置协议
   * @param mServiceEntity
   */
  private init(mServiceEntity: ServiceEntity): void {
    LogUtil.info(TAG, `init ServiceName: ${mServiceEntity.getServiceName()}.`);
    LinkTextParser.getInstance().initAbilities(mServiceEntity?.getAbilities());
  }
}
