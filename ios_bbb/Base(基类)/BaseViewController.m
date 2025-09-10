//
//  BaseViewController.m
//  BaseProject
//
//  Created by janker on 2018/11/1.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "BaseViewController.h"
#import "TouchObjectViewController.h"
#import <MJRefresh.h>
#import "CustomView.h"
//导航栏的背景色
#define headerViewBackGroundColor Color_ViewBackground_blue
#define headerViewTextColor Color_Nomal_Font_White
#define contentViewBackGroundColor Color_Clear
#define viewBackGroundColor Color_ViewBackground
@interface BaseViewController ()<RCTBridgeDelegate,RCTBridgeModule>
@property (nonatomic,strong) UILabel* noDataView;
@end

@implementation BaseViewController
@synthesize viewDic;

#pragma mark- delegate
- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}
//react-native 调用native代码
RCT_EXPORT_MODULE(iosUtil);
RCT_EXPORT_METHOD(pushToNativeViewWithviewControllerName:(NSString *)viewControllerName)
{
  //  NSString *str = [NSString stringWithFormat:@"=========%@",[[NSThread currentThread] name]];
  //  [[self.bridge eveventDispatcher] sendDeviceEventWithName]
  //  NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaa");
  kWeakSelf(self);
  [GCDUtil asyncThreadAndMainQueueWithBlock:^{
    [weakself pushToViewWithClassName:viewControllerName];
  }];
}

RCT_EXPORT_METHOD(pushToViewWithModuleName:(NSString *)moduleName viewControllerName:(NSString *)viewControllerName)
{
//  NSString *str = [NSString stringWithFormat:@"=========%@",[[NSThread currentThread] name]];
//  [[self.bridge eveventDispatcher] sendDeviceEventWithName]
//  NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaa");
  kWeakSelf(self);
  [GCDUtil asyncThreadAndMainQueueWithBlock:^{
//    [weakself.viewDic setObjectFilterNull:@"test" forKey:@"testKey"];
    [weakself pushToViewWithReactNativeModuleName:moduleName viewControllerName:viewControllerName animate:YES];
  }];
}
RCT_EXPORT_METHOD(pushToViewWithModuleName2:(NSString *)moduleName viewControllerName:(NSString *)viewControllerName object:(NSDictionary*)obj)
{
  //  NSString *str = [NSString stringWithFormat:@"=========%@",[[NSThread currentThread] name]];
  
  //  NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaa");
  kWeakSelf(self);
  [GCDUtil asyncThreadAndMainQueueWithBlock:^{
    [weakself pushToViewWithModuleName4:moduleName viewControllerName:viewControllerName object:obj animate:YES];
  }];
}
RCT_EXPORT_METHOD(pushToViewWithModuleName3:(NSString *)moduleName viewControllerName:(NSString *)viewControllerName object:(NSDictionary*)obj animate:(NSString *)animate)
{
  //  NSString *str = [NSString stringWithFormat:@"=========%@",[[NSThread currentThread] name]];
  
  //  NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaa");
  kWeakSelf(self);
  [GCDUtil asyncThreadAndMainQueueWithBlock:^{
    BOOL isAnimate = NO;
    if ([@"true" isEqualToString:animate])
    {
      isAnimate = YES;
    }
    [weakself pushToViewWithModuleName4:moduleName viewControllerName:viewControllerName object:obj animate:isAnimate];
  }];
}
-(void)pushToViewWithModuleName4:(NSString *)moduleName viewControllerName:(NSString *)viewControllerName object:(NSDictionary*)obj animate:(BOOL)animate
{
  [self.viewDic setObjectFilterNull:obj forKey:@"object"];
  [self.viewDic setObjectFilterNull:moduleName forKey:@"moduleName"];
  [self pushToViewWithReactNativeModuleName:moduleName viewControllerName:viewControllerName animate:animate];
  
}

RCT_EXPORT_METHOD(showNativeMessage:(NSString *)message)
{
  //  NSString *str = [NSString stringWithFormat:@"=========%@",[[NSThread currentThread] name]];
  
  //  NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaa");
  kWeakSelf(self);
  [GCDUtil asyncThreadAndMainQueueWithBlock:^{
    // 显示在页面中间，duration代表多久之后消失
    [weakself showViewMessage:message afterDelayTime:3];
  }];
}


