// Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.

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

import type { Project } from '@ohos/hvigor';
import { hvigor, getHvigorNode } from '@ohos/hvigor';
import { appTasks } from '@ohos/hvigor-ohos-plugin';
import fs from 'fs';
import path from 'path';
import crypto from 'crypto';

const hvigorNode = getHvigorNode(__filename) as Project;
const appTask = appTasks(hvigorNode);

const interfacesFiles = [
  'common/src/main/ets/openApi/@ohos.telephony.rcs.d.ts',
  'common/src/main/ets/api/@hms.system.hwadc.d.ts'
];

function getFileHash(filePath: string): string {
  const hash = crypto.createHash('md5');
  const buffer = fs.readFileSync(filePath);
  hash.update(buffer);
  return hash.digest('hex');
}

function copySingleInterfaceFile(etsApiDir: string, file: string): void {
  const srcFile = path.resolve(__dirname, file);
  const destFile = path.resolve(etsApiDir, path.basename(file));
  console.log(`srcFile ${srcFile} destFile ${destFile}`);
  if (!fs.existsSync(srcFile)) {
    console.warn(`Source file not found: ${srcFile}`);
    return;
  }
  if (!fs.existsSync(destFile) || getFileHash(srcFile) !== getFileHash(destFile)) {
    try {
      fs.copyFileSync(srcFile, destFile);
      console.log(`Copy ${file} to sdk dir success`);
    } catch (err) {
      console.warn(`Failed to copy ${file} to sdk dir:`, err);
    }
  }
}

function copyInterfacesFile(sdkInfo): void {
  try {
    const etsApiDir = path.resolve(sdkInfo.getSdkToolchainsDir(), '../ets/api');
    if (!fs.existsSync(etsApiDir)) {
      console.warn('Cannot find ets api dir:', etsApiDir);
      return;
    }
    for (const file of interfacesFiles) {
      copySingleInterfaceFile(etsApiDir, file);
    }
  } catch (err) {
    console.warn('Failed to copy interfaces files:', err);
  }
}

hvigor.nodesEvaluated(() => {
  try {
    const taskService = appTask.getTaskService()!;
    const sdkInfo = taskService.getSdkInfo();
    copyInterfacesFile(sdkInfo);
  } catch (e) {
    console.log('Prepare for build failed:', e);
  }
});

export default {
  system: appTasks,
};
