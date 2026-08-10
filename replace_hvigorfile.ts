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

import { hvigor, getHvigorNode } from '@ohos/hvigor';
import { appTasks } from '@ohos/hvigor-ohos-plugin';
import { uploadTestCases } from '@ohos/hypium-plugin';
import { onlineSignPlugin, OnlineSignOptions } from '@ohos/hvigor-ohos-online-sign-plugin';

const config = {
  hvigor: hvigor,
  hvigorNode: getHvigorNode(__filename),
  modulesConfig: [
    {
      moduleName: 'phone_startupguide',
      appName: 'oobe',
      templateEngName: 'HwStartupGuideTest', // CDE任务模板中维护的模板英文名称
    },
    {
      moduleName: 'pc_hwstartupguide', // build-profile.json5
      appName: 'oobe',
      templateEngName: 'HwStartupGuidePcTask', // CDE任务模板中维护的模板英文名称
    },
    {
      moduleName: 'watch_hwstartupguide', // build-profile.json5
      appName: 'Watch-OOBE',
      templateEngName: 'DTHwStartupGuide_watch', // CDE任务模板中维护的模板英文名称
    }
  ]
};

const signOptions: OnlineSignOptions = {
  profile: 'signature/startupguide.p7b',
  keyAlias: 'HwStartupGuide HMOS',
  hapSignToolFile: 'signature/hap-sign-tool.jar', // 签名工具hap-sign-tool.jar的路径
  username: `${process.env.ONLINE_USERNAME}`, // 环境变量中需要配置用户名和密码
  password: `${process.env.ONLINE_PASSWD}`,
  enableOnlineSign: true // 是否启用在线签名
};

uploadTestCases(config);


export default {
  system: appTasks,
  plugins: [onlineSignPlugin(signOptions)]
};
