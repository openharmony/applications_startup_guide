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

/**
 * 常量类
 *
 * @since 2022-11-21
 */
export class CommonConstant {
  /**
   * 开机向导的包名
   */
  public static HW_STARTUP_GUIDE_PKG_NAME: string = 'com.ohos.startupguide';

  /**
   * OOBE阶段通过RPC通信传递给OOBE的旧设备名称key值
   */
  public static OLD_DEVICE_NAME: string = 'oldDeviceName';

  /**
   * 开机向导主页面
   */
  public static HW_STARTUP_GUIDE_MAIN_ABILITY: string = 'com.ohos.startupguide.MainAbility';

  /**
   * 无效值
   */
  public static INVALID_VALUE: string = '-1';

  /**
   * 状态-开
   */
  public static STATUS_ON: string = '1';

  /**
   * 状态-关
   */
  public static STATUS_OFF: string = '0';

  /**
   * 用户设置完成
   */
  public static USER_SETUP_COMPLETE: string = 'user_setup_complete';

  /**
   * 用户初始化完成
   */
  public static USER_INITIALIZED: string = 'user_initialized';

  /**
   * 开机向导完成标记位
   */
  public static DEVICE_PROVISIONED: string = 'device_provisioned';

  /**
   * 版本后缀
   */
  public static VERSION_SUFFIX: string = '_version';

  /**
   * 状态后缀
   */
  public static STATUS_SUFFIX: string = '_status';

  /**
   * 服务启动失败
   */
  public static RUN_SERVIVCES_FAILED: string = 'run_service_failed';

  /**
   * 页面跳转异常
   */
  public static PAGE_REDIRECTION_EXCEPTION: string = 'page_redirection_exception';

  /**
   * 服务退出异常
   */
  public static SERVICE_EXITION_EXCEPTION: string = 'service_exition_exception';

  /**
   * 基础服务声明操作失败
   */
  public static BS_OPERATION_FAILED: string = 'BS_operation_failed';

  /**
   * 增强服务声明操作失败
   */
  public static ES_OPERATION_FAILED: string = 'ES_operation_failed';

  /**
   * 选择地区操作失败
   */
  public static REGION_SELECT_OPERATION_FAILED: string = 'region_select_operation_failed';

  /**
   * 状态-完成
   */
  public static STATUS_FINISHED: string = '1';

  /**
   * 状态-未完成
   */
  public static STATUS_NO_FINISHED: string = '0';

  /**
   * OTA场景标识符
   */
  public static SECURE_IS_OTA_FINISHED: string = 'is_ota_finished';

  /**
   * 用户设置完成状态
   */
  public static SECURE_USER_SETUP_COMPLETE: string = 'user_setup_complete';

  /**
   * 基础服务声明同意Key值(settings)
   */
  public static BASIC_STATEMENT_AGREED_KEY: string = 'basic_statement_agreed';

  /**
   * 同意基础服务声明公共事件
   */
  public static BASIC_STATEMENT_AGREE_TERMS_OF_USE: string = 'custom.event.OOBE.HWSTARTUPGUIDE.AGREE.TERMS.OF.USE';

  /**
   * 基础服务声明公共事件权限
   */
  public static HWSTARTUPGUIDE_ACCESS_PERMISSION: string = 'ohos.permission.ACCESS_STARTUPGUIDE';
  public static PUBLISH_SYSTEM_COMMON_EVENT_PERMISSION: string = 'ohos.permission.PUBLISH_SYSTEM_COMMON_EVENT';

  /**
   * oobe结束公共事件
   */
  public static HWSTARTUPGUIDE_FINISHED_EVENT: string = 'custom.event.OOBE.HWSTARTUPGUIDE.FINISHED';

  /**
   * 构造版本信息
   */
  public static SECURE_BUILD_VERSION_RELEASE: string = 'buildversionrelease';

  /**
   * 构造重要提醒版本信息
   */
  public static VERSION_FOR_TIPS: string = 'version_for_tips';

  /**
   * lottie动画宽高默认值
   */
  public static DEFAULT_CANVASWH: number = 200;

  /**
   * 系统版本号
   */
  public static DISPLAY_VERSION_PARAM: string = 'const.build.ver.physical';

  /**
   * 了解详情
   */
  public static LEARN_MORE_DETAILS: string = 'LEARN_MORE_DETAILS';

