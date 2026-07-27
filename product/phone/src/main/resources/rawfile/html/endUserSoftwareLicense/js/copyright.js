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

window.focus();

function getQueryVariable(variable) {
  let query = window.location.search.substring(1);
  let vars = query.split('&');
  for (let i = 0; i < vars.length; i++) {
    let pair = vars[i].split('=');
    if (pair[0] === variable) {
      return pair[1];
    }
  }
  return null;
}

function appendThemeClass(clsName, key) {
  let nodes = document.getElementsByClassName(clsName);
  if (nodes && nodes.length !== 0) {
    [].forEach.call(nodes, function (element) {
      element.className += ' ' + clsName + '-' + key;
    });
  }
}

function initThemeClass(backgroundMode) {
  let clsNames = ['title', 'caption', 'firstTitle', 'secondTitle', 'thirdTitleMain', 'thirdTitleSub',
    'firstContent', 'secondContent', 'thirdContent', 'contentText', 'list'];
  let key = 'light-text';
  let linkClass = ' link link-light-text';
  let bgClass = ' light_bg_color';
  let logoClass = 'logo_light';
  let logoInClass = 'logoIn_light';
  let logoOutClass = 'logoOut_light';
  let moreBtnClass = ' textBtnLight';
  let stopBtnClass = ' normalBtnLight';
  let tdClass = ' light';
  if (backgroundMode === 'black') {
    key = 'dark-text';
    linkClass = ' link link-dark-text';
    bgClass = ' dark_bg_color';
    logoClass = 'logo_dark';
    logoInClass = 'logoIn_dark';
    logoOutClass = 'logoOut_dark';
    moreBtnClass = ' textBtnDark';
    stopBtnClass = ' normalBtnDark';
    tdClass = ' dark';
  } else if (backgroundMode === 'gray') {
    bgClass = ' light_sub_bg_color';
  }
  clsNames.forEach(function (clsName) {
    appendThemeClass(clsName, key);
  });
  let aNodes = document.getElementsByTagName('a');
  if (aNodes && aNodes.length !== 0) {
    [].forEach.call(aNodes, function (element) {
      element.className += linkClass;
    });
  }
  let tdNodes = document.getElementsByTagName('td');
  if (tdNodes && tdNodes.length !== 0) {
    [].forEach.call(tdNodes, function (element) {
      element.className += tdClass;
    });
  }
  document.getElementsByTagName('body')[0].className += bgClass;
  document.getElementsByTagName('html')[0].className += bgClass;
  let nodes = document.getElementsByClassName('fixedBottom');
  if (nodes && nodes.length !== 0) {
    [].forEach.call(nodes, function (element) {
      element.className += bgClass;
    });
  }
  let logo = document.getElementById('default_logo');
  if (logo) {
    logo.classList.add(logoClass);
  }
  let logoIn = document.getElementById('logo_in');
  if (logoIn) {
    logoIn.classList.add(logoInClass);
  }
  let logoOut = document.getElementById('logo_out');
  if (logoOut) {
    logoOut.classList.add(logoOutClass);
  }
  let moreBtn = document.getElementById('moreBtn');
  if (moreBtn) {
    moreBtn.className += moreBtnClass;
  }
  let stopBtn = document.getElementById('stopBtn');
  if (stopBtn) {
    stopBtn.className += stopBtnClass;
  }
}

function getBackgroundMode() {
  let backgroundMode = 'white';
  let bgModeQS = getQueryVariable('bgmode') || getQueryVariable('themeName');
  if (bgModeQS) {
    switch (bgModeQS) {
      case 'light':
        backgroundMode = 'white';
        break;
      case 'white':
        backgroundMode = 'white';
        break;
      case 'dark':
        backgroundMode = 'black';
        break;
      case 'black':
        backgroundMode = 'black';
        break;
      case 'gray':
        backgroundMode = 'gray';
        break;
      default:
        backgroundMode = 'black';
        break;
    }
  }
  if (backgroundMode.startsWith('$')) {
    backgroundMode = 'white';
  }
  if (window.agrattr && window.agrattr.getBackgroundMode) {
    backgroundMode = window.agrattr.getBackgroundMode();
  }
  return backgroundMode;
}

function dealWithHarmonyFont(targets) {
  console.log('dealWithHarmonyFont');
  targets.forEach(function (target) {
    let ns = document.querySelectorAll(target);
    [].forEach.call(ns, function (element) {
      element.classList.add('medium');
    });
  });
}

function dealWithNoHarmonyFont(targets) {
  console.log('dealWithNoHarmonyFont');
  let nodes = document.getElementsByClassName('medium');
  [].forEach.call(nodes, function (element) {
    element.style.fontWeight = 'bold';
  });
  targets.forEach(function (target) {
    let ns = document.querySelectorAll(target);
    [].forEach.call(ns, function (element) {
      element.style.fontWeight = 'bold';
    });
  });
}

function setTransparent() {
  let transparent = getQueryVariable('trsp');
  let transparentColor = '#00000000';
  if (transparent === 'true') {
    let body = document.getElementsByTagName('body')[0];
    body.style.backgroundColor = transparentColor;
    body.style.backgroundImage = 'none';
    document.getElementsByTagName('html')[0].style.backgroundColor = transparentColor;
    let nodes = document.getElementsByClassName('fixedBottom');
    if (nodes && nodes.length !== 0) {
      [].forEach.call(nodes, function (element) {
        element.style.backgroundColor = transparentColor;
      });
    }
  }
}

document.body.style.opacity = 1;
if (window.localStorage && window.localStorage.getItem) {
  if (window.localStorage.getItem('paramsInfo')) {
    let paramsJson = JSON.parse(window.localStorage.getItem('paramsInfo'));
    if (paramsJson && paramsJson.serviceName && paramsJson.serviceName === 'id') {
      document.body.style.boxSizing = 'border-box';
    }
  }
}

window.onload = function () {
  let backgroundMode = getBackgroundMode();
  initThemeClass(backgroundMode);
};
