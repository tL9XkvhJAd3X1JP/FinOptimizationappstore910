//
//  AppDelegate+AppService.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/19.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "AppDelegate.h"

//#define ReplaceRootViewController(vc) [[AppDelegate shareAppDelegate] replaceRootViewController:vc]

/**
 包含第三方 和 应用内业务的实现，减轻入口代码压力
 */
@interface AppDelegate (AppService)

//初始化服务
-(void)initService;

//初始化 window
-(void)initWindow;

//初始化 UMeng
-(void)initUMeng;

//初始化用户系统
-(void)initUserManager;

//监听网络状态
- (void)monitorNetworkStatus;

//初始化网络配置
-(void)NetWorkConfig;

//单例
+ (AppDelegate *)shareAppDelegate;

/**
 当前顶层控制器
 */
//获取当前Viewcontroller
-(UIViewController*) getCurrentVC;
//获取当前UI的viewcontroller
-(UIViewController*) getCurrentUIVC;

//日志相关初始化
-(void)setLoggerSettings;
//中添加这段代码，就可以全局不用管键盘的弹起收回了！ #pragma mark - 键盘处理
- (void)completionHandleIQKeyboard;
//设置组件的基本属性
-(void)setAppDefaultUISetting;
//初始化本地数据库
-(void)initAppLocalDB;
//关闭本地数据库，长时间不用关掉，应用进入后台可以关掉
-(void)closeAppLocalDB;
//用什么界面开始
- (void)appStartWithView:(NSString *)myclassStr;

//更换桌面图标 CFBundleAlternateIcons
//https://www.cnblogs.com/zhw511006/p/8458180.html
-(void) changeIcon:(NSString *)iconName;
@end
