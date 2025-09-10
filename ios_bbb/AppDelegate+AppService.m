//
//  AppDelegate+AppService.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/19.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "OpenUDID.h"
#import "NetWorkCenter.h"
#import <IQKeyboardManager.h>
#import "OneViewController.h"
#import "MyRootNavigationController.h"
#import "RootWebViewController.h"
#import "RootNavigationController.h"
@implementation AppDelegate (AppService)


#pragma mark ————— 初始化服务 —————
-(void)initService{
    //注册登录状态监听
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loginStateChange:)
//                                                 name:KNotificationLoginStateChange
//                                               object:nil];
    
    //网络状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkStateChange:)
                                                 name:KNotificationNetWorkStateChange
                                               object:nil];
}

#pragma mark ————— 初始化window —————
-(void)initWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = KWhiteColor;
    [self.window makeKeyAndVisible];
    //MainTabBarController  OneViewController BMKPolygonOverlayPage
   [self appStartWithView:@"LoginViewController2"];
    
//    [self appStartWithView:@"RootWebViewController"];
//    OneViewController *one = [[OneViewController alloc] init];
//    MyRootNavigationController *rootViewController = [[MyRootNavigationController alloc] initWithRootViewController:one];
//    self.window.rootViewController = rootViewController;
    
}

- (void)appStartWithView:(NSString *)myclassStr
{
        //BOOL loginSuccess = [notification.object boolValue];
    
//        if ([@"MainTabBarController" isEqualToString:myclassStr])
//        {//登陆成功加载主窗口控制器
//
//            //为避免自动登录成功刷新tabbar
//            if (!self.mainTabBar || ![self.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
//                self.mainTabBar = [MainTabBarController new];
//
//                CATransition *anima = [CATransition animation];
//                anima.type = @"cube";//设置动画的类型
//                anima.subtype = kCATransitionFromRight; //设置动画的方向
//                anima.duration = 0.3f;
//
//                self.window.rootViewController = self.mainTabBar;
//
//                [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
//
//            }
//
//        }
        if([@"OneViewController" isEqualToString:myclassStr])
        {//登陆失败加载登陆页面控制器
    
//            self.mainTabBar = nil;
            MyRootNavigationController *loginNavi =[[MyRootNavigationController alloc] initWithRootViewController:[OneViewController new]];
    
//            CATransition *anima = [CATransition animation];
//            anima.type = @"fade";//设置动画的类型
//            anima.subtype = kCATransitionFromRight; //设置动画的方向
//            anima.duration = 0.3f;
    
            self.window.rootViewController = loginNavi;
    
//            [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
    
        }
        else if([@"RootWebViewController" isEqualToString:myclassStr])
        {
            RootWebViewController *webView = [[RootWebViewController alloc] initWithUrl:@"http://hao123.com"];
            webView.isShowCloseBtn = YES;
            RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:webView];
            
            if (kRootViewController != nil)
            {
                [kRootViewController presentViewController:loginNavi animated:YES completion:nil];
            }
            else
            {
                self.window.rootViewController = loginNavi;
            }
//            [self presentViewController:loginNavi animated:YES completion:nil];
//            [kRootViewController presentViewController:loginNavi animated:YES completion:nil];
            
        }
        else
        {
            
//            UINavigationController *loginNavi =[[UINavigationController alloc] initWithRootViewController:[[NSClassFromString(myclassStr) alloc] init]];
            MyRootNavigationController *loginNavi =[[MyRootNavigationController alloc] initWithRootViewController:[[NSClassFromString(myclassStr) alloc] init]];
            self.window.rootViewController = loginNavi;
        }
        //展示FPS
//        [AppManager showFPS];
}

#pragma mark ————— 初始化网络配置 —————
-(void)NetWorkConfig
{
    [NetWorkCenter sharedInstance];
//    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
//    config.baseUrl = URL_main;
}

