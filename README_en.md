# StartupGuide

## Introduction

**StartupGuide** (bundle name: `com.ohos.startupguide`) is the **OOBE (Out Of Box Experience) startup guide system application** in the OpenHarmony standard system. It guides users through initial setup during scenarios such as first boot, factory reset, and sub-user creation.

This application is pre-installed by the system and usually has no icon on the desktop. In SceneBoard mode, `SCBOobeManager` explicitly starts `com.ohos.startupguide.MainAbility` using the agreed bundleName; the implementation class of this Ability is `GuideHomeAbility`. After the guide is complete, StartupGuide writes the completion state and enters the system desktop. This repository currently provides the `product/phone` entry, and Pad can be extended with the same layered approach.

### Core Capabilities

**Guide Scene Recognition**
- `SceneTypeManager` identifies scenarios such as first boot and sub-user creation based on Settings state and user type.
- `PageOrderController` assembles a page-controller chain for each scenario and uniformly handles forward navigation, back navigation, jumps, and conditional skipping.

**Guide Features**
- Initial setup: welcome, language selection, and region selection.
- Agreements and services: basic services and enhanced services.
- Flow completion: the Experience Now page ends OOBE and hands control over to the system desktop.

**Agreement and Privacy Guidance**
- Basic services display the End User License Agreement and basic service terms, and save the user's consent state.
- Enhanced services determine which agreements to display from the OOBE configuration file, then locate agreement resources through metadata in the corresponding business application and read their contents. After the user selects or clears each item, the results are written to Settings.

**External Pages and System Collaboration**
- WLAN and other external system pages are integrated into the guide chain through `ExternalPageComponent` and `BaseExternalPageController`.
- SceneBoard explicitly starts the application and coordinates window policies during OOBE, while Settings / DataShare are used to read or write guide state.
- Supports conditional WLAN display after fast cloning, fullscreen windows, floating-window hiding, and system-bar control.

**Multilingual and Accessibility Support**
- The product module provides Chinese, English, and other locale resources.
- `RTLUtil`, `AccessibilityUtil`, and font-size adjustment components provide support for RTL layouts, assistive reading, and font-size changes.

> **Note**: This repository is positioned as the OOBE **application layer**. Complete businesses such as SceneBoard and system Settings are provided by their corresponding system components; the WLAN configuration page is actually hosted by the OOBE extension Ability in Settings. StartupGuide is responsible for recognizing scenarios, orchestrating steps, hosting guide interactions, and saving results.

### Supported Guide Pages

| Page / PageKey | Module | Scenario and Handling Summary |
| ---- | ---- | ---- |
| `WELCOME` | `feature/welcome` | Welcome page and enterprise-device-related handling |
| `LANGUAGE_SELECT` | `feature/languageselect` | Language selection and font-size adjustment |
| `REGION_SELECT` | `feature/regionselect` | Country / region selection and result persistence |
| `BASIC_SERVICE` | `feature/basicservice` | Basic service terms / End User License Agreement |
| `ENHANCED_SERVICE` | `feature/enhanceservice` | Configuration-driven optional enhanced service statements |
| `WLAN_KEY` | External controller in `product/phone` | Integrates the WLAN system page |
| `EXPERIENCE_NOW` | `feature/experience` | Completes the guide and enters the desktop |

## Architecture

StartupGuide uses a three-layer **Product - Feature - Common** modular architecture and collaborates with system components such as SceneBoard and Settings (including the WLAN OOBE extension page).

### Position in the System

StartupGuide resides in the application layer and is explicitly started by SceneBoard. During the guide, it uses system frameworks for UI, Ability, window, and data access, and integrates the WLAN page and reads or writes system settings as needed.

![StartupGuide Layered Architecture](./docs/figures/oobe_architecture_en.png)

