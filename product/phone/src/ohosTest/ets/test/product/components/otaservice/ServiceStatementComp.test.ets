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

import { describe, beforeAll } from '@ohos/hypium';
import {
  CommonConstant,
  ServiceEntity,
  SettingUtil
} from '@ohos/hwstartupguide.common';
import settings from '@ohos.settings';

export default function ServiceStatementCompTest() {
  describe('ServiceStatementCompTest', (done: Function) => {
    beforeAll(async () => {
      SettingUtil.setValueSync(CommonConstant.DEVICE_PROVISIONED, '1');
      SettingUtil.setValueSync(CommonConstant.SECURE_USER_SETUP_COMPLETE, '1', settings.domainName.USER_SECURITY);

      let ent0 = new ServiceEntity(new Object());
      ent0.setTitle('启用全部增强服务');
      let ent1 = new ServiceEntity(new Object());
      ent1.setTitle('服务1');
    })

  });
}