#pragma mark ————— 初始化用户系统 —————
-(void)initUserManager{
//    DLog(@"设备IMEI ：%@",[OpenUDID value]);
//    if([userManager loadUserInfo]){
//
//        //如果有本地数据，先展示TabBar 随后异步自动登录
//        self.mainTabBar = [MainTabBarController new];
//        self.window.rootViewController = self.mainTabBar;
//
//        //自动登录
//        [userManager autoLoginToServer:^(BOOL success, NSString *des) {
//            if (success) {
//                DLog(@"自动登录成功");
//                //                    [MBProgressHUD showSuccessMessage:@"自动登录成功"];
//                KPostNotification(KNotificationAutoLoginSuccess, nil);
//            }else{
//                [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
//            }
//        }];
//
//    }else{
//        //没有登录过，展示登录页面
//        KPostNotification(KNotificationLoginStateChange, @NO)
////        [MBProgressHUD showErrorMessage:@"需要登录"];
//    }
}

#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification
{
//    BOOL loginSuccess = [notification.object boolValue];
//
//    if (loginSuccess) {//登陆成功加载主窗口控制器
//
//        //为避免自动登录成功刷新tabbar
//        if (!self.mainTabBar || ![self.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
//            self.mainTabBar = [MainTabBarController new];
//
//            CATransition *anima = [CATransition animation];
//            anima.type = @"cube";//设置动画的类型
//            anima.subtype = kCATransitionFromRight; //设置动画的方向
//            anima.duration = 0.3f;
//
//            self.window.rootViewController = self.mainTabBar;
//
//            [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
//
//        }
//
//    }else {//登陆失败加载登陆页面控制器
//
//        self.mainTabBar = nil;
//        RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[LoginViewController new]];
//
//        CATransition *anima = [CATransition animation];
//        anima.type = @"fade";//设置动画的类型
//        anima.subtype = kCATransitionFromRight; //设置动画的方向
//        anima.duration = 0.3f;
//
//        self.window.rootViewController = loginNavi;
//
//        [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
//
//    }
//    //展示FPS
//    [AppManager showFPS];
}


#pragma mark ————— 网络状态变化 —————
- (void)netWorkStateChange:(NSNotification *)notification
{
//    BOOL isNetWork = [notification.object boolValue];
//
//    if (isNetWork) {//有网络
//        if ([userManager loadUserInfo] && !isLogin) {//有用户数据 并且 未登录成功 重新来一次自动登录
//            [userManager autoLoginToServer:^(BOOL success, NSString *des) {
//                if (success) {
//                    DLog(@"网络改变后，自动登录成功");
////                    [MBProgressHUD showSuccessMessage:@"网络改变后，自动登录成功"];
//                    KPostNotification(KNotificationAutoLoginSuccess, nil);
//                }else{
//                    [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
//                }
//            }];
//        }
//
//    }else {//登陆失败加载登陆页面控制器
//        [MBProgressHUD showTopTipMessage:@"网络状态不佳" isWindow:YES];
//    }
}


#pragma mark ————— 友盟 初始化 —————
-(void)initUMeng
{
//    /* 打开调试日志 */
//    [[UMSocialManager defaultManager] openLog:YES];
//
//    /* 设置友盟appkey */
//    [[UMSocialManager defaultManager] setUmSocialAppkey:UMengKey];
//
//    [self configUSharePlatforms];
    
    
}
#pragma mark ————— 配置第三方 —————
-(void)configUSharePlatforms{
//    /* 设置微信的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kAppKey_Wechat appSecret:kSecret_Wechat redirectURL:nil];
//    /*
//     * 移除相应平台的分享，如微信收藏
//     */
//    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
//
//    /* 设置分享到QQ互联的appID
//     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kAppKey_Tencent/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
}

#pragma mark ————— OpenURL 回调 —————
// 支持所有iOS系统。注：此方法是老方法，建议同时实现 application:openURL:options: 若APP不支持iOS9以下，可直接废弃当前，直接使用application:openURL:options:
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}

