//
//  MainViewController.m
//  BaseProject
//
//  Created by janker on 2019/1/23.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "MainViewController.h"
#import "CustomView.h"
@interface MainViewController ()
@property (nonatomic, strong)UIButton *button2;//围栏报警
@property (nonatomic, strong)UILabel *numLable;//围栏报警个数
@property (nonatomic, strong)UILabel *numLable1;//拆除警个数
@property (nonatomic, strong)UIButton *button1;//围栏报警
@end

@implementation MainViewController
@synthesize button2,button1;
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
    self.navType = 2;
    self.notRightScrollPop = YES;
    [super loadView];
}
- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    [self initAllViews];
//    [self changeButton2WidthNum:12];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self sendGetNumberRequest];
    [super viewWillAppear:animated];
}
-(void)sendGetNumberRequest
{
    RequestAction *request = [[RequestAction alloc] init];
    //设备号
    [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.idc forKey:@"idc"];
    
    NSString *dismantleID = [kUserDefaults objectForKey:[NSString stringWithFormat:@"%@dismantleID",[SingleDataManager instance].userInfoModel.idc]];
    NSString *efenceID = [kUserDefaults objectForKey:[NSString stringWithFormat:@"%@efenceID",[SingleDataManager instance].userInfoModel.idc]];
    if (![NomalUtil isValueableString:dismantleID])
    {
        dismantleID = @"0";
    }
    if (![NomalUtil isValueableString:efenceID])
    {
        efenceID = @"0";
    }
    //拆除预警最大ID
    [request.parm setObjectFilterNull:dismantleID forKey:@"dismantleID"];
    //围栏最大ID
    [request.parm setObjectFilterNull:efenceID forKey:@"efenceID"];
    
    [request request_getAlarmUnreadNum_success:^(__kindof YTKBaseRequest * _Nonnull request)
     {
         //         NSLog(@"%@",request.responseData);
         Response *response =  [Response modelWithJSON:request.responseData];
         NSDictionary *dic = (NSDictionary *)response.data;
         if ([NomalUtil isValueableString:[dic objectForKeyWithStringValue:@"efence"]])
         {
             
             [self changeButton2WidthNum:[[dic objectForKeyWithStringValue:@"efence"] intValue]];
         }
         else
         {
             [self changeButton2WidthNum:0];
         }
         if ([NomalUtil isValueableString:[dic objectForKeyWithStringValue:@"dismantle"]])
         {
             
             [self changeButton1WidthNum:[[dic objectForKeyWithStringValue:@"dismantle"] intValue]];
         }
         else
         {
             [self changeButton1WidthNum:0];
         }
         
         //         NSLog(@"%@",response);
//         VersionModel *mode = [VersionModel modelWithJSON:response.data];
//         [SingleDataManager instance].versionModel = mode;
//         [[DataBaseUtil instance] deleteObjWithClass:NSClassFromString(@"VersionModel")];
//         [[DataBaseUtil instance] addClassWidthObj:mode];
        
         
     } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
         
     }];
   

}
- (void) longTapAction:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        [self pushToViewWithClassName:@"LogViewController"];
    }
    else
    {
       
    }
    
}

-(void)initAllViews
{
    UIImageView *imageView = (UIImageView *)[self.view getSubViewInstanceWith:[UIImageView class]];
    imageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction:)];
    longPress.minimumPressDuration = 3; //定义按的时间
    longPress.numberOfTouchesRequired = 1;
    [imageView addGestureRecognizer:longPress];
    imageView.image = IMAGE_NAMED(@"上面车");
    //750x606
    [imageView setFrameInSuperViewLeftTop:nil toLeftSpace:0 toTopSpace:0 width:ScreenWidth height:[self.view getPicScaleLen:606]];
    imageView = (UIImageView *)[self.view getSubViewInstanceWith:[UIImageView class]];
    imageView.image = IMAGE_NAMED(@"下面车");
    //617/432
    [imageView setFrameInSuperViewRightBottom:nil toRightSpace:0 toBottomSpace:10 width:[self.view getPicScaleLen:617] height:[self.view getPicScaleLen:432]];
    
    UILabel *lable1 = (UILabel *)[self.view getSubViewInstanceWith:[UILabel class]];
    lable1.font = [UIFont systemFontOfSize:26];
    lable1.textColor = Color_Nomal_Font_White;
    lable1.text = @"你好";
    lable1.textAlignment = NSTextAlignmentLeft;
    [lable1 setFrameInSuperViewLeftTop:nil toLeftSpace:30 toTopSpace:50 width:100 height:30];
    
    
    UILabel *lable2 = (UILabel *)[self.view getSubViewInstanceWith:[UILabel class]];
    lable2.font = [UIFont systemFontOfSize:14];
    lable2.textColor = Color_Nomal_Font_White;
    lable2.text = @"我的爱车";
    lable2.textAlignment = NSTextAlignmentLeft;
    [lable2 setFrameLeftTopFromViewLeftBottom:lable1 leftToLeftSpace:0 bottomToTopSpace:0 width:100 height:30];
    
    //从界面底部开始加按钮
    button1 = (UIButton *)[self.view getSubViewInstanceWith:[UIButton class]];
    [button1 setBackgroundImage:IMAGE_NAMED(@"botomButton") forState:UIControlStateNormal];
    [button1 setImage:IMAGE_NAMED(@"拆除报警icon") forState:UIControlStateNormal];
