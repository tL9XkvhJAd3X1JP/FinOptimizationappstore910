//
//  EarlyWarningCenterViewController.m
//  BaseProject
//
//  Created by janker on 2019/3/27.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "EarlyWarningCenterViewController.h"
#import "CustomView.h"
#import "AlarmRecordModel.h"
@interface EarlyWarningCenterViewController ()
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) UIScrollView *myScrollView;
@property (strong, nonatomic) NSMutableArray *arrayData;

@end

@implementation EarlyWarningCenterViewController
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
    self.leftNavBtnImg = @"刷新";
    self.title = @"预警处理";
    [super loadView];
}
-(void)leftNavBtnPressed:(id)sender
{
    //刷新
}
- (void)viewDidLoad
{
    self.arrayData = [NSMutableArray arrayWithCapacity:10];
    [super viewDidLoad];
    [self initAllViews];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    UIButton *button2 = [_bottomView viewWithTag:2];
    [button2 click:button2];
    [super viewWillAppear:animated];
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
        //MonitorViewController
        if (![NomalUtil popToViewControllWithClassName:@"MonitorViewController" animated:NO])
        {
            [self pushToViewWithClassName:@"MonitorViewController" animate:NO];
        }
       
    }];
    
    [button2 addTapBlock:^(UIButton *btn) {
        button1.selected = NO;
        button3.selected = NO;
        button2.selected = YES;

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
//    button1.selected = YES;
    

    [button2 renderButtonWithColor:Color_Nomal_Font_White image:IMAGE_NAMED(@"预警") forState:UIControlStateNormal renderingMode:UIImageRenderingModeAlwaysOriginal];
    [button2 renderButtonWithColor:Color_yellow_select image:IMAGE_NAMED(@"预警按下") forState:UIControlStateSelected renderingMode:UIImageRenderingModeAlwaysOriginal];
    [button2 layoutButtonWithImageTitleSpace:5];


    
    [button3 renderButtonWithColor:Color_Nomal_Font_White image:IMAGE_NAMED(@"我的") forState:UIControlStateNormal renderingMode:UIImageRenderingModeAlwaysOriginal];
    [button3 renderButtonWithColor:Color_yellow_select image:IMAGE_NAMED(@"我的按下") forState:UIControlStateSelected renderingMode:UIImageRenderingModeAlwaysOriginal];
    [button3 layoutButtonWithImageTitleSpace:5];

    
    _myScrollView = (UIScrollView *)[self.contentView getSubViewInstanceWith:[UIScrollView class]];
    _myScrollView.backgroundColor = [UIColor redColor];//Color_Clear;
    [_myScrollView setFrameInSuperViewLeftTop:nil toLeftSpace:0 toTopSpace:0 width:ScreenWidth_Content height:_bottomView.top];
}
//刷新
-(void)refreshItems
{
    CustomView *lastItem = nil;
    for (AlarmRecordModel *model in _arrayData)
    {
        CustomView *item = (CustomView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomView4"
                                                                        owner:self
                                                                      options:nil]
                                          objectAtIndex:0];
        CGFloat space = 15*ScalNum_Width;
        CGFloat boxWidth = (ScreenWidth_Content - space*3)/2;
        CGFloat boxHeight = 100;
        if (lastItem == nil)
        {
            
        }
        lastItem = item;
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
