# StartupGuide

## 简介

**StartupGuide**（包名：`com.ohos.startupguide`）是 OpenHarmony 标准系统中的 **OOBE（Out Of Box Experience）开机引导系统应用**，负责在初次开机、恢复出厂设置场景中完成初始设置引导。

本应用为系统预置应用，不在桌面显示图标。在SceneBoard进程的 `SCBOobeManager` 按约定 BaseOOBEManager 显式拉起 `com.ohos.startupguide.MainAbility`；该 Ability 的实现类为 `GuideHomeAbility`。引导完成后，StartupGuide 写入完成状态并进入系统桌面。当前仓库提供 phone、Pad入口。

### 核心能力

**欢迎**
- 展示开机欢迎界面，引导用户开始初始设置。

**语言选择**
- 供用户选择系统显示语言，并使后续引导页面使用所选语言。

**国家地区选择**
- 供用户选择所在国家或地区，为后续系统服务提供区域信息。

**基础服务条款**
- 展示最终用户许可协议和基础服务条款，并保存用户的同意状态。

**增强服务**
- 根据配置展示可选的增强服务协议，并保存用户的选择结果。

**立即体验**
- 完成 OOBE 引导，保存完成状态并进入系统桌面。

### 支持的引导页面

| 页面 / PageKey | 所属模块 | 场景与处理概要 |
| ---- | ---- | ---- |
| `WELCOME` | `feature/welcome` | 欢迎页及企业设备相关处理 |
| `LANGUAGE_SELECT` | `feature/languageselect` | 语言选择 |
| `REGION_SELECT` | `feature/regionselect` | 国家 / 地区选择 |
| `BASIC_SERVICE` | `feature/basicservice` | 基础服务条款 / 最终用户许可协议 |
| `ENHANCED_SERVICE` | `feature/enhanceservice` | 增强服务声明 |
| `WLAN_KEY` | `product/phone` 外部控制器 | 连接网络页面 |
| `EXPERIENCE_NOW` | `feature/experience` | 完成引导并进入桌面 |

## 架构说明

StartupGuide 采用 **Product - Feature - Common** 三层模块化架构，并与 SceneBoard、Settings（含 WLAN OOBE 扩展页）等系统部件协同工作。

### 在系统中的定位

StartupGuide 位于应用层，由 SceneBoard 显式拉起；引导过程中通过系统框架完成 UI、Ability、窗口和数据访问，并按需接入 WLAN 页面、读写系统设置。

![StartupGuide 分层架构](./docs/figures/oobe_architecture.png)

图中右侧系统应用与前文保持一致：
- **SceneBoard**：启动 OOBE，并在引导期间限制其它应用窗口显示，确保开机引导始终保持在前台。
- **Settings（WLAN）**：提供 WLAN OOBE 扩展页，并承载相关系统配置。
- **Settings / DataShare**：提供数据的读写能力。

### StartupGuide 与其它系统应用的关系

StartupGuide 与系统定位图右侧的 SceneBoard、Settings（含 WLAN OOBE 扩展页）协同，但不包含这些部件的完整业务实现。

**事件与调用关系如下：**
1. SceneBoard 的 `SCBOobeManager` 在需要开机引导时，通过 bundleName `com.ohos.startupguide` 显式拉起 `com.ohos.startupguide.MainAbility`；其 `srcEntry` 指向 `GuideHomeAbility.ets`。
2. StartupGuide 通过 `SceneTypeManager` 识别场景，再由 `PageOrderController` 组装对应页面链。
3. WLAN 步骤由 `WlanPageController` 经外部页面接入框架拉起 Settings 的 `OobeWifiSettingsExtensionAbility`，外部页面完成后按 NEXT / PRE 等结果返回引导链。
4. 语言、地区、协议同意和 OOBE 完成状态通过 Settings / DataShare 等系统能力读写。
5. 引导完成后，StartupGuide 更新 `device_provisioned` 状态并交还系统桌面。

> 一次典型的初次开机流程：
> - SceneBoard 拉起 `com.ohos.startupguide.MainAbility`；
> - `SceneTypeManager` 判定为 `FIRST_BOOT_SCENE`；
> - `PageOrderController` 组装欢迎 → 语言 → 地区 → 基础服务 → 增强服务 → WLAN → 立即体验；
> - 用户完成最后一页后，StartupGuide 保存完成状态并进入系统桌面。

### 分层设计

产品层负责系统交互入口和设备形态适配；特性层承载完整引导步骤；公共层提供跨特性复用的页面、场景、存储和窗口能力。

