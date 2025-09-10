//
//  SetNewPasswordViewController.m
//  BaseProject
//
//  Created by janker on 2019/1/25.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "SetNewPasswordViewController.h"

@interface SetNewPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *passwordTextField1;
@property (nonatomic, strong) UITextField *passwordTextField2;
@property (nonatomic, strong) NSString *loginname;
@property (nonatomic, strong) NSString *validateCode;
@end

@implementation SetNewPasswordViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:[self className] bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    self.leftNavBtnName = @"返回";
    self.title = [self.viewDic objectForKey:@"viewTitle"];
    [viewDic removeObjectForKey:@"viewTitle"];
    self.loginname = [self.viewDic objectForKey:@"loginname"];
    [viewDic removeObjectForKey:@"loginname"];
    self.validateCode = [self.viewDic objectForKey:@"validateCode"];
    [viewDic removeObjectForKey:@"validateCode"];
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
    CGFloat lineSpace = 15;
    CGFloat lableWidth = 80;
    UILabel *lable1 = (UILabel *)[bgView getSubViewInstanceWith:[UILabel class]];
    lable1.font = FFont_Default;
    lable1.textColor = [UIColor grayColor];
    lable1.text = @"新密码";
    
    lable1.textAlignment = NSTextAlignmentCenter;
    [lable1 setFrameInSuperViewLeftTop:nil toLeftSpace:10 toTopSpace:15 width:lableWidth height:30];
    
    UITextField *textField1 = (UITextField *)[bgView getSubViewInstanceWith:[UITextField class]];
    textField1.font = FFont_Default;
    textField1.textColor = [UIColor grayColor];
    textField1.placeholder = @"请输入新密码";
    self.passwordTextField1 = textField1;
    [textField1 setFrameLeftTopFromViewRightTop:lable1 rightToLeftSpace:10 topToTop:0 width:bgView.width - lable1.right - 20 height:30];
    UIImageView *lineImg = (UIImageView *)[bgView getSubViewInstanceWith:[UIImageView class]];
    lineImg.backgroundColor = [UIColor lightGrayColor];
    [lineImg setFrameLeftTopFromViewLeftBottom:textField1 leftToLeftSpace:0 bottomToTopSpace:lineSpace/2 width:textField1.width height:1];
    
    UILabel *lable2 = (UILabel *)[bgView getSubViewInstanceWith:[UILabel class]];
    lable2.font = FFont_Default;
    lable2.textColor = [UIColor grayColor];
    lable2.text = @"确认密码";
    
    lable2.textAlignment = NSTextAlignmentCenter;
    [lable2 setFrameLeftTopFromViewLeftBottom:lable1 leftToLeftSpace:0 bottomToTopSpace:10 width:lableWidth height:30];
    
    UITextField *textField2 = (UITextField *)[bgView getSubViewInstanceWith:[UITextField class]];
    textField2.font = FFont_Default;
    textField2.textColor = [UIColor grayColor];
    textField2.placeholder = @"请再次输入新密码";
    self.passwordTextField2 = textField2;
    [textField2 setFrameLeftTopFromViewRightTop:lable2 rightToLeftSpace:lineSpace topToTop:0 width:bgView.width - lable2.right - 20 height:30];
    self.passwordTextField1.delegate =self;
    self.passwordTextField2.delegate =self;
    
  
    bgView.height = textField2.bottom + 15;
    
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
    if (_passwordTextField2.text != nil && [_passwordTextField2.text isEqualToString:_passwordTextField1.text])
    {
        //提交
        RequestAction *request = [[RequestAction alloc] init];
        
        request.delegate = self;
        
        [request addAccessory:self];
        request.tag = 2;
        
        //用户名既登录名（必填）
        [request.parm setObjectFilterNull:_loginname forKey:@"loginname"];
        //必填
        [request.parm setObjectFilterNull:[_passwordTextField2.text md5] forKey:@"password"];
        [request.parm setObjectFilterNull:_validateCode forKey:@"validateCode"];
        [request request_updatePasswordByLoginname];
    }
    else
    {
        [self showViewMessage:@"两次密码输入不一致！"];
    }
   
}

-(void)requestFinished:(__kindof YTKBaseRequest *)request
{
   if (request.tag == 2)//修改密码
    {
        //request.responseString
        Response *response =  [Response modelWithJSON:request.responseData];
        if ([@"10000" isEqualToString:response.code])
        {
            //验证码做本地较验
            //        [self showViewMessage:response.message];
            kWeakSelf(self);
            [self showViewMessage:response.message afterDelayTime:3 block:^{
                [weakself popToViewControllWithClassName:@"LoginViewController"];
            }];
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
#pragma mark -UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _passwordTextField1 || textField == _passwordTextField2)
    {
        NSString *textValue = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //密码要做下较验
        if (![NomalUtil isValidateUserPwd:textValue])
        {
            [self showViewMessage:@"只允许输入数字，字母和下划线，且不超过30个字符!"];
            return NO;
        }
    }
   
   
    
    return YES;
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
