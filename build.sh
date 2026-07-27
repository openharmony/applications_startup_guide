#!/bin/bash
#
# Copyright (c) Huawei Device Co., Ltd. 2026. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Need to edit this file name.
set -e
compileTask="$1"

# 初始化相关路径
PROJECT_PATH=$(pwd -P)
SDK_DIR_NAME=$(ls $HM_SDK_HOME|head -1)

# 进入 package 目录安装依赖
ohpm_install()
{
  cd $1
  ohpm -v
  ohpm install
}

# npm配置
npmrc_init()
{
 touch ~/.npmrc
 npm config set strict-ssl false
 npm config set registry
 npm config set @ohos:registry
 npm config set package-lock false
}

# add .npmrc file
if [ -f ~/.npmrc ]; then
 echo ".npmrc file is exist"
else
 npmrc_init
fi

# 编译
build()
{
 echo "build start"

 # 根据业务情况安装 ohpm 三方库依赖
 ohpm_install "$PROJECT_PATH"

# 获得签名jar文件
    cd ./hw_sign
    echo "----------------phone task----------------"
    chmod +x build.sh
    ./build.sh

    # 根据业务情况，采用对应的构建命令，可以参考IDE构建日志中的命令
    cd ${PROJECT_PATH}
    # 2份流水线构建xml传不一样的compile_task, gradlew里通过$1接收参数
    echo "compileTask=>$compileTask"
    echo "----------------phone task----------------"
    # build hap (main: entry module)
    hvigorw --mode module -p module=phone_startupguide -p debuggable=false -p buildMode=release assembleHap --parallel --incremental --no-daemon --stacktrace
    hvigorw --mode module -p module=phone_startupguide@ohosTest -p debuggable=false -p ohos-test-coverage=true assembleHap packageTesting --no-daemon --stacktrace
    # build test hap (ohosTest)

    echo "----------------phone task----------------"
    hvigorw assembleHap --mode module -p product=default -p debuggable=false --no-daemon
    cp product/phone/build/default/outputs/default/phone_startupguide-default-signed.hap product/phone/build/default/outputs/default/HwStartupGuide.hap

    # 在build/outputs/xxx/目录下创建source/模块名的目录,解决DT覆盖率资源找不到问题
    mkdir -p build/outputs/oobe/source/product/phone
    mkdir -p build/outputs/oobe/source/common
    mkdir -p build/outputs/oobe/source/feature/basicservice
    mkdir -p build/outputs/oobe/source/feature/enhanceservice
    mkdir -p build/outputs/oobe/source/feature/experience
    mkdir -p build/outputs/oobe/source/feature/languageselect
    mkdir -p build/outputs/oobe/source/feature/otaservice
    mkdir -p build/outputs/oobe/source/feature/regionselect
    mkdir -p build/outputs/oobe/source/feature/upgradeguide
    mkdir -p build/outputs/oobe/source/feature/welcome
    # cp -r 模块名目录/src build/outputs/xxx/source/模块名的目录
    cp -r product/phone/src build/outputs/oobe/source/product/phone
    cp -r common/src build/outputs/oobe/source/common
    cp -r feature/basicservice/src build/outputs/oobe/source/feature/basicservice
    cp -r feature/enhanceservice/src build/outputs/oobe/source/feature/enhanceservice
    cp -r feature/experience/src build/outputs/oobe/source/feature/experience
    cp -r feature/languageselect/src build/outputs/oobe/source/feature/languageselect
    cp -r feature/otaservice/src build/outputs/oobe/source/feature/otaservice
    cp -r feature/regionselect/src build/outputs/oobe/source/feature/regionselect
    cp -r feature/upgradeguide/src build/outputs/oobe/source/feature/upgradeguide
    cp -r feature/welcome/src build/outputs/oobe/source/feature/welcome

    echo "-----------------handle DTPipeline.zip--------------------"
    has_package_dt_pipeline=0
    if [ -e "build/DTPipeline.zip" ];then
        file_size=$(stat -c%s build/DTPipeline.zip)
        if [ $file_size -gt 0 ]; then
            has_package_dt_pipeline=1
            rm -rf build/DTPipeline.zip
            echo "DTPipeline.zip is normal"
        else
            has_package_dt_pipeline=1
            rm -rf build/DTPipeline.zip
            echo "DTPipeline.zip size is 0"
        fi
    else
        has_package_dt_pipeline=1
        echo "build/DTPipeline.zip is not exist"
    fi
    if [ $has_package_dt_pipeline -eq 1 ];then
        pushd build/outputs
        if [ $? -ne 0 ];then
            echo "build/outputs is not exist"
            exit 1
        fi
        zip -r ../DTPipeline.zip ./*
        popd
    fi

  cd ${PROJECT_PATH}
  echo "build end"
  echo "######### Finished to build, resultCode: $?"
}

# 主函数
main() {
 local start_time=$(date '+%s')

 # 进入编译
 build

 local end_time=$(date '+%s')
 local elapsed_time=$(expr $end_time - $start_time)
 echo "build success in ${elapsed_time}s..."
}

# 开始
main