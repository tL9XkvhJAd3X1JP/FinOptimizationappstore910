/**
 * Created by guangqiang on 2017/8/26.
 */

/** 基于fetch 封装的网络请求工具类 **/

import { Component } from "react";
import Global from "../../Global";
import md5 from "../../utils/md5";

const isDebug = false;

/**
 * fetch 网络请求的header，可自定义header 内容
 * @type {{Accept: string, Content-Type: string, accessToken: *}}
 */
const header = (url, params, isForm) => {
  var header = {};
  header.Accept = "application/json";
  header["Content-Type"] = isForm
    ? "application/x-www-form-urlencoded"
    : "application/json";
  if (
    url &&
    url.indexOf(global.urlInterface.LoginInfo.LoginInfoInterface) != -1
  ) {
    //登录接口，生成token
    header.userName = global.account;
    header.password = global.password;
    header.phoneID = global.imei;
  } else {
    //其他接口，传入token
    header.token = global.userAccount ? global.userAccount.token : "";
  }
  header.timestamp = new Date().getTime().toString();
  header.sign = md5
    .md5(
      header.token +
        header.timestamp +
        getBodyParam(params) +
        Global.URL_ENCODE_KEY
    )
    .toUpperCase();
  if (isDebug) {
    console.log("[Header] " + JSON.stringify(header));
  }
  return header;
};

const formHeader = {
  Accept: "application/json",
  "Content-Type": "application/x-www-form-urlencoded"
};

getBodyParam = params => {
  var param = "";
  if (params instanceof Map) {
    var arr = [...params.keys()].sort();
    var length = arr.length;
    for (var i = 0; i < length; i++) {
      var key1 = arr[i];
      for (let [key, value] of params.entries()) {
        if (key == key1) {
          if (
            value != null &&
            value != "null" &&
            value != undefined &&
            value != "undefined" &&
            value != ""
          ) {
            param += key + value;
          }
          break;
        }
      }
    }
  }
  return param;
};

/**
 * GET 请求时，拼接请求URL
 * @param url 请求URL
 * @param params 请求参数
 * @returns {*}
 */
const handleUrl = url => params => {
  if (params) {
    let paramsArray = [];
    Object.keys(params).forEach(key =>
      paramsArray.push(key + "=" + encodeURIComponent(params[key]))
    );
    if (url.search(/\?/) == -1) {
      typeof params == "object" ? (url += "?" + paramsArray.join("&")) : url;
    } else {
      url += "&" + paramsArray.join("&");
    }
  }
  if (isDebug) {
    console.log("[HTTP_REQUEST] " + url);
  }
  return url;
};

/**
 * fetch 网络请求超时处理
 * @param original_promise 原始的fetch
 * @param timeout 超时时间 30s
 * @returns {Promise.<*>}
 */
const timeoutFetch = (original_fetch, timeout = 10000) => {
  let timeoutBlock = () => {};
  let timeout_promise = new Promise((resolve, reject) => {
    timeoutBlock = () => {
      // 请求超时处理
      reject("timeout promise");
    };
  });

  // Promise.race(iterable)方法返回一个promise
  // 这个promise在iterable中的任意一个promise被解决或拒绝后，立刻以相同的解决值被解决或以相同的拒绝原因被拒绝。
  let abortable_promise = Promise.race([original_fetch, timeout_promise]);

  setTimeout(() => {
    timeoutBlock();
  }, timeout);

  return abortable_promise;
};

/**
 * 网络请求工具类
 */