+ (BOOL)requiresMainQueueSetup
{
  return YES;
}
-(void)pushToViewWithReactNativeModuleName:(NSString *)moduleName viewControllerName:(NSString *)viewControllerName
{
  [self pushToViewWithReactNativeModuleName:moduleName viewControllerName:viewControllerName animate:YES];
}
-(void)pushToViewWithReactNativeModuleName:(NSString *)moduleName viewControllerName:(NSString *)viewControllerName animate:(BOOL)animate
{
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:moduleName
                                            initialProperties:viewDic];
  
  rootView.backgroundColor = Color_Nomal_Font_White;
  
//  [self pushToViewWithClassName:viewControllerName];
  [self pushToViewWithClassName:viewControllerName data:viewDic nav:nil dataType:1 animate:animate rootView:rootView];
  
}
//右返回
//https://github.com/forkingdog/FDFullscreenPopGesture


#pragma mark- StatusBar设置
-(BOOL)prefersStatusBarHidden
{
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
#pragma mark -  屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // 默认进去类型
    return   UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotate
{
    // 是否支持旋转
    return NO;
}
#pragma mark-生命周期
//APP生命周期中 只会执行一次
//+ (void)initialize
//{
//    [super initialize];
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    //    nibNameOrNil = [NomalUtil changeToIos5Xib:nibNameOrNil];
    //国际化
    //    nibNameOrNil = [NomalUtil changeToInternationalXib:nibNameOrNil];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    DLog(@"初始化界面======%@",[self className]);
    if (self)
    {
        if (self.viewDic == nil)
        {
            self.viewDic = [NSMutableDictionary dictionaryWithCapacity:0];
        }

    }
    return self;
}
- (void)dealloc
{
    [self cancelRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//创建self.view 对象用的，在viewDidLoad前调用
-(void)loadView
{
    DLog(@"loadView");
//    self.notRightScrollPop = YES;
    [super loadView];
    //初始化开始的界面结构
    [self initBaseFrame];
    
    //    self.view = self.contentView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self closeNetWaiting];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    // 1.约束创建的控件在-ViewDidAppear:可获得真是Frame，
    //或者在手动调用-layoutIfNeeded方法后获得真是Frame
    [self.view layoutIfNeeded];
    //不计算内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    //if (@available(iOS 11.0, *))
    //uiscrollView contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever 不计算内边距
    
    DLog(@"viewDidLoad");
    if (_navType != 2)
    {
        [self loadNavBarView];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (( VCCount > 1 || self.navigationController.presentingViewController != nil))
    
    if (!_notRightScrollPop && self.navigationController != nil && self.navigationController.viewControllers.count > 1&& ![@"Main" isEqualToString:[viewDic objectForKey:@"moduleName"]])
    {
        
      self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    else
    {
        //不需要右滑的做处理
        TouchObjectViewController * obj =[[TouchObjectViewController alloc] init];
        self.navigationController.interactivePopGestureRecognizer.delegate = obj;
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }
//        [obj release];
        
    }
}



//-(UIStatusBarStyle)StatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
#pragma mark-代理

- (void)requestWillStart:(id)request
{
    [self showNetWaiting];
    
}
- (void)requestWillStop:(id)request
{
//    [MBProgressHUD hideHUD];
    [self closeNetWaiting];
    [self tableViewEndRefreshing];
}

- (void)requestDidStop:(id)request
{
    
}

-(void)requestFinished:(__kindof YTKBaseRequest *)request
{
//    [MBProgressHUD showSuccessMessage:@"完成"];
    
//    [self showViewMessageInfo:@"完成了" afterDelayTime:3 block:^{
//        DDLogInfo(@"requestFinished");
//    }];

}
-(void)requestFailed:(__kindof YTKBaseRequest *)request
{
//    [self closeNetWaiting];
//    [MBProgressHUD showErrorMessage:@"失败"];
    
    
//    [MBProgressHUD showInfoMessage:@""]
    //[YJProgressHUD show]
    [self closeNetWaiting];
    [self tableViewEndRefreshing];
    [self showViewMessage:@"网络异常!"];
}


#pragma mark -tableView collectionView相关 懒加载
-(void)showNoDataImage
{
    if (_noDataView != nil)
    {
        [_noDataView removeFromSuperview];
    }
    self.noDataView = [[UILabel alloc] initWithFrame:Rect(0, 0, 200, 100)];
    self.noDataView.text = @"暂无数据";
    self.noDataView.font = [UIFont systemFontOfSize:20];
    self.noDataView.textColor = [UIColor lightGrayColor];
    self.noDataView.textAlignment = NSTextAlignmentCenter;
//    UIImage *bgImg = [UIImage imageNamed:@"没有数据"];
//    [_noDataView setImage:bgImg];
//    self.noDataView.frame = Rect(0, 0, bgImg.size.width, bgImg.size.height);
//    kWeakSelf(self);
    [self.tableView addSubview:self.noDataView];
    self.noDataView.center = self.tableView.center;
    //循环每一个组件
//    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
//        if ([obj isKindOfClass:[UITableView class]]) {
//            [weakself.noDataView setFrame:CGRectMake(0, 0,obj.frame.size.width, obj.frame.size.height)];
//            [obj addSubview:weakself.noDataView];
//        }
//    }];
}

-(void)removeNoDataImage{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}

/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView
{
    if (_tableView == nil) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight -kTabBarHeight) style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (self.contentView != nil)
        {
            [self.contentView addSubview:_tableView];
            _tableView.frame = Rect(0, 0, self.contentView.width, self.contentView.height);
        }
        if (!_removeHeaderRequest)
        {
            //头部刷新
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
            header.automaticallyChangeAlpha = YES;
            header.lastUpdatedTimeLabel.hidden = YES;
            _tableView.mj_header = header;
        }
       if (!_removeFooterRequest)
       {
           //底部刷新
           _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
           //        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
           //        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
           
           _tableView.backgroundColor= Color_ViewBackground;
           _tableView.scrollsToTop = YES;
           _tableView.tableFooterView = [[UIView alloc] init];
       }
        
        
    }
    return _tableView;
}

/**
 *  懒加载collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth , KScreenHeight - kTopHeight - kTabBarHeight) collectionViewLayout:flow];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _collectionView.mj_header = header;
        
        //底部刷新
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        
        //#ifdef kiOS11Before
        //
        //#else
        //        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //        _collectionView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        //        _collectionView.scrollIndicatorInsets = _collectionView.contentInset;
        //#endif
        
        _collectionView.backgroundColor=CViewBgColor;
        _collectionView.scrollsToTop = YES;
    }
    return _collectionView;
}
-(void)headerRereshing{
    
}

-(void)footerRereshing{
    
}
-(void)tableViewEndRefreshing
{
    if (_tableView != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tableView.mj_header)
            {
                [self.tableView.mj_header endRefreshing];
            }
            if (self.tableView.mj_footer)
            {
                [self.tableView.mj_footer endRefreshing];
            }
            
            
            
        });
    }
 
}
#pragma mark- 自己定义的方法

//取消请求
- (void)cancelRequest
{
    
}
//// 使用UIActivityIndicatorView来显示进度，这是默认值
//MBProgressHUDModeIndeterminate,
//// 使用一个圆形饼图来作为进度视图
//MBProgressHUDModeDeterminate,
//// 使用一个水平进度条
//MBProgressHUDModeDeterminateHorizontalBar,
//// 使用圆环作为进度条
//MBProgressHUDModeAnnularDeterminate,
//// 显示一个自定义视图，通过这种方式，可以显示一个正确或错误的提示图
//MBProgressHUDModeCustomView,
//// 只显示文本
//MBProgressHUDModeText
//导航条
-(void)loadNavBarView
{
    UIView *navView = [self.headerView getSubViewInstanceWith:[UIView class]];
    navView.backgroundColor = [UIColor clearColor];
    navView.frame = Rect(0, StatusBarHeight, ScreenWidth, NavBarHeight);
//    navView.frame = Rect(0, 0, ScreenWidth, StatusBarHeight + NavBarHeight);
    //[self.headerView addSubview:navView];
    CGFloat addWidth = 24;
    UIFont *font = [UIFont systemFontOfSize:15];
    CGFloat heightButton = 32;
    CGFloat margin = 12.0f;
    UIColor *textColor = headerViewTextColor;
    if (self.title != nil)
    {
        UILabel *titleLable = [[UILabel alloc] initWithFrame:Rect(0, 0, ScreenWidth, NavBarHeight)];
        titleLable.text = self.title;
        titleLable.backgroundColor = [UIColor clearColor];
        [titleLable setTextColor:textColor];
        [navView addSubview:titleLable];
        [titleLable setTextAlignment:NSTextAlignmentCenter];
        
    }
    
    if (_leftNavBtnName != nil || _leftNavBtnImg != nil)
    {
        
        UIButton *b;
        b = (UIButton*) [[UIButton alloc] init];
        [b setShowsTouchWhenHighlighted:YES];
        [navView addSubview:b];
        b.backgroundColor = [UIColor clearColor];
        b.titleLabel.font = font;
        [b setTitleColor:textColor forState:UIControlStateNormal];
        
        if(_leftNavBtnImg != nil)
        {
            UIImage *tmpimage = IMAGE_NAMED(_leftNavBtnImg);
            
            [b setFrameInSuperViewHeightCenterAndLeft:nil toLeftSpace:margin width:[self.view getPicScaleLen2:tmpimage.size.width] height:[self.view getPicScaleLen2:tmpimage.size.height]];
            [b setBackgroundImage:tmpimage forState:UIControlStateNormal];
//            b.frame = Rect(margin, 0, buttonWidth, buttonHeight);
        }
        else
        {
            CGSize size = [_leftNavBtnName sizeWithAttributes:@{NSFontAttributeName : b.titleLabel.font}];;
            
            b.frame = CGRectMake(margin, 0, size.width + addWidth, heightButton);
            if ([@"返回" isEqualToString:_leftNavBtnName])
            {
                //            UIImage *tmpimage = IMAGE_NAMED(@"return");
                //        [btn setBackgroundImage:tmpimage forState:UIControlStateNormal];
                //图片变色
                UIImage *tmpimage =[IMAGE_NAMED(@"return") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [b setTintColor:Color_Nomal_Font_Blue];
                [b setImage:tmpimage forState:UIControlStateNormal];
                int imgWidth = tmpimage.size.width;
                int imgHeight = tmpimage.size.height;
                CGFloat leftSpace = 1;
                CGFloat buttonHeight = 42;
                CGFloat buttonWidth = 40;
                //CGFloat space = 12;
                [b setImageEdgeInsets:UIEdgeInsetsMake((buttonHeight - imgHeight)/2 , leftSpace, (buttonHeight - imgHeight)/2, buttonWidth - imgWidth - leftSpace)];
                b.frame = Rect(margin, 0, buttonWidth, buttonHeight);
                b.centerY = navView.height/2;
                [b setEnlargeEdgeWithTop:5 right:5 bottom:5 left:15];
            }
            else
            {
                
                [b setTitle:_leftNavBtnName forState:UIControlStateNormal];
            }
        }

        
        [b addTarget:self action:@selector(leftNavBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (_rightNavBtnName != nil || _rightNavBtnImg != nil)
    {
        
        UIButton *b;
        b = (UIButton*) [[UIButton alloc] init];
        [b setShowsTouchWhenHighlighted:YES];
        
        b.backgroundColor = [UIColor clearColor];
        b.titleLabel.font = font;
        //[b.titleLabel setTextAlignment:NSTextAlignmentRight];
        //UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
        [b setTitle:_rightNavBtnName forState:UIControlStateNormal];
        [b setTitleColor:textColor forState:UIControlStateNormal];
        [navView addSubview:b];
        if(_rightNavBtnImg != nil)
        {
            UIImage *tmpimage = IMAGE_NAMED(_rightNavBtnImg);
            
//            [b setFrameInSuperViewHeightCenterAndLeft:nil toLeftSpace:margin width:[self.view getPicScaleLen2:tmpimage.size.width] height:[self.view getPicScaleLen2:tmpimage.size.height]];
            [b setFrameInSuperViewHeightCenterAndRight:nil toRightSpace:margin width:[self.view getPicScaleLen2:tmpimage.size.width] height:[self.view getPicScaleLen2:tmpimage.size.height]];
            [b setBackgroundImage:tmpimage forState:UIControlStateNormal];
            //            b.frame = Rect(margin, 0, buttonWidth, buttonHeight);
        }
        else
        {
            CGSize size = [_rightNavBtnName sizeWithAttributes:@{NSFontAttributeName : b.titleLabel.font}];
            
            b.frame = CGRectMake(ScreenWidth -(size.width + addWidth) - 2 , 0, size.width + addWidth, heightButton);
            b.centerY = navView.height/2;
        }
        
        //[b setTitleEdgeInsets:UIEdgeInsetsMake(0, size.width + addWidth, 0, 0)];
        //b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [b addTarget:self action:@selector(rightNavBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
//获取当前window view
-(UIView*)getShowView
{
    //return [UIApplication sharedApplication].keyWindow;
    if ([@"UITextEffectsWindow" isEqualToString:[[[[UIApplication sharedApplication].windows lastObject] class] description]])
    {
        return [[UIApplication sharedApplication].windows lastObject];
    }
    else
    {
        return [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
}
//提示语展示
-(void)showViewMessage:(NSString *)message
{
//    [YJProgressHUD showMessage:message inView:[self getShowView]];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [MBProgressHUD showTipMessageInWindow:message];
}
//进度条展示
-(void)showNetWaiting
{
//    [YJProgressHUD showProgress:@"Loading" inView:[self getShowView]];
    //不可反回
//    [MBProgressHUD showActivityMessageInWindow:@"加载中..."];
    //可反回
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    
}

//进度条关
-(void)closeNetWaiting
{
//    [YJProgressHUD hide];
    [MBProgressHUD hideHUD];
}
//提示语展示
-(void)showViewMessageInfo:(NSString *)message afterDelayTime:(NSTimeInterval)delay block:(void(^)(void))block
{
//    [YJProgressHUD show:message inView:[self getShowView] mode:YJProgressModeOnlyText];
    
    [MBProgressHUD showCustomInfoNotHideMessage:message];

    [self performSelector:@selector(hideViewMessage:) withObject:block afterDelay:3];
}
//提示
-(void)showViewMessage:(NSString *)message afterDelayTime:(NSTimeInterval)delay block:(void(^)(void))block
{
    //    [YJProgressHUD show:message inView:[self getShowView] mode:YJProgressModeOnlyText];
    
    [MBProgressHUD showNotHideTipMessageInWindow:message];
    [self performSelector:@selector(hideViewMessage:) withObject:block afterDelay:3];
}
//提示语隐藏
-(void)hideViewMessage:(void(^)(void))block
{
//    [YJProgressHUD hide];
    [MBProgressHUD hideHUD];
    block();
}
//提示语展示
-(void)showViewMessage:(NSString *)message afterDelayTime:(NSTimeInterval)delay
{
//    [YJProgressHUD showMessage:message inView:[self getShowView] afterDelayTime:delay];
    [MBProgressHUD showTipMessageInView:message timer:delay];
}

-(void)renderHeaderView
{
    self.headerView = [self.view getSubViewInstanceWith:[UIView class]];
    //    [self.view addSubview:_headerView];
    [_headerView setFrameInSuperViewCenterTop:nil toTopSpace:0 width:ScreenWidth height:StatusBarHeight+NavBarHeight];
    _headerView.backgroundColor = headerViewBackGroundColor;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 1, 1, 1);
    UIImage * shadowimg = [UIImage imageNamed:@"阴影"];
    shadowimg = [shadowimg resizableImageWithCapInsets:insets];
    UIImageView * shadowimgv = [[UIImageView alloc]init];
    shadowimgv.image = shadowimg;
    shadowimgv.frame = CGRectMake(0, 0, CGRectGetWidth(_headerView.frame), shadowimg.size.height);
    [_headerView addSubview:shadowimgv];
}

//初始化开始的界面结构
-(void)initBaseFrame
{
    self.view.frame = ScreenBounds;
    self.view.backgroundColor = viewBackGroundColor;
    //0:默认(导航上和contentview下) 1:导航和contentview重叠 2无导航 无contentview
    if (_navType == 0)
    {
        [self renderHeaderView];
        self.contentView = [self.view getSubViewInstanceWith:[UIView class]];
        //    [self.view addSubview:self.contentView];
        [self.contentView setFrameLeftTopFromViewLeftBottom:_headerView leftToLeftSpace:0 bottomToTopSpace:0 width:ScreenWidth_Content height:ScreenHeight_Content];
        self.contentView.backgroundColor = contentViewBackGroundColor;
    }
    else if (_navType == 1)
    {
        
        self.contentView = [self.view getSubViewInstanceWith:[UIView class]];
        [self.contentView setFrameInSuperViewCenterTop:nil toTopSpace:0 width:ScreenWidth height:ScreenHeight];
        self.contentView.backgroundColor = contentViewBackGroundColor;
        self.headerView = [self.view getSubViewInstanceWith:[UIView class]];
        [_headerView setFrameInSuperViewCenterTop:nil toTopSpace:0 width:ScreenWidth height:StatusBarHeight+NavBarHeight];
        _headerView.backgroundColor = headerViewBackGroundColor;
    }
    
}
//nav左按钮
- (void) leftNavBtnPressed: (id) sender
{
    //[self clearAllRequest];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//nav右按钮
- (void) rightNavBtnPressed: (id) sender
{
    //子类进行覆盖，若子类没有覆盖，则为空方法
    
}
//显示二次确认 nonnull (nullable void(^)())cancelBlock (void(^)(void))cancelBlock
-(void)showCustomAlertViewWithTitle:(NSString *)title message:(NSString *)message okButtonTitle:(NSString *)okButtonTitle cancelBlock:(void(^)(void))cancelBlock okBlock:(void(^)(void))okBlock
{
    CGFloat spaceX = 15;
    CGFloat spaceY = 15;
    __weak CustomView *alertView = (CustomView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomView3"
                                                                    owner:self
                                                                  options:nil]
                                      objectAtIndex:0];
    [self.view addSubview:alertView];
    [alertView setFrameInSuperViewCenter:nil width:ScreenWidth height:ScreenHeight];
    alertView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.7];
    alertView.view1.backgroundColor = [UIColor whiteColor];
    [alertView.view1 setCornerRadius:11];
    alertView.view1.width = ScreenWidth - spaceX*4;
    UIImage *image = IMAGE_NAMED(@"关闭k8");
    [alertView.button2 setFrameInSuperViewRightTop:nil toRightSpace:0 toTopSpace:0 width:[self.view getPicScaleLen2:image.size.width] height:[self.view getPicScaleLen2:image.size.height]];
    [alertView.button2 setBackgroundImage:image forState:UIControlStateNormal];
    [alertView.button2 setBackgroundImage:IMAGE_NAMED(@"关闭按下k8") forState:UIControlStateHighlighted];
    if (title == nil)
    {
        title = @"";
    }
    alertView.label.text = title;
    alertView.label.font = FFont_Default_Big;
    alertView.label.textColor = Color_Nomal_Font_Blue;
    [alertView.label setFrameInSuperViewLeftTop:nil toLeftSpace:spaceX toTopSpace:spaceY width:alertView.view1.width - alertView.button2.width - 3 height:-2];
    if (message == nil)
    {
        message = @"";
    }
    
    alertView.label2.text = message;
    alertView.label2.font = FFont_Default;
    alertView.label2.textColor = [UIColor grayColor];
    [alertView.label2 setFrameLeftTopFromViewLeftBottom:alertView.label leftToLeftSpace:0 bottomToTopSpace:spaceY*2 width:alertView.view1.width - spaceX *2 height:-2];
    
    [alertView.button1 setFrameLeftTopFromViewLeftBottom:alertView.label2 leftToLeftSpace:0 bottomToTopSpace:spaceY*2 width:alertView.view1.width - spaceX *2 height:40];
    [alertView.button1 setCornerRadius:4];
    alertView.button1.backgroundColor = Color_Nomal_Bg;
    [alertView.button1 setTitle:okButtonTitle forState:UIControlStateNormal];
    
    alertView.view1.height = alertView.button1.bottom + spaceY;
    alertView.view1.center = alertView.center;
    
    //cancel
    [alertView.button2 addTapBlock:^(UIButton *btn) {
        [alertView removeFromSuperview];
        if (cancelBlock != nil)
        {
            cancelBlock();
        }
        
        
    }];
    //ok
    [alertView.button1 addTapBlock:^(UIButton *btn) {
        [alertView removeFromSuperview];
        if (okBlock != nil)
        {
          okBlock();
        }
        
    }];
}
//进下一个界面
#pragma mark -view Push Pop
-(void) pushToViewWithClassName:(NSString *) className
{
    [self pushToViewWithClassName:className data:viewDic nav:nil dataType:1 animate:YES rootView:nil];
}
-(void) pushToViewWithClassName:(NSString *) className animate:(BOOL)animate
{
    [self pushToViewWithClassName:className data:viewDic nav:nil dataType:1 animate:animate rootView:nil];
}
//进下一个界面
-(void) pushToViewWithNewViewDicAndClassName:(NSString *) className
{
    [self pushToViewWithClassName:className data:viewDic nav:nil dataType:0 animate:YES rootView:nil];
}

//进下一个界面
-(void) pushToViewWithClassName:(NSString *) className data:(NSMutableDictionary *)dic nav:(UINavigationController *)nav dataType:(int)dataType animate:(BOOL)animate rootView:(UIView*)rootView
{
    //dataType = 0新建 1传递 2拷贝
    //    SuperViewController *superViewController = [[NSClassFromString(className) alloc] init];
    //    DLog(@"========%@  %@",className,kRootViewController);
    
    
    BaseViewController *superViewController = [[NSClassFromString(className) alloc] init];
  if (rootView != nil)
  {
    superViewController.view = rootView;
  }
  if (dic == nil)
  {
    dic = [NSMutableDictionary dictionaryWithCapacity:0];
  }
//    BaseViewController *superViewController =[(UIViewController)[NSClassFromString(className) alloc] initWithNibName:[NSClassFromString(className) bundle:nil]];
    
    if (dataType == 1)
    {
      
        superViewController.viewDic = dic;
    }
    else if (dataType == 2)
    {
        NSMutableDictionary *tempDic = [dic mutableCopy];
        superViewController.viewDic = tempDic;
        //        [tempDic release];
    }
    
    //有tabView的时候
    if (nav == nil)
    {
        //        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //        nav = delegate.navControllerRoot;
        
        nav = (UINavigationController *)kRootViewController;
    }
    //[@"MainTabBarController" isEqualToString:NSStringFromClass([nav class])]
    if ([nav isKindOfClass:NSClassFromString(@"MainTabBarController")])
    {
        //MainTabBarController *tmp = (MainTabBarController *)nav;
        nav = self.navigationController;
    }
    
    [nav pushViewController:superViewController animated:animate];
    //    [superViewController release];
}

-(UIViewController *)getViewControllWithClassName:(NSString *)className
{
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   UINavigationController * nav = (UINavigationController *)kRootViewController;
    for (NSInteger i = [nav.viewControllers count] - 1; i >= 0  ;i-- )
    {
        UIViewController *contro = [nav.viewControllers objectAtIndex:i];
        
        if ([contro isKindOfClass:NSClassFromString(className)])
        {
            
            return contro;
            
        }
    }
    return nil;
}
-(BOOL)popToViewControllWithClassName:(NSString *)className
{
    BOOL isFind = NO;
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController * nav = (UINavigationController *)kRootViewController;
    for (NSInteger i = [nav.viewControllers count] - 1; i >= 0  ;i-- )
    {
        UIViewController *contro = [nav.viewControllers objectAtIndex:i];
        
        if ([contro isKindOfClass:NSClassFromString(className)])
        {
            [nav popToViewController:contro animated:YES];
            isFind = YES;
            return isFind;
            //            break;
        }
    }
    return isFind;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark tabcell
-(UITableViewCell *)getTabbleViewCellFrom:(id)sender
{
    UIView *tempview = sender;//[sender superview];
    for (int i = 0;i < 6 ; i++)
    {
        tempview = [tempview superview];
        if ([tempview isKindOfClass:[UITableViewCell class]])
        {
            break;
        }
    }
    UITableViewCell *view =(UITableViewCell *)tempview;
    return view;
}
-(UITableView *)getTabbleViewFrom:(id)sender
{
    UIView *tempview = sender;//[sender superview];
    for (int i = 0;i < 8 ; i++)
    {
        tempview = [tempview superview];
        if ([tempview isKindOfClass:[UITableView class]])
        {
            break;
        }
    }
    UITableView *view =(UITableView *)tempview;
    return view;
    
}
@end
