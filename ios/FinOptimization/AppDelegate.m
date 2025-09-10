/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "UtilsMacros.h"
#import "BaseViewController.h"
#import "MyRootNavigationController.h"
//#import "RCTDevLoadingView.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self initNativeView];
  
  NSString *moduleName = @"Main";
  moduleName = @"Login";
  
// [RCTDevLoadingView setEnabled:NO] ;
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

  BaseViewController *rootViewController = [BaseViewController new];
  rootViewController.moduleName = moduleName;
  MyRootNavigationController *loginNavi =[[MyRootNavigationController alloc] initWithRootViewController:rootViewController];
//  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  self.bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:_bridge
                                                   moduleName:moduleName
                                            initialProperties:nil];
  //[NSDictionary dictionaryWithObjectsAndKeys:loginNavi,@"navigation", nil]
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
  rootView.appProperties = [NSDictionary dictionaryWithObjectsAndKeys:loginNavi,@"navigation", nil];
  rootViewController.view = rootView;
  
  rootViewController.navigationController.navigationBar.hidden = YES;
  self.window.rootViewController = loginNavi;
  [self.window makeKeyAndVisible];
  
  [self addWelcomeView];
  return YES;
}
//加欢迎界面
-(void)addWelcomeView
{
   UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"MyLaunchView" owner:self options:nil] objectAtIndex:0];
  view.frame = Rect(0, 0, ScreenWidth, ScreenHeight);
  UIImageView *img = [view viewWithTag:1];
  img.frame = view.frame;
  img.image = IMAGE_NAMED(@"welcomeBg");
  [self.window addSubview:view];
  self.myView = view;
  [self performSelector:@selector(timerFireMethod:) withObject:nil afterDelay:2];
}
-(void)timerFireMethod:(NSDictionary *)dic
{

  [UIView animateWithDuration:0.7 //速度0.7秒
                   animations:^{//修改rView坐标
                     self.myView.frame = CGRectMake(self.window.frame.origin.x,
                                                -self.window.frame.size.height,
                                                self.window.frame.size.width,
                                                self.window.frame.size.height);
                   }
                   completion:^(BOOL finished){
                   }];
  [self performSelector:@selector(removeMyPicView) withObject:nil afterDelay:1];
  //    [_myView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
  //进入相关界面
//  [self goToSomeView:dic];
  
  //    [view removeFromSuperview];
  //    [CoreAnimationEffect animationRevealFromTop:view];
  
}
-(void)removeMyPicView
{
  if (_myView != nil)
  {
    [_myView removeFromSuperview];
    self.myView = nil;
  }
  
}
-(void)initNativeView
{
  [self getAppToken];
  //    [self getNewDeviceId];
  [self initBaiDu];
  //初始化本地数据库
  [self initAppLocalDB];
  //设置日志
  [self setLoggerSettings];
  
  //网络设置
  [self NetWorkConfig];
  
  
  //设置UI组件的基本属性
  [self setAppDefaultUISetting];
  //输入键盘
  [self completionHandleIQKeyboard];
  
  //    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  //    OneViewController *one = [[OneViewController alloc] init];
  //    UINavigationController *rootViewController = [[UINavigationController alloc] initWithRootViewController:one];
  //    self.window.rootViewController = rootViewController;
  //    [self.window makeKeyAndVisible];
  //初始化window
//  [self initWindow];
//  [self getIpAndVersionRequest];
}
//- (void)baiduMapAuthorization
//{
//  BMKMapManager *temp = [[BMKMapManager alloc]init];
//  self.mapManager = temp;
//
//  // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
//  BOOL ret = [_mapManager start:Baidu_AppKey  generalDelegate:self];
//  if (!ret)
//  {
//    NSLog(@"manager start failed!");
//  }
//}
-(void)initBaiDu
{
//  [self baiduMapAuthorization];
  // 初始化定位SDK
  [[BMKLocationAuth sharedInstance] checkPermisionWithKey:Baidu_AppKey authDelegate:self];
  
  //要使用百度地图，请先启动BMKMapManager
  _mapManager = [[BMKMapManager alloc] init];
  //    目前国内主流坐标系类型主要有三种：WGS84、GCJ02、BD09；
  //    WGS84：为一种大地坐标系，也是目前广泛使用的GPS全球卫星定位系统使用的坐标系；
  //
  //    GCJ02：是由中国国家测绘局制订的地理信息系统的坐标系统，是由WGS84坐标系经加密后的坐标系；
  //
  //    BD09：百度坐标系，在GCJ02坐标系基础上再次加密。其中BD09ll表示百度经纬度坐标，BD09mc表示百度墨卡托米制坐标。
  
  /**
   百度地图SDK所有API均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
   默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
   如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
   */
  if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
    NSLog(@"经纬度类型设置成功");
  } else {
    NSLog(@"经纬度类型设置失败");
  }
  
  //启动引擎并设置AK并设置delegate
  BOOL result = [_mapManager start:Baidu_AppKey generalDelegate:self];
  if (!result) {
    NSLog(@"启动引擎失败");
  }
  
}
//获取版本信息
-(void)getIpAndVersionRequest
{
  //http://118.26.142.213:8080/upgrade/version/channelClient?CustomerFlag=RENT&clientType=2&timestamp=1548827743049
  //ZXKY
  RequestAction *request = [[RequestAction alloc] init];
  [request.parm setObjectFilterNull:Client_Type forKey:@"clientType"];
  [request.parm setObjectFilterNull:Customer_Flag forKey:@"CustomerFlag"];
  [request.parm setObjectFilterNull:[NSString stringWithFormat:@"%f",IOSVersion] forKey:@"SystemVersion"];
  [request.parm setObjectFilterNull:Customer_Version forKey:@"version"];
  [request.parm setObjectFilterNull:AppVersion forKey:@"AppVersion"];
  [request.parm setObjectFilterNull:[NomalUtil getCurrentTimeWithLongLongNum] forKey:@"timestamp"];
  [request.parm setObjectFilterNull:@"2" forKey:@"platform"];
  
  [request request_GetIP_success:^(__kindof YTKBaseRequest * _Nonnull request)
   {
     //         NSLog(@"%@",request.responseData);
     Response *response =  [Response modelWithJSON:request.responseData];
     //         NSLog(@"%@",response);
     VersionModel *mode = [VersionModel modelWithJSON:response.data];
     [SingleDataManager instance].versionModel = mode;
     [[DataBaseUtil instance] deleteObjWithClass:NSClassFromString(@"VersionModel")];
     [[DataBaseUtil instance] addClassWidthObj:mode];
//     if (mode.versionCode != nil && [mode.versionCode floatValue] > [Customer_Flag floatValue] && mode.clientDownUrl != nil)
//     {
//       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"人民币" message:@"是否升级?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//       alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
//       [alertView show];
//       UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"标题" message:@"内容" preferredStyle:UIAlertControllerStyleActionSheet];
//       //默认只有标题 没有操作的按钮:添加操作的按钮 UIAlertAction
//
//       UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//       }];
//       //添加确定
//       UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
//
//       }];
//       //设置`确定`按钮的颜色
//       [sureBtn setValue:[UIColor redColor] forKey:@"titleTextColor"];
//       //将action添加到控制器
//       [alertVc addAction:cancelBtn];
//       [alertVc addAction :sureBtn];
//       //展示
//       [self presentViewController:alertVc animated:YES completion:nil];
//     }
     //         MAIN(^{
     //             [self appStartWithView:@"LoginViewController"];
     //         });
     
     //singdata 换url在内存  url拼接部分要修改 main_url全局找
     //         request.responseData
     //        NSLog(@"%@",mode);
     
   } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
     
   }];
}
//获取token
-(void)getAppToken
{
  NSString *token = [kUserDefaults objectForKey:@"app_token"];
  if ([NomalUtil isValueableString:token])
  {
    [SingleDataManager instance].token = token;
  }
}