  /**
   * 栅格布局参数
   */
  public static GRID_NUM_FOUR: number = 4;

  /**
   * 动效参数
   */
  public static TRANSACTION_TIME: number = 600;

  /**
   * 动效参数
   */
  public static DELAY_TIME: number = 1000;

  /**
   * 延时
   */
  public static DELAY_DURATION_ZERO: number = 0 ;

  /**
   * 延时
   */
  public static DELAY_DURATION: number =5000 ;

  /**
   * BasicServiceList滚动条滚动到最后事件
   */
  public static EVENT_BASIC_SERVICE_LIST_SCROLL_END: string = 'event_basic_service_list_scroll_end';

  /**
   * 卡片滚动条滚动到最后事件
   */
  public static CARD_CONTENT_SCROLL_END_EVENT: string = 'card_content_scroll_end';

  /**
   * OOBE流程结束事件
   */
  public static EVENT_FINISH_OOBE: string = 'finish_oobe';

  /**
   * 版本
   */
  public static APP_VERSION: string = 'OpenHarmony';

  public static SHOW_EXIT_DIALOG = 'showExitDialog';

  /**
   * 打开弹窗时背板蒙层的zIndex层级
   */
  public static MASK_INDEX_NUMBER: number = 5;
  /**
   * 弹窗的关闭图标zIndex层级
   */
  public static CLOSE_ICON_INDEX_NUMBER: number = 99;

  /**
   * 双升单隐私空间迁移状态  1则表示未进行迁移
   */
  public static MIGRATE_PRIVACY_SPACE_STATUS: string = 'migrate_privacy_space_status';

  /**
   * 迁移状态开启
   */
  public static readonly MIGRATE_PRIVACY_SPACE_STATUS_ON: string = '1';

  /**
   * 迁移状态关闭
   */
  public static readonly MIGRATE_PRIVACY_SPACE_STATUS_OFF: string = '0';
  /**
   * 打点事件名称：返回上一页
   */
  public static readonly PRE_PAGE_BUTTON: string = 'PRE_PAGE_BUTTON';

  /**
   * 打点事件名称：结束OOBE
   */
  public static readonly FINISH_OOBE: string = 'FINISH_OOBE';

  /**
   * 打点事件名称：进入下一页
   */
  public static readonly NEXT_PAGE_BUTTON: string = 'NEXT_PAGE_BUTTON';

  /**
   * 打点事件名称：点击页面按钮
   */
  public static readonly CLICK_PAGE_BUTTON: string = 'CLICK_PAGE_BUTTON';


  /**
   * 打点事件名称：页面展示
   */
  public static readonly COMPONENT_APPEAR: string = 'component_appear';

  /**
   * 打点事件名称：页面消失
   */
  public static readonly COMPONENT_DISAPPEAR: string = 'component_disappear';

  /**
   * 打点事件名称：初始化语言列表
   */
  public static readonly INIT_LANGUAGE_LIST = 'init_language_list';

  /**
   * 打点事件名称：选择语言
   */
  public static readonly EVENT_SELECT_LANGUAGE = 'EVENT_SELECT_LANGUAGE';

  /**
   * 打点事件名称：语言修改生效
   */
  public static readonly EVENT_LANGUAGE_CHANGED = 'language_changed';

  /**
   * 打点事件名称：选择地区
   */
  public static readonly EVENT_REGION_SELECT = 'EVENT_SELECT_REGION';

  /**
   * 协议与声明支持的语言
   */
  public static readonly SUPPORT_LANGUAGES: string[] = ['zh-Hans', 'bo', 'en-Latn-US', 'ug', 'zh-Hant', 'zh_HK', 'zh_TW'];

  /**
   * 页面切换行为名称
   */
  public static readonly PAGE_ACTION: string = 'pageAction';

  /**
   * 给业务传入得双升单flag
   */
  public static readonly HMOS_2_NEXT_FLAG: string = 'persist.update.hmos_to_next_flag';

  /**
   * 给业务传入得双升单flag
   */
  public static readonly IS_HMOS_2_NEXT: string = '1';

  /**
   * 给业务传入得场景， 表示OTA还是开机向导
   */
  public static readonly SCENE_TYPE: string = 'sceneType';

  /**
   * 升级向导拉起时记录的版本号
   */
  public static readonly UPGRADE_PRE_FINGERPRINT: string = 'hw_upgrade_pre_fingerprint';