| 层次 | 主要目录 / 组件 | 说明 |
| ---- | ---- | ---- |
| 产品层 | `product/phone` | `GuideHomeAbility`、页面链组装、外部页面控制器及产品形态组件封装；当前提供 Phone、Pad 入口。 |
| 特性层 | `feature/*` | 欢迎、语言、地区、基础服务、增强服务和立即体验等独立 HAR |
| 公共层 | `common` | 页面加载与生命周期、场景识别、外部页面接入、数据持久化、窗口管控、事件和通用 UI |

### 部件与外部依赖

`phone_startupguide` 是入口 HAP，各 Feature 与 Common 以本地 HAR 方式被入口模块依赖：

```text
product/phone (phone_startupguide)
├── @ohos/hwstartupguide.common
├── @ohos/hwstartupguide.basicservice
├── @ohos/hwstartupguide.enhanceservice
├── @ohos/hwstartupguide.languageselect
├── @ohos/hwstartupguide.regionselect
├── @ohos/hwstartupguide.welcome
└── @ohos/hwstartupguide.experience
```

跨进程协作边界如下：
- SceneBoard 负责启动与 OOBE 阶段系统霸屏。
- WLAN 等系统应用提供具体业务页面。
- Settings / DataShare 提供数据库存储。
- BundleManager 与 ResourceManager 用于读取业务应用 metadata 和协议资源。

### 模块说明

| 模块 | 路径 | 说明 |
| ---- | ---- | ---- |
| 基础服务 | `feature/basicservice/` | 最终用户许可协议及基础服务条款 |
| 增强服务 | `feature/enhanceservice/` | 协议配置、业务应用 metadata 读取、勾选状态保存 |
| 欢迎 | `feature/welcome/` | 欢迎引导步骤的 Controller、Component 与 Model |
| 语言 | `feature/languageselect/` | 语言选择步骤的 Controller、Component 与 Model |
| 地区 | `feature/regionselect/` | 地区选择步骤的 Controller、Component 与 Model |
| 体验 | `feature/experience/` | 立即体验步骤的 Controller、Component 与 Model |

## 编译构建

本工程为单模块 HAP 应用工程，使用 Hvigor 构建。入口模块为 `phone_startupguide`。

### 环境要求

- OpenHarmony SDK：`compileSdkVersion` 23，`compatibleSdkVersion` / `targetSdkVersion` 20
- DevEco Studio 或命令行 Hvigor 工具链
- Node.js 与 OHPM

### 编译命令

在工程根目录执行：

```bash
sh build.sh
```

### 构建产物

| 类型 | 产物 / 目标 | 说明 |
| ---- | ---- | ---- |
| 签名 HAP | `product/phone/build/default/outputs/default/phone_startupguide-default-signed.hap` | 可安装的默认签名产物 |

## StartupGuide 开发

StartupGuide 使用 **ArkTS** 开发。产品层负责入口与页面编排，Feature 层承载独立特性，Common 层提供跨特性基础能力。

### 基于已有模块的开发

适用场景：裁剪引导步骤、修改协议交互、调整外部页面接入或定制产品形态 UI。

**1. 确认改动层次**
- Ability 和形态适配：`product/phone`
- 单个引导步骤业务：`feature/<module>`
- 页面基类、场景、存储和通用能力：`common`

**2. 调整外部页面显示和隐藏**

外部页面控制器继承 `BaseExternalPageController`。以 WLAN 为例：

```typescript
export class WlanPageController extends BaseExternalPageController {
  isNeedShow(): boolean {
    if (FastCloneSceneManager.getInstance().isCloneWlan()) {
      let isNetConnected =
        InternetManager.getInstance().isNetConnected();
      return super.isNeedShow() && !isNetConnected;
    }
    return super.isNeedShow();
  }
}
```

**3. 调整增强服务协议**

- 展示项配置：`product/phone/src/main/resources/rawfile/enhance_service_statements.json`
- 协议实体生成：`common/src/main/ets/util/ServiceEntityUtil.ets`
- 页面控制器：`feature/enhanceservice/src/main/ets/controller/EnhanceServicePageController.ets`
- 状态保存：`feature/enhanceservice/src/main/ets/util/EnhanceServiceUtil.ets`

#### 协议接入 OOBE 指导

协议类型分为两类：

- **基础协议（协议与声明）**：用户必须同意后方可使用手机的基础协议。
- **增强协议（增强服务与用户体验改进）**：用户可选的协议，支持逐项勾选。

开机向导服务声明的接入方式主要分为两块：

- 在开机向导代码仓中配置声明信息。
- 在业务方代码仓中定义声明的版本号、标题、内容及参数等信息。

