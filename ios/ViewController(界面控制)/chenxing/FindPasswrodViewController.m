//
//  FindPasswrodViewController.m
//  BaseProject
//
//  Created by janker on 2019/1/25.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "FindPasswrodViewController.h"

@interface FindPasswrodViewController ()
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *validateCodeTextField;
@property (nonatomic, strong)NSString *validateCode;//
@property (nonatomic, strong) NSTimer *timerClock;
@property (nonatomic, assign) int timeNum;
@property (nonatomic, strong) UIButton *validateCodeButton;
@end

@implementation FindPasswrodViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:[self className] bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    self.leftNavBtnName = @"返回";
    self.title = [self.viewDic objectForKey:@"viewTitle"];
    [viewDic removeObjectForKey:@"viewTitle"];
    [super viewDidLoad];
    [self initAllViews];
    // Do any additional setup after loading the view from its nib.
}
-(void)initAllViews
{
    UIView *bgView = (UIView *)[self.contentView getSubViewInstanceWith:[UIView class]];
    [bgView setFrameInSuperViewCenterTop:nil toTopSpace:20 width:ScreenWidth_Content - Space_Normal*2 height:200];
    [bgView setCornerRadius:4];
    [bgView setBorder:[UIColor lightGrayColor] width:1];
    bgView.backgroundColor = Color_Nomal_Font_White;
    CGFloat lableWidth = 65;
    CGFloat lineSpace = 15;
    UILabel *lable1 = (UILabel *)[bgView getSubViewInstanceWith:[UILabel class]];
    lable1.font = FFont_Default;
    lable1.textColor = [UIColor grayColor];
    lable1.text = @"用户名";
    
    lable1.textAlignment = NSTextAlignmentCenter;
    [lable1 setFrameInSuperViewLeftTop:nil toLeftSpace:10 toTopSpace:15 width:lableWidth height:30];
    
    UITextField *textField1 = (UITextField *)[bgView getSubViewInstanceWith:[UITextField class]];
    textField1.font = FFont_Default;
    textField1.textColor = [UIColor grayColor];
    textField1.placeholder = @"请输入用户名";
    self.accountTextField = textField1;
    [textField1 setFrameLeftTopFromViewRightTop:lable1 rightToLeftSpace:10 topToTop:0 width:bgView.width - lable1.right - 20 height:30];
    UIImageView *lineImg = (UIImageView *)[bgView getSubViewInstanceWith:[UIImageView class]];
    lineImg.backgroundColor = [UIColor lightGrayColor];
    [lineImg setFrameLeftTopFromViewLeftBottom:textField1 leftToLeftSpace:0 bottomToTopSpace:lineSpace/2 width:textField1.width height:1];
    
    UILabel *lable2 = (UILabel *)[bgView getSubViewInstanceWith:[UILabel class]];
    lable2.font = FFont_Default;
    lable2.textColor = [UIColor grayColor];
    lable2.text = @"手机号";
    
    lable2.textAlignment = NSTextAlignmentCenter;
    [lable2 setFrameLeftTopFromViewLeftBottom:lable1 leftToLeftSpace:0 bottomToTopSpace:lineSpace width:lableWidth height:30];
    
    
    UIButton *button2 = (UIButton *)[bgView getSubViewInstanceWith:[UIButton class]];
    self.validateCodeButton = button2;
    [button2 setTitle:@"发送验证码" forState:UIControlStateNormal];
    [button2 setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
    button2.backgroundColor = Color_Nomal_Bg;
    button2.titleLabel.font = FFont_Default_Small;
    [button2 setCornerRadius:4];
    [button2 setFrameRightTopFromViewRightBottom:textField1 rightToRightSpace:0 bottomToTopSpace:lineSpace width:80 height:30];
    [button2 addTarget:self action:@selector(buttonPressed2:) forControlEvents:UIControlEventTouchUpInside];
    UITextField *textField2 = (UITextField *)[bgView getSubViewInstanceWith:[UITextField class]];
    self.phoneTextField = textField2;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    textField2.font = FFont_Default;
    textField2.textColor = [UIColor grayColor];
    textField2.placeholder = @"请输入手机号码";
    textField2.keyboardType = UIKeyboardTypeNumberPad;
    [textField2 setFrameLeftTopFromViewRightTop:lable2 rightToLeftSpace:10 topToTop:0 width:bgView.width - lable2.right - 20 - button2.width height:30];
    UIImageView *lineImg2 = (UIImageView *)[bgView getSubViewInstanceWith:[UIImageView class]];
    lineImg2.backgroundColor = [UIColor lightGrayColor];
    [lineImg2 setFrameLeftTopFromViewLeftBottom:textField2 leftToLeftSpace:0 bottomToTopSpace:lineSpace/2 width:bgView.width - lable2.right - 20 height:1];
    
    UILabel *lable3 = (UILabel *)[bgView getSubViewInstanceWith:[UILabel class]];
    lable3.font = FFont_Default;
    lable3.textColor = [UIColor grayColor];
    lable3.text = @"验证码";
    
    lable3.textAlignment = NSTextAlignmentCenter;
    [lable3 setFrameLeftTopFromViewLeftBottom:lable2 leftToLeftSpace:0 bottomToTopSpace:lineSpace width:lableWidth height:30];
    
    UITextField *textField3 = (UITextField *)[bgView getSubViewInstanceWith:[UITextField class]];
    self.validateCodeTextField = textField3;
    textField3.font = FFont_Default;
    textField3.textColor = [UIColor grayColor];
    textField3.placeholder = @"请输入验证码";
    
    [textField3 setFrameLeftTopFromViewRightTop:lable3 rightToLeftSpace:10 topToTop:0 width:bgView.width - lable3.right - 20 height:30];
//    UIImageView *lineImg3 = (UIImageView *)[bgView getSubViewInstanceWith:[UIImageView class]];
//    lineImg3.backgroundColor = [UIColor lightGrayColor];
//    [lineImg3 setFrameLeftTopFromViewLeftBottom:textField3 leftToLeftSpace:0 bottomToTopSpace:0 width:bgView.width - lable3.right - 20 height:1];
    bgView.height = textField3.bottom + 15;
    
    UIButton *button3 = (UIButton *)[self.contentView getSubViewInstanceWith:[UIButton class]];
    [button3 setTitle:@"提 交" forState:UIControlStateNormal];
    [button3 setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
    button3.backgroundColor = Color_Nomal_Bg;
    button3.titleLabel.font = FFont_Default;
    [button3 setCornerRadius:4];
    [button3 setFrameLeftTopFromViewLeftBottom:bgView leftToLeftSpace:0 bottomToTopSpace:100 width:bgView.width height:40];
    
    
    [button3 addTarget:self action:@selector(buttonPressed3:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)buttonPressed3:(UIButton *)button
{
    if (![NomalUtil isValueableString:_accountTextField.text])
    {
        [self showViewMessage:@"请输入用户名"];
        return;
    }
    else if (![NomalUtil isPhoneNum:_phoneTextField.text])
    {
        [self showViewMessage:@"请输入正确的手机号"];
        return;
    }
//    else if (![NomalUtil isValueableString:_validateCodeTextField.text] || ![self.validateCode isEqualToString:_validateCodeTextField.text])
//    {
//        [self showViewMessage:@"请输入正确的验证码"];
//        return;
//    }
    //提交
    RequestAction *request = [[RequestAction alloc] init];
    
    request.delegate = self;
    
    [request addAccessory:self];
    request.tag = 1;
    
    //账号
    [request.parm setObjectFilterNull:_accountTextField.text forKey:@"loginname"];
    //手机号
    [request.parm setObjectFilterNull:_phoneTextField.text forKey:@"mobilephone"];
    [viewDic setObjectFilterNull:_validateCodeTextField.text forKey:@"validateCode"];
    [request request_checkPhoneAndLoginname];
    
//    [viewDic setObject:_accountTextField.text forKey:@"loginname"];
//    [viewDic setObject:@"设置新密码" forKey:@"viewTitle"];
//    [self pushToViewWithClassName:@"SetNewPasswordViewController"];
}
-(void)buttonPressed2:(UIButton *)button
{
    if (![NomalUtil isPhoneNum:_phoneTextField.text])
    {
        [self showViewMessage:@"请输入正确的手机号"];
        return;
    }
    //发验证码
    RequestAction *request = [[RequestAction alloc] init];
    
    request.delegate = self;
    
    [request addAccessory:self];
    request.tag = 2;
    
    //手机号(必填)
    [request.parm setObjectFilterNull:_phoneTextField.text forKey:@"phone"];
//    [request.parm setObjectFilterNull:_accountTextField.text forKey:@"loginname"];
    //1：注册；2忘记密码；4：绑定手机
    [request.parm setObjectFilterNull:@"2" forKey:@"type"];
    //是否发短信 1是；0否
    [request.parm setObjectFilterNull:@"1" forKey:@"isSend"];
    [request request_sendValidateCode];
    [self startTimeClock];
}
-(void)requestFinished:(__kindof YTKBaseRequest *)request
{
    if (request.tag == 1)
    {
        //request.responseString
        Response *response =  [Response modelWithJSON:request.responseData];
        //         NSLog(@"%@",response);
        if ([@"10000" isEqualToString:response.code])
        {
            [viewDic setObjectFilterNull:_accountTextField.text forKey:@"loginname"];
            [viewDic setObjectFilterNull:@"设置新密码" forKey:@"viewTitle"];
            [viewDic setObjectFilterNull:_validateCodeTextField.text forKey:@"validateCode"];
            [self pushToViewWithClassName:@"SetNewPasswordViewController"];
//            UserInfoModel *mode = [UserInfoModel modelWithJSON:response.data];
//            [SingleDataManager instance].userInfoModel = mode;
//            //            [[DataBaseUtil instance] updateClassWidthObj:mode searchKey:@"userId" searchValue:mode.userId];
//            [[DataBaseUtil instance] deleteObjWithClass:NSClassFromString(@"UserInfoModel")];
//            [[DataBaseUtil instance] addClassWidthObj:mode];
//            NSLog(@"%@",mode);
//            [self pushToViewWithClassName:@"MainViewController"];
        }
        else
        {
            [self showViewMessage:response.message];
        }
        
    }
    
    else if (request.tag == 2)//验证码
    {
        //request.responseString
        Response *response =  [Response modelWithJSON:request.responseData];
        //验证码做本地较验
        self.validateCode = response.validateCode;
        [self showViewMessage:response.message];
        
    }
    
    
}
-(void)requestFailed:(__kindof YTKBaseRequest *)request
{
    [super requestFailed:request];
}
#pragma mark-时钟相关
-(void)startTimeClock
{
    // 创建定时器
    if (self.timerClock == nil)
    {
        self.timerClock = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    }
    
    _timeNum = 60;
    [self.timerClock fire];
}
-(void)stopTimeClock
{
    _validateCodeButton.userInteractionEnabled = YES;
    [_validateCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    // 停止定时器
    [self.timerClock invalidate];
    self.timerClock = nil;
}
-(void)changeTime
{
    
    _timeNum --;
    if (_timeNum > 0)
    {
        _validateCodeButton.userInteractionEnabled = NO;
        [_validateCodeButton setTitle:[NSString stringWithFormat:@"%d",_timeNum] forState:UIControlStateNormal];
    }
    else
    {
        
        [self stopTimeClock];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self stopTimeClock];
    [super viewWillDisappear:animated];
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
