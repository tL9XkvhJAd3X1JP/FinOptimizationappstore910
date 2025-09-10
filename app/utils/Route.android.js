import React from "react";
import { NativeModules, DeviceEventEmitter, ToastAndroid } from "react-native";
import Global from "../Global";
//use : navigateTo("xx","xx")
navigateTo = (
  moduleView,
  json = null,
  className = null,
  animate = null,
  androidClassName = null
) => {
  if (androidClassName != null) {
    NativeModules.AndroidUtils.startActivity(androidClassName, json);
  } else {
    NativeModules.AndroidUtils.startReactActivity(moduleView, json);
  }
};

//事件传递，事件触发，回调，参数传递，广播
var eventMap = new Map(); //做事件记录
postEventAction = (key, json = null) => {
  DeviceEventEmitter.emit(key, json);
};

//注册事件监听
registEventAction = (key, callBack) => {
  if (key != null && callBack != null) {
    var event = DeviceEventEmitter.addListener(key, callBack);
    eventMap.set(key, event); //移除的时候用
  }
};
//删除事件监听
removeEventAction = key => {
  if (key != null) {
    var event = eventMap.get(key);
    if (event != null) {
      event.remove();
      eventMap.delete(key);
    }
  }
};
//删除所有的事件
removeAllEventAction = () => {
  var keys = eventMap.keys();
  for (let key of keys) {
    removeEventAction(key);
  }
};
//吐丝框
showToastMessage = message => {
  if (message) {
    ToastAndroid.show(message, ToastAndroid.SHORT);
  }
};

//关闭当前界面
popCurrentView = () => {
  NativeModules.AndroidUtils.finishActivity();
};

//获取本地地址 global.versionAndUrlModel
getVersionAndUrlModel = callBack => {
  NativeModules.AndroidUtils.getUrl(callBack);
};

//调第三方地图
goToPlaceWithMap = (mapType, latiude, longitude, place) => {
  NativeModules.AndroidUtils.goToPlaceWith(
    mapType,
    latiude + "",
    longitude + "",
    place
  );
};
//行政区边界数据检索
searchPlace = (cityName, okCallBack, errorCallBack) => {
  NativeModules.AndroidUtils.getAreaEdgePoints(
    cityName,
    okCallBack,
    errorCallBack
  );
};
//保存当前登录状态
saveLoginState = loginState => {
  NativeModules.AndroidUtils.saveLoginState(loginState);
};

//获取app版本号
getVersionName = () => {
  return Global.androidVersionName;
};
getVersionCode = () => {
  return Global.androidVersionCode;
};
//升级
updateAppWithUrl = updateUrl => {
  NativeModules.AndroidUtils.updateAppWithUrl(updateUrl);
};
//获取手机唯一标识
getPhoneImei = callBack => {
  return NativeModules.AndroidUtils.getPhoneImei(callBack);
};
//传递token给本地
setRequestToken = token => {
  NativeModules.AndroidUtils.setRequestToken(token);
};
module.exports = {
  navigateTo,
  postEventAction,
  registEventAction,
  removeEventAction,
  removeAllEventAction,
  showToastMessage,
  popCurrentView,
  getVersionAndUrlModel,
  goToPlaceWithMap,
  searchPlace,
  saveLoginState,
  getVersionName,
  getVersionCode,
  updateAppWithUrl,
  getPhoneImei,
  setRequestToken
};