#pragma mark- delegate
- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}
RCT_EXPORT_MODULE(Native);
//以后className=moduleName   className=""就返回上一界面
RCT_EXPORT_METHOD(popViewTo:(NSString *)className)
{
//  NSLog(@"aaaaaaaaaaaaaaaa");
  //  [self.navigationController popViewControllerAnimated:YES];
  //  [GCDUtil asyncThreadAndMainQueueWithBlock:^{
  //    [self.navigationController popToRootViewControllerAnimated:NO];
  //  }];
  dispatch_async(dispatch_get_main_queue(), ^{
    
    UINavigationController * nav = (UINavigationController *)kRootViewController;
//    [nav popViewControllerAnimated:YES];
    if (className != nil && [className length] > 1)
    {
      [self popToViewControllWithClassName:className animated:YES];
    }
    else
    {
      [nav popViewControllerAnimated:YES];
    }
  });
  
}

RCT_EXPORT_METHOD(setRequestToken:(NSString *)token)
{
  NSLog(@"++++++++============%@",token);
  [SingleDataManager instance].token = token;
  [kUserDefaults setObject:token forKey:@"app_token"];
  [kUserDefaults synchronize];
}

//[SingleDataManager instance].versionModel
RCT_EXPORT_METHOD(getVersionModel:(RCTResponseSenderBlock)callback)
{
  //  [self.navigationController popViewControllerAnimated:YES];
  //  [GCDUtil asyncThreadAndMainQueueWithBlock:^{
  //    [self.navigationController popToRootViewControllerAnimated:NO];
  //  }];
  //[SingleDataManager instance].versionModel;
  NSArray * array = nil;
  if ([SingleDataManager instance].versionModel != nil)
  {
    array = [NSArray arrayWithObjects:[[SingleDataManager instance].versionModel modelToJSONString], nil];
  }
  //
  //[[[VersionModel alloc] init] modelToJSONObject]
//  VersionModel *model = [[VersionModel alloc] init];
//  model.versionName = @"aaaaa";
//  model.versionCode = @"cccc";
//  VersionModel *model2 = [[VersionModel alloc] init];
//  model.versionCode = @"bbb";
//  array = [NSArray arrayWithObjects:[model modelToJSONString], nil];
  callback(array);
  
}
RCT_EXPORT_METHOD(openURLWithUrlString:(NSString *)url)
{
  //@"itms-services://?action=download-manifest&url=https://raw.githubusercontent.com/chenxingking/ios/master/UBI/k8.plist"
  if ([NomalUtil isValueableString:url])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
  }
  
}
-(BOOL)popToViewControllWithClassName:(NSString *)className animated:(BOOL)animated
{
  BOOL isFind = NO;
  //    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  UINavigationController * nav = (UINavigationController *)kRootViewController;
  for (NSInteger i = [nav.viewControllers count] - 1; i >= 0  ;i-- )
  {
//    UIViewController *contro = [nav.viewControllers objectAtIndex:i];
    BaseViewController *contro = [nav.viewControllers objectAtIndex:i];
    NSString *moduleName = contro.moduleName;
//    if ([contro isKindOfClass:NSClassFromString(className)])
    if(className != nil && [className isEqualToString:moduleName])
    {
      [nav popToViewController:contro animated:animated];
      isFind = YES;
      return isFind;
    }
  }
  return isFind;
}
@end
