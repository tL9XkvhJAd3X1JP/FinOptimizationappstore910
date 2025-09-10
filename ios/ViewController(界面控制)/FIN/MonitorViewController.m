//
//  EarlyWarningCenterViewController.m
//  BaseProject
//
//  Created by janker on 2019/3/27.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "MonitorViewController.h"

@interface MonitorViewController ()
@property (strong, nonatomic) IBOutlet UIView *bottomView;


@end

@implementation MonitorViewController
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
//    self.navType = 1;
//    self.leftNavBtnName = @"返回";
    self.rightNavBtnName = @"已处理";
    self.notRightScrollPop = YES;
    self.rightNavBtnImg = @"选车";
    self.title = @"车辆监控";
    [super loadView];
}
-(void)leftNavBtnPressed:(id)sender
{
    //刷新
}
-(void)viewWillAppear:(BOOL)animated
{
    
    UIButton *button1 = [_bottomView viewWithTag:1];
    [button1 click:button1];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self initAllViews];
    // Do any additional setup after loading the view from its nib.
}
-(void)initAllViews
{
    [_bottomView removeFromSuperview];
    CGFloat space = 15*ScalNum_Width;
    CGFloat bottomH = 70;
    [self.contentView addSubview:_bottomView];
    [_bottomView setFrameInSuperViewCenterBottom:nil toBottomSpace:SAFE_AREA_INSETS_BOTTOM_NotZero width:ScreenWidth_Content - space*2  height:bottomH];
    [_bottomView setCornerRadius:5];
    _bottomView.backgroundColor = Color_Nomal_Bg;
    
    __weak UIButton *button1 = [_bottomView viewWithTag:1];
    __weak UIButton *button2 = [_bottomView viewWithTag:2];
    __weak UIButton *button3 = [_bottomView viewWithTag:3];
    [button1 addTapBlock:^(UIButton *btn) {
        button2.selected = NO;
        button3.selected = NO;
        button1.selected = YES;
       
    }];
    
    [button2 addTapBlock:^(UIButton *btn) {
        button1.selected = NO;
        button3.selected = NO;
        button2.selected = YES;
        if (![NomalUtil popToViewControllWithClassName:@"EarlyWarningCenterViewController" animated:NO])
        {
            [self pushToViewWithClassName:@"EarlyWarningCenterViewController" animate:NO];
        }
    }];
    
    [button3 addTapBlock:^(UIButton *btn) {
        button2.selected = NO;
        button1.selected = NO;
        button3.selected = YES;
    }];
    [button1.titleLabel setFont:FFont_Default_14];
    [button2.titleLabel setFont:FFont_Default_14];
    [button3.titleLabel setFont:FFont_Default_14];
    
    [button2 setFrameInSuperViewCenter:nil width:100 height:bottomH];
    
    [button1 setFrameInSuperViewLeftTop:nil toLeftSpace:0 toTopSpace:0 width:100 height:bottomH];
    [button3 setFrameInSuperViewRightTop:nil toRightSpace:0 toTopSpace:0 width:100 height:bottomH];
    
   
    [button1 renderButtonWithColor:Color_Nomal_Font_White image:IMAGE_NAMED(@"监控") forState:UIControlStateNormal renderingMode:UIImageRenderingModeAlwaysOriginal];
    [button1 renderButtonWithColor:Color_yellow_select image:IMAGE_NAMED(@"监控按下") forState:UIControlStateSelected renderingMode:UIImageRenderingModeAlwaysOriginal];
    [button1 layoutButtonWithImageTitleSpace:5];
    button1.selected = YES;
    

    [button2 renderButtonWithColor:Color_Nomal_Font_White image:IMAGE_NAMED(@"预警") forState:UIControlStateNormal renderingMode:UIImageRenderingModeAlwaysOriginal];
    [button2 renderButtonWithColor:Color_yellow_select image:IMAGE_NAMED(@"预警按下") forState:UIControlStateSelected renderingMode:UIImageRenderingModeAlwaysOriginal];
    [button2 layoutButtonWithImageTitleSpace:5];


    
    [button3 renderButtonWithColor:Color_Nomal_Font_White image:IMAGE_NAMED(@"我的") forState:UIControlStateNormal renderingMode:UIImageRenderingModeAlwaysOriginal];
    [button3 renderButtonWithColor:Color_yellow_select image:IMAGE_NAMED(@"我的按下") forState:UIControlStateSelected renderingMode:UIImageRenderingModeAlwaysOriginal];
    [button3 layoutButtonWithImageTitleSpace:5];
    
  
    
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
