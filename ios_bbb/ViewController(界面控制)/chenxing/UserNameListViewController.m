//
//  UserNameListViewController.m
//  BaseProject
//
//  Created by janker on 2019/1/25.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "UserNameListViewController.h"
#import "CustomView.h"
@interface UserNameListViewController ()
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSString *phoneNum;
@end

@implementation UserNameListViewController
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
    self.phoneNum = [self.viewDic objectForKey:@"phoneNum"];
    [viewDic removeObjectForKey:@"phoneNum"];
    _dataArray = [NSMutableArray arrayWithCapacity:3];
    [super viewDidLoad];
    [self sendRequest];
//    [self initAllViews];
    // Do any additional setup after loading the view from its nib.
}
-(void)initAllViews
{
    [self.contentView removeAllSubviews];
    
    CGFloat space = 15;
    CGFloat space2 = 10;
    UILabel *lable1 = (UILabel *)[self.contentView getSubViewInstanceWith:[UILabel class]];
    lable1.font = FFont_Default;
    lable1.textColor = [UIColor grayColor];
    lable1.text = @"您当前手机号绑定的设备共有如下账户，请选择：";
    lable1.textAlignment = NSTextAlignmentLeft;
    
    [lable1 setFrameInSuperViewLeftTop:nil toLeftSpace:space toTopSpace:15 width:-2 height:30];
    
    
    UIView *itemTemp = lable1;
    
    
    UIButton *button3 = (UIButton *)[self.contentView getSubViewInstanceWith:[UIButton class]];
    [button3 setTitle:@"确 定" forState:UIControlStateNormal];
    [button3 setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
    button3.backgroundColor = Color_Nomal_Bg;
    button3.titleLabel.font = FFont_Default;
    [button3 setCornerRadius:4];
    //    [button3 setFrameLeftTopFromViewLeftBottom:itemTemp leftToLeftSpace:0 bottomToTopSpace:100 width:itemTemp.width height:40];
    [button3 setFrameInSuperViewCenterBottom:nil toBottomSpace:SAFE_AREA_INSETS_BOTTOM_NotZero+20 width:itemTemp.width height:40];
    
    [button3 addTarget:self action:@selector(buttonPressed4:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIScrollView *scroll = (UIScrollView *)[self.contentView getSubViewInstanceWith:[UIScrollView class]];
    [scroll setFrameLeftTopFromViewLeftBottom:itemTemp leftToLeftSpace:0 bottomToTopSpace:10 width:ScreenWidth - space *2 height:button3.top - 10 - lable1.bottom - 10];
    itemTemp = nil;
    NSUInteger count = [_dataArray count];
//    count = 3;
    for (int i = 0; i < count; i ++)
    {
        NSDictionary *dic = [_dataArray objectAtIndex:i];
        CustomView *item = (CustomView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomView2"
                                                                        owner:self
                                                                      options:nil]
                                          objectAtIndex:0];
        [scroll addSubview:item];
        
//        [item setFrameLeftBottomFromViewLeftTop:itemTemp leftToLeftSpace:0 topToBottom:30 width:ScreenWidth - space *2 height:[self.view getPicScaleLen:131]];
        if (itemTemp == nil)
        {
            [item setFrameInSuperViewCenterTop:nil toTopSpace:0 width:ScreenWidth - space *2 height:[self.view getPicScaleLen:131]];
        }
        else
        {
           [item setFrameLeftTopFromViewLeftBottom:itemTemp leftToLeftSpace:0 bottomToTopSpace:space2 width:ScreenWidth - space *2 height:[self.view getPicScaleLen:131]];
        }
        
        item.button1.tag = i+1;
        if (i == 0)
        {
            item.button1.selected = YES;
        }
        item.button1.frame = Rect(0, 0, item.width, item.height);
        [item.button1 addTarget:self action:@selector(buttonPressed3:) forControlEvents:UIControlEventTouchUpInside];
        [item.button1 setBackgroundImage:IMAGE_NAMED(@"按钮背景") forState:UIControlStateNormal];
        [item.button1 setBackgroundImage:IMAGE_NAMED(@"按钮背景_按下") forState:UIControlStateSelected];
        
        item.button1.backgroundColor = Color_Clear;
        
        
        
        item.label.font = FFont_Default;
        item.label.textColor = Color_Nomal_Font_BlueGray;
        //        [item.label setFrameLeftTopFromViewRightTop:item.imgView rightToLeftSpace:10 topToTop:0 width:200 height:30];
        [item.label setFrameInSuperViewLeftBottom:nil toLeftSpace:Space_Normal +[self.view getPicScaleLen:78]+10  toBottomSpace:0 width:200 height:30];
        item.label.centerY = item.height/2;
        //25x45
//        item.imgView2.image = IMAGE_NAMED(@"右箭头");
        [item.imgView2 setFrameInSuperViewRightBottom:nil toRightSpace:Space_Normal toBottomSpace:Space_Normal width:[self.view getPicScaleLen:25] height:[self.view getPicScaleLen:45]];
        
        item.imgView2.centerY = item.height/2;
        
        item.label.text = [NSString stringWithFormat:@"用户名：%@",[dic objectForKey:@"loginname"]];
        item.imgView.image = IMAGE_NAMED(@"个人中心icon");
        //56x53
        [item.imgView setFrameInSuperViewCenter:nil width:[self.view getPicScaleLen:56] height:[self.view getPicScaleLen:53]];
        item.imgView.left = Space_Normal;
        itemTemp = item;
        
       
    }
    [scroll setContentSize:CGSizeMake(scroll.width, itemTemp.bottom + 10)];
    

}
- (void)clearSelectButton:(UIButton *)selButton
{
    NSUInteger count = [_dataArray count];
    for (int i = 0; i < count; i++)
    {
        UIButton * button = [self.contentView viewWithTag:i+1];
        if (button!= nil && button != selButton)
        {
            
            button.selected = NO;
        }
        
        
    }
}
-(void)buttonPressed3:(UIButton *)button
{
    
    button.selected = YES;
    //选中
    [self clearSelectButton:button];

}
-(void)buttonPressed4:(UIButton *)button
{
    //确定 到登录界面
    NSUInteger count = [_dataArray count];
    int selectIndex = 0;
    for (int i = 0; i < count; i++)
    {
        UIButton * button = [self.contentView viewWithTag:i+1];
        if (button.selected)
        {
            
            selectIndex = i;
            break;
        }
        
    }
    NSDictionary *dic = [_dataArray objectAtIndex:selectIndex];
    NSString *loginName = [dic objectForKey:@"loginname"];
    [viewDic setObjectFilterNull:loginName forKey:@"loginName_select"];
    [self popToViewControllWithClassName:@"LoginViewController"];
}

-(void)sendRequest
{
    RequestAction *request = [[RequestAction alloc] init];
    
    request.delegate = self;
    
    [request addAccessory:self];
    
    request.tag = 3;
    //手机号(必填)
    [request.parm setObjectFilterNull:_phoneNum forKey:@"mobilePhone"];
    [request request_getLoginnameByPhoneNum];
}
#pragma mark -responseData
-(void)requestFinished:(__kindof YTKBaseRequest *)request
{
    if (request.tag == 3)
    {
        //request.responseString
        [_dataArray removeAllObjects];
        Response *response =  [Response modelWithJSON:request.responseData];
        //         NSLog(@"%@",response);
        if ([@"10000" isEqualToString:response.code])
        {
            NSArray * array = (NSArray *)response.data;
            for (NSDictionary *dic in array)
            {
                [_dataArray addObject:dic];
            }
            [self initAllViews];
            //            self.arrayData = (NSArray *)response.data;
            //            UserInfoModel *mode = [UserInfoModel modelWithJSON:response.data];
            
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