//    [button1 setImage:IMAGE_NAMED(@"选中") forState:UIControlStateSelected];
    [button1 setTitle:@"拆除报警" forState:UIControlStateNormal];
    [button1 setTitleColor:Color_Nomal_Font_BlueGray forState:UIControlStateNormal];
    button1.titleLabel.font = FFont_Default;
    //333*131
    CGFloat space = 20;
//    CGFloat space2 = ScreenWidth - [self.view getPicScaleLen:333]*2 - space*2;
    [button1 setFrameInSuperViewRightBottom:nil toRightSpace:space toBottomSpace:SAFE_AREA_INSETS_BOTTOM_NotZero + space  width:[self.view getPicScaleLen:333] height:[self.view getPicScaleLen:131]];
   
    [button1 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    [button1 setSelected:YES];
    [button1 addTarget:self action:@selector(buttonPressed1:) forControlEvents:UIControlEventTouchUpInside];
    _numLable1 = (UILabel *)[button1 getSubViewInstanceWith:[UILabel class]];
    
    [_numLable1 setFrameInSuperViewRightTop:nil toRightSpace:0 toTopSpace:5 width:22 height:15];
    _numLable1.textAlignment = NSTextAlignmentCenter;
    _numLable1.textColor = Color_Nomal_Font_White;
    _numLable1.text = @"";
    _numLable1.font = [UIFont systemFontOfSize:10];
    
    //从界面底部开始加按钮
    button2 = (UIButton *)[self.view getSubViewInstanceWith:[UIButton class]];
    [button2 setBackgroundImage:IMAGE_NAMED(@"botomButton") forState:UIControlStateNormal];
//    [button2 setBackgroundImage:IMAGE_NAMED(@"rightNumButton") forState:UIControlStateNormal];
    [button2 setImage:IMAGE_NAMED(@"围栏报警icon") forState:UIControlStateNormal];
    //    [button1 setImage:IMAGE_NAMED(@"选中") forState:UIControlStateSelected];
    [button2 setTitle:@"围栏报警" forState:UIControlStateNormal];
    [button2 setTitleColor:Color_Nomal_Font_BlueGray forState:UIControlStateNormal];
    [button2 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [button2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    button2.titleLabel.font = FFont_Default;
    [button2 addTarget:self action:@selector(buttonPressed2:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setFrameInSuperViewLeftBottom:nil toLeftSpace:space toBottomSpace:SAFE_AREA_INSETS_BOTTOM_NotZero + space width:[self.view getPicScaleLen:333] height:[self.view getPicScaleLen:131]];
    _numLable = (UILabel *)[button2 getSubViewInstanceWith:[UILabel class]];
    
    [_numLable setFrameInSuperViewRightTop:nil toRightSpace:0 toTopSpace:5 width:22 height:15];
    _numLable.textAlignment = NSTextAlignmentCenter;
    _numLable.textColor = Color_Nomal_Font_White;
    _numLable.text = @"";
    _numLable.font = [UIFont systemFontOfSize:10];
    UIView *itemTemp = button2;
    
    for (int i = 0; i < 3; i ++)
    {
        CustomView *item = (CustomView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomView2"
                                                                        owner:self
                                                                      options:nil]
                                          objectAtIndex:0];
        [self.view addSubview:item];
        
        [item setFrameLeftBottomFromViewLeftTop:itemTemp leftToLeftSpace:0 topToBottom:30*ScalNum_Height width:ScreenWidth - space *2 height:[self.view getPicScaleLen:131]];
        item.backgroundColor = Color_Clear;
        item.button1.tag = i+1;
        item.button1.frame = Rect(0, 0, item.width, item.height);
        [item.button1 addTarget:self action:@selector(buttonPressed3:) forControlEvents:UIControlEventTouchUpInside];
        [item.button1 setBackgroundImage:IMAGE_NAMED(@"按钮背景") forState:UIControlStateNormal];
        [item.button1 setBackgroundImage:IMAGE_NAMED(@"按钮背景_按下") forState:UIControlStateHighlighted];
        //UIControlStateDisabled
//        [item.button1 setShowsTouchWhenHighlighted:NO];
//        item.button1.backgroundColor = Color_Clear;
//        item.button1.imageView.backgroundColor = Color_Clear;
        
        
        item.label.font = FFont_Default;
        item.label.textColor = Color_Nomal_Font_BlueGray;
//        [item.label setFrameLeftTopFromViewRightTop:item.imgView rightToLeftSpace:10 topToTop:0 width:200 height:30];
        [item.label setFrameInSuperViewLeftBottom:nil toLeftSpace:Space_Normal +[self.view getPicScaleLen:78]+10  toBottomSpace:0 width:200 height:30];
        item.label.centerY = item.height/2;
        //25x45
        item.imgView2.image = IMAGE_NAMED(@"右箭头");
        [item.imgView2 setFrameInSuperViewRightBottom:nil toRightSpace:Space_Normal toBottomSpace:Space_Normal width:[self.view getPicScaleLen:25] height:[self.view getPicScaleLen:45]];
        
        item.imgView2.centerY = item.height/2;
        if (i == 0)
        {
            //118*81
            //78x54
            [item.imgView setFrameInSuperViewCenter:nil width:[self.view getPicScaleLen:78] height:[self.view getPicScaleLen:54]];
            item.label.text = @"轨迹回放";
            item.imgView.image = IMAGE_NAMED(@"轨迹回放icon");
        }
        else if (i == 1)
        {
            //46x62
            
            [item.imgView setFrameInSuperViewCenter:nil width:[self.view getPicScaleLen:46] height:[self.view getPicScaleLen:62]];
            item.label.text = @"当前位置";
            item.imgView.image = IMAGE_NAMED(@"PIN2");
        }
        else if (i == 2)
        {
            item.label.text = @"个人中心";
            item.imgView.image = IMAGE_NAMED(@"个人中心icon");
            //56x53
            [item.imgView setFrameInSuperViewCenter:nil width:[self.view getPicScaleLen:56] height:[self.view getPicScaleLen:53]];
        }
        item.imgView.left = Space_Normal;
        itemTemp = item;
    }
   
}
//设置拆除报警个数
-(void)changeButton1WidthNum:(int)num
{
    if (num > 0)
    {
        if (num > 99)
        {
            _numLable1.text = @"N";
        }
        else
        {
            _numLable1.text = NSStringFormat(@"%d",num);
        }
        
        [button1 setBackgroundImage:IMAGE_NAMED(@"rightNumButton") forState:UIControlStateNormal];
    }
    else
    {
        [button1 setBackgroundImage:IMAGE_NAMED(@"botomButton") forState:UIControlStateNormal];
        _numLable1.text = @"";
    }
}
//设置围栏报警个数
-(void)changeButton2WidthNum:(int)num
{
    if (num > 0)
    {
        if (num > 99)
        {
            _numLable.text = @"N";
        }
        else
        {
            _numLable.text = NSStringFormat(@"%d",num);
        }
        
        [button2 setBackgroundImage:IMAGE_NAMED(@"rightNumButton") forState:UIControlStateNormal];
    }
    else
    {
        [button2 setBackgroundImage:IMAGE_NAMED(@"botomButton") forState:UIControlStateNormal];
        _numLable.text = @"";
    }
}
//拆除报警
-(void)buttonPressed1:(UIButton *)button
{
    [viewDic setObjectFilterNull:@"拆除报警" forKey:@"viewTitle"];
    [viewDic setObjectFilterNull:@"1" forKey:@"initType"];
    [self pushToViewWithClassName:@"ListViewController"];
}
//围栏报警
-(void)buttonPressed2:(UIButton *)button
{
    //ListViewController
    [viewDic setObjectFilterNull:@"围栏报警" forKey:@"viewTitle"];
    [viewDic setObjectFilterNull:@"0" forKey:@"initType"];
    [self pushToViewWithClassName:@"ListViewController"];
}
-(void)buttonPressed3:(UIButton *)button
{
    if (button.tag == 1)
    {
        //轨迹回放
//        [viewDic setObjectFilterNull:@"轨迹回放" forKey:@"viewTitle"];
//        [viewDic setObjectFilterNull:@"2" forKey:@"initType"];
//        [self pushToViewWithClassName:@"ListViewController"];
        [self pushToViewWithClassName:@"PlayBackViewController"];
    }
    else if (button.tag == 2)
    {
        //当前位置
//        [self.viewDic setObject:@"1" forKey:@"initType"];//报警位置
        [self pushToViewWithClassName:@"PositionViewController"];
    }
    else if (button.tag == 3)
    {
        //个人中心
        [self pushToViewWithClassName:@"UserInfoViewController"];
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