##### 服务声明接入方式

**1. 开机向导代码仓修改**

在 `basic_service_statements.json` 配置文件中添加对应的基础服务声明配置。

- 手机产品路径：`product/phone/src/main/resources/rawfile/basic_service_statements.json`

在 `enhance_service_statements.json` 配置文件中添加对应的增强服务声明配置。

- 手机产品路径：`product/phone/src/main/resources/rawfile/enhance_service_statements.json`

**配置示例（基础协议）**

```json
[
  {
    "serviceType": "basic",
    "serviceName": "test_basic_statement",
    "moduleName": "entry",
    "packageName": "com.example.teststartupguide",
    "validatorList": [],
    "checkboxList": ["settings=test_basic_status"],
    "saveDataList": ["settings=test_basic_status"]
  }
]
```

**配置示例（增强协议）**

```json
[
  {
    "serviceType": "enhance",
    "serviceName": "test_enhance_statement",
    "moduleName": "entry",
    "packageName": "com.example.teststartupguide",
    "validatorList": [],
    "checkboxList": ["settings=test_enhance_status"],
    "saveDataList": ["settings=test_enhance_status"]
  }
]
```

**配置参数说明**

| 参数名 | 说明 | 示例 |
| ---- | ---- | ---- |
| `serviceType` | 必填。协议类型，`"basic"` 表示基础协议，`"enhance"` 表示增强协议，其他值无效 | `"basic"` |
| `serviceName` | 必填。业务接入方 metadata 中的 name 值 | `"test_enhance_statement"` |
| `moduleName` | 必填。业务接入方 metadata 所属的模块名 | `"entry"` |
| `packageName` | 必填。业务接入方包名 | `"com.example.teststartupguide"` |
| `validatorList` | 可选。显示控制字段，用于指定是否显示的判断条件，支持 SysParameter、SettingsData、Custom 三种方式 | `["sysparameter=const.xxx.yyy=zzz"]` |
| `checkboxList` | 可选。历史选中状态，主要用于 OTA 升级场景中判断历史勾选状态。该字段需为 `saveDataList` 的子集，可配置一个字段。指定表名示例：`["settings=xxx, test_enhance_status"]`；不指定表名示例：`["settings=test_enhance_status"]`（默认存储于 global 表，与底层 settings 行为保持一致） | `["settings=test_enhance_status"]` |
| `saveDataList` | 可选。存储 settings 数据，可配置多个字段。存储值为 1 表示勾选，0 表示未勾选。指定表名示例：`["settings=xxx, test_enhance_status"]`；不指定表名示例：`["settings=test_enhance_status"]`（默认存储于 global 表） | `["settings=test_enhance_status"]` |
| `defaultCheckStatus` | 可选。首次进入页面时的默认开关状态，默认为开启（true），如需默认关闭可配置为 false | `false` |

**2. 业务侧代码修改**

**2.1 配置 metadata 信息**

在业务侧代码中配置与开机向导对应的 metadata 信息，样例如下（请根据实际框架补充）。

**2.2 配置服务声明内容 JSON 文件**

```json
{
  "version": "1.0",
  "title": "$string:statement_test_title",
  "content": "$string:statement_test_content",
  "params": [
    {
      "name": "param1",
      "value": "我的"
    },
    {
      "name": "param2",
      "value": "$string:param_value_2"
    }
  ],
  "abilities": [
    {
      "key": "测试",
      "value": {
        "bundleName": "com.example.teststartupguide",
        "abilityName": "EntryAbility",
        "parameters": {
          "ability.want.params.uiExtensionType": "您的type",
          "msg": "测试"
        }
      }
    },
    {
      "key": "r",
      "value": {
        "bundleName": "com.example.teststartupguide",
        "abilityName": "EntryAbility",
        "parameters": {
          "ability.want.params.uiExtensionType": "sys/commonUI"
        }
      }
    }
  ],
  "appLists": [
    {
      "name": "xxxxx",
      "content": "xxxxxxx",
      "key": "xxxxx"
    }
  ]
}
```

**常用修改入口：**

| 目标 | 路径 |
| ---- | ---- |
| 场景识别 | `common/src/main/ets/manager/SceneTypeManager.ets` |
| 页面键 | `common/src/main/ets/constant/PageKey.ts` |
| 页面编排 | `product/phone/src/main/ets/controller/PageOrderController.ets` |
| 外部页面 | `product/phone/src/main/ets/controller/external/` |
| 产品组件 | `product/phone/src/main/ets/components/` |
| 页面配置 | `product/phone/src/main/resources/rawfile/page_configs.json` |
| 协议配置 | `product/phone/src/main/resources/rawfile/*service_statements.json` |
| 主入口 | `product/phone/src/main/ets/ability/GuideHomeAbility.ets` |

