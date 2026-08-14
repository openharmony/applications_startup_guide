# startup guide

## Introduction

**startup guide** (bundle name: `com.ohos.startup_guide`) is the **OOBE (Out Of Box Experience) startup guide system application** in the OpenHarmony standard system. It guides users through initial setup during first boot and factory reset.

This application is pre-installed by the system and does not show an icon on the desktop. When the device boots, the system first starts the SceneBoard (SCB) process—SceneBoard is the system-level desktop process in the window subsystem; it hosts the desktop, lock screen, wallpaper, and other system UI, and manages screens and windows. After startup, its `SCBOobeManager` checks OOBE flags to decide whether to launch the startup guide. If guidance is required, it explicitly starts `com.ohos.startup_guide.MainAbility` (implemented by `GuideHomeAbility`). After the guide is complete, startup guide writes the completion state and enters the system desktop. This repository currently provides phone and Pad entries.

### Core Capabilities

**Guide Scene Recognition**
- Query OOBE flags in the settingsData database to distinguish first boot from factory reset
- Preset scenario: after SceneBoard starts, it reads OOBE flags to decide whether to launch OOBE. If `device_provisioned` is 0 or does not exist, OOBE is launched for first boot or factory reset; after the flow finishes, `device_provisioned` is set to 1
- OTA scenario: if `is_ota_finished` is 0, factory-reset OOBE is entered; if it is not 0, the version is further checked using `buildversionrelease`. When an agreement has changed, the corresponding page is shown (basic service changes show Basic Service; enhanced service changes show Enhanced Service)

| Field | device_provisioned | is_ota_finished |
| ---- | ---- | ---- |
| Flag meaning | Whether the device has completed activation | Whether the scenario is OTA unfinished |
| Table in database | (device-level) SETTINGSDATA | (user-level) USER_SETTINGSDATA_SECURE_XXX |

**Welcome:** Display the boot welcome page and guide the user to start initial setup.

**Language Selection:** Let the user pick the language the system will use; after that, the following guide pages are shown in the same language.

**Country / Region Selection:** Allow the user to select a country or region and provide regional information for subsequent system services.

**Basic Service Terms:** Display the End User License Agreement and basic service terms, and save the user's consent state.

**Enhanced Service:** Display optional enhanced service agreements based on configuration, and save the user's selection results.

**Experience Now**
- Complete the OOBE guide, save the completion state, and enter the system desktop.

### Supported Guide Pages

| Page / PageKey                | Module | Scenario and Handling Summary |
|-----------------------------| ---- | ---- |
| `WELCOME`                   | `feature/welcome` | Welcome page and enterprise-device-related handling |
| `LANGUAGE_SELECT`           | `feature/languageselect` | Language selection |
| `REGION_SELECT`             | `feature/regionselect` | Country / region selection |
| `BASIC_SERVICE`             | `feature/basicservice` | Basic service terms / End User License Agreement |
| `ENHANCED_SERVICE`          | `feature/enhanceservice` | Enhanced service statements |
| `LOADING`                   | `feature/otaservice` | Loading page in the OTA scenario |
| `SERVICE_CHANGED_STATEMENT` | `feature/otaservice` | OTA agreement-change display (agreement capability) |
| `WLAN_KEY`                  | External controller in `product/phone` | Network connection page |
| `EXPERIENCE_NOW`            | `feature/experience` | Complete the guide and enter the desktop |

## Architecture

startup guide uses a three-layer **Product - Feature - Common** modular architecture and collaborates with system components such as SceneBoard and Settings (including the WLAN OOBE extension page).

### Position in the System

startup guide resides in the application layer and is explicitly started by SceneBoard. During the guide, it uses system frameworks for UI, Ability, window, and data access, and integrates the WLAN page and reads or writes system settings as needed.

![startup guide Layered Architecture](./docs/figures/oobe_architecture_en.png)

### Application-Layer Design

The overall design can be divided into the product layer, feature layer, and common layer:

| Layer | Main Directories / Components | Description |
| ---- | ---- |--------------------------------------------------------|
| Product | `product` | Supports phone and tablet form factors; hosts `GuideHomeAbility`, page-chain assembly, external page controllers, and product-form component wrappers |
| Feature | `feature/welcome`, `feature/languageselect`, `feature/regionselect`, `feature/basicservice`, `feature/enhanceservice`, `feature/experience`, `feature/otaservice` | Welcome, language selection, region selection, basic service, enhanced service, Experience Now, and OTA agreement capability |
| Common | `common` | Page loading, page lifecycle management, external page integration, scene recognition, Preferences-based data persistence, window control, and logging utilities |

**Feature Module Description:**

| Capability | Module | Description |
| ---- | ---- | ---- |
| Welcome | `WelcomePageController` (welcome) | Display the boot welcome page and guide the user to start initial setup |
| Language Selection | `LanguageSelectPageController` (languageselect) | Let the user pick the language the system will use; after that, the following guide pages are shown in the same language |
| Region Selection | `RegionSelectPageController` (regionselect) | Allow the user to select a country or region and provide regional information for subsequent system services |
| Basic Service | `BasicServicePageController` (basicservice) | Display the End User License Agreement and basic service terms, and save the user's consent state |
| Enhanced Service | `EnhanceServicePageController` (enhanceservice) | Display optional enhanced service agreements based on configuration, and save the user's selection results |
| Experience Now | `ExperiencePageController` (experience) | Complete the OOBE guide, save the completion state, and enter the system desktop |
| OTA Agreement | `LoadingPageController` and related (otaservice) | Agreement capability in the OTA scenario: loading page, agreement version comparison, and change display; necessary capabilities formerly under upgradeguide are merged here |

### Relationship with Other Applications

| Dimension | Description |
|-------------| ---- |
| Whether other applications can call it | Allowed. The entry Ability `com.ohos.startup_guide.MainAbility` (`GuideHomeAbility`) declares `exported=true` and is explicitly started by the system side |
| Who can call it | SceneBoard launches OOBE through `SCBOobeManager`; Settings provides the WLAN OOBE extension page `OobeWifiSettingsExtensionAbility`, which startup guide starts through the external page integration framework |
| When it can be called | During first boot, factory reset, and other scenarios that require startup guidance, SceneBoard launches it; the WLAN step is integrated when the guide page chain reaches network configuration |
| Supported Want parameters | SceneBoard explicitly starts `MainAbility` with the agreed bundleName `com.ohos.startup_guide`; the WLAN external page is integrated through bundleName / abilityName / UIExtension parameters in the page configuration |
| Cross-process services | Language, region, agreement consent, and OOBE completion states are read and written through Settings Data; the UI depends on ArkUI; Ability lifecycle and extension capabilities depend on AbilityKit; after the guide completes, `device_provisioned` is updated and control is returned to the system desktop |

## Build

This project is a single-HAP multi-module application project built with Hvigor. The entry module is `phone_startupguide`.

### Environment Requirements

- OpenHarmony SDK: compileSdkVersion 26.0.0, compatibleSdkVersion 23, targetSdkVersion 23
- DevEco Studio or the command-line Hvigor toolchain
- Node.js and OHPM

### Build Commands

Run the following command in the project root directory:

```bash
sh build.sh
```

### Build Artifacts

| Type | Artifact / Target | Description |
| ---- | ---- | ---- |
| Signed HAP | `product/phone/build/default/outputs/default/phone_startupguide-default-signed.hap` | Installable default signed artifact |

## startup guide Development

startup guide is developed with **ArkTS**. The product layer is responsible for entry and page orchestration, the Feature layer hosts independent features, and the Common layer provides cross-feature basic capabilities.

### Development Based on Existing Modules

Applicable scenarios: trimming guide steps, modifying agreement interactions, adjusting external page integration, or customizing product-form UI.

**1. Confirm the change layer**
- Ability and form-factor adaptation: `product/phone`
- Business of a single guide step: `feature/<module>`
- Page base classes, scenes, storage, and common capabilities: `common`

**2. Adjust external page show and hide**

External page controllers inherit `BaseExternalPageController`. Taking WLAN as an example:

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

**3. Adjust enhanced service agreements**

- Display item configuration: `product/phone/src/main/resources/rawfile/enhance_service_statements.json`
- Agreement entity generation: `common/src/main/ets/util/ServiceEntityUtil.ets`
- Page controller: `feature/enhanceservice/src/main/ets/controller/EnhanceServicePageController.ets`
- State saving: `feature/enhanceservice/src/main/ets/util/EnhanceServiceUtil.ets`