The system applications on the right side of the figure are consistent with the preceding description:
- **SceneBoard**: Explicitly starts OOBE and coordinates window and scene policies during OOBE.
- **Settings (WLAN)**: Provides the WLAN OOBE extension page and hosts related system configuration.
- **Settings / DataShare**: Provides read and write access to guide states, agreement selections, and other data.

### Relationship Between StartupGuide and Other System Applications

StartupGuide collaborates with SceneBoard and Settings (including the WLAN OOBE extension page) shown on the right side of the system positioning diagram, but does not contain the complete business implementations of these components.

**The event and call relationships are as follows:**
1. When startup guidance is required, SceneBoard's `SCBOobeManager` explicitly starts `com.ohos.startupguide.MainAbility` using the bundleName `com.ohos.startupguide`; its `srcEntry` points to `GuideHomeAbility.ets`.
2. StartupGuide uses `SceneTypeManager` to identify the scenario, then `PageOrderController` assembles the corresponding page chain.
3. For the WLAN step, `WlanPageController` starts Settings' `OobeWifiSettingsExtensionAbility` through the external-page integration framework. After the external page finishes, it returns to the guide chain with a result such as NEXT / PRE.
4. Language, region, agreement consent, and OOBE completion states are read and written through system capabilities such as Settings / DataShare.
5. After the guide is complete, StartupGuide updates states such as `device_provisioned` and `user_setup_complete`, then hands control back to the system desktop.

> A typical first-boot flow:
> - SceneBoard starts `com.ohos.startupguide.MainAbility`;
> - `SceneTypeManager` determines that the scenario is `FIRST_BOOT_SCENE`;
> - `PageOrderController` assembles Welcome → Language → Region → Basic Service → Enhanced Service → WLAN → Experience Now;
> - After the user completes the final page, StartupGuide saves the completion state and enters the system desktop.

### Layered Design

The Product layer is responsible for system interaction entry points and device-form adaptation; the Feature layer hosts complete guide steps; the Common layer provides reusable cross-feature capabilities for pages, scenes, storage, and windows.


| Layer | Main Directory / Component | Description |
| ---- | ---- | ---- |
| Product layer | `product/phone` | Encapsulates `GuideHomeAbility`, page-chain assembly, external-page controllers, and product-form components; currently provides only the Phone entry, while Pad is an extensible product form |
| Feature layer | `feature/*` | Independent HARs for welcome, language, region, basic services, enhanced services, Experience Now, and other steps |
| Common layer | `common` | Page loading and lifecycle, scene recognition, external-page integration, data persistence, window control, events, and shared UI |

### Ability and UI Scenes

After the entry Ability initializes the scenario, it loads the unified page container. The page-controller chain determines whether the current view displays an internal Feature component or an external system page.

**Data Flow Overview:**

```text
SceneBoard (SCBOobeManager)
  → com.ohos.startupguide.MainAbility (GuideHomeAbility)
  → SceneTypeManager
  → PageOrderController
  → Feature PageController / ExternalPageController
  → Feature Component / WLAN External Page
  → ExperiencePageController
  → Persist State to Settings
  → System Desktop
```

**Main Scenario Page Chain:**

```text
First Boot / Sub-user:
Welcome → Language → Region → Basic Service → Enhanced Service → WLAN → Experience Now
```

> Whether a page is actually displayed is also affected by conditions such as `isNeedShow()`, page configuration, agreement version, network state, and fast-clone state.

### Components and External Dependencies

`phone_startupguide` is the entry HAP. Each Feature and Common module is a local HAR dependency of the entry module:

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

The cross-process collaboration boundaries are as follows:
- SceneBoard is responsible for startup and system-scene collaboration during OOBE.
- WLAN and other system applications provide specific business pages.
- Settings / DataShare provides system-level storage for guide states and user selections.
- BundleManager and ResourceManager are used to read business-application metadata and agreement resources.

### Module Description

