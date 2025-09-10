/**
 * Created by guangqiang on 2017/8/26.

  user:

  requestWarnData() {
    const param = new Map();
    param.set(global.urlInterface.AlarmEfenceRecord.companyId, 1);
    postFetch(
      global.urlInterface.AlarmEfenceRecord.AlarmEfenceRecordInterface,
      param
    ).then(response => {
      Alert.alert(JSON.stringify(response));
    });
  }


 */

/** 网络请求工具类的拓展类，便于后期网络层修改维护 **/

import HttpUtils from "./HttpUtils";
import { dataCache } from "../cache";

// const API_URL_TEST = "http://192.168.42.106:8765";
const API_URL_TEST = "https://192.168.10.194:8770/fin";
// const API_URL_TEST = "https://192.168.43.201:8770/fin";
// const API_URL = "http://124.193.71.141:8080/upgrade";
// const API_URL_CONST = "http://124.193.71.141:8765";
const API_URL_ = "https://fin.wiselink.net.cn:8770/fin";
const RTM_ENV = true;

const API_URL = url => {
  // if (
  //   url &&
  //   url.indexOf(global.urlInterface.ChannelClient.ChannelClientInterface) != -1
  // ) {
  //   //升级接口
  //   return API_URL_CONST;
  // }
  // return global.versionAndUrlModel
  //   ? global.versionAndUrlModel.businessInterfaceAddress_ssl
  //   : "";
  // return "http://192.168.42.50:8765";
  return RTM_ENV ? API_URL_ : API_URL_TEST;
};

/**
 * GET
 * 从缓存中读取数据
 * @param isCache: 是否缓存
 * @param url 请求url
 * @param params 请求参数
 * @param isCache 是否缓存
 * @param callback 是否有回调函数
 * @returns {value\promise}
 * 返回的值如果从缓存中取到数据就直接换行数据，或则返回promise对象
 */
const fetchData = (isCache, type) => (url, params, callback) => {
  // url = `${API_URL}${url}`;
  url = API_URL(url) + url;
  const fetchFunc = () => {
    let promise =
      type == "get"
        ? HttpUtils.getRequest(url, params)
        : HttpUtils.postRequrst(url, params);
    if (callback && typeof callback == "function") {
      promise.then(response => {
        return callback(response);
      });
    }
    return promise;
  };
  return dataCache(url, fetchFunc, isCache);
};

/**
 * GET 请求
 * @param url
 * @param params
 * @param source
 * @param callback
 * @returns {{promise: Promise}}
 */
const getFetch = fetchData(false, "get");

/**
 * POST 请求
 * @param url
 * @param params
 * @param callback
 * @returns {{promise: Promise}}
 */
const postFetch = fetchData(false, "post");

/**
 * GET 请求，带缓存策略
 * @param url
 * @param params
 * @param callback
 * @returns {{promise: Promise}}
 */
const getFetchFromCache = fetchData(true, "get");

export { getFetch, postFetch, getFetchFromCache };