#### Guidance for Integrating Agreements into OOBE

#### Basic Agreements (Agreements and Statements)

Basic agreements that the user must accept before using the phone.

Add the corresponding basic service statement configuration to the `basic_service_statements.json` configuration file.

- Phone product path: `product/phone/src/main/resources/rawfile/basic_service_statements.json`
- For the basic agreement page, update the HTML files under the corresponding language directories in `product/phone/src/main/resources/rawfile/html/endUserSoftwareLicense/`, including the update date, agreement content, and version number

**Configuration Example (Basic Agreement)**

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

#### Enhanced Agreements (Enhanced Services and User Experience Improvement)

Optional agreements that support item-by-item selection.

Add the corresponding enhanced service statement configuration to the `enhance_service_statements.json` configuration file.

- Phone product path: `product/phone/src/main/resources/rawfile/enhance_service_statements.json`
- Configure statement resources in the business repository, including the agreement version number, title, content, and parameters

**Configuration Example (Enhanced Agreement)**

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

**Configuration Parameter Description**

| Parameter | Description | Example |
| ---- | ---- | ---- |
| `serviceType` | Required. Agreement type. `"basic"` means basic agreement, `"enhance"` means enhanced agreement; other values are invalid | `"basic"` |
| `serviceName` | Required. The `name` value in the business-side metadata | `"test_enhance_statement"` |
| `moduleName` | Required. The module name that owns the business-side metadata | `"entry"` |
| `packageName` | Required. The business-side package name | `"com.example.teststartupguide"` |
| `validatorList` | Optional. Display-control fields used to decide whether to show the item. Supports SysParameter, SettingsData, and Custom | `["sysparameter=const.xxx.yyy=zzz"]` |
| `checkboxList` | Optional. Historical selection state, mainly used in OTA upgrade scenarios to determine previous check states. This field must be a subset of `saveDataList` and can configure one field. Example with table name: `["settings=xxx, test_enhance_status"]`; example without table name: `["settings=test_enhance_status"]` (stored in the global table by default, consistent with underlying settings behavior) | `["settings=test_enhance_status"]` |
| `saveDataList` | Optional. Settings data to store; multiple fields can be configured. A stored value of 1 means selected, and 0 means not selected. Example with table name: `["settings=xxx, test_enhance_status"]`; example without table name: `["settings=test_enhance_status"]` (stored in the global table by default) | `["settings=test_enhance_status"]` |
| `defaultCheckStatus` | Optional. Default switch state when the page is entered for the first time. The default is on (`true`); configure `false` if it should be off by default | `false` |

**Business-Side Code Changes**

**1. Configure metadata**

Configure metadata corresponding to the startup guide on the business side. The following is a sample (complete it according to the actual framework).

**2. Configure the service statement content JSON file**