| Module | Path | Description |
| ---- | ---- | ---- |
| AbilityStage | `product/phone/src/main/ets/Application/` | Application-level lifecycle entry |
| GuideHomeAbility | `product/phone/src/main/ets/ability/` | Main-window Ability that initializes page orchestration, media configuration, and layout configuration |
| Page orchestration | `product/phone/src/main/ets/controller/PageOrderController.ets` | Registers page controllers by scenario |
| External-page controllers | `product/phone/src/main/ets/controller/external/` | Display, return, and conditional control for WLAN and other external pages |
| Product components | `product/phone/src/main/ets/components/` | Product-form wrappers for Feature components |
| Pages and models | `product/phone/src/main/ets/pages/`, `product/phone/src/main/ets/model/` | Main page, restart prompt page, page switching, and style models |
| Common controllers | `common/src/main/ets/controller/` | Base classes for page controllers, page chains, and external-page controllers |
| Common managers | `common/src/main/ets/manager/` | Managers for scenes, media, windows, networks, page configuration, and more |
| Common storage | `common/src/main/ets/preferences/`, `common/src/main/ets/storage/` | Preferences and KV storage |
| Common components | `common/src/main/ets/component/` | Title bar, Footer, rich text, Lottie, cards, and other components |
| Basic services | `feature/basicservice/` | End User License Agreement and basic service terms |
| Enhanced services | `feature/enhanceservice/` | Agreement configuration, business-application metadata reading, and selection-state saving |
| Welcome / language / region / experience | `feature/welcome/`, `feature/languageselect/`, `feature/regionselect/`, `feature/experience/` | Controllers, Components, and Models for the corresponding guide steps |

## Build

This project is a multi-module HAP application project built with Hvigor. The entry module is `phone_startupguide`, and the Feature / Common modules are packaged into the entry HAP as HAR dependencies. The pipeline copies the signed artifact as `HwStartupGuide.hap`.

### Environment Requirements

- OpenHarmony SDK: `compileSdkVersion` 23, `compatibleSdkVersion` / `targetSdkVersion` 20
- DevEco Studio or the command-line Hvigor toolchain
- Node.js and OHPM
- System signing certificate and profile (`hw_sign/`)

### Build Commands

Run the following commands from the project root:

```bash
# Install dependencies
ohpm install

# Build the release HAP
hvigorw --mode module \
  -p module=phone_startupguide \
  -p debuggable=false \
  -p buildMode=release \
  assembleHap --parallel --incremental --no-daemon --stacktrace
```

Alternatively, use the pipeline script:

```bash
sh build.sh
```

### Build Artifacts

| Type | Artifact / Target | Description |
| ---- | ---- | ---- |
| Signed HAP | `product/phone/build/default/outputs/default/phone_startupguide-default-signed.hap` | Installable artifact with the default signature |
| Unsigned HAP | `product/phone/build/default/outputs/default/phone_startupguide-default-unsigned.hap` | Used for subsequent signing and not installed directly |
| Pipeline HAP | `product/phone/build/default/outputs/default/HwStartupGuide.hap` | Pre-installed system package generated by copying in `build.sh` |
| Test build target | `phone_startupguide@ohosTest` | ohosTest module target passed to Hvigor by `build.sh`; the actual filename is determined by the build output |
| HAR | Common and each Feature module | Packaged into the entry HAP as local dependencies and not deployed separately as system applications |

When integrated into the source tree as an OpenHarmony system component, the product build should pre-install the signed HAP into the system image as a non-removable system application.

## StartupGuide Development

StartupGuide is developed in **ArkTS**, with UI based on the ArkUI Stage model. The Product layer is responsible for the entry and page orchestration, the Feature layer hosts independent guide steps, and the Common layer provides cross-feature base capabilities. Development reference: [ArkUI Development Overview](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-ui-development-overview.md).

### Development Based on Existing Modules

Applicable scenarios: adjusting page order, removing guide steps, modifying agreement interactions, adjusting external-page integration, or customizing product-form UI.

