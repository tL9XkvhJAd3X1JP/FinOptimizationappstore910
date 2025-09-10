import React from "react";
import { NativeModules } from "react-native";
import Global from "../Global";
//use : navigateTo("xx","xx")
//界面跳转 animate="true"代表动画传null代表true  className是viewCoroller的名称
navigateTo = (
  moduleView,
  json = null,
  className = null,
  animate = null,
  androidClassName = null
) => {
  if (moduleView == null) {
    moduleView = "";
  }
  if (className == null) {
    className = "BaseViewController";
  }
  if (animate == null) {
    animate = "true";
  }
  NativeModules.iosUtil.pushToViewWithModuleName3(
    moduleView,
    className,
    json,
    animate
  );
};

//事件传递，事件触发，回调，参数传递，广播

var eventMap = new Map(); //做事件记录
// alert(9999);
postEventAction = (key, json = null) => {
  //每次响应完要重新注册一下
  var callBack = eventMap.get(key);
  // alert("post==" + key);
  // alert(eventMap);
  if (callBack != null) {
    NativeModules.EventUtil.actionEventOnce(key, json);
    // alert(88);
    //每次响应完要重新注册一下
    registEventAction(key, callBack);
  }
};

//注册事件监听
registEventAction = (key, callBack) => {
  if (key != null && callBack != null) {
    //  alert(key);
    //此处注册一次，回调完就会释放内存，所有要重新注册
    NativeModules.EventUtil.addEventOnce(key, callBack);
    eventMap.set(key, callBack);
  }
};
//删除事件监听
removeEventAction = key => {
  if (key != null) {
    NativeModules.EventUtil.removeEventOnce(key);
    eventMap.delete(key);
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
    NativeModules.iosUtil.showNativeMessage(message);
  }
};

//关闭当前界面，不传参数关闭当前界面，传就到moduleName的界面
popCurrentView = (moduleName=null) => {
    if(moduleName == null)
    {
        moduleName = "";
    }
  NativeModules.Native.popViewTo(moduleName);
};

//获取本地地址 global.versionModel
getVersionAndUrlModel = callBack => {
  NativeModules.Native.getVersionModel(callBack);
};

//调第三方地图
goToPlaceWithMap = (mapType, latiude, longitude, place) => {
  NativeModules.EventUtil.goToPlaceWith(
    mapType,
    latiude + "",
    longitude + "",
    place
  );
};
//行政区边界数据检索
searchPlace = (cityName, okCallBack, errorCallBack) => {
  NativeModules.WarnLocation.searchPlace(cityName, okCallBack, errorCallBack);
};

//获取app版本号
getVersionName = () => {
  return Global.iosVersionName;
};
getVersionCode = () => {
  return Global.iosVersionCode;
};
//升级
updateAppWithUrl = updateUrl => {
  NativeModules.Native.openURLWithUrlString(updateUrl);
};
//获取手机唯一标识
getPhoneImei = callBack => {
    return NativeModules.EventUtil.getIOSImei(callBack);
};

//传递token给本地
setRequestToken=token=>
{
    NativeModules.Native.setRequestToken(token);
};
module.exports = {
  navigateTo,
  postEventAction,
  registEventAction,
  removeEventAction,
  removeAllEventAction,
  showToastMessage,
  getVersionAndUrlModel,
  popCurrentView,
  goToPlaceWithMap,
  searchPlace,
  getVersionName,
  getVersionCode,
  updateAppWithUrl,
  getPhoneImei,
  setRequestToken
};
