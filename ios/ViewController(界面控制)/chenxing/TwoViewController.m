//
//  TwoViewController.m
//  BaseProject
//
//  Created by janker on 2018/11/3.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "TwoViewController.h"
#import "RequestCacheAction.h"
#import "Response.h"
#import "NVLogManager.h"
#import "NetWorkCenter.h"
@interface TwoViewController ()
//@property (strong, nonatomic) RequestAction *request;
@end

@implementation TwoViewController

- (void)viewDidLoad {
    self.leftNavBtnName = @"返回";
    self.title = @"two";
    self.rightNavBtnName = @"保存";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.contentView addSubview:button];
    [button setTitle:@"click" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    self.contentView.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)buttonPressed:(id)sender
{
    //
    RequestAction *request = [[RequestAction alloc] init];
//    request = [[RequestAction alloc] init];
    [request.parm setObject:@"111111" forKey:@"account"];
    //[request.baseUrl ];
    
    request.delegate = self;
    
    [request addAccessory:self];
//    request.tag = -1;//不取消的请求
    request.tag = 1;
    
    
    [request request_getRegisterAddress];
    return;
    //    [self configHttpRequest];
    
//    NSString *pastr = @"languageType=CN&ProductID=874f8131-877a-44ba-87a9-12d02a2cc185&SystemType=ANDROID26&wsmver=5.54&TimeStamp=1540879006556&checkInfo=FFC86C3283F7E768A58F9788EB925B9F";
//    NSArray *array = [pastr componentsSeparatedByString:@"&"];
//    RequestCacheAction *request = [[RequestCacheAction alloc] init];
//    for (NSString *str in array)
//    {
//        NSArray *temp = [str componentsSeparatedByString:@"="];
//        if ([temp count] > 1)
//        {
//            [request.parm setObject:temp[1] forKey:temp[0]];
//        }
//    }
//    //[request.baseUrl ];
//    request.delegate = self;
//    //中请求的监听
//    [request addAccessory:self];
//    [request request_ControlPwdPassword];
    
    [[NVLogManager shareInstance] uploadFileLogWithBlock:^(NSString *logFilePath) {
        NSString * content_IOS = [NomalUtil gb2312StringToString:[NSString stringWithFormat:@"000_Base_IOS"]];
        NSDictionary *paraM = [NSDictionary dictionaryWithObjectsAndKeys:logFilePath,@"error",content_IOS,@"idc",@"000",@"type", nil];
        
        
        [NetWorkCenter uploadErrorFileFromData:paraM methodName:@"" progress:^(NSProgress *progress) {
            
        } success:^(id responseObject) {
            if (responseObject && [responseObject isEqualToString:@"1"])
            {

                [self showViewMessage:@"上传成功"];
            }
            else
            {

                [self showViewMessage:@"上传失败"];
            }
            
        } failure:^(NSError *error) {

            [self showViewMessage:@"上传失败"];
        }];

        
    }];
//    [self pushToViewWithClassName:@"TwoViewController"];
}

-(void)requestFinished:(__kindof YTKBaseRequest *)request
{
    if (request.tag == 1)
    {
        
    }
    else if ([request.requestUrl containsString:@"ControlPwdPassword.ashx"])
    {
        //request.responseString
        Response *res = [Response modelWithJSON:request.responseData];
        
        NSLog(@"requestFinished111=%@",[res modelDescription]);
    }
    NSLog(@"requestFinished");
}
-(void)requestFailed:(__kindof YTKBaseRequest *)request
{
    NSLog(@"requestFailed");
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
-(UIView *)targetTransitionView
{
    return self.view;
}


/**
 *  是否是需要实现转场效果，不需要转场动画可不实现，需要必须实现并返回YES
 *
 *  @return 是否
 */
-(BOOL)isNeedTransition
{
    return YES;
}
@end
