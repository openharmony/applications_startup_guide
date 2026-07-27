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

import ArrayUtilTest from './common/utils/ArrayUtil.test';
import SharePreferencesTest from './common/preferences/SharePreferences.test';
import RawFileUtilTest from './common/utils/RawFileUtil.test';
import ResourceUtilTest from './common/utils/ResourceUtil.test';
import ServiceEntityUtilTest from './common/utils/ServiceEntityUtil.test';
import StringUtilTest from './common/utils/StringUtil.test';
import OobeFrameworkTest from './oobeframework/oobeframework.test';
import BoldParserTest from './common/textparse/parser/BoldParser.test';
import HtmlParserTest from './common/textparse/parser/HtmlParser.test';
import ParseStrategyTest from './common/textparse/strategy/ParseStrategy.test';
import StrategyChainTest from './common/textparse/strategy/StrategyChain.test';
import LinkParserTest from './common/textparse/parser/LinkTextParser.test';
import AbilityUtilTest from './common/utils/AbilityUtil.test';
import AccountUtilTest from './common/utils/AccountUtil.test';
import SaveDataFactoryTest from './feature/enhanceservice/factory/SaveDataFactory.test';
import SettingsSaveHandlerTest from './feature/enhanceservice/factory/SettingsSavaHandler.test';
import EnhanceServiceUtilTest from './feature/enhanceservice/util/EnhanceServiceUtil.test';
import ConfigParseUtilTest from './common/utils/ConfigParseUtil.test';
import ServiceEntryDataSourceTest from './feature/basicservice/component/ServiceEntryDataSource.test';
import BasicServiceUtilTest from './feature/basicservice/util/BasicServiceUtil.test';
import PageConfigManagerTest from './common/manager/PageConfigManager.test';
import AbilityManagerTest from './common/manager/AbilityManager.test';
import ShipModeManagerTest from './common/manager/ShipModeManager.test';
import WindowManagerTest from './common/manager/WindowManager.test';
import SeriviceEntityTest from './common/model/ServiceEntity.test';
import KvStoreTest from './common/storage/KvStore.test';
import OOBEUtilTest from './common/utils/OOBEUtil.test';
import SystemParameterUtilTest from './common/utils/SystemParameterUtil.test';
import CommonUtilsTest from './common/utils/CommonUtils.test';
import SettingUtilTest from './common/utils/SettingUtil.test';
import SubUserUtilTest from './common/utils/SubUserUtil.test';
import PageOrderControllerTest from './product/controller/PageOrderController.test';
import EnhanceServicePageControllerTest from './feature/enhanceservice/controller/EnhanceServicePageController.test';
import CommonComponentsTest from './common/CommonComponent/CommonComponents.test';
import CountryAndRegionTest from './feature/regionselect/model/CountryAndRegion.test';
import ServiceStatementUtilTest from './feature/otaservice/util/ServiceStatementUtil.test';
import RegionSelectUtilTest from './feature/regionselect/util/RegionSelectUtil.test';
import RegionDataSourceTest from './feature/regionselect/constant/RegionDataSource.test';
import RegionSelectPageControllerTest from './feature/regionselect/controller/RegionSelectPageController.test';
import LanguageAndRegionTest from './feature/regionselect/model/LanguageAndRegion.test';
import BasicServicePageControllerTest from './feature/basicservice/controller/BasicServicePageController.test';
import ValidatorUtilTest from './common/utils/ValidatorUtil.test';
import ServiceExtensionManagerUtilTest from './common/utils/ServiceExtensionManager.test';
import MeeTimeEnhanceUtilsTest from './common/utils/MeeTimeEnhanceUtils.test';
import HiSysEventUtilTest from './common/utils/HiSysEventUtil.test';
import HiViewXUtilTest from './common/utils/HiViewXUtil.test';
import PasswordUtilTest from './common/utils/PasswordUtil.test';
import ResourceStringUtilTest from './common/utils/ResourceStringUtil.test';
import RouterUtilTest from './common/utils/RouterUtil.test';
import WantUtilTest from './common/utils/WantUtil.test';
import BasePageControllerTest from './common/controller/BasePageController.test';
import BaseExternalPageControllerTest from './common/controller/BaseExternalPageController.test';
import BasePageOrderControllerTest from './common/controller/BasePageOrderController.test'
import BaseUtilTest from './common/utils/BaseUtil.test';
import EnhanceServiceListModelTest from './product/components/enhanceservice/EnhanceServiceListModel.test';
import RegionSelectListModelTest from './feature/regionselect/model/RegionSelectListModel.test';
import UpgradeGuideCompTest from './product/components/upgrade/UpgradeListComp.test';
import ServiceStatementCompTest from './product/components/otaservice/ServiceStatementComp.test';
import PageTest from './product/components/pages/Page.test';
import BasicDataSourceTest from './feature/basicservice/component/BasicDataSource.test';
import SafeUtilTest from './common/utils/SafeUtil.test';
import TextModelTest from './common/textparse/parser/TextModel.test';
import BasePreferencesTest from './common/preferences/BasePreferences.test';
import RegionBasicDataSourceTest from './feature/regionselect/constant/RegionBasicDatasource.test';
import BaseUtilsTest from './common/utils/BaseUtils.test';
import NumberUtilsTest from './common/utils/NumberUtils.test';
import WindowUtilsTest from './common/utils/WindowUtils.test';
import ColumnSystemManagerTest from './common/manager/ColumnSystemManager.test';
import LanguageAndRegionModelTest from './feature/languageselect/model/LanguageAndRegionModel.test';
import InternetManagerTest from './common/manager/InternetManager.test';
import FastCloneSceneManagerTest from './common/manager/FastCloneSceneManager.test';
import LanguageAndRegionManagerTest from './common/manager/LanguageAndRegionManager.test';
import WlanPageControllerTest from './product/controller/external/WlanPageController.test';
import SceneTypeManagerTest from './common/manager/SceneTypeManager.test';
import TimeOutUtilTest from './common/utils/TimeOutUtil.test';
import PageModelTest from './product/pages/PageModel.test';
import BgVideoPlayerManagerTest from './common/manager/BgVideoPlayerManager.test';
import ExperienceManagerTest from './common/manager/ExperienceMannager.test';
import EnterHomeComponentModelTest from './common/model/EnterHomeComponentModel.test';
import FirstDefaultPageManagerTest from './common/manager/FirstDefaultPageManager.test';
import MediaConfigManagerTest from './common/manager/MediaConfigManager.test';
import EnhanceServiceItemModelTest from './product/components/enhanceservice/EnhanceServiceItemModel.test';
import LanguageDataSourceTest from './feature/languageselect/constant/LanguageDataSource.test';
import DataShareUtilTest from './common/utils/DataShareUtilTest.test';
import EnterpriseDeviceManagerTest from './feature/welcome/manager/EnterpriseDeviceManager.test';
import { CommonEventTest } from './common/event/CommonEvent.test';
import StyleManagerTest from './common/manager/StyleManager.test';
import EventEmitterTest from './common/event/EventEmitterTest.test';
import HeadModelTest from './common/model/HeadModel.test';
import EventBusTest from './common/utils/EventBus.test';