  /**
   * 空字符串
   */
  public static readonly EMPTY_STRING: string = '';

  /**
   * 迁移服务包名
   */
  public static readonly MIGRATE_CLIENT_BUNDLE_NAME: string = 'com.ohos.openharmony.migrateclient';

  /**
   * 字体大小级别 标准
   */
  public static readonly TEXT_FONT_SIZE_NORMAL: number = 1;

  /**
   * 字体大小级别 大
   */
  public static readonly TEXT_FONT_SIZE_LARGE: number = 1.15;

  /**
   * 字体大小级别 超大
   */
  public static readonly TEXT_FONT_SIZE_EXTRA_LARGE: number = 1.3;

  /**
   * 字体大小级别 特大
   */
  public static readonly TEXT_FONT_SIZE_HUGE: number = 1.45;

  /**
   * 默认字体大小当前位置
   */
  public static readonly DEFAULT_FONT_SIZE_STEP: number = 1;

  /**
   * 字体 标准 Step值
   */
  public static readonly TEXT_FONT_SIZE_NORMAL_STEP: number = 1;

  /**
   * 字体 大 Step值
   */
  public static readonly TEXT_FONT_SIZE_LARGE_STEP: number = 2;

  /**
   * 字体 超大 Step值
   */
  public static readonly TEXT_FONT_SIZE_EXTRA_LARGE_STEP: number = 3;

  /**
   * 字体 特大 Step值
   */
  public static readonly TEXT_FONT_SIZE_HUGE_STEP: number = 4;

  /**
   * 字体最大缩放级别
   */
  public static readonly MAX_FONT_SIZE_LEVEL: number = 4;

  /**
   * 字体最小缩放
   */
  public static readonly MIN_FONT_SIZE_LEVEL: number = 1;

  /**
   * 默认字体大小缩放倍数
   */
  public static readonly DEFAULT_FONT_SIZE_SCALE: string = '1';

  /**
   * 默认字体粗细倍数
   */
  public static readonly DEFAULT_FONT_WEIGHT_SCALE: string = '1';

  /**
   * 默认深色模式
   */
  public static readonly DEFAULT_ALLOW_DARK_MODE: string = '2';

  /**
   * 默认空值
   */
  public static readonly DEFAULT_ALLOW_MODE: string = '';

  /**
   * 用于备份深色模式数据
   */
  public static readonly DARK_MODE_BACKUP = 'dark_mode_backup';

  /**
   * 字体大小缩放 settingData key值
   */
  public static readonly SETTINGS_DATA_FONT_SIZE_SCALE: string = 'font_scale';

  /**
   * 字体粗细缩放 settingData key值
   */
  public static readonly SETTINGS_DATA_FONT_WEIGHT_SCALE: string = 'font_weight_scale';

  /**
   * 是否深色模式 settingData key值, 2：深色, 其他：浅色
   */
  public static readonly SETTINGS_DATA_UI_NIGHT_MODE: string = 'ui_night_mode';

  /**
   * 字体大小缩放备份值 settingData key值
   */
  public static readonly SETTINGS_DATA_BACKUP_FONT_SIZE_SCALE: string = 'font_scale_backup';

  /**
   * 字体粗细缩放备份值 settingData key值
   */
  public static readonly SETTINGS_DATA_BACKUP_FONT_WEIGHT_SCALE: string = 'font_weight_scale_backup';

  /**
   * 是否深色模式备份值 settingData key值
   */
  public static readonly SETTINGS_DATA_BACKUP_UI_NIGHT_MODE: string = 'ui_night_mode_backup';

  /**
   * 定时深色模式数据库字段darkmode settings.uiappearance.darkmode_mode
   */
  public static readonly SETTINGS_UIAPPEARANCE_DARKMODE_MODE: string = 'settings.uiappearance.darkmode_mode';

  /**
   * 用于备份darkmode settings.uiappearance.darkmode_mode中的值
   */
  public static readonly DARKMODE_MODE_BACKUP = 'darkmode_mode_backup';

  /**
   * 系统参数第一次通过此值判断双升单
   */
  public static readonly UPGRADE_GUIDE_FROM_DUAL: string = 'persist.update.upgrade_guide_from_dual';

