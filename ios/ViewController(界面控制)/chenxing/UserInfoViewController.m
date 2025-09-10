//
//  UserInfoViewController.m
//  BaseProject
//
//  Created by janker on 2019/1/23.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "UserInfoViewController.h"
#import "CustomView.h"
@interface UserInfoViewController ()
@property (nonatomic, strong) UILabel *stateLabel;
@end

@implementation UserInfoViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:[self className] bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    self.navType = 1;

    [super loadView];
//    [self initAllViews];
}
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
    UIColor *textColor = [UIColor whiteColor];
    if (self.title != nil)
    {
        UILabel *titleLable = [[UILabel alloc] initWithFrame:Rect(0, 0, ScreenWidth, NavBarHeight)];
        titleLable.text = self.title;
        titleLable.backgroundColor = [UIColor clearColor];
        [titleLable setTextColor:textColor];
        [navView addSubview:titleLable];
        [titleLable setTextAlignment:NSTextAlignmentCenter];
        
    }
    
    if (self.leftNavBtnName != nil)
    {
        
        UIButton *b;
        b = (UIButton*) [[UIButton alloc] init];
        [b setShowsTouchWhenHighlighted:YES];
        [navView addSubview:b];
        b.backgroundColor = [UIColor clearColor];
        b.titleLabel.font = font;
        [b setTitleColor:textColor forState:UIControlStateNormal];
        
        CGSize size = [self.leftNavBtnName sizeWithAttributes:@{NSFontAttributeName : b.titleLabel.font}];;
        
        
        
        b.frame = CGRectMake(margin, 0, size.width + addWidth, heightButton);
        if ([@"返回" isEqualToString:self.leftNavBtnName])
        {
            //            UIImage *tmpimage = IMAGE_NAMED(@"return");
            //        [btn setBackgroundImage:tmpimage forState:UIControlStateNormal];
            //图片变色
            UIImage *tmpimage =[IMAGE_NAMED(@"return") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [b setTintColor:Color_Nomal_Font_White];
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
            
            [b setTitle:self.leftNavBtnName forState:UIControlStateNormal];
        }
        [b addTarget:self action:@selector(leftNavBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.rightNavBtnName != nil)
    {
        
        UIButton *b;
        b = (UIButton*) [[UIButton alloc] init];
        [b setShowsTouchWhenHighlighted:YES];
        
        b.backgroundColor = [UIColor clearColor];
        b.titleLabel.font = font;
        //[b.titleLabel setTextAlignment:NSTextAlignmentRight];
        //UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
        [b setTitle:self.rightNavBtnName forState:UIControlStateNormal];
        [b setTitleColor:textColor forState:UIControlStateNormal];
        CGSize size = [self.rightNavBtnName sizeWithAttributes:@{NSFontAttributeName : b.titleLabel.font}];
        
        b.frame = CGRectMake(ScreenWidth -(size.width + addWidth) - 2 , 0, size.width + addWidth, heightButton);
        b.centerY = navView.height/2;
        //[b setTitleEdgeInsets:UIEdgeInsetsMake(0, size.width + addWidth, 0, 0)];
        //b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [b addTarget:self action:@selector(rightNavBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:b];
    }
}

-(void)initAllViews
{
    UIImageView *imageView = (UIImageView *)[self.view getSubViewInstanceWith:[UIImageView class]];
    imageView.image = IMAGE_NAMED(@"userinfo_bg");
    //750x606
    [imageView setFrameInSuperViewLeftTop:nil toLeftSpace:0 toTopSpace:0 width:ScreenWidth height:[self.view getPicScaleLen:708]];
    [self.view bringSubviewToFront:self.headerView];
    UILabel *lable1 = (UILabel *)[self.view getSubViewInstanceWith:[UILabel class]];
    lable1.font = [UIFont systemFontOfSize:26];
    lable1.textColor = Color_Nomal_Font_White;
    lable1.text = @"你好";
    lable1.textAlignment = NSTextAlignmentLeft;
    [lable1 setFrameInSuperViewLeftTop:nil toLeftSpace:30 toTopSpace:45+StatusBarHeight width:100 height:30];
    
    UILabel *lable2 = (UILabel *)[self.view getSubViewInstanceWith:[UILabel class]];
    lable2.font = [UIFont systemFontOfSize:14];
    lable2.textColor = Color_Nomal_Font_White;
    lable2.text = @"我的爱车";
    lable2.textAlignment = NSTextAlignmentLeft;
    [lable2 setFrameLeftTopFromViewLeftBottom:lable1 leftToLeftSpace:0 bottomToTopSpace:0 width:100 height:30];
    
    
    
    //从界面底部开始加按钮
    UIButton *button1 = (UIButton *)[self.view getSubViewInstanceWith:[UIButton class]];
    
    button1.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.9];
    [button1 setTitle:@"退出登录" forState:UIControlStateNormal];
    [button1 setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
    __weak typeof(self)weakSelf = self;
    [button1  addTapBlock:^(UIButton *btn) {
        //显示二次确认
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if (strongSelf) {
//            [strongSelf showCustomAlertViewWithTitle:@"退出登录" message:@"确定要退出登录吗?" okButtonTitle:@"确 定" cancelBlock:nil okBlock:^{
//                NSLog(@"aaaaa");
//            }];
//        }
        [weakSelf showCustomAlertViewWithTitle:@"退出登录" message:@"确定要退出登录吗?" okButtonTitle:@"确 定" cancelBlock:nil okBlock:^{
//            NSLog(@"aaaaa");
            [[DataBaseUtil instance] deleteObjWithClass:NSClassFromString(@"UserInfoModel")];
            [weakSelf popToViewControllWithClassName:@"LoginViewController"];
        }];
       
    }];
    button1.titleLabel.font = FFont_Default;
    //333*131
    CGFloat space = 20;
    //    CGFloat space2 = ScreenWidth - [self.view getPicScaleLen:333]*2 - space*2;
    [button1 setFrameInSuperViewCenterBottom:nil toBottomSpace:SAFE_AREA_INSETS_BOTTOM_NotZero + 30 width:ScreenWidth - space * 2 height:[self.view getPicScaleLen:131]-10];
    [button1 setCornerRadius:4];
    UIView *itemTemp = button1;
    for (int i = 0; i < 3; i ++)
    {
        CustomView *item = (CustomView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomView2"
                                                                        owner:self
                                                                      options:nil]
                                          objectAtIndex:0];
        [self.view addSubview:item];
        
        [item setFrameLeftBottomFromViewLeftTop:itemTemp leftToLeftSpace:0 topToBottom:30 width:ScreenWidth - space *2 height:[self.view getPicScaleLen:131]];
        item.button1.tag = i+1;
        item.button1.frame = Rect(0, 0, item.width, item.height);
        [item.button1 addTarget:self action:@selector(buttonPressed3:) forControlEvents:UIControlEventTouchUpInside];
        [item.button1 setBackgroundImage:IMAGE_NAMED(@"按钮背景") forState:UIControlStateNormal];
        [item.button1 setBackgroundImage:IMAGE_NAMED(@"按钮背景_按下") forState:UIControlStateHighlighted];
        //        item.button1.backgroundColor = Color_Clear;
        
        
        
        item.label.font = FFont_Default;
        item.label.textColor = Color_Nomal_Font_BlueGray;
        //        [item.label setFrameLeftTopFromViewRightTop:item.imgView rightToLeftSpace:10 topToTop:0 width:200 height:30];
        [item.label setFrameInSuperViewLeftBottom:nil toLeftSpace:Space_Normal +[self.view getPicScaleLen:78]+10  toBottomSpace:0 width:200 height:30];
        [item.label2 setFrameInSuperViewLeftBottom:nil toLeftSpace:Space_Normal +[self.view getPicScaleLen:78]+10  toBottomSpace:0 width:200 height:30];
        item.label.centerY = item.height/2;
        //25x45
        item.imgView2.image = IMAGE_NAMED(@"右箭头");
        [item.imgView2 setFrameInSuperViewRightBottom:nil toRightSpace:Space_Normal toBottomSpace:Space_Normal width:[self.view getPicScaleLen:25] height:[self.view getPicScaleLen:45]];
        
        item.imgView2.centerY = item.height/2;
        if (i == 0)
        {
            //118*81
            //78x54
            [item.imgView setFrameInSuperViewCenter:nil width:[self.view getPicScaleLen:56] height:[self.view getPicScaleLen:45]];
            item.label.text = @"软件更新";
            item.imgView.image = IMAGE_NAMED(@"软件升级");
            
            if (ScalNum_Width < 1)
            {
                item.label.top = 1;
            }
            else
            {
                item.label.top = 5*ScalNum_Width;
            }
            item.label2.font = FFont_Default_Small_12;
            item.label2.textColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
            item.label2.text = NSStringFormat(@"当前版本号：V%@",AppVersion);
            
            item.label2.bottom = item.height;
        }
        else if (i == 1)
        {
            //46x62
            
            [item.imgView setFrameInSuperViewCenter:nil width:[self.view getPicScaleLen:57] height:[self.view getPicScaleLen:45]];
            item.label.text = @"围栏设置";
            item.imgView.image = IMAGE_NAMED(@"围栏设置");
        }
        else if (i == 2)
        {
            item.label.text = @"个人资料查看";
            item.imgView.image = IMAGE_NAMED(@"个人中心icon");
            //56x53
            [item.imgView setFrameInSuperViewCenter:nil width:[self.view getPicScaleLen:56] height:[self.view getPicScaleLen:53]];
            [item.label2 setFrameRightTopFromViewLeftTop:item.imgView2 leftToRightSpace:10 topToTopSpace:0 width:200 height:item.imgView.height];
            
            [item.label2 setTextAlignment:NSTextAlignmentRight];
            item.label2.text = @"审核中";
            if ([@"1" isEqualToString:[SingleDataManager instance].userInfoModel.state])
            {
                item.label2.text = @"审核中";
            }
            else if ([@"2" isEqualToString:[SingleDataManager instance].userInfoModel.state])
            {
                item.label2.text = @"通过审核";
            }
            else if ([@"3" isEqualToString:[SingleDataManager instance].userInfoModel.state])
            {
                item.label2.text = @"未通过审核";
            }
            
            //Color_Nomal_red
            item.label2.textColor = [UIColor greenColor];
            self.stateLabel = item.label2;
        }
        item.imgView.left = Space_Normal;
        itemTemp = item;
    }
}
- (void)viewDidLoad {
    self.leftNavBtnName = @"返回";
    self.title = @"个人中心";
    [super viewDidLoad];
    [self initAllViews];
    [self renderUserInfoStates];
    // Do any additional setup after loading the view from its nib.
}
-(void)renderUserInfoStates
{
    RequestAction *request = [[RequestAction alloc] init];
//    [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.customerid forKey:@"customerid"];
    //登录账号(必填)
    [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.loginname forKey:@"loginname"];
    [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.password forKey:@"password"];//md5后的
    kWeakSelf(self);
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
                 if ([@"1" isEqualToString:[SingleDataManager instance].userInfoModel.state])
                 {
                     weakself.stateLabel.text = @"审核中";
                 }
                 else if ([@"2" isEqualToString:[SingleDataManager instance].userInfoModel.state])
                 {
                     weakself.stateLabel.text = @"通过审核";
                 }
                 else if ([@"3" isEqualToString:[SingleDataManager instance].userInfoModel.state])
                 {
                     weakself.stateLabel.text = @"未通过审核";
                 }
             }
             else
             {
                 //密码不同的时候
                 [SingleDataManager instance].userInfoModel = nil;
                 [[DataBaseUtil instance] deleteObjWithClass:NSClassFromString(@"UserInfoModel")];
                 [self pushToViewWithClassName:@"LoginViewController"];

             }
             
         }
//         else
//         {
//
//             [SingleDataManager instance].userInfoModel = nil;
//             //            [[DataBaseUtil instance] updateClassWidthObj:mode searchKey:@"userId" searchValue:mode.userId];
//             [[DataBaseUtil instance] deleteObjWithClass:NSClassFromString(@"UserInfoModel")];
//             [self pushToViewWithClassName:@"LoginViewController"];
//         }
         
     } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
         
     }];
}
-(void)buttonPressed3:(UIButton *)button
{
    if (button.tag == 1)
    {
        //软件更新
        NSString *urlStr = [SingleDataManager instance].versionModel.clientDownUrl;
        if ([NomalUtil isValueableString:urlStr] && urlStr.length > 5)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
        else
        {
            [self showViewMessage:@"暂时没审核完成!"];
        }
        
    }
    else if (button.tag == 2)
    {
        //围栏设置
        [self pushToViewWithClassName:@"BMKPolygonOverlayPage"];
    }
    else if (button.tag == 3)
    {
        //个人资料编辑
//        [self pushToViewWithClassName:@"UserInfoViewController"];
        [viewDic setObject:@"1" forKey:@"initType"];
         [self pushToViewWithClassName:@"RegisterViewController"];
    }
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
