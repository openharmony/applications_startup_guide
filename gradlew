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
set -ex

echo "old NODE_HOME is ${NODE_HOME}"

compileTask="$1"

# NODE_HOME的环境变量多配置了一个bin目录, 在这里去除掉
[[ "${NODE_HOME}" =~ .*\bin$ ]] && NODE_HOME=${NODE_HOME%\bin*}
echo "new NODE_HOME is ${NODE_HOME}"
echo "HM_SDK_HOME is ${HM_SDK_HOME}"
echo "OHOS_SDK_HOME is ${OHOS_SDK_HOME}"
echo "OHOS_BASE_SDK_HOME is ${OHOS_BASE_SDK_HOME}"
node -v
npm -v

# 初始化相关路径
PROJECT_PATH="`pwd -P`"
COMMADNLINE_TOOL_DIR=${PROJECT_PATH}

# Setup npm
npm config set registry
npm config set registry=
npm config set @ohos:registry
npm config set strict-ssl false

cp -rf ${PROJECT_PATH}/common/src/main/ets/api/*
cp -rf ${PROJECT_PATH}/common/src/main/ets/openApi/*

function init_command_line_tool() {
  #命令行工具的版本号，跟当前使用的IDE版本号一致
  commandLineVersion=5.0.1.300
  cd $COMMADNLINE_TOOL_DIR
  wget --no-check-certificate -q "" -O ohcommandline-tools-linux.zip
  unzip -oq ohcommandline-tools-linux.zip
  rm -rf "ohcommandline-tools-linux-x64-${commandLineVersion}.zip"
  export PATH=$COMMADNLINE_TOOL_DIR/oh-command-line-tools/bin:$PATH
}

function init_hvigor() {
  #HOS_SDK_HOME代表SDK所在的路径的环境变量，如果执行机上不存在HOS_SDK_HOME环境变量，请修改成SDK存放的实际路径
  export DEVECO_SDK_HOME=$HOS_SDK_HOME
  #hvigor还需要通过npm下载pnpm，需要给npm设置内网仓库地址
  npm config set registry
  npm config set strict-ssl false
}

# 安装ohpm, 若镜像中已存在ohpm，则无需重新安装
function init_ohpm() {
   ohpm -v
   ohpm config set log_level debug
   ohpm config set registry
   ohpm config set registry
   ohpm config set
   ohpm config set strict_ssl false
}

# 进入package目录安装依赖
function ohpm_install
{
    cd $1
    ohpm -v
    ohpm install
}

# 环境适配
function build() {
    # 根据业务情况适配local.properties
    cd ${PROJECT_PATH}
    echo "sdk.dir=${HM_SDK_HOME}"  > ./local.properties
    echo "nodejs.dir=${NODE_HOME}" >> ./local.properties

    # 根据业务情况安装ohpm三方库依赖
    ohpm_install "$PROJECT_PATH"
    ohpm_install "$PROJECT_PATH/common"
    ohpm_install "$PROJECT_PATH/feature/quicksetup"
    ohpm_install "$PROJECT_PATH/feature/basicservice"
    ohpm_install "$PROJECT_PATH/feature/enhanceservice"
    ohpm_install "$PROJECT_PATH/feature/upgradeguide"
    ohpm_install "$PROJECT_PATH/feature/regionselect"
    ohpm_install "$PROJECT_PATH/feature/languageselect"
    ohpm_install "$PROJECT_PATH/feature/experience"
    ohpm_install "$PROJECT_PATH/feature/welcome"
    ohpm_install "$PROJECT_PATH/feature/otaservice"
    ohpm_install "$PROJECT_PATH/feature/subuserservice"
    ohpm_install "$PROJECT_PATH/feature/deviceactivation"
    ohpm_install "$PROJECT_PATH/feature/tipsinnerfilm"
    ohpm_install "$PROJECT_PATH/product/phone"
    ohpm_install "$PROJECT_PATH/product/pc"
    ohpm_install "$PROJECT_PATH/product/watch"
    cat ${HOME}/.npmrc | grep 'lockfile=false' || echo 'lockfile=false' >> ${HOME}/.npmrc

    # 获得签名jar文件
    cd $PROJECT_PATH/hw_sign
    chmod +x build.sh
    ./build.sh

    # 根据业务情况，采用对应的构建命令，可以参考IDE构建日志中的命令
    cd ${PROJECT_PATH}
       # 2份流水线构建xml传不一样的compile_task, gradlew里通过$1接收参数
       echo "compileTask=>$compileTask"
        if [ "$compileTask" == "gradlew_pc" ];then
          echo "-----------------pc task-----------------"
          # build hap (pc: entry module)
          hvigorw --mode module -p module=pc_hwstartupguide -p debuggable=false -p ohos-test-coverage=true -p buildMode=test assembleHap --parallel --incremental --no-daemon --stacktrace
          # build test hap (ohosTest)
          hvigorw --mode module -p module=pc_hwstartupguide@ohosTest -p debuggable=false -p ohos-test-coverage=true assembleHap packageTesting --no-daemon --stacktrace
        elif [ "$compileTask" == "gradlew_watch" ];then
          echo "----------------watch task----------------"
          # build hap (main: entry module)
          hvigorw --mode module -p module=watch_hwstartupguide -p debuggable=false -p ohos-test-coverage=true -p buildMode=test assembleHap --parallel --incremental --no-daemon --stacktrace
          # build test hap (ohosTest)
          hvigorw --mode module -p module=watch_hwstartupguide@ohosTest -p debuggable=false -p ohos-test-coverage=true assembleHap packageTesting --no-daemon --stacktrace
        elif [ "$compileTask" == "gradlew_tv" ];then
          echo "----------------tv task----------------"
          # build hap (main: entry module)
          hvigorw --mode module -p module=tv_hwstartupguide -p debuggable=false -p buildMode=test assembleHap --parallel --incremental --no-daemon --stacktrace
          hvigorw --mode module -p module=tv_hwstartupguide@ohosTest -p debuggable=false -p ohos-test-coverage=true assembleHap packageTesting --no-daemon --stacktrace
          # build test hap (ohosTest)
        else
          echo "----------------phone task----------------"
          # build hap (main: entry module)
          hvigorw --mode module -p module=phone_startupguide -p debuggable=false -p ohos-test-coverage=true -p buildMode=test assembleHap --parallel --incremental --no-daemon --stacktrace
          # build test hap (ohosTest)
          hvigorw --mode module -p module=phone_startupguide@ohosTest -p debuggable=false -p ohos-test-coverage=true assembleHap packageTesting --no-daemon --stacktrace
        fi
        hvigorw assembleHap --mode module -p product=default -p debuggable=false --no-daemon
        echo "-----------------handle DTPipeline.zip--------------------"
             has_package_dt_pipeline=0
             if [ -e "build/DTPipeline.zip" ];then
                 file_size=$(stat -c%s build/DTPipeline.zip)
                 if [ $file_size -gt 0 ]; then
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
}

function main {
  local startTime=$(date '+%s')
  init_command_line_tool
  init_hvigor
  init_ohpm
  build
  local endTime=$(date '+%s')
  local elapsedTime=$(expr $endTime - $startTime)
  echo "build success in ${elapsedTime}s..."
}

main