```json
{
  "version": "1.0",
  "title": "$string:statement_test_title",
  "content": "$string:statement_test_content",
  "params": [
    {
      "name": "param1",
      "value": "Mine"
    },
    {
      "name": "param2",
      "value": "$string:param_value_2"
    }
  ],
  "abilities": [
    {
      "key": "Test",
      "value": {
        "bundleName": "com.example.teststartupguide",
        "abilityName": "EntryAbility",
        "parameters": {
          "ability.want.params.uiExtensionType": "YourType",
          "msg": "Test"
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

**Common Modification Entry Points:**

| Target | Path |
| ---- | ---- |
| Scene recognition | `common/src/main/ets/manager/SceneTypeManager.ets` |
| Page keys | `common/src/main/ets/constant/PageKey.ts` |
| Page orchestration | `product/phone/src/main/ets/controller/PageOrderController.ets` |
| External pages | `product/phone/src/main/ets/controller/external/` |
| Product components | `product/phone/src/main/ets/components/` |
| Page configuration | `product/phone/src/main/resources/rawfile/page_configs.json` |
| Agreement configuration | `product/phone/src/main/resources/rawfile/*service_statements.json` |
| Main entry | `product/phone/src/main/ets/ability/GuideHomeAbility.ets` |

### Developing New Features or Guide Steps

Applicable scenarios: adding a guide page, extending agreement types, or integrating a new external system page.

**Step 1: Define the page key and controller**
1. Add a unique page key in `PageKey.ts`.
2. Create a controller that inherits `BasePageController` in the corresponding `feature/<module>`.
3. Register the controller in the target scenario Map of `PageOrderController`.

**Step 2: Implement and integrate the UI**
1. Implement reusable Components / Models in the Feature module.
2. Add necessary product-form wrappers under `product/phone/src/main/ets/components/`.

**Step 3: Integrate an external system page**
1. Inherit `BaseExternalPageController`.
2. Declare the target bundleName, abilityName, parameters, and return semantics in the page configuration.
3. Verify return paths such as NEXT, PRE, SUBPAGE, and CRASH.
4. Implement corresponding methods, such as `isNeedShow()` to control page visibility and navigation to the next page.

**Step 4: Configure the entry and permissions**

The entry is already declared in `product/phone/src/main/module.json5`:

```json
{
  "module": {
    "name": "phone_startupguide",
    "type": "entry",
    "srcEntrance": "./ets/Application/AbilityStage.ets",
    "mainElement": "com.ohos.startup_guide.MainAbility",
    "deviceTypes": ["default"]
  }
}
```

**Step 5: Testing**
- Add tests for page controllers, components, and utility classes under `product/phone/src/ohosTest/`.
- Cover forward, back, skip, and external-page exception paths.
- Verify layout, rotation, and language behavior on the target Phone / Pad product forms.

## Directory

```text
startup guide
├─AppScope
│  ├─app.json5                          # bundleName, version, and app-level configuration
│  └─resources/                         # Application icons and global resources
├─common                                # Shared HAR for the Common layer
│  └─src/main/ets/
│     ├─ability/                        # AbstractGuideAbility
│     ├─component/                      # Common UI components
│     ├─constant/                       # PageKey, CommonConstant
│     ├─context/                        # Common context wrappers
│     ├─controller/                     # Base classes for page and external page controllers
│     ├─event/                          # Inter-page events
│     ├─manager/                        # Scene, page, media, window, and other managers
│     ├─model/                          # Common models for page configs, service statements, layout styles, etc.
│     ├─preferences/                    # Preferences wrappers (agreement selection, scene flags, and other local persistence)
│     ├─storage/                        # KV storage
│     ├─textparse/                      # Rich-text parsing for agreements
│     ├─timer/                          # Timer abstractions and implementations
│     └─util/                           # Utilities for Settings, resources, Want, etc.
├─feature                               # Independent HARs for the Feature layer
│  ├─basicservice/                      # Basic service agreements
│  ├─enhanceservice/                    # Enhanced service agreements
│  ├─experience/                        # Experience Now
│  ├─languageselect/                    # Language and font size
│  ├─otaservice/                        # OTA agreement capability (loading page, agreement change, etc.)
│  ├─regionselect/                      # Country / region
│  └─welcome/                           # Welcome page
├─product
│  └─phone/                             # Current entry HAP
│     ├─src/main/ets/                   # Ability, orchestration, components, and models
│     ├─src/main/resources/             # Page configs, agreement configs, and multilingual resources
├─docs
│  └─figures/
│     ├─oobe_architecture.png            # startup guide Chinese layered architecture diagram
│     └─oobe_architecture_en.png         # startup guide English layered architecture diagram
├─hvigor                                # Hvigor configuration
├─build.sh                              # Build script
├─hvigorfile.ts                         # Hvigor build entry
├─README.md                             # Chinese documentation
└─README_en.md                          # English documentation
```

Among them, `common/src/main/ets/model/` centrally defines page configurations, service statements, layout styles, and common data structures for reuse by the Product layer and Feature modules.

## Constraints

- **Language**: Use ArkTS.
- **Device types**: Phone and tablet.

## Contributing

You are welcome to contribute code and documentation. For the detailed process, see OpenHarmony [Contributing](https://gitcode.com/openharmony/docs/blob/master/en/contribute/contribution.md).

## Related Repositories

- [window_scene_board](https://gitcode.com/openharmony/window_scene_board) (SceneBoard startup and window-scene collaboration)
- [applications_settings](https://gitcode.com/openharmony/applications_settings) (system settings and related external pages)
