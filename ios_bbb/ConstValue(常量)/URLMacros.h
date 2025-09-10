//
//  URLMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//



#ifndef URLMacros_h
#define URLMacros_h


//内部版本号 每次发版递增
//#define KVersionCode 1
/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#define DevelopSever    1
#define TestSever       0
#define ProductSever    0

#define  Client_Id @"564f7e35-5163-4431-9ba7-dceb2e46e509"
#define  Client_Type @"2"
#define  Customer_Flag @"FIN"
#define Customer_Version @"2"
//1 https 0 http
#define Is_Use_Https @"1"
#define Baidu_AppKey @"vPrsSZUZlQl8zzG3wFmzYGEeMB3NRMxB"

#if DevelopSever
//zxky.wiselink.net.cn  service.zhixinkeyuan.com
/**开发服务器*/
//#define URL_main @"http://k8.wiselink.net.cn"
//#define URL_main @"http://192.168.10.190:18080/evrental/interfaceController/"
#define URL_main @"http://118.26.142.213:8080/"
//#define URL_https_cer_name @"zxky.wiselink.net.cn"
#define URL_https_cer_name @"service.zhixinkeyuan.com"
//#define URL_businessInterfaceAddress_ssl @"https://zxky.wiselink.net.cn:8446/"

#elif TestSever

/**预生产服务器*/
#define URL_main @"https://service.zhixinkeyuan.com:8443/"
#define URL_https_cer_name @"service.zhixinkeyuan.com"
//#define URL_businessInterfaceAddress_ssl @"https://zxky.wiselink.net.cn:8446/"

#elif ProductSever

/**生产服务器*/
#define URL_main @"https://service.zhixinkeyuan.com:8443/"
#define URL_https_cer_name @"service.zhixinkeyuan.com"
//#define URL_businessInterfaceAddress_ssl @"https://zxky.wiselink.net.cn:8446/"
#endif



#pragma mark - ——————— 详细接口地址 ————————

//测试接口
//NSString *const URL_Test = @"api/recharge/price/list";
//#define URL_Test @"/api/cast/home/start"

//#pragma mark - ——————— 用户相关 ————————
////自动登录
//#define URL_user_auto_login @"/api/autoLogin"
////登录
//#define URL_user_login @"/api/login"
////用户详情
//#define URL_user_info_detail @"/api/user/info/detail"
////修改头像
//#define URL_user_info_change_photo @"/api/user/info/changephoto"
////注释
//#define URL_user_info_change @"/api/user/info/change"


#endif /* URLMacros_h */