  /**
   * 在数据库中保存双升单信息1为是双升单场景  0表示非
   */
  public static readonly UPGRADE_FROM_DUAL: string = 'upgrade_from_dual';

  /**
   * 双升单开
   */
  public static readonly UPGRADE_FROM_DUAL_ON: string = '1';

  /**
   * 双升单关
   */
  public static readonly UPGRADE_FROM_DUAL_OFF: string = '0';

  /**
   * 字体缩放调节数
   */
  public static readonly FONT_SIZE_STEP_NUM: number = 1;

  /**
   * get name by step Map
   */
  public static FONT_NAME_STEP_MAP: Map<number, Resource> = new Map([
    [CommonConstant.TEXT_FONT_SIZE_NORMAL_STEP, $r('app.string.display_mode_font_size_normal')],
    [CommonConstant.TEXT_FONT_SIZE_LARGE_STEP, $r('app.string.display_mode_font_size_large')],
    [CommonConstant.TEXT_FONT_SIZE_EXTRA_LARGE_STEP, $r('app.string.display_mode_font_size_extra_large')],
    [CommonConstant.TEXT_FONT_SIZE_HUGE_STEP, $r('app.string.display_mode_font_size_huge')],
  ]);

  /**
   * get name by scale Map
   */
  public static FONT_NAME_SCALE_MAP: Map<number, Resource> = new Map([
    [CommonConstant.TEXT_FONT_SIZE_NORMAL, $r('app.string.display_mode_font_size_normal')],
    [CommonConstant.TEXT_FONT_SIZE_LARGE, $r('app.string.display_mode_font_size_large')],
    [CommonConstant.TEXT_FONT_SIZE_EXTRA_LARGE, $r('app.string.display_mode_font_size_extra_large')],
    [CommonConstant.TEXT_FONT_SIZE_HUGE, $r('app.string.display_mode_font_size_huge')],
  ]);

  /**
   * get scale by step Map
   */
  public static FONT_SCALE_BY_STEP_MAP: Map<number, number> = new Map([
    [CommonConstant.TEXT_FONT_SIZE_NORMAL_STEP, CommonConstant.TEXT_FONT_SIZE_NORMAL],
    [CommonConstant.TEXT_FONT_SIZE_LARGE_STEP, CommonConstant.TEXT_FONT_SIZE_LARGE],
    [CommonConstant.TEXT_FONT_SIZE_EXTRA_LARGE_STEP, CommonConstant.TEXT_FONT_SIZE_EXTRA_LARGE],
    [CommonConstant.TEXT_FONT_SIZE_HUGE_STEP, CommonConstant.TEXT_FONT_SIZE_HUGE],
  ]);

  /**
   * get step by scale Map
   */
  public static FONT_STEP_BY_SCALE_MAP: Map<number, number> = new Map([
    [CommonConstant.TEXT_FONT_SIZE_NORMAL, CommonConstant.TEXT_FONT_SIZE_NORMAL_STEP],
    [CommonConstant.TEXT_FONT_SIZE_LARGE, CommonConstant.TEXT_FONT_SIZE_LARGE_STEP],
    [CommonConstant.TEXT_FONT_SIZE_EXTRA_LARGE, CommonConstant.TEXT_FONT_SIZE_EXTRA_LARGE_STEP],
    [CommonConstant.TEXT_FONT_SIZE_HUGE, CommonConstant.TEXT_FONT_SIZE_HUGE_STEP],
  ]);

  /**
   * 优先选择的地区
   */
  public static readonly PRIOR_REGIONS: string = 'prior_regions';

  /**
   * AT指令前缀
   */
  public static readonly COMMAND_AT: string = 'at';

  /**
   * AT指令读取最大buffer
   */
  public static readonly MAX_BUFFER_SIZE: number = 8192;

  /**
   * 读取电子标签指令
   */
  public static readonly GET_ELECTRONICTAG_COMMAND: string = 'AT^ELECTRONICTAG=get';

  /**
   * 增强服务同步写入超时时间
   */
  public static readonly ENHANCE_SERVICE_TIMEOUT: number = 5000;

  /**
   * FooterComponent组件Id
   */
  public static readonly FOOTER_COMPONENT_ID: string = 'footer_component_id';

  /**
   * 是否允许跳过强制联网
   */
  public static readonly IS_NETWORK_CONNECT_ALLOW_SKIP: string = 'is_network_connect_allow_skip';
}