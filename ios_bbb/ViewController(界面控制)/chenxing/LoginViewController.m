//
//  LoginViewController.m
//  BaseProject
//
//  Created by janker on 2019/1/22.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomView.h"
//#import "VersionModel.h"
#import "UserInfoModel.h"
#import "WQCodeScanner.h"
@interface LoginViewController ()
@property (nonatomic, strong)CustomView *item1;
@property (nonatomic, strong)CustomView *item2;
@end

@implementation LoginViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:[self className] bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([viewDic objectForKey:@"loginName_select"] != nil)
    {
        UITextField *textField1 = [_item1 viewWithTag:2];
        textField1.text = [viewDic objectForKey:@"loginName_select"];
        [viewDic removeObjectForKey:@"loginName_select"];
    }
    [super viewWillAppear:animated];
}
-(void)loadView
{
    self.navType = 2;
    [super loadView];
}
- (void)viewDidLoad
{
//    NSLog(@"%d",self.view.tag);

    [super viewDidLoad];
    [self initAllView];
    NSArray* array = [[DataBaseUtil instance] findAllObjsByClass:NSClassFromString(@"UserInfoModel")];
    if (array != nil && [array count] > 0)
    {
        [SingleDataManager instance].userInfoModel = [array objectAtIndex:0];
        [self pushToViewWithClassName:@"MainViewController" animate:NO];
       
        //后台进行一次登录较验
        RequestAction *request = [[RequestAction alloc] init];
        //登录账号(必填)
        [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.loginname forKey:@"loginname"];
        [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.password forKey:@"password"];//md5后的
        
//        [request request_getLoginInfo_success:^(__kindof YTKBaseRequest * _Nonnull request)
//        {
//            //request.responseString
//            Response *response =  [Response modelWithJSON:request.responseData];
//            //         NSLog(@"%@",response);
//            if ([@"10000" isEqualToString:response.code])
//            {
//                UserInfoModel *mode = [UserInfoModel modelWithJSON:response.data];
//                [[DataBaseUtil instance] updateClassWidthObj:mode searchKey:@"customerid" searchValue:mode.customerid];
//                [SingleDataManager instance].userInfoModel = [[[DataBaseUtil instance] findAllObjsByClass:NSClassFromString(@"UserInfoModel")] objectAtIndex:0];
//            }
//            else
//            {
//
//                [SingleDataManager instance].userInfoModel = nil;
//                //            [[DataBaseUtil instance] updateClassWidthObj:mode searchKey:@"userId" searchValue:mode.userId];
//                [[DataBaseUtil instance] deleteObjWithClass:NSClassFromString(@"UserInfoModel")];
//                [self pushToViewWithClassName:@"LoginViewController"];
//            }
//
//        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//        }];
        [request request_getInfoByCustomerId_success:^(__kindof YTKBaseRequest * _Nonnull request)
         {
             //request.responseString
             Response *response =  [Response modelWithJSON:request.responseData];
             //         NSLog(@"%@",response);
             if ([@"10000" isEqualToString:response.code])
             {
                 UserInfoModel *mode = [UserInfoModel modelWithJSON:response.data];
                 //密码要相同
                 if (mode != nil && mode.password != nil && [mode.password isEqualToString:[SingleDataManager instance].userInfoModel.password])
                 {
                     [[DataBaseUtil instance] updateClassWidthObj:mode searchKey:@"customerid" searchValue:mode.customerid];
                     [SingleDataManager instance].userInfoModel = [[[DataBaseUtil instance] findAllObjsByClass:NSClassFromString(@"UserInfoModel")] objectAtIndex:0];
                 }
                 else
                 {
                     //密码不同的时候
                     [SingleDataManager instance].userInfoModel = nil;
                     [[DataBaseUtil instance] deleteObjWithClass:NSClassFromString(@"UserInfoModel")];
                     [self pushToViewWithClassName:@"LoginViewController"];
                     
                 }
                 
             }
           
             
         } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
             
         }];
    }
   
    // Do any additional setup after loading the view from its nib.
}
-(void)initAllView
{
    UIImageView *imageView = (UIImageView *)[self.view getSubViewInstanceWith:[UIImageView class]];
    imageView.frame = self.view.frame;
    imageView.image = IMAGE_NAMED(@"login_bg");
    UILabel *lable1 = (UILabel *)[self.view getSubViewInstanceWith:[UILabel class]];
    
    lable1.font = [UIFont boldSystemFontOfSize:40];
    lable1.textColor = Color_Nomal_Font_White;
    lable1.text = @"登 录";
    [lable1 setFrameInSuperViewLeftTop:nil toLeftSpace:30 toTopSpace:100 width:100 height:50];
    
    _item1 = (CustomView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomView1"
                                                                    owner:self
                                                                  options:nil]
                                      objectAtIndex:0];
    [self.view addSubview:_item1];
    _item1.backgroundColor = Color_Nomal_Font_White;
    [_item1 setCornerRadius:4];
    [_item1 setFrameInSuperViewLeftTop:nil toLeftSpace:20 toTopSpace:180 width:ScreenWidth - 40 height:40];
    UILabel *lable = [_item1 viewWithTag:1];
    lable.text = @"用户名";
    lable.textColor = Color_Nomal_Font_Gray;
    lable.font = FFont_Default;
    [lable setFrameInSuperViewCenter:nil width:[lable.text widthForFont:lable.font] height:30];
    lable.left = Space_Normal;
    
    UITextField *textField = [_item1 viewWithTag:2];
    textField.textColor = Color_Nomal_Font_Gray;
    textField.font = FFont_Default;
    
    [textField setFrameLeftTopFromViewRightTop:lable rightToLeftSpace:10 topToTop:0 width:_item1.width - lable.right - 10 height:30];
    
    _item2 = (CustomView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomView1"
                                                         owner:self
                                                       options:nil]
                           objectAtIndex:0];
    [self.view addSubview:_item2];
    _item2.backgroundColor = Color_Nomal_Font_White;
    [_item2 setCornerRadius:4];
    [_item2 setFrameLeftTopFromViewLeftBottom:_item1 leftToLeftSpace:0 bottomToTopSpace:30 width:_item1.width height:40];
    
    lable = [_item2 viewWithTag:1];
    lable.text = @"密码";
    lable.textColor = Color_Nomal_Font_Gray;
    lable.font = FFont_Default;
    [lable setFrameInSuperViewCenter:nil width:[lable.text widthForFont:lable.font] height:30];
    lable.left = Space_Normal;
    
    
    textField = [_item2 viewWithTag:2];
    textField.textColor = Color_Nomal_Font_Gray;
    textField.font = FFont_Default;
    textField.secureTextEntry = YES;
    [textField setFrameLeftTopFromViewRightTop:lable rightToLeftSpace:10 topToTop:0 width:_item2.width - lable.right - 10 height:30];
    
    UIButton *button = (UIButton *)[self.view getSubViewInstanceWith:[UIButton class]];
    [button setTitle:@"找回用户名>>" forState:UIControlStateNormal];
    [button setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
    button.titleLabel.font = FFont_Default_Small;
    
    [button setFrameRightTopFromViewRightBottom:_item2 rightToRightSpace:0 bottomToTopSpace:10 width:[button.titleLabel.text widthForFont:button.titleLabel.font] height:30];
    [button addTarget:self action:@selector(buttonPressed1:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button2 = (UIButton *)[self.view getSubViewInstanceWith:[UIButton class]];
    [button2 setTitle:@"找回密码>>" forState:UIControlStateNormal];
    [button2 setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
    button2.titleLabel.font = FFont_Default_Small;
    [button2 setFrameRightTopFromViewLeftTop:button leftToRightSpace:10 topToTopSpace:0 width:[button2.titleLabel.text widthForFont:button2.titleLabel.font] height:30];
    [button2 addTarget:self action:@selector(buttonPressed2:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = (UIButton *)[self.view getSubViewInstanceWith:[UIButton class]];
    [button3 setTitle:@"登 录" forState:UIControlStateNormal];
    [button3 setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
    button3.backgroundColor = Color_button_Bg;
    button3.titleLabel.font = FFont_Default;
    [button3 setCornerRadius:4];
    [button3 setFrameLeftTopFromViewLeftBottom:_item2 leftToLeftSpace:0 bottomToTopSpace:100 width:_item2.width height:40];
    
  
    [button3 addTarget:self action:@selector(buttonPressed3:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button4 = (UIButton *)[self.view getSubViewInstanceWith:[UIButton class]];
    [button4 setTitle:@"还没有注册，马上去注册" forState:UIControlStateNormal];
    [button4 setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
    button4.backgroundColor = Color_Clear;
    button4.titleLabel.font = FFont_Default;
    [button4 setFrameLeftTopFromViewLeftBottom:button3 leftToLeftSpace:0 bottomToTopSpace:10 width:_item2.width height:40];
    
    
    [button4 addTarget:self action:@selector(buttonPressed4:) forControlEvents:UIControlEventTouchUpInside];
}
//注册
-(void)buttonPressed4:(UIButton *)button
{
//    [viewDic setObjectFilterNull:@"找回用户名" forKey:@"viewTitle"];
    [self pushToViewWithClassName:@"RegisterViewController"];
    
}
//找回用户名
-(void)buttonPressed1:(UIButton *)button
{
    [viewDic setObjectFilterNull:@"找回用户名" forKey:@"viewTitle"];
    [self pushToViewWithClassName:@"FindUserNameViewController"];
    
}
//找回密码
-(void)buttonPressed2:(UIButton *)button
{
    [viewDic setObjectFilterNull:@"找回密码" forKey:@"viewTitle"];
    [self pushToViewWithClassName:@"FindPasswrodViewController"];
    
//    [self scanData];
}
//扫描二维码
-(void)scanData
{
    MAIN((^{
        WQCodeScanner *scanner = [[WQCodeScanner alloc] initWidth:WQCodeScannerTypeQRCode];
        
        scanner.resultBlock = ^(NSString *value) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:value message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
            
        };
        [self presentViewController:scanner animated:YES completion:nil];
        
    }));
    
}
//登录
-(void)buttonPressed3:(UIButton *)button
{
    UITextField *textField1 = [_item1 viewWithTag:2];
    UITextField *textField2 = [_item2 viewWithTag:2];
    if (![NomalUtil isValueableString:textField1.text])
    {
        [self showViewMessage:@"用户名不能为空!"];
        return;
    }
    else if (![NomalUtil isValueableString:textField2.text])
    {
        [self showViewMessage:@"密码不能为空!"];
        return;
    }
    RequestAction *request = [[RequestAction alloc] init];
    
    
    //[request.baseUrl ];
    
    request.delegate = self;
    
    [request addAccessory:self];
    request.tag = 1;
   
    //登录账号(必填)
    [request.parm setObjectFilterNull:textField1.text forKey:@"loginname"];
    [request.parm setObjectFilterNull:[textField2.text md5] forKey:@"password"];
    
    [request request_getLoginInfo];

//    [self pushToViewWithClassName:@"MainViewController"];
//    [self getIpAndVersionRequest];
}
#pragma mark -responseData
-(void)requestFinished:(__kindof YTKBaseRequest *)request
{
    
    if (request.tag == 1)
    {
//        NSLog(@"-------------------++++");
        //request.responseString
        Response *response =  [Response modelWithJSON:request.responseData];
        //         NSLog(@"%@",response);
        if ([@"10000" isEqualToString:response.code])
        {
            UserInfoModel *mode = [UserInfoModel modelWithJSON:response.data];
            [SingleDataManager instance].userInfoModel = mode;
//            [[DataBaseUtil instance] updateClassWidthObj:mode searchKey:@"userId" searchValue:mode.userId];
            [[DataBaseUtil instance] deleteObjWithClass:NSClassFromString(@"UserInfoModel")];
            [[DataBaseUtil instance] addClassWidthObj:mode];
            NSLog(@"%@",mode);
            [self pushToViewWithClassName:@"MainViewController"];
            UITextField *textField1 = [_item1 viewWithTag:2];
            UITextField *textField2 = [_item2 viewWithTag:2];
            textField1.text = nil;
            textField2.text = nil;
        }
        else
        {
            [self showViewMessage:response.message];
        }
        
        
        
    }
   
   
    
}
-(void)requestFailed:(__kindof YTKBaseRequest *)request
{
    [super requestFailed:request];
}
//-(void)getIpAndVersionRequest
//{
//    //http://118.26.142.213:8080/upgrade/version/channelClient?CustomerFlag=RENT&clientType=2&timestamp=1548827743049
//    //ZXKY
//    RequestAction *request = [[RequestAction alloc] init];
//    [request.parm setObjectFilterNull:Client_Type forKey:@"clientType"];
//    [request.parm setObjectFilterNull:Customer_Flag forKey:@"CustomerFlag"];
//    [request.parm setObjectFilterNull:[NSString stringWithFormat:@"%f",IOSVersion] forKey:@"SystemVersion"];
//    [request.parm setObjectFilterNull:Customer_Version forKey:@"version"];
//    [request.parm setObjectFilterNull:AppVersion forKey:@"AppVersion"];
//    [request.parm setObjectFilterNull:[NomalUtil getCurrentTimeWithLongLongNum] forKey:@"timestamp"];
//    [request.parm setObjectFilterNull:@"2" forKey:@"platform"];
//
//    [request request_GetIP_success:^(__kindof YTKBaseRequest * _Nonnull request)
//     {
////         NSLog(@"%@",request.responseData);
//         Response *response =  [Response modelWithJSON:request.responseData];
////         NSLog(@"%@",response);
//         VersionModel *mode = [VersionModel modelWithJSON:response.data];
//         [SingleDataManager instance].versionModel = mode;
//         //singdata 换url在内存  url拼接部分要修改 main_url全局找
////         request.responseData
////        NSLog(@"%@",mode);
//
//     } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//     }];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