**1. Identify the Layer to Change**
- Page order, Ability, and form adaptation: `product/phone`
- Business for an individual guide step: `feature/<module>`
- Page base classes, scenes, storage, and shared capabilities: `common`

**2. Adjust Page Order**

Page keys are located in `common/src/main/ets/constant/PageKey.ts`, and scenario page chains are located in `product/phone/src/main/ets/controller/PageOrderController.ets`:

```typescript
private initFirstBootSceneMap(): void {
  // Create the welcome-page controller and set the welcome page as the default first page
  let firstController: BasePageController =
    new WelcomePageController(this, PageKey.WELCOME);
  FirstDefaultPageManager.getInstance()
    .setDefaultFirstPage(PageKey.WELCOME, firstController);
  this.mControllerMap.set(PageKey.WELCOME, firstController);

  // Register the language and region selection pages
  this.mControllerMap.set(PageKey.LANGUAGE_SELECT,
    new LanguageSelectPageController(this));
  this.mControllerMap.set(PageKey.REGION_SELECT,
    new RegionSelectPageController(this));

  // Register the basic and enhanced service agreement pages
  this.mControllerMap.set(PageKey.BASIC_SERVICE,
    new BasicServicePageController(this));
  this.mControllerMap.set(PageKey.ENHANCED_SERVICE,
    new EnhanceServicePageController(this));

  // Register the external WLAN page provided by Settings
  this.mControllerMap.set(PageKey.WLAN_KEY,
    new WlanPageController(this));

  // Register the flow completion page
  this.mControllerMap.set(PageKey.EXPERIENCE_NOW,
    new ExperiencePageController(this));
}
```

When removing a page, also check forward and back navigation, configuration files, analytics, and test dependencies to avoid breaking the controller chain.

**3. Adjust External Page Display and Hiding**

External-page controllers inherit from `BaseExternalPageController`. Using WLAN as an example:

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

**4. Adjust Enhanced Service Agreements**

- Display-item configuration: `product/phone/src/main/resources/rawfile/enhance_service_statements.json`
- Agreement entity generation: `common/src/main/ets/util/ServiceEntityUtil.ets`
- Page controller: `feature/enhanceservice/src/main/ets/controller/EnhanceServicePageController.ets`
- State saving: `feature/enhanceservice/src/main/ets/util/EnhanceServiceUtil.ets`

#### Agreement Integration into OOBE Guide

##### Basic Agreements (Agreements and Statements)

Basic agreements that the user must agree to before using the device.

Add the corresponding basic service statement configuration to the `basic_service_statements.json` configuration file.

- Phone product path: `product/phone/src/main/resources/rawfile/basic_service_statements.json`
- For basic agreement pages, update the HTML files in the corresponding language directory under `product/phone/src/main/resources/rawfile/html/endUserSoftwareLicense/` to modify the update date, agreement content, and version number

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

##### Enhanced Agreements (Enhanced Services and User Experience Improvement)

Optional agreements that the user can select individually.

Add the corresponding enhanced service statement configuration to the `enhance_service_statements.json` configuration file.

- Phone product path: `product/phone/src/main/resources/rawfile/enhance_service_statements.json`
- Configure statement resources in the business-side code repository, including the agreement version number, title, agreement content, and parameters

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
| `serviceType` | Required. Agreement type: `"basic"` for basic agreements, `"enhance"` for enhanced agreements; other values are invalid | `"basic"` |
| `serviceName` | Required. The name value in the business-side metadata | `"test_enhance_statement"` |
| `moduleName` | Required. The module name to which the business-side metadata belongs | `"entry"` |
| `packageName` | Required. The business-side package name | `"com.example.teststartupguide"` |
| `validatorList` | Optional. Display control fields used to specify conditions for whether to show the item; supports SysParameter, SettingsData, and Custom methods | `["sysparameter=const.xxx.yyy=zzz"]` |
| `checkboxList` | Optional. Historical selection state, mainly used in OTA upgrade scenarios to determine previous check states. Must be a subset of `saveDataList` and can contain one field. With table name: `["settings=xxx, test_enhance_status"]`; without table name: `["settings=test_enhance_status"]` (stored in the global table by default, consistent with the underlying settings behavior) | `["settings=test_enhance_status"]` |
| `saveDataList` | Optional. Stores settings data; multiple fields can be configured. A stored value of 1 indicates selected, 0 indicates not selected. With table name: `["settings=xxx, test_enhance_status"]`; without table name: `["settings=test_enhance_status"]` (stored in the global table by default) | `["settings=test_enhance_status"]` |
| `defaultCheckStatus` | Optional. The default toggle state when the page is first entered; defaults to enabled (true). Set to false for default disabled | `false` |

