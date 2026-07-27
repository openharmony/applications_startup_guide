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
  AbilityType,
  BasePageController,
  GlobalContext,
  IPageController,
  IPageOrderController,
  PageConfig,
  PageKey
} from '@ohos/hwstartupguide.common';
import { describe, it, expect, TestType, beforeAll, afterAll } from '@ohos/hypium';
import { PageOrderController } from '../../../../../main/ets/controller/PageOrderController';
import UIAbility from '@ohos.app.ability.UIAbility';
import { PageModel } from '../../../../../main/ets/model/pages/PageModel';

export default function PageModelTest() {
  let model: PageModel;
  let loaderMap: Map<String, ($$: IPageController | null | undefined) => void> =
    new Map<String, ($$: IPageController | null | undefined) => void>();

  class TestPageOrderController implements IPageOrderController {
    nextPageController: IPageController | null = null;

    constructor() {
    }

    isExperiencePage(): boolean {
      throw new Error('Method not implemented.');
    }

    getTag(): string {
      throw new Error('Method not implemented.');
    }

    getAllPageController(): IPageController[] {
      throw new Error('Method not implemented.');
    }

    getPageControllerByName(pageName: string): IPageController {
      throw new Error('Method not implemented.');
    }

    getCurPageController(): IPageController {
      throw new Error('Method not implemented.');
    }

    getLastPageController(): IPageController {
      throw new Error('Method not implemented.');
    }

    hasNextPage(): boolean {
      throw new Error('Method not implemented.');
    }

    showNextPage(): void {
      throw new Error('Method not implemented.');
    }

    hasPrevPage(): boolean {
      throw new Error('Method not implemented.');
    }

    showPrevPage(): void {
      throw new Error('Method not implemented.');
    }

    getNextEnableShowPage(): IPageController {
      return this.nextPageController!!;
    }

    adjustPageIndex(step: number): void {
      throw new Error('Method not implemented.');
    }

    finishOOBE(): void {
      throw new Error('Method not implemented.');
    }

    finishOOBEWithDelSubUser(): void {
      throw new Error('Method not implemented.');
    }

    jumpToPage(pageKey: string): void {
      throw new Error('Method not implemented.');
    }

    mapNewIndex(pageKey: string): void {
      throw new Error('Method not implemented.');
    }

    exchangePage(pageOne: PageKey, pageTwo: PageKey): void {
      throw new Error('Method not implemented.');
    }
  }

  let testCtrl = new TestPageOrderController();

  describe('PageModelTest', () => {
    beforeAll(async () => {
      let config = new PageConfig('');
      config.setKey('test');
      model = new PageModel([config], [-1], loaderMap, (func: ($$: IPageController | null | undefined) => void) => {
      });
    })

    it('PageModelTest_001', TestType.FUNCTION, () => {
      model.refreshUI(0);
      model.refreshUI(1);
      let result = (): void => {
        GlobalContext.getInstance().setObject('mPageOrderController', testCtrl);
      };
      expect(result).not().assertFail();
      model.refreshUI(0);
    });

    afterAll(() => {
      model.adjustOrientation();
      model.addOrientationListener();
      model.aboutToAppear(1);
      model.aboutToDisappear();
    })
  });
}