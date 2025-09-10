//
//  OneViewController.m
//  BaseProject
//
//  Created by janker on 2018/11/3.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "OneViewController.h"
#import "Response.h"
#import "UploadFileRequest.h"
#import "FileUploadAction.h"
#import "RootWebViewController.h"
#import "RootNavigationController.h"
#import "BMKPolygonOverlayPage.h"
#import "LoginViewController.h"
@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    //DLog(@"%@",AppVersion);
    //self.view.frame = ScreenBounds;
    self.title = @"第一个界面";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.tag = -100;
    [self.contentView addSubview:button];
    [button setTitle:@"click" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.contentView.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UITextField *filed =[[UITextField alloc] init];
    filed.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:filed];
    [filed setFrameLeftTopFromViewLeftBottom:button leftToLeftSpace:10 bottomToTopSpace:10 width:ScreenWidth_Content - 20 height:40];
    
    UITextField *filed2 =[[UITextField alloc] init];
    filed2.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:filed2];
    [filed2 setFrameLeftTopFromViewLeftBottom:filed leftToLeftSpace:0 bottomToTopSpace:10 width:ScreenWidth_Content - 20 height:40];
    [super viewDidLoad];
    self.contentView.backgroundColor = [UIColor redColor];
    UIView *temp = [[UIView alloc] initWithFrame:Rect(0, 0, 50, 50)];
    temp.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:temp];
    temp.bottom = self.contentView.height - SAFE_AREA_INSETS_BOTTOM;
    
    DLog(@"%f   %f",SAFE_AREA_INSETS_TOP,SAFE_AREA_INSETS_BOTTOM);
    //https://github.com/squarefrog/UIDeviceIdentifier
//    self.contentView.addi
//    self.contentView.additionalSafeAreaInsets.bottom = 34.f;
//    DLog(@"%@",NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    UIEdgeInsets newSafeAreaInsets = self.view.safeAreaInsets;
//    CGFloat rightViewWidth = 0;
//    CGFloat bottomViewHeight = 49;
//    newSafeAreaInsets.right += rightViewWidth;
//    newSafeAreaInsets.bottom += bottomViewHeight;
//    self.additionalSafeAreaInsets = newSafeAreaInsets;
//    self.view.safeAreaLayoutGuide
}


//-(void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    DLog(@"%@",NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
//}
//handleRequestResult
-(void)requestFinished:(__kindof YTKBaseRequest *)request
{
    static int num = 0;
    num ++;
    DLog(@"===========%d",num);
    if ([request.requestUrl containsString:@"ControlPwdPassword.ashx"])
    {
        //request.responseString
        Response *res = [Response modelWithJSON:request.responseData];
        
        NSLog(@"requestFinished111=%@",[res modelDescription]);
    }
    NSLog(@"requestFinished");
}
-(void)requestFailed:(__kindof YTKBaseRequest *)request
{
    static int num = 0;
    num ++;
    DLog(@"requestFailed===========%d",num);
    NSLog(@"requestFailed");
}






-(void)buttonPressed:(id)sender
{
//    LoginViewController *log = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    [self.navigationController pushViewController:log animated:YES];
    //    [self configHttpRequest];
//    LoginViewController *log =[[LoginViewController alloc] init];
//    [self.navigationController pushViewController:log animated:YES];
    //TwoViewController BMKPolygonOverlayPage LoginViewController
//    [self pushToViewWithClassName:@"TwoViewController"];
    [self pushToViewWithClassName:@"LoginViewController"];
//    [self.navigationController pushViewController:[[BMKPolygonOverlayPage alloc] init] animated:YES];
//    [kAppDelegate appStartWithView:@"RootWebViewController"];
//    [kAppDelegate appStartWithView:@"MainTabBarController"];
 //    RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:webView];
//    [self presentViewController:loginNavi animated:YES completion:^{
//
//    }];
//    [self.navigationController pushViewController:webView animated:YES];
//    [self.viewDic setObject:@"http://hao123.com" forKey:@"url"];
//    [self pushToViewWithClassName:@"RootWebViewController"];
    return;
    NSString *pastr = @"languageType=CN&ProductID=874f8131-877a-44ba-87a9-12d02a2cc185&SystemType=ANDROID26&wsmver=5.54&TimeStamp=1540879006556&checkInfo=FFC86C3283F7E768A58F9788EB925B9F";
    NSArray *array = [pastr componentsSeparatedByString:@"&"];
    RequestAction *request = [[RequestAction alloc] init];
    for (NSString *str in array)
    {
        NSArray *temp = [str componentsSeparatedByString:@"="];
        if ([temp count] > 1)
        {
            [request.parm setObject:temp[1] forKey:temp[0]];
        }
    }
    //[request.baseUrl ];
    
    request.delegate = self;
    //request.tag = -1;//不取消的请求
    [request addAccessory:self];
//    [request request_ControlPwdPassword];

    
    
    
    
    FileUploadAction *request2 = [[FileUploadAction alloc] init];
    request2.filePath = [NVLogManager shareInstance].getCurrentLogFilePath;
    request2.fileToServerName = @"error";
    request2.delegate = self;
    [request2 addAccessory:self];
    NSString * content_IOS = [NomalUtil gb2312StringToString:[NSString stringWithFormat:@"Base_IOS"]];
    [request2.parm setObjectFilterNull:content_IOS forKey:@"idc"];
    [request2.parm setObjectFilterNull:@"000" forKey:@"type"];
    [request2 setUploadProgressBlock_file:^(UploadFileRequest * _Nonnull request, NSProgress * _Nonnull progress) {
        
    }];
    [request2 setDownloadProgressBlock_file:^(UploadFileRequest * _Nonnull request, NSProgress * _Nonnull progress) {
        
    }];
    [request2 request_errorReport];
    
//    [[YTKNetworkAgent sharedAgent] cancelRequest:req];
//    [[YTKNetworkAgent sharedAgent] cancelAllRequests];
//    [self pushToViewWithClassName:@"TwoViewController"];
    
//    [[YTKNetworkAgent sharedAgent] cancelRequest:<#(nonnull YTKBaseRequest *)#>]
//    [[YTKNetworkAgent sharedAgent] cancelAllRequests];
    
    
    
    //    RequestAction *request = [[RequestAction alloc] init];
    //    [request.parm setObject:@"IOS" forKey:@"type"];
    //    [request.parm setObject:@"1" forKey:@"userId"];
    //    [request.parm setObject:@"1.6" forKey:@"ver"];
    //    request.delegate = self;
    //    [request request_update];
    
    
    //    NSLog(@"==%@",[request description]);
    //    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
    //        NSLog(@"succeed");
    //    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    //        NSLog(@"failure");
    //    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark- XYTransitionProtocol
/**
 转场动画的目标View 需要转场动画的对象必须实现该方法并返回要做动画的View
 
 @return view
 */
//-(UIView *)targetTransitionView
//{
//    return [self.view viewWithTag:-100];
//}


/**
 *  是否是需要实现转场效果，不需要转场动画可不实现，需要必须实现并返回YES
 *
 *  @return 是否
 */
//-(BOOL)isNeedTransition
//{
//    return YES;
//}
@end