// NOTE: 9.0以后使用新API接口
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
//    if (!result) {
//        // 其他如支付等SDK的回调
//        if ([url.host isEqualToString:@"safepay"]) {
//            //跳转支付宝钱包进行支付，处理支付结果
////            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
////                NSLog(@"result = %@",resultDic);
////            }];
//            return YES;
//        }
////        if  ([OpenInstallSDK handLinkURL:url]){
////            return YES;
////        }
////        //微信支付
////        return [WXApi handleOpenURL:url delegate:[PayManager sharedPayManager]];
//    }
//    return result;
//}

#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus
{
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {
        
        switch (networkStatus) {
                // 未知网络
            case PPNetworkStatusUnknown:
                DLog(@"网络环境：未知网络");
                // 无网络
            case PPNetworkStatusNotReachable:
                DLog(@"网络环境：无网络");
                KPostNotification(KNotificationNetWorkStateChange, @NO);
                break;
                // 手机网络
            case PPNetworkStatusReachableViaWWAN:
                DLog(@"网络环境：手机自带网络");
                // 无线网络
            case PPNetworkStatusReachableViaWiFi:
                DLog(@"网络环境：WiFi");
                KPostNotification(KNotificationNetWorkStateChange, @YES);
                break;
        }
        
    }];
    
}

+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//获取当前Viewcontroller
-(UIViewController *)getCurrentVC
{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
//获取当前UI的viewcontroller
-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}

//日志相关初始化
-(void)setLoggerSettings
{
    [[NVLogManager shareInstance] enableFileLogSystem];
    //出于日志第一行写入{UploadLog}的需要
    //    NSString *filePath = [NVLogManager shareInstance].getCurrentLogFilePath;
    //    NSFileManager* fileManager = [NSFileManager defaultManager];
    //出于日志第一行写入{UploadLog}的需要
    NSString *content = @"{UploadLog}\n";
    [[NVLogManager shareInstance] writeLogString:content];
    DDLogInfo(@"{UploadLog}");
    NVLogError(@"Error Log")
    NVlogWarn(@"Warn Log")
    NVLogDebug(@"Debug Log")
    NVLogInfo(@"Info Log")
    NVLogInfo(@"{UploadLog}");
    //    NVLogInfo(@"日志文件地址:\n%@", [[NVLogManager shareInstance] getCurrentLogFilePath])
    
    [[NVLogManager shareInstance] uploadFileLogWithBlock:^(NSString *logFilePath) {
        
        NSLog(@"地址: %@", logFilePath); // 拿到地址后上传
    }];
    
    //    [[NVLogManager shareInstance] uploadFileLogWithBlock:^(NSString *logFilePath) {
    //
    //        NSLog(@"地址: %@", logFilePath); // 按指定频率上传
    //    } withFrequency:kNVFrequencyDay];
    //
    //    //[[NVLogManager shareInstance] stopLog];
    //    //[[NVLogManager shareInstance] clearFileLog];
    //
    //    NVLogError(@"Error")
    //    NVlogWarn(@"Warn")
    //    NVLogDebug(@"Debug")
    //    NVLogInfo(@"Info")
    
    //defaultLogsDirectory 可以修改文件存储路径
    //    [DDLog addLogger:[DDOSLogger sharedInstance]]; // Uses os_log
    //    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    //    //2、ASL = Apple System Logs 苹果系统日志
    //    //[DDLog addLogger:[DDASLLogger sharedInstance]];
    //    DDLogFileManagerDefault *logFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    //    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager]; // File Logger
    //    fileLogger.maximumFileSize = 5 * 1024 * 1024;           // 文件达到 10MB 回滚
    ////    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    //    fileLogger.logFileManager.maximumNumberOfLogFiles = 1;// 最多允许创建7个文件
    //    fileLogger.rollingFrequency = 0;// 忽略时间回滚
    //    [DDLog addLogger:fileLogger];
    //
    //    DDLogVerbose(@"Verbose");
    //    DDLogDebug(@"Debug");
    //
    //    DDLogInfo(@"aa%@",fileLogger.currentLogFileInfo.filePath);
    //    DDLogWarn(@"Warn");
    //    DDLogError(@"Error");
}


