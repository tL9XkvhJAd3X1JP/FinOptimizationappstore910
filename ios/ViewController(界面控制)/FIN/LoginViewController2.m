//
//  LoginViewController.m
//  BaseProject
//
//  Created by janker on 2019/1/22.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "LoginViewController2.h"
#import "CustomView.h"
//#import "VersionModel.h"
#import "UserInfoModel.h"
#import "WQCodeScanner.h"
@interface LoginViewController2 ()
@property (nonatomic, strong)CustomView *item1;
@property (nonatomic, strong)CustomView *item2;
@end

@implementation LoginViewController2
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
    
//    NSArray* array = [[DataBaseUtil instance] findAllObjsByClass:NSClassFromString(@"UserInfoModel")];
//    if (array != nil && [array count] > 0)
//    {
//        [SingleDataManager instance].userInfoModel = [array objectAtIndex:0];
//        [self pushToViewWithClassName:@"MainViewController" animate:NO];
//
//        //后台进行一次登录较验
//        RequestAction *request = [[RequestAction alloc] init];
//        //登录账号(必填)
//        [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.loginname forKey:@"loginname"];
//        [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.password forKey:@"password"];//md5后的
//
//        [request request_getInfoByCustomerId_success:^(__kindof YTKBaseRequest * _Nonnull request)
//         {
//             //request.responseString
//             Response *response =  [Response modelWithJSON:request.responseData];
//             //         NSLog(@"%@",response);
//             if ([@"10000" isEqualToString:response.code])
//             {
//                 UserInfoModel *mode = [UserInfoModel modelWithJSON:response.data];
//                 //密码要相同
//                 if (mode != nil && mode.password != nil && [mode.password isEqualToString:[SingleDataManager instance].userInfoModel.password])
//                 {
//                     [[DataBaseUtil instance] updateClassWidthObj:mode searchKey:@"customerid" searchValue:mode.customerid];
//                     [SingleDataManager instance].userInfoModel = [[[DataBaseUtil instance] findAllObjsByClass:NSClassFromString(@"UserInfoModel")] objectAtIndex:0];
//                 }
//                 else
//                 {
//                     //密码不同的时候
//                     [SingleDataManager instance].userInfoModel = nil;
//                     [[DataBaseUtil instance] deleteObjWithClass:NSClassFromString(@"UserInfoModel")];
//                     [self pushToViewWithClassName:@"LoginViewController"];
//
//                 }
//
//             }
//
//
//         } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//         }];
//    }
   
    // Do any additional setup after loading the view from its nib.
}
-(void)initAllView
{
    self.view.backgroundColor = Color_ViewBackground_blue;
    UIImageView *imageView = (UIImageView *)[self.view getSubViewInstanceWith:[UIImageView class]];
//    imageView.frame = self.view.frame;
    UIImage *image = IMAGE_NAMED(@"背景login@2x");
    [imageView setFrameInSuperViewCenterTop:nil toTopSpace:0 width:[self.view getPicScaleLen2:image.size.width] height:[self.view getPicScaleLen2:image.size.height]];
    imageView.image = image;
    UILabel *lable1 = (UILabel *)[self.view getSubViewInstanceWith:[UILabel class]];
    
    lable1.font = [UIFont boldSystemFontOfSize:40];
    lable1.textColor = Color_Nomal_Font_White;
    lable1.text = @"登 录";
    [lable1 setFrameInSuperViewLeftTop:nil toLeftSpace:30 toTopSpace:100 width:100 height:50];
    [lable1 setFrameInSuperViewCenterTop:nil toTopSpace:100 width:100 height:50];
    
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
    lable.hidden = YES;
    UITextField *textField = [_item1 viewWithTag:2];
    textField.textColor = Color_Nomal_Font_Gray;
    textField.font = FFont_Default;
    textField.placeholder = @"输入账号";
//    [textField setFrameLeftTopFromViewRightTop:lable rightToLeftSpace:10 topToTop:0 width:_item1.width - lable.right - 10 height:30];
    textField.frame = Rect(10, 0, _item1.width - 20, _item1.height);
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
    lable.hidden = YES;
    
    textField = [_item2 viewWithTag:2];
    textField.textColor = Color_Nomal_Font_Gray;
    textField.font = FFont_Default;
    textField.secureTextEntry = YES;
    [textField setFrameLeftTopFromViewRightTop:lable rightToLeftSpace:10 topToTop:0 width:_item2.width - lable.right - 10 height:30];
    textField.placeholder = @"输入密码";
    textField.frame = Rect(10, 0, _item2.width - 20, _item2.height);
//    UIButton *button = (UIButton *)[self.view getSubViewInstanceWith:[UIButton class]];
//    [button setTitle:@"找回用户名>>" forState:UIControlStateNormal];
//    [button setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
//    button.titleLabel.font = FFont_Default_Small;
//
//    [button setFrameRightTopFromViewRightBottom:_item2 rightToRightSpace:0 bottomToTopSpace:10 width:[button.titleLabel.text widthForFont:button.titleLabel.font] height:30];
//    [button addTarget:self action:@selector(buttonPressed1:) forControlEvents:UIControlEventTouchUpInside];
//    UIButton *button2 = (UIButton *)[self.view getSubViewInstanceWith:[UIButton class]];
//    [button2 setTitle:@"找回密码>>" forState:UIControlStateNormal];
//    [button2 setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
//    button2.titleLabel.font = FFont_Default_Small;
//    [button2 setFrameRightTopFromViewLeftTop:button leftToRightSpace:10 topToTopSpace:0 width:[button2.titleLabel.text widthForFont:button2.titleLabel.font] height:30];
//    [button2 addTarget:self action:@selector(buttonPressed2:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = (UIButton *)[self.view getSubViewInstanceWith:[UIButton class]];
    [button3 setTitle:@"登 录" forState:UIControlStateNormal];
    [button3 setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
    button3.backgroundColor = Color_button_Bg_half_white;
    button3.titleLabel.font = FFont_Default;
    [button3 setCornerRadius:4];
    [button3 setFrameLeftTopFromViewLeftBottom:_item2 leftToLeftSpace:0 bottomToTopSpace:100 width:_item2.width height:40];
    
  
    [button3 addTarget:self action:@selector(buttonPressed3:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *button4 = (UIButton *)[self.view getSubViewInstanceWith:[UIButton class]];
//    [button4 setTitle:@"还没有注册，马上去注册" forState:UIControlStateNormal];
//    [button4 setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
//    button4.backgroundColor = Color_Clear;
//    button4.titleLabel.font = FFont_Default;
//    [button4 setFrameLeftTopFromViewLeftBottom:button3 leftToLeftSpace:0 bottomToTopSpace:10 width:_item2.width height:40];
//
//
//    [button4 addTarget:self action:@selector(buttonPressed4:) forControlEvents:UIControlEventTouchUpInside];
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
    if (true)
    {
        [self pushToViewWithClassName:@"EarlyWarningCenterViewController" animate:NO];
//        [self showCustomAlertViewWithTitle:@"修改密码" okButtonTitle:@"确 定" cancelBlock:nil okBlock:^(NSMutableDictionary *dic) {
//
//        }];
        return;
    }
    
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

-(void)showCustomAlertViewWithTitle:(NSString *)title okButtonTitle:(NSString *)okButtonTitle cancelBlock:(void(^)(void))cancelBlock okBlock:(void(^)(NSMutableDictionary*dic))okBlock
{
    
    //__weak
//    CGFloat spaceX = 15;
//    CGFloat spaceY = 15;
    __weak CustomView *alertView = (CustomView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomView5"
                                                                                owner:self
                                                                              options:nil]
                                                  objectAtIndex:0];
    [self.view addSubview:alertView];
    [alertView renderModifyPasswrodViewWithTitle:title okButtonTitle:okButtonTitle cancelBlock:cancelBlock okBlock:okBlock];
//    [alertView setFrameInSuperViewCenter:nil width:ScreenWidth height:ScreenHeight];
//    alertView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.7];
//    alertView.view1.backgroundColor = [UIColor whiteColor];
//    [alertView.view1 setCornerRadius:11];
//    alertView.view1.width = ScreenWidth - spaceX*4;
//    UIImage *image = IMAGE_NAMED(@"关闭k8");
//    [alertView.button2 setFrameInSuperViewRightTop:nil toRightSpace:0 toTopSpace:0 width:[self.view getPicScaleLen2:image.size.width] height:[self.view getPicScaleLen2:image.size.height]];
//    [alertView.button2 setBackgroundImage:image forState:UIControlStateNormal];
//    [alertView.button2 setBackgroundImage:IMAGE_NAMED(@"关闭按下k8") forState:UIControlStateHighlighted];
//    if (title == nil)
//    {
//        title = @"";
//    }
//    alertView.label.text = title;
//    alertView.label.font = FFont_Default_Big;
//    alertView.label.textColor = Color_Nomal_Font_Blue;
//    [alertView.label setFrameInSuperViewLeftTop:nil toLeftSpace:spaceX toTopSpace:spaceY width:alertView.view1.width - alertView.button2.width - 3 height:-2];
////    if (message == nil)
////    {
////        message = @"";
////    }
////
////    alertView.label2.text = message;
////    alertView.label2.font = FFont_Default;
////    alertView.label2.textColor = [UIColor grayColor];
////    alertView.label2.hidden = YES;
////    [alertView.label2 setFrameLeftTopFromViewLeftBottom:alertView.label leftToLeftSpace:0 bottomToTopSpace:spaceY*2 width:alertView.view1.width - spaceX *2 height:-2];
//
//
//
//    alertView.view2.layer.cornerRadius = 5;
//    alertView.view2.layer.borderWidth = 1;
//    alertView.view2.layer.borderColor = Color_border.CGColor;
//
//    alertView.view3.layer.cornerRadius = 5;
//    alertView.view3.layer.borderWidth = 1;
//    alertView.view3.layer.borderColor = Color_border.CGColor;
//    [alertView.view2 setFrameInSuperViewCenterTop:nil toTopSpace:alertView.label.bottom + 20 width:alertView.view1.width - spaceX *2 height:40];
//    alertView.textField.frame = Rect(5, 0, alertView.view2.width-10, alertView.view2.height);
//    [alertView.view3 setFrameLeftTopFromViewLeftBottom:alertView.view2 leftToLeftSpace:0 bottomToTopSpace:15 width:alertView.view2.width height:40];
//    alertView.textField2.frame = Rect(5, 0, alertView.view3.width - 57, alertView.view3.height);
//    //54 × 48
//
//    alertView.textField.placeholder = @"旧密码";
//    alertView.textField2.placeholder = @"新密码";
//    alertView.textField2.secureTextEntry = YES;
//    alertView.textField2.delegate = self;
//    alertView.textField.delegate = self;
//    [alertView.button3 setImage:[UIImage imageNamed:@"VIEWOFF"] forState:UIControlStateNormal];
//    [alertView.button3 setFrameInSuperViewHeightCenterAndRight:nil toRightSpace:10 width:27 height:24];
//    [alertView.button3 addTapBlock:^(UIButton *btn) {
//        if (alertView.textField2.secureTextEntry)
//        {
//            alertView.textField2.secureTextEntry = NO;
//
//            [alertView.button3 setImage:[UIImage imageNamed:@"VIEWOFF"] forState:UIControlStateNormal];
//        }
//        else
//        {
//            alertView.textField2.secureTextEntry = NO;
//
//            [alertView.button3 setImage:[UIImage imageNamed:@"VIEW"] forState:UIControlStateNormal];
//        }
//    }];
//    [alertView.button1 setFrameLeftTopFromViewLeftBottom:alertView.view3 leftToLeftSpace:0 bottomToTopSpace:spaceY*2 width:alertView.view1.width - spaceX *2 height:40];
//
//    [alertView.button1 setCornerRadius:4];
//    alertView.button1.backgroundColor = Color_Nomal_Bg;
//    [alertView.button1 setTitle:okButtonTitle forState:UIControlStateNormal];
//
//    alertView.view1.height = alertView.button1.bottom + spaceY;
//    alertView.view1.center = alertView.center;
//
//    //cancel
//    [alertView.button2 addTapBlock:^(UIButton *btn) {
//
//        [alertView removeFromSuperview];
//        if (cancelBlock != nil)
//        {
//            cancelBlock();
//        }
//
//
//    }];
//    //ok
//    [alertView.button1 addTapBlock:^(UIButton *btn) {
//        [alertView removeFromSuperview];
//        if (okBlock != nil)
//        {
//            okBlock();
//        }
//
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

@end