### 新特性或引导步骤开发

适用场景：新增引导页面、扩展协议类型或接入新的外部系统页面。

**步骤 1：定义页面键和控制器**
1. 在 `PageKey.ts` 中新增唯一页面键。
2. 在对应 `feature/<module>` 中创建继承 `BasePageController` 的控制器。
3. 在 `PageOrderController` 的目标场景 Map 中注册控制器。

**步骤 2：实现并接入 UI**
1. 在 Feature 中实现可复用 Component / Model。
2. 在 `product/phone/src/main/ets/components/` 中增加必要的产品形态封装。

**步骤 3：接入外部系统页面**
1. 继承 `BaseExternalPageController`。
2. 在页面配置中声明目标 bundleName、abilityName、参数及返回语义。
3. 校验 NEXT、PRE、SUBPAGE、CRASH 等返回路径。
4. 实现对应方法，如：`isNeedShow()` 控制页面显隐、跳转下一页等。

**步骤 4：配置入口与权限**

入口已在 `product/phone/src/main/module.json5` 中声明：

```json
{
  "module": {
    "name": "phone_startupguide",
    "type": "entry",
    "srcEntrance": "./ets/Application/AbilityStage.ets",
    "mainElement": "com.ohos.startupguide.MainAbility",
    "deviceTypes": ["default"]
  }
}
```

**步骤 5：测试**
- 在 `product/phone/src/ohosTest/` 增加页面控制器、组件和工具类测试。
- 覆盖前进、返回、跳过和外部页面异常等路径。
- 在目标 Phone / Pad 产品形态上验证布局、旋转和语言表现。

## 目录

```text
StartupGuide
├─AppScope
│  ├─app.json5                          # bundleName、版本与应用级配置
│  └─resources/                         # 应用图标与全局资源
├─common                                # Common 层共享 HAR
│  └─src/main/ets/
│     ├─ability/                        # AbstractGuideAbility
│     ├─api/                            # 系统能力类型声明
│     ├─component/                      # 通用 UI 组件
│     ├─constant/                       # PageKey、CommonConstant
│     ├─context/                        # 公共上下文封装
│     ├─controller/                     # 页面与外部页面控制器基类
│     ├─event/                          # 页面间事件
│     ├─manager/                        # 场景、页面、媒体、窗口等管理器
│     ├─model/                          # 页面配置、服务声明、布局样式等公共模型
│     ├─storage/                        # KV 存储
│     ├─textparse/                      # 协议富文本解析
│     ├─timer/                          # 定时器抽象与实现
│     └─util/                           # Settings、资源、Want 等工具
├─feature                               # Feature 层独立 HAR
│  ├─basicservice/                      # 基础服务协议
│  ├─enhanceservice/                    # 增强服务协议
│  ├─experience/                        # 立即体验
│  ├─languageselect/                    # 语言与字号
│  ├─regionselect/                      # 国家 / 地区
│  └─welcome/                           # 欢迎页
├─product
│  └─phone/                             # 当前 entry HAP
│     ├─src/main/ets/                   # Ability、编排、组件与模型
│     ├─src/main/resources/             # 页面配置、协议配置和多语言资源
├─docs
│  └─figures/
│     ├─oobe_architecture.png            # StartupGuide 中文分层架构图
│     └─oobe_architecture_en.png         # StartupGuide 英文分层架构图
├─hvigor                                # Hvigor 配置
├─build.sh                              # 构建脚本
├─hvigorfile.ts                         # Hvigor 构建入口
├─README.md                             # 中文文档
└─README_en.md                          # 英文文档
```

其中，`common/src/main/ets/model/` 集中定义页面配置、服务声明、布局样式及通用数据结构，供 Product 层和各 Feature 模块复用。

## 约束

- **语言**：使用 ArkTS 语言。
- **设备类型**：手机、平板。

## 参与贡献

欢迎广大开发者贡献代码和文档，具体流程请参见 OpenHarmony [参与贡献](https://gitcode.com/openharmony/docs/blob/master/zh-cn/contribute/%E5%8F%82%E4%B8%8E%E8%B4%A1%E7%8C%AE.md)。

## 相关仓

- [window_scene_board](https://gitcode.com/openharmony/window_scene_board)（SceneBoard 启动与窗口场景协同）
- [applications_settings](https://gitcode.com/openharmony/applications_settings)（系统设置与相关外部页面）
