import { AsyncStorage } from "react-native";

export default class StorageUtil {
  /**
     
     保存一个Json对象
     @param key
     @param value
     
     @param callback
     */
  static async saveJsonObject(key, value, callback) {
    var result = await this.saveString(key, JSON.stringify(value));
    callback(result);
    return result;
  }

  /**
     获取一个Json对象
     @param key
     
     @param defaultObject
     */
  static async getJsonObject(key, defaultObject, callback) {
    let result = null;
    try {
      result = await this.getString(key, null);
      result = await JSON.parse(result);
    } catch (err) {
      // if(defaultObject){
      //     return Promise.resolve(defaultObject);
      // }else{
      //     return Promise.reject(err);
      // }
      result = defaultObject;
      return defaultObject;
    }
    if (callback) {
      callback(result);
    }
    return result;
  }

  /**
     保存一个值
     @param key
     
     @param value
     */
  static async saveString(key, value) {
    if (key != null && value != null) {
      //Key 与Value 都不为空
      try {
        await AsyncStorage.setItem(key, value);
      } catch (err) {
        return Promise.reject(err);
      }

      return Promise.resolve(true);
    } else {
      return Promise.reject({ msg: "Key and value can not be null" });
    }
  }

  /**
     获取一个值
     @param key
     放在一个函数前的async有两个作用：
     1.使函数总是返回一个promise
     2.允许在这其中使用await 有了async/await，我们很少需要写promise.then/catch，但是我们仍然不应该忘记它们是基于promise的，因为有些时候（例如在最外面的范围内）我们不得不使用这些方法。Promise.all也是一个非常棒的东西，它能够同时等待很多任务。
     @param defaultValue
     */
  static async getString(key, defaultValue) {
    let result = null;
    let noDataError = { msg: "No value found !" };
    if (key != null) {
      result = await AsyncStorage.getItem(key);
      //             console.log('get string result',result,defaultValue);
      //            alert("11="+result);
      //            return result;
      return result
        ? result
        : defaultValue != null ? defaultValue : Promise.reject(noDataError);
    } else {
      if (defaultValue) {
        //                alert(2222);
        return Promise.resolve(defaultValue);
      } else {
        //                alert(3333);
        return Promise.reject(noDataError);
      }
    }
  }

  /**
     移除一个值
     
     @param key
     */
  static async remove(key, callback) {
    let result = true;
    try {
      result = await AsyncStorage.removeItem(key);
      //            alert("remove="+result);
    } catch (err) {
      return Promise.reject(err);
    }
    callback(result);
    return result;
  }

  /**
     获取所有已存储
     */
  static async getAllKeys() {
    let result = true;
    try {
      result = await AsyncStorage.getAllKeys();
    } catch (err) {
      return Promise.reject(err);
    }
    return result;
  }
}
//export {
//    remove
//
//};

//外界调用：
//返回的都是 Promise
//StorageUtil.getJsonObject("myKeyJson",null).then(result => {
//
//
//                                                 alert(result);
//                                                 //                                                             alert(JSON.stringify(result));
//
//                                                 }).catch(err => {
//                                                          alert("err="+err);
//                                                          });
//StorageUtil.getString("myKey1","aaaa").then(result => {
//
//
//                                            alert("str="+result);
//                                            }).catch(err => {
//                                                     alert("err="+err);
//                                                     });
//保存操作：
//StorageUtil.saveJsonObject(KEY_LOCAL_USER_INFO, user);
//
//读取操作：
//StorageUtil.getJsonObject(KEY_LOCAL_USER_INFO).then(data=>{console.log(data)})
//
//清除操作：
//StorageUtil.remove(KEY_LOCAL_USER_INFO)
