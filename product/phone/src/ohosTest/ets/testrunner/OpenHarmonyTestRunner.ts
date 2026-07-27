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

import type TestRunner from '@ohos.application.testRunner';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator;
let abilityDelegatorArguments: AbilityDelegatorRegistry.AbilityDelegatorArgs;
const global: object = globalThis as object;


/**
 * Phone test runner for unittest
 *
 * @since 2023-07-17
 */
async function onAbilityCreateByPhoneCallback(): Promise<void> {
}

async function addAbilityMonitorByPhoneCallback(err: unknown): Promise<void> {
}

export default class OpenHarmonyTestRunner implements TestRunner {
  onPrepare(): void {
  }

  async onRun(): Promise<void> {
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    /**
     * omitted
     */
    const savePath: string = '__savePath__';
    const readPath: string = '__readPath__';
    const testMode: string = '__testMode__';
    let uid: number = Math.floor(abilityDelegator.getAppContext().applicationInfo.uid / 200000);
    const bundleName: string = abilityDelegatorArguments.bundleName;
    global[savePath] = '/data/storage/el2/base/js_coverage.json';
    global[readPath] = '/data/app/el2/' + uid + '/base/' + bundleName + '/js_coverage.json';
    global[testMode] = 'ohostest';
    /**
     * omitted
     */
    const lMonitorByPhone = {
      abilityName: `${abilityDelegatorArguments?.bundleName}.TestAbility`,
      onAbilityCreate: onAbilityCreateByPhoneCallback,
    };
    abilityDelegator.addAbilityMonitor(lMonitorByPhone, addAbilityMonitorByPhoneCallback);
    let cmd = `aa start -d 0 -a TestAbility -b ${abilityDelegatorArguments.bundleName}`;
    const debugByPhone = abilityDelegatorArguments.parameters['-D'];
    if (debugByPhone === 'true') {
      cmd += ' -D';
    }
    abilityDelegator.executeShellCommand(cmd,
      (err: unknown, data: unknown) => {
      });
  }
}