//中添加这段代码，就可以全局不用管键盘的弹起收回了！ #pragma mark - 键盘处理
- (void)completionHandleIQKeyboard
{
    
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    manager.toolbarManageBehaviour = IQAutoToolbarByTag; // 最新版的设置键盘的returnKey的关键字 ,可以点击键盘上的next键，自动跳转到下一个输入框，最后一个输入框点击完成，自动收起键盘。
    
}
//设置UI组件的基本属性
-(void)setAppDefaultUISetting
{
    //同一界面上多个控件接受事件时的排他性
    [[UIButton appearance] setExclusiveTouch:YES];
//    [[UIButton appearance] setShowsTouchWhenHighlighted:YES];
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObjects:[MBProgressHUD class], nil]].color = KWhiteColor;
    //    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:[MBProgressHUD class], nil].color = KWhiteColor;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    if (@available(iOS 11.0, *))
//    {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//
//    }
//    else
//    {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//
//    }
//    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0); _tableView.scrollIndicatorInsets = _tableView.contentInset;
    
  
    
    
    [[UINavigationBar appearance] setBackgroundImage:[NomalUtil imageWithColor:Color_Nomal_Bg] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [UINavigationBar appearance].barStyle = UIBarStyleBlackTranslucent;
//    [[UINavigationBar appearance] setTintColor:Color_Nomal_Bg];
    //[[UIToolbar appearance] setBarTintColor:GetColorWithString(ConstColor_popView_bgColor)];
    //    [[UIToolbar appearance] setBackgroundColor:GetColorWithString(ConstColor_popView_bgColor)];
//    [[UIToolbar appearance] setBackgroundColor:[UIColor colorWithHex:0x2F2F2F]];
    [[UIToolbar appearance] setBackgroundColor:Color_Nomal_Bg];
    //UIImage *hightLight = [UIImage imageWithColor:GetColorWithString2(ConstColor_popView_bgColor, 1) size:CGSizeMake(5, 5)];
    UIImage *hightLight = [[UIImage alloc] init];
    [[UIToolbar appearance] setBackgroundImage:hightLight forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [[UIToolbar appearance] setShadowImage:hightLight forToolbarPosition:UIBarPositionAny];
    [UIToolbar appearance].barStyle = UIBarStyleBlackTranslucent;
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
//初始化本地数据库
-(void)initAppLocalDB
{
    [[DataBaseUtil instance] createAndUpdateAllTable];
    //获取初始化数据
    NSMutableArray * array = [[DataBaseUtil instance] findAllObjsByClass:NSClassFromString(@"VersionModel")];
    if (array != nil && [array count] > 0)
    {
        [SingleDataManager instance].versionModel = [array objectAtIndex:0];
    }
   
}
//关闭本地数据库，长时间不用关掉，应用进入后台可以关掉
-(void)closeAppLocalDB
{
    [[DataBaseUtil instance] closeDataBase];
}
//更换桌面图标 CFBundleAlternateIcons
//https://www.cnblogs.com/zhw511006/p/8458180.html
-(void) changeIcon:(NSString *)iconName
{
    
    if (@available(iOS 10.3, *))
    {
        
        if ([[UIApplication sharedApplication] supportsAlternateIcons])
        {//判断设备是否支持更换图标
            NSLog(@"支持更换图标！");
            
            //开始更换
            [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
                
            }];
           
            
        }
        else
        {
            
            
        }
    }
    else
    {
        // Fallback on earlier versions
    }
}
@end