export default function testsuite() {
  HeadModelTest();
  EventBusTest();
  ServiceStatementCompTest();
  UpgradeGuideCompTest();
  CommonComponentsTest();

  PageConfigManagerTest();
  AbilityManagerTest();
  ShipModeManagerTest();
  WindowManagerTest();
  InternetManagerTest();
  FastCloneSceneManagerTest();
  LanguageAndRegionManagerTest();
  FirstDefaultPageManagerTest();
  MediaConfigManagerTest();

  SeriviceEntityTest();

  SharePreferencesTest();
  BasePreferencesTest();

  BoldParserTest();
  HtmlParserTest();
  LinkParserTest();
  TextModelTest();
  ParseStrategyTest();
  StrategyChainTest();

  AccountUtilTest();
  ArrayUtilTest();
  BaseUtilTest()
  ConfigParseUtilTest();
  RawFileUtilTest();
  ResourceUtilTest();
  ServiceEntityUtilTest();
  StringUtilTest();
  OOBEUtilTest();
  SystemParameterUtilTest();
  CommonUtilsTest();
  SettingUtilTest();
  SubUserUtilTest();
  ValidatorUtilTest();
  MeeTimeEnhanceUtilsTest();
  HiSysEventUtilTest();
  HiViewXUtilTest();
  PasswordUtilTest();
  ResourceStringUtilTest();
  RouterUtilTest();
  WantUtilTest();
  SafeUtilTest();
  BaseUtilsTest();

  ServiceExtensionManagerUtilTest();

  BasePageControllerTest();
  BaseExternalPageControllerTest();
  BasePageOrderControllerTest();

  ServiceEntryDataSourceTest();
  BasicServiceUtilTest();

  SaveDataFactoryTest();
  SettingsSaveHandlerTest();
  EnhanceServiceUtilTest();
  EnhanceServicePageControllerTest();
  EnhanceServiceListModelTest();
  EnhanceServiceItemModelTest();

  CountryAndRegionTest();
  RegionSelectUtilTest();
  RegionDataSourceTest();
  RegionSelectPageControllerTest();
  LanguageAndRegionTest();
  RegionBasicDataSourceTest();

  ServiceStatementUtilTest();

  BasicDataSourceTest();

  EnterpriseDeviceManagerTest();
  // 特定需求
  OobeFrameworkTest();
  PageOrderControllerTest();
  RegionSelectListModelTest();
  PageTest();
  WindowUtilsTest();
  NumberUtilsTest();
  LanguageAndRegionModelTest();
  ColumnSystemManagerTest();
  WlanPageControllerTest();
  PageModelTest();
  KvStoreTest();
  RawFileUtilTest();
  SceneTypeManagerTest();
  TimeOutUtilTest();
  AbilityUtilTest();
  BasicServicePageControllerTest();
  BgVideoPlayerManagerTest();
  ExperienceManagerTest();
  EnterHomeComponentModelTest();
  LanguageDataSourceTest();
  ParseStrategyTest();
  DataShareUtilTest();
  CommonEventTest();
  StyleManagerTest();
  EventEmitterTest();
}