**Business-Side Code Modifications**

**1. Configure Metadata Information**

Configure the metadata information corresponding to the startup guide in the business-side code (please supplement according to the actual framework).

**2. Configure the Service Statement Content JSON File**

```json
{
  "version": "1.0",
  "title": "$string:statement_test_title",
  "content": "$string:statement_test_content",
  "params": [
    {
      "name": "param1",
      "value": "My"
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
          "ability.want.params.uiExtensionType": "Your type",
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

Applicable scenarios: adding guide pages, extending agreement types, or integrating new external system pages.

**Step 1: Define the Page Key and Controller**
1. Add a unique page key to `PageKey.ts`.
2. Create a controller extending `BasePageController` in the corresponding `feature/<module>`.
3. Register the controller in the target scenario Map in `PageOrderController`.

**Step 2: Implement and Integrate the UI**
1. Implement reusable Components / Models in the Feature.
2. Add necessary product-form wrappers in `product/phone/src/main/ets/components/`.
3. If adding an independent entry page, register it in `product/phone/src/main/resources/base/profile/main_pages.json`; ordinary Feature Components do not need separate registration.

**Step 3: Integrate an External System Page**
1. Inherit from `BaseExternalPageController`.
2. Declare the target bundleName, abilityName, parameters, and return semantics in the page configuration.
3. Verify NEXT, PRE, SUBPAGE, CRASH, and other return paths.

**Step 4: Configure the Entry and Permissions**

The entry is already declared in `product/phone/src/main/module.json5`:

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

In SceneBoard mode, do not register `entity.system.home` / `action.system.home` for this application, or it may occupy the startup home slot. Before adding permissions, verify the calling scenario, `usedScene`, system pre-installation identity, and target system capability.

**Step 5: Test**
- Add tests for page controllers, components, and utility classes under `product/phone/src/ohosTest/`.
- Cover forward, back, skip, external-page exception, and other paths.
- Verify layout, rotation, folding state, language, and accessibility behavior on target Phone / Pad product forms.

## Directory

```text
StartupGuide
├─AppScope
│  ├─app.json5                          # bundleName, version, and application-level configuration
│  └─resources/                         # Application icon and global resources
├─common                                # Shared HAR for the Common layer
│  └─src/main/ets/
│     ├─ability/                        # AbstractGuideAbility
│     ├─api/                            # System capability type declarations
│     ├─component/                      # Shared UI components
│     ├─constant/                       # PageKey, CommonConstant
│     ├─context/                        # Common context wrappers
│     ├─controller/                     # Base classes for page and external-page controllers
│     ├─event/                          # Events between pages
│     ├─manager/                        # Managers for scenes, pages, media, windows, and more
│     ├─model/                          # Common models for page configuration, service statements, layout styles, and more
│     ├─preferences/                    # Preferences
│     ├─storage/                        # KV storage
│     ├─textparse/                      # Agreement rich-text parsing
│     ├─timer/                          # Timer abstractions and implementations
│     └─util/                           # Utilities for Settings, resources, Want, and more
├─feature                               # Independent HARs in the Feature layer
│  ├─basicservice/                      # Basic service agreements
│  ├─enhanceservice/                    # Enhanced service agreements
│  ├─experience/                        # Experience Now
│  ├─languageselect/                    # Language and font size
│  ├─regionselect/                      # Country / region
│  └─welcome/                           # Welcome page
├─product
│  └─phone/                             # Current entry HAP
│     ├─src/main/ets/                   # Ability, orchestration, components, and models
│     ├─src/main/resources/             # Page configuration, agreement configuration, and multilingual resources
│     └─src/ohosTest/                   # Hypium tests
├─docs
│  └─figures/
│     ├─oobe_architecture.png            # StartupGuide Chinese layered architecture diagram
│     └─oobe_architecture_en.png         # StartupGuide English layered architecture diagram
├─hvigor                                # Hvigor configuration
├─hw_sign                               # System signing materials and profile
├─build-profile.json5                   # SDK, product, signing, and module configuration
├─build.sh                              # Pipeline build script
├─hvigorfile.ts                         # Hvigor build entry
├─oh-package.json5                      # Project dependencies
├─OAT.xml                               # Open-source compliance audit
├─LICENSE
├─README.md                             # Chinese documentation
└─README_en.md                          # English documentation
```

The `common/src/main/ets/model/` directory centrally defines page configuration, service statements, layout styles, and shared data structures for reuse by the Product layer and each Feature module.

## Constraints

- **Language and UI**: Uses ArkTS and the ArkUI Stage model.
- **Runtime form**: A pre-installed, non-removable system application with the bundleName `com.ohos.startupguide`.
- **Startup method**: Explicitly started by `SCBOobeManager` in SceneBoard mode; do not register it as the system desktop.
- **Entry module**: This repository currently has only the `phone_startupguide` entry HAP, whose `deviceTypes` is `default`; Phone / Pad are product-form concepts, not two independent HAPs.
- **SDK**: `compileSdkVersion` 23, `compatibleSdkVersion` / `targetSdkVersion` 20; application `minAPIVersion` 11, `targetAPIVersion` 12.
- **Signing**: Installation and system pre-installation require a system signature and profile matching the product; after modifying the bundleName, update the signing profile and SceneBoard startup constants together.
- **Permissions**: This application depends on privileged system permissions; before removing or adding permissions, verify actual calls, `usedScene`, and pre-installation identity.
- **External applications**: This repository does not contain SceneBoard or system Settings source code; the WLAN step depends on `OobeWifiSettingsExtensionAbility` provided by Settings, and external-page availability depends on the target product configuration.
- **Agreement metadata**: packageName, moduleName, and serviceName in enhanced-service configuration must match business-application metadata, whose value must point to a valid `rawfile:*.json`.
- **Page orchestration**: When adding or removing pages, check `PageKey`, scenario Maps, page configuration, forward and back navigation, analytics, and tests together.
- **Scenario state**: Do not arbitrarily change the semantics of fields such as `device_provisioned` and `user_setup_complete`, or OOBE may be entered repeatedly or become inaccessible.
- **Multilingual support**: When adding text or agreement content, verify resources, RTL, font size, and accessibility together.
- **Device forms**: Breakpoints, windows, and media resources for Phone / Pad, portrait / landscape orientation, and folding states must be verified on the target product.
- **Build artifacts**: Install only signed HAPs; unsigned HAPs are used only for subsequent signing.

## Contributing

Code and documentation contributions are welcome. For details, see OpenHarmony [Contributing](https://gitcode.com/openharmony/docs/blob/master/zh-cn/contribute/%E5%8F%82%E4%B8%8E%E8%B4%A1%E7%8C%AE.md).

## Related Repositories

- [window_scene_board](https://gitcode.com/openharmony/window_scene_board) (SceneBoard startup and window-scene collaboration)
- [applications_settings](https://gitcode.com/openharmony/applications_settings) (system Settings and related external pages)