export default class HttpUtils extends Component {
  /**
   * 基于fetch 封装的GET 网络请求
   * @param url 请求URL
   * @param params 请求参数
   * @returns {Promise}
   */
  static getRequest = (url, params = {}) => {
    return timeoutFetch(
      fetch(handleUrl(url)(params), {
        method: "GET",
        headers: formHeader
      })
    )
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          alert(response);
        }
      })
      .then(response => {
        if (response) {
          return response;
        } else {
          // alert(response.message)
          return response;
        }
      })
      .catch(error => {
        alert(error);
      });
  };

  /**
   * 基于fetch 的 POST 请求
   * @param url 请求的URL
   * @param params 请求参数
   * @returns {Promise}
   */
  static postRequrst = (url, params = {}) => {
    return timeoutFetch(
      fetch(url, {
        method: "POST",
        headers: header(
          url,
          params,
          typeof params == "string" || params instanceof Map
        ),
        body:
          typeof params == "string"
            ? HttpUtils.dealString(url, params)
            : params instanceof Map
              ? HttpUtils.dealMap(url, params)
              : HttpUtils.dealJson(url, params)
      })
    )
      .then(response => {
        if (response && response.ok) {
          HttpUtils.dealToken(url, response);
          return response.json();
        } else {
          showToastMessage("服务器繁忙，请稍后再试；\r\nCode:" + response.status);
        }
      })
      .then(response => {
        // response.code：是与服务器端约定code：200表示请求成功，非200表示请求失败，message：请求失败内容
        if (!global.requestInterrupt) {
          if (isDebug) {
            console.log("[HTTP_REQUEST] " + url);
            console.log("[RET] " + JSON.stringify(response));
          }

          if (response && response.code == -1) {
            //登录已经失效
            global.requestInterrupt = true;
            //跳转登录界面
            global.userAccount = null;
            StorageUtil.remove("userAccount", result => {
              if (Global.ios) {
                popCurrentView(global.navigation.Login);
                postEventAction("invalidLogin", "登录已失效，请重新登录!");
              } else {
                navigateTo(global.navigation.Login, "finishOther");
                showToastMessage("登录已失效，请重新登录!");
              }
            });
            return "";
          } else {
            // alert(response.message)
            return response;
          }
        }
      })
      .catch(error => {
        if (error) {
          if (error.toString().indexOf("timeout") != -1) {
            showToastMessage("请求超时，请稍后再试！");
          } else if (error.toString().indexOf("Parse") != -1) {
            showToastMessage("数据异常，请稍后再试！");
          } else if (error.toString().indexOf("Network request failed") != -1) {
            showToastMessage("网络异常，请稍后再试！");
          } else {
            showToastMessage(error.toString());
          }
          console.log(error.toString());
        }
      });
  };

  static dealMap(url, params) {
    var param = "";
    for (let [key, value] of params.entries()) {
      if (
        value != null &&
        value != "null" &&
        value != undefined &&
        value != "undefined" &&
        value != ""
      ) {
        param += `${key}=${value}&`;
      }
    }
    if (param.length > 0) {
      param = param.substring(0, param.length - 1);
    }
    if (isDebug) {
      console.log("[HTTP_REQUEST] " + url + "?" + param);
    }
    return param;
  }

  static dealJson(url, parms) {
    var param = JSON.stringify(params);
    console.log("[HTTP_REQUEST] " + url + "?" + param);
    return param;
  }

  static dealString(url, parms) {
    console.log("[HTTP_REQUEST] " + url + (parms == "" ? parms : "?" + parms));
    return parms;
  }

  static dealToken(url, response) {
    if (
      url &&
      url.indexOf(global.urlInterface.LoginInfo.LoginInfoInterface) != -1
    ) {
      console.log("[Token] " + response.headers.map.token);
      global.token = response.headers.map.token;
      //不再拦截请求
      global.requestInterrupt = false;
    }
  }

  static dealResponse(response) {
    // if (response.code == global.Code.OVER_TIME) {
    //   //退出登录，关闭所有界面，跳到登录界面
    //   if (Global.android) {
    //     NativeModules.AndroidUtils.saveLoginState(false);
    //   }
    //   global.userAccount = null;
    //   StorageUtil.remove("userAccount", result => {
    //     navigateTo(global.navigation.Login, "finishOther");
    //   });
    // } else {
    return response;
    // }
  }
}
