"use strict";
/**
 *@flow
 */
import { Dimensions, Platform, StatusBar, PixelRatio } from "react-native";
//import DeviceInfo from "react-native-device-info";
import { Component } from "react";
const iosVersionCode = "3";
const iosVersionName = "1.2";
const androidVersionCode = "2";
const androidVersionName = "1.1";
const CustomerFlag = "FIN"; //大客户标识
const OS = Platform.OS;
const ios = OS == "ios";
const android = OS == "android";
//url加密
const URL_ENCODE_KEY = "e10adc3949ba59abbe56e057f20f888e";
//UI设计图的宽度
const iosDesignWidth = 640;
//UI设计图的高度
const iosDesignHeight = 1136;
//UI设计图的宽度
const androidDesignWidth = 1080;
//UI设计图的高度
const androidDesignHeight = 1920;
//手机屏幕的宽度
const width = Dimensions.get("window").width;
//手机屏幕的高度
const height = Dimensions.get("window").height;
//计算手机屏幕宽度对应设计图宽度的单位宽度
//使用：px * unitWidth
const unitWidth = width / (ios ? iosDesignWidth : androidDesignWidth);
//计算手机屏幕高度对应设计图高度的单位高度
//使用：px * unitHeight
const unitHeight = height / (ios ? iosDesignHeight : androidDesignHeight);

const pixelScale = PixelRatio.get();

const isIPhoneX = ios && height == 812 && width == 375;
const statusBarHeight = ios
  ? isIPhoneX ? 44 : 20
  : StatusBar.currentHeight <= 0 ? 25 * pixelScale : StatusBar.currentHeight;

const safeAreaViewHeight = isIPhoneX ? 34 : 0;
//标题栏的高度
const titleHeight = () => {
  let pTitleHeight;
  if (ios) {
    pTitleHeight = statusBarHeight + 44;
  } else {
    if (Platform.Version < 19) {
      pTitleHeight = height / 10.0 + statusBarHeight;
    } else {
      pTitleHeight = height / 10.0;
    }
  }

  return pTitleHeight;
};

const isAboveAndroidLollipop = () => {
  return Platform.Version >= 21;
};

//对应app中x14
const unitPxWidthConvert = num => {
  return PixelRatio.roundToNearestPixel(width / 320.0 * num);
};

const unitPxHeightConvert = num => {
  return PixelRatio.roundToNearestPixel(height / 480.0 * num);
};

//字体缩放比例，一般情况下不用考虑。
// 当应用中的字体需要根据手机设置中字体大小改变的话需要用到缩放比例
//使用：px/fonstScale
const fontScale = PixelRatio.getFontScale();

export default {
  unitWidth,
  unitHeight,
  statusBarHeight,
  fontScale,
  width,
  height,
  pixelScale,
  titleHeight,
  unitPxWidthConvert,
  unitPxHeightConvert,
  isAboveAndroidLollipop,
  ios,
  android,
  safeAreaViewHeight,
  iosVersionCode,
  iosVersionName,
  androidVersionCode,
  androidVersionName,
  CustomerFlag,
  URL_ENCODE_KEY
};
