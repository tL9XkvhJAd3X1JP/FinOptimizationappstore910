import StorageUtil from "../utils/StorageUtil";

import {
    Initializer
} from "react-native-baidumap-sdk";
//import SingleData from "../utils/SingleData";
global.StorageUtil = StorageUtil;
global.variables = {          userAccount: null,          language: 'English',        }
//使用
//global.variables.userAccount = {c:4, a:2, d:3, b:1};
//global.variables.language = "aa";
//登录信息
//global.userAccount = StorageUtil.getJsonObject("userAccount",null);
//账号信息返回值
//private int id;//主键
//private String username;//用户登录名
//private String password;//用户登录密码
//private String realname;//用户真实姓名
//private String mobile;//用户电话
//private int isLogin;//是否允许登录 1-是 0-否
//private String lastLoginDate;//最后登录时间
//private int isDelete;//是否删除 0-未删除 1-已删除
//private int createUserId;//创建人id
//private Date createDate;//创建时间
//private int companyId;//所属公司id
StorageUtil.getJsonObject("userAccount",null).then(data=>{
                                                   
                                    global.userAccount = data;
                                                    });

Initializer.init("VwG2kj6iDZ21dHMGP8sKAUQl0ejVqwVg").catch(e =>
                                                           console.error(e)
                                                           );
//getVersionModel((array)=>
//                {
////                alert(array);
//                //    global.version =
////                alert(JSON.stringify(array));
//                alert(JSON.stringify(array));
////                alert(JSON.parse(array[0]));
//
//                });
