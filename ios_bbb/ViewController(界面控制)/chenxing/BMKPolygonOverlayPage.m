//
//  BMKPolygonOverlayPage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPolygonOverlayPage.h"
#import "TSTimeHMView.h"
#import "EfenceInfoModel.h"
static NSString *annotationViewIdentifier = @"com.Baidu.BMKPointAnnotation";
//开发者通过此delegate获取mapView的回调方法
@interface BMKPolygonOverlayPage ()<BMKMapViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKPolygon *polygon; //当前界面的多边形

//@property (nonatomic, strong) BMKPointAnnotation *annotation3; //当前界面的标注
//@property (nonatomic, strong) BMKPointAnnotation *annotation4; //当前界面的标注
//@property (nonatomic, strong) BMKPointAnnotation *annotation5; //当前界面的标注
//放多边形的标注
@property (nonatomic, strong) NSMutableArray *annotationArray;

@property (nonatomic, strong) BMKCircle *circle; //当前界面的圆
@property (nonatomic, strong) BMKPointAnnotation *annotation1; //圆心
@property (nonatomic, strong) BMKPointAnnotation *annotation2; //圆边的点

@property (nonatomic, assign) CLLocationCoordinate2D carLocation; //车的坐标
////方形的 主要是记录在缓存里
//@property (nonatomic, strong) NSMutableArray *locationPolygonArray;
////圆形的 主要是记录在缓存里
//@property (nonatomic, strong) NSMutableArray *locationCircleArray;

// 围栏类型  1圆形 2矩形    3多边形
@property (nonatomic, assign) int initType;

//围栏启用状态：0否；1是
@property (nonatomic, assign) int isEnable;


//报警类型  0全部  1入区    2出区
@property (nonatomic, assign) int alarmType;

//开始时间
@property (nonatomic, strong) NSString *startDate;
//结束时间
@property (nonatomic, strong) NSString *endDate;

@property (nonatomic, strong) UIView *myBottomView;

@property (nonatomic, strong) BMKPointAnnotation *annotation_fix;//固定参考点
@end

@implementation BMKPolygonOverlayPage

#pragma mark - View life cycle
-(void)loadView
{
    self.navType = 2;
//    self.title = @"画多边形";
    self.leftNavBtnName = @"返回";
    [super loadView];
}
- (void)resetSomeSetting {
    _isEnable = 0;
    _initType = 1;
    _startDate = @"00:00";
    _endDate = @"23:59";
    _alarmType = 2;
}

- (void)viewDidLoad {

    [super viewDidLoad];
//     _initType = 1;
    [self resetSomeSetting];
    //初始化车的位置
    _carLocation = CLLocationCoordinate2DMake(39.915, 116.404);
//    self.locationPolygonArray = [NSMutableArray arrayWithCapacity:5];
//    self.locationCircleArray = [NSMutableArray arrayWithCapacity:2];
//    [self configUI];
    [self createMapView];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(Space_Normal, StatusBarHeight+Space_Normal, 30, 30)];
    [self.view addSubview:button3];
    button3.backgroundColor = [UIColor clearColor];
    [button3 addTarget:self action:@selector(leftNavBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button3 setBackgroundImage:IMAGE_NAMED(@"返回") forState:UIControlStateNormal];
    [button3 setBackgroundImage:IMAGE_NAMED(@"返回按下") forState:UIControlStateHighlighted];
    [self sendRequest_getData];

//    [self addBottomView];
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight - 100, 100, 50)];
//    [self.view addSubview:button];
//    button.backgroundColor = [UIColor redColor];
//    [button addTarget:self action:@selector(initPolygonPressed) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(120, ScreenHeight - 100, 100, 50)];
//    [self.view addSubview:button2];
//    button2.backgroundColor = [UIColor redColor];
//    [button2 addTarget:self action:@selector(initCirclePressed) forControlEvents:UIControlEventTouchUpInside];

}
//驶入
-(void)buttonPressed1:(UIButton *)button
{
//    if (button.selected == NO)
//    {
        button.selected = !button.selected;
//    }
    UIButton *temp = [self.view viewWithTag:2];
//    if (button.selected)
//    {
//        temp.selected =  !button.selected;
//    }
    //报警类型  0全部  1入区    2出区
    if (button.selected)
    {
        _alarmType = 1;
    }
    if (temp.selected)
    {
        _alarmType = 2;
    }
    if (temp.selected && button.selected)
    {
        _alarmType = 0;
    }
    if (!temp.selected && !button.selected)
    {
        button.selected = YES;
        _alarmType = 1;
    }
}
//驶出
-(void)buttonPressed2:(UIButton *)button
{
//    if (button.selected == NO)
//    {
        button.selected = !button.selected;
//    }
    UIButton *temp = [self.view viewWithTag:1];
//    if (button.selected)
//    {
//        temp.selected =  !button.selected;
//    }
    //报警类型  0全部  1入区    2出区
    if (button.selected)
    {
        _alarmType = 2;
    }
    if (temp.selected)
    {
        _alarmType = 1;
    }
    if (temp.selected && button.selected)
    {
        _alarmType = 0;
    }
    if (!temp.selected && !button.selected)
    {
        button.selected = YES;
        _alarmType = 2;
    }
}
//结束报警时间
-(void)buttonPressed3:(UIButton *)button
{
    TSTimeHMView *loa = [TSTimeHMView initWithTitle:@"结束报警时间" delegate:self];
    loa.buttonIndex = 6;
    [loa showInView:self.view];
    [loa setFirstValuesWithStr:button.titleLabel.text];
//    if ([NomalUtil isValueableString:[viewDic objectForKey:name]])
//    {
//        [loa setFirstValuesWithStr:[viewDic objectForKey:name]];
//    }
}

//开始报警时间
-(void)buttonPressed4:(UIButton *)button
{
    TSTimeHMView *loa = [TSTimeHMView initWithTitle:@"开始报警时间" delegate:self];
    loa.buttonIndex = 5;
    [loa showInView:self.view];
//    NSLog(@"%@",button.titleLabel.attributedText);
    
    [loa setFirstValuesWithStr:button.titleLabel.text];
}
//是否启用 是
-(void)buttonPressed5:(UIButton *)button
{
    if (button.selected == NO)
    {
        button.selected = !button.selected;
    }
    UIButton *temp = [self.view viewWithTag:6];
    if (button.selected)
    {
        temp.selected =  !button.selected;
    }
    if (button.selected)
    {
        _isEnable = 1;
    }
}
//是否启用 否
-(void)buttonPressed6:(UIButton *)button
{
    if (button.selected == NO)
    {
        button.selected = !button.selected;
    }
    UIButton *temp = [self.view viewWithTag:5];
    if (button.selected)
    {
        temp.selected =  !button.selected;
    }
    if (button.selected)
    {
        _isEnable = 0;
    }
}
//不规则形
-(void)buttonPressed7:(UIButton *)button
{
    if (button.selected == NO)
    {
        button.selected = !button.selected;
        [self initPolygonPressed];
    }
    
    UIButton *temp = [self.view viewWithTag:8];
    if (button.selected)
    {
        temp.selected =  !button.selected;
    }

}
//圆形
-(void)buttonPressed8:(UIButton *)button
{
    if (button.selected == NO)
    {
        button.selected = !button.selected;
        [self initCirclePressed];
    }
    UIButton *temp = [self.view viewWithTag:7];
    if (button.selected)
    {
        temp.selected =  !button.selected;
    }

}
//重绘
-(void)buttonPressed9:(UIButton *)button
{
    
    UIButton *buttonTemp = [self.view viewWithTag:7];
    if (buttonTemp.isSelected)
    {
        [self clearOverlayAndCache:NO];
//        [self initPolygonPressed];
    }
    else
    {
        [self clearOverlayAndCache:YES];
//        [self initCirclePressed];
    }
//    [self resetSomeSetting];
    [self repaintAndResetData];
}
//保存
-(void)buttonPressed10:(UIButton *)button
{
    [kUserDefaults setObject:@"1" forKey:@"isShowAlertHelp"];
    [kUserDefaults synchronize];
    [self sendRequest];
}
-(void)addBottomView
{
    if (self.myBottomView != nil)
    {
        [self.myBottomView removeFromSuperview];
    }
    CGFloat space = 10;
    CGFloat space2 = 5;
    UIView *bottomView = [self.view getSubViewInstanceWith:[UIView class]];
    bottomView.backgroundColor = Color_Nomal_Bg;
    self.myBottomView = bottomView;
    [bottomView setFrameInSuperViewCenterBottom:nil toBottomSpace:SAFE_AREA_INSETS_BOTTOM_NotZero width:ScreenWidth - Space_Normal*2 height:100];
    [bottomView setCornerRadius:5];
    [bottomView setBorder:[UIColor whiteColor] width:1];
    CGFloat lineHeight = 25;
    UILabel *lable1 = (UILabel *)[bottomView getSubViewInstanceWith:[UILabel class]];
    lable1.font = FFont_Default_Small;
    lable1.textColor = Color_Nomal_Font_BlueGray;
    lable1.text = @"报警类型";
    
    [lable1 setFrameInSuperViewLeftTop:nil toLeftSpace:space toTopSpace:space width:[lable1.text widthForFont:FFont_Default_Small] height:lineHeight];
    
     UIButton *button1 = (UIButton *)[bottomView getSubViewInstanceWith:[UIButton class]];
    [button1 setImage:IMAGE_NAMED(@"未选中") forState:UIControlStateNormal];
    [button1 setImage:IMAGE_NAMED(@"选中") forState:UIControlStateSelected];
    [button1 setTitle:@"驶入" forState:UIControlStateNormal];
    [button1 setTitleColor:Color_Nomal_Font_BlueGray forState:UIControlStateNormal];
    button1.titleLabel.font = FFont_Default_Small;
    [button1 setFrameLeftTopFromViewRightTop:lable1 rightToLeftSpace:space2 topToTop:0 width:50*ScalNum_Width height:lineHeight];
    if (ScalNum_Width < 1)
    {
        [button1 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 1)];
    }
    else
    {
       [button1 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    }
    
//    [button1 setSelected:YES];
    [button1 addTarget:self action:@selector(buttonPressed1:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button2 = (UIButton *)[bottomView getSubViewInstanceWith:[UIButton class]];
    [button2 setImage:IMAGE_NAMED(@"未选中") forState:UIControlStateNormal];
    [button2 setImage:IMAGE_NAMED(@"选中") forState:UIControlStateSelected];
    
    if (ScalNum_Width < 1)
    {
        [button2 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 1)];
    }
    else
    {
        [button2 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    }
    [button2 setTitle:@"驶出" forState:UIControlStateNormal];
    [button2 setTitleColor:Color_Nomal_Font_BlueGray forState:UIControlStateNormal];
    button2.titleLabel.font = FFont_Default_Small;
    [button2 setFrameLeftTopFromViewRightTop:button1 rightToLeftSpace:0 topToTop:0 width:50*ScalNum_Width height:lineHeight];
    [button2 addTarget:self action:@selector(buttonPressed2:) forControlEvents:UIControlEventTouchUpInside];
    if (_alarmType == 0)
    {
        [button1 setSelected:YES];
        [button2 setSelected:YES];
    }
    else if (_alarmType == 1)
    {
        [button1 setSelected:YES];
    }
    else if (_alarmType == 2)
    {
        [button2 setSelected:YES];
    }
    //从右向左绘
    UIButton *button3 = (UIButton *)[bottomView getSubViewInstanceWith:[UIButton class]];
    [button3 setBackgroundColor:[UIColor clearColor]];
    [button3 setTitle:_endDate forState:UIControlStateNormal];
    [button3 setTitleColor:Color_Nomal_Font_BlueGray forState:UIControlStateNormal];
    button3.titleLabel.font = FFont_Default_Small;
    // 下划线
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:button3.titleLabel.text attributes:attribtDic];
    //赋值
    button3.titleLabel.attributedText = attribtStr;
    
    [button3 setFrameInSuperViewRightTop:nil toRightSpace:space toTopSpace:space width:[button3.titleLabel.text widthForFont:button3.titleLabel.font]+3 height:lineHeight];
    [button3 addTarget:self action:@selector(buttonPressed3:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lable2 = (UILabel *)[bottomView getSubViewInstanceWith:[UILabel class]];
    lable2.font = FFont_Default_Small;
    lable2.textColor = Color_Nomal_Font_BlueGray;
    lable2.text = @"至";
    [lable2 setFrameRightTopFromViewLeftTop:button3 leftToRightSpace:5*ScalNum_Width topToTopSpace:0 width:[lable2.text widthForFont:lable2.font] height:lineHeight];
    
    UIButton *button4 = (UIButton *)[bottomView getSubViewInstanceWith:[UIButton class]];
    [button4 setBackgroundColor:[UIColor clearColor]];
    [button4 setTitle:_startDate forState:UIControlStateNormal];
    [button4 setTitleColor:Color_Nomal_Font_BlueGray forState:UIControlStateNormal];
    button4.titleLabel.font = FFont_Default_Small;
    // 下划线
    NSDictionary *attribtDic2 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    NSMutableAttributedString *attribtStr2 = [[NSMutableAttributedString alloc]initWithString:button4.titleLabel.text attributes:attribtDic2];
    //赋值
    button4.titleLabel.attributedText = attribtStr2;
    
    //富文本
//    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"发送验证码"]];
//    NSRange contentRange = {0,[content length]};
//    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
//    //button的setAttributedTitle方法
//    [button4 setAttributedTitle:content forState:UIControlStateNormal];

  
    [button4 addTarget:self action:@selector(buttonPressed4:) forControlEvents:UIControlEventTouchUpInside];
    [button4 setFrameRightTopFromViewLeftTop:lable2 leftToRightSpace:5*ScalNum_Width topToTopSpace:0 width:[button4.titleLabel.text widthForFont:button4.titleLabel.font]+3 height:lineHeight];
    
    UILabel *lable3 = (UILabel *)[bottomView getSubViewInstanceWith:[UILabel class]];
    lable3.font = FFont_Default_Small;
    
    lable3.textColor = Color_Nomal_Font_BlueGray;
    lable3.text = @"时间范围";
    [lable3 setFrameRightTopFromViewLeftTop:button4 leftToRightSpace:5*ScalNum_Width topToTopSpace:0 width:[lable3.text widthForFont:lable3.font] height:lineHeight];
    
    
    //第二行
    UILabel *lable4 = (UILabel *)[bottomView getSubViewInstanceWith:[UILabel class]];
    lable4.font = FFont_Default_Small;
    lable4.textColor = Color_Nomal_Font_BlueGray;
    lable4.text = @"是否启用";
    [lable4 setFrameLeftTopFromViewLeftBottom:lable1 leftToLeftSpace:0 bottomToTopSpace:space2 width:[lable4.text widthForFont:FFont_Default_Small] height:lineHeight];
    
    
    UIButton *button5 = (UIButton *)[bottomView getSubViewInstanceWith:[UIButton class]];
    [button5 setImage:IMAGE_NAMED(@"未选中") forState:UIControlStateNormal];
    [button5 setImage:IMAGE_NAMED(@"选中") forState:UIControlStateSelected];
    [button5 setTitle:@"是" forState:UIControlStateNormal];
    [button5 setTitleColor:Color_Nomal_Font_BlueGray forState:UIControlStateNormal];
    button5.titleLabel.font = FFont_Default_Small;
    [button5 setFrameLeftTopFromViewRightTop:lable4 rightToLeftSpace:space2 topToTop:0 width:40*ScalNum_Width height:lineHeight];
    [button5 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    
    [button5 addTarget:self action:@selector(buttonPressed5:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button6 = (UIButton *)[bottomView getSubViewInstanceWith:[UIButton class]];
    [button6 setImage:IMAGE_NAMED(@"未选中") forState:UIControlStateNormal];
    [button6 setImage:IMAGE_NAMED(@"选中") forState:UIControlStateSelected];
    
    [button6 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [button6 setTitle:@"否" forState:UIControlStateNormal];
    [button6 setTitleColor:Color_Nomal_Font_BlueGray forState:UIControlStateNormal];
    button6.titleLabel.font = FFont_Default_Small;
    [button6 setFrameLeftTopFromViewRightTop:button5 rightToLeftSpace:0 topToTop:0 width:40*ScalNum_Width height:lineHeight];
    [button6 addTarget:self action:@selector(buttonPressed6:) forControlEvents:UIControlEventTouchUpInside];
    if (_isEnable == 1)
    {
        [button5 setSelected:YES];
        [button6 setSelected:NO];
    }
    else
    {
        [button6 setSelected:YES];
        [button5 setSelected:NO];
    }
    //从右向左绘
    UIButton *button7 = (UIButton *)[bottomView getSubViewInstanceWith:[UIButton class]];
    [button7 setBackgroundColor:[UIColor clearColor]];
    //不规则形
    [button7 setBackgroundImage:IMAGE_NAMED(@"不规则形") forState:UIControlStateNormal];
    [button7 setBackgroundImage:IMAGE_NAMED(@"不规则形按下") forState:UIControlStateSelected];
    
    [button7 setFrameRightTopFromViewRightBottom:button3 rightToRightSpace:0 bottomToTopSpace:space2 width:79*ScalNum_Width height:lineHeight];
    [button7 addTarget:self action:@selector(buttonPressed7:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button8 = (UIButton *)[bottomView getSubViewInstanceWith:[UIButton class]];
    [button8 setBackgroundColor:[UIColor clearColor]];
//    button8.selected = YES;
    [button8 setBackgroundImage:IMAGE_NAMED(@"圆形") forState:UIControlStateNormal];
    [button8 setBackgroundImage:IMAGE_NAMED(@"圆形按下") forState:UIControlStateSelected];
    [button8 setFrameRightTopFromViewLeftTop:button7 leftToRightSpace:space topToTopSpace:0 width:79*ScalNum_Width height:lineHeight];
    
    [button8 addTarget:self action:@selector(buttonPressed8:) forControlEvents:UIControlEventTouchUpInside];
    if (_initType == 1)
    {
        button8.selected = YES;
        button7.selected = NO;
    }
    else
    {
        button7.selected = YES;
        button8.selected = NO;
    }
    UIButton *button9 = (UIButton *)[bottomView getSubViewInstanceWith:[UIButton class]];
    button9.backgroundColor = [UIColor colorWithHexString:@"FFFFFF" alpha:0.3];
    [button9 setCornerRadius:4];
    [button9 setTitle:@"重 绘" forState:UIControlStateNormal];
    [button9 setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
    button9.titleLabel.font = FFont_Default_Small;
    [button9 setFrameLeftTopFromViewLeftBottom:lable4 leftToLeftSpace:0 bottomToTopSpace:space width:150*ScalNum_Width height:lineHeight+5];
    [button9 addTarget:self action:@selector(buttonPressed9:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button10 = (UIButton *)[bottomView getSubViewInstanceWith:[UIButton class]];
    button10.backgroundColor = [UIColor whiteColor];
    [button10 setCornerRadius:4];
    [button10 setTitle:@"保 存" forState:UIControlStateNormal];
    [button10 setTitleColor:Color_Nomal_Font_Blue forState:UIControlStateNormal];
    button10.titleLabel.font = FFont_Default_Small;
    
    [button10 setFrameRightTopFromViewRightBottom:button7 rightToRightSpace:0 bottomToTopSpace:space width:150*ScalNum_Width height:lineHeight +5];
    [button10 addTarget:self action:@selector(buttonPressed10:) forControlEvents:UIControlEventTouchUpInside];

    
    [bottomView setFrameInSuperViewCenterBottom:nil toBottomSpace:SAFE_AREA_INSETS_BOTTOM_NotZero width:ScreenWidth - Space_Normal*2 height:button9.bottom + space + 3];
    
    button1.tag = 1;
    button2.tag = 2;
    button3.tag = 3;
    button4.tag = 4;
    button5.tag = 5;
    button6.tag = 6;
    button7.tag = 7;
    button8.tag = 8;
    button9.tag = 9;
    button10.tag = 10;
}
//-(UIStatusBarStyle)StatusBarStyle
//{
//    return UIStatusBarStyleDefault;
//}
//初始化多边形
-(void)initPolygonPressed
{
    
    [self clearOverlay];
    _initType = 3;

    [_mapView addOverlay:self.polygon];
    
//    BMKMapRect rect = self.polygon.boundingMapRect;
//    CLLocationCoordinate2D temp = [_mapView convertPoint:[_mapView glPointForMapPoint:rect.origin] toCoordinateFromView:self.view];
//     [_mapView setCenterCoordinate:temp];
    double max_latitude = 0;
    double min_latitude = 1000;
    double max_longitude = 0;
    double min_longitude = 1000;
    for (BMKPointAnnotation *ano in _annotationArray)
    {
        if (ano.coordinate.latitude > max_latitude)
        {
            max_latitude = ano.coordinate.latitude;
        }
        if (ano.coordinate.longitude > max_longitude)
        {
            max_longitude = ano.coordinate.longitude;
        }
        if (ano.coordinate.latitude < min_latitude)
        {
            min_latitude = ano.coordinate.latitude;
        }
        if (ano.coordinate.longitude < min_longitude)
        {
            min_longitude = ano.coordinate.longitude;
        }
        
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((max_latitude + min_latitude)/2, (max_longitude + min_longitude)/2);
//    [_mapView setCenterCoordinate:_carLocation];
    [_mapView setCenterCoordinate:center];
    [_mapView setZoomLevel:15];
    //经纬度与界面坐标的转换
//    [_mapView convertPoint:<#(CGPoint)#> toCoordinateFromView:<#(UIView *)#>]
    
}
//初始化圆
-(void)initCirclePressed
{
    [self clearOverlay];
    _initType = 1;
    
    [_mapView addOverlay:self.circle];
    
    [_mapView setCenterCoordinate:_annotation1.coordinate];
    [_mapView setZoomLevel:15];
    
}
//保存上次绘的图
-(void)clearOverlay
{
    if (_mapView != nil)
    {
        if (_polygon != nil)
        {
            [_mapView removeOverlay:_polygon];
            [_mapView removeAnnotations:_annotationArray];
//            _polygon = nil;
        }
        if (_circle != nil)
        {
            [_mapView removeOverlay:_circle];
            [_mapView removeAnnotation:_annotation1];
            [_mapView removeAnnotation:_annotation2];
//            _circle = nil;
        }
    }
}

//清缓存，不保存上次绘的图
-(void)clearOverlayAndCache:(BOOL)isCircle
{
    if (_mapView != nil)
    {
        if (_polygon != nil && !isCircle)
        {
            [_mapView removeOverlay:_polygon];
            [_mapView removeAnnotations:_annotationArray];
            _polygon = nil;
            self.annotationArray = nil;
        }
        if (_circle != nil && isCircle)
        {
            [_mapView removeOverlay:_circle];
            [_mapView removeAnnotation:_annotation1];
            [_mapView removeAnnotation:_annotation2];
            _annotation1 = nil;
            _annotation2 = nil;
            _circle = nil;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
    [super viewWillAppear:animated];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated {
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
    [super viewWillDisappear:animated];
}

#pragma mark - Config UI
//- (void)configUI
//{
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"多边形绘制";
//}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"didSelectAnnotationView");
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"didDeselectAnnotationView");
}
- (void)createMapView
{
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    /**
     向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
     来生成标注对应的View
     
     @param overlay 要添加的overlay
     */
//    _initType = 1;
//    [_mapView addOverlay:self.polygon];
//    [self initCirclePressed];
}
//创建一个固定的参考点
- (void)createFixAnnotationWith:(CLLocationCoordinate2D) coordinate
{
    if (_annotation_fix != nil)
    {
        [_mapView removeAnnotation:_annotation_fix];
    }
    //初始化标注类BMKPointAnnotation的实例
    _annotation_fix = [[BMKPointAnnotation alloc] init];
    //设置标注的经纬度坐标
    _annotation_fix.coordinate =  coordinate;
    //标注是否固定在指定屏幕位置,  必须与screenPointToLock一起使用
    _annotation_fix.isLockedToScreen = YES;
    /**
     标注锁定在屏幕上的位置(地图初始化后才能设置，可以在地图加载完成的回调方法
     -mapViewDidFinishLoading中使用此属性
     */
    
    
//    _annotation_fix.screenPointToLock = [self.mapView convertCoordinate:coordinate toPointToView:self.view];
    _annotation_fix.screenPointToLock = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    //设置标注的标题
    _annotation_fix.title = @"重绘参考点";
    
    //副标题
//    _annotation_fix.subtitle = @"固定屏幕";
    /**
     
     当前地图添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:方法
     来生成标注对应的View
     @param annotation 要添加的标注
     */
    [_mapView addAnnotation:_annotation_fix];
}
//-(void)mapViewDidFinishLoading:(BMKMapView *)mapView
//{
////    _annotation_fix.screenPointToLock = CGPointMake(ScreenWidth/2, ScreenHeight/2);
//
//}
#pragma mark - BMKMapViewDelegate
/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        //初始化一个overlay并返回相应的BMKPolygonView的实例
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithPolygon:overlay];
        //设置polygonView的画笔（边框）颜色
        polygonView.strokeColor = [UIColor colorWithHexString:@"097C25" alpha:1];
        //设置polygonView的填充色
        polygonView.fillColor = [UIColor colorWithHexString:@"097C25" alpha:0.26];
        //设置polygonView的线宽度
        polygonView.lineWidth = 1.0;
        //设置polygonView为虚线样式
//        polygonView.lineDash = YES;
        return polygonView;
    }
    else if ([overlay isKindOfClass:[BMKCircle class]])
    {
        //初始化一个overlay并返回相应的BMKCircleView的实例
        BMKCircleView *circleView = [[BMKCircleView alloc] initWithCircle:overlay];
        //设置circleView边色
        circleView.strokeColor = [UIColor colorWithHexString:@"097C25" alpha:1];
        //设置circleView的填充色
        circleView.fillColor = [UIColor colorWithHexString:@"097C25" alpha:0.26];
        //设置circleView的轮廓宽度
        circleView.lineWidth = 1.0;
        
//        circleView.lineDash = YES;
        return circleView;
    }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState fromOldState:(BMKAnnotationViewDragState)oldState
{
    //    NSLog(@"didChangeDragState");
    [self repaintView];
}


/**
 根据anntation生成对应的annotationView
 
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        /**
         根据指定标识查找一个可被复用的标注，用此方法来代替新创建一个标注，返回可被复用的标注
         */
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
        if (annotationView == nil) {
            /**
             初始化并返回一个annotationView
             
             @param annotation 关联的annotation对象
             @param reuseIdentifier 如果要重用view，传入一个字符串，否则设为nil，建议重用view
             @return 初始化成功则返回annotationView，否则返回nil
             */
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier];
            //annotationView显示的图片，默认是大头针
            //annotationView.image = nil;
            /**
             默认情况下annotationView的中心点位于annotation的坐标位置，可以设置centerOffset改变
             annotationView的位置，正的偏移使annotationView朝右下方移动，负的朝左上方，单位是像素
             */
            annotationView.centerOffset = CGPointMake(0, 0);
            /**
             默认情况下, 弹出的气泡位于annotationView正中上方，可以设置calloutOffset改变annotationView的
             位置，正的偏移使annotationView朝右下方移动，负的朝左上方，单位是像素
             */
            annotationView.calloutOffset = CGPointMake(0, 0);
            //是否显示3D效果，标注在地图旋转和俯视时跟随旋转、俯视，默认为NO
            annotationView.enabled3D = NO;
            //是否忽略触摸时间，默认为YES
            annotationView.enabled = YES;
            /**
             开发者不要直接设置这个属性，若设置，需要在设置后调用BMKMapView的-(void)mapForceRefresh;方法
             刷新地图，默认为NO，当annotationView被选中时为YES
             */
            annotationView.selected = NO;
            //annotationView被选中时，是否显示气泡（若显示，annotation必须设置了title），默认为YES
            annotationView.canShowCallout = YES;
            /**
             显示在气泡左侧的view(使用默认气泡时，view的width最大值为32，
             height最大值为41，大于则使用最大值）
             */
            annotationView.leftCalloutAccessoryView = nil;
            /**
             显示在气泡右侧的view(使用默认气泡时，view的width最大值为32，
             height最大值为41，大于则使用最大值）
             */
            annotationView.rightCalloutAccessoryView = nil;
            /**
             annotationView的颜色： BMKPinAnnotationColorRed，BMKPinAnnotationColorGreen，
             BMKPinAnnotationColorPurple
             */
            annotationView.pinColor = BMKPinAnnotationColorRed;
            //设置从天而降的动画效果
            annotationView.animatesDrop = YES;
            //当设为YES并实现了setCoordinate:方法时，支持将annotationView在地图上拖动
            annotationView.draggable = NO;
            //当前view的拖动状态
            //annotationView.dragState;
            //            NSLog(@"0000000000");
        }
        BMKPointAnnotation *tempAnnotation = (BMKPointAnnotation*)annotation;
        if ([@"重绘参考点" isEqualToString:tempAnnotation.title])
        {
            annotationView.pinColor = BMKPinAnnotationColorGreen;
            annotationView.draggable = NO;
            annotationView.selected = YES;
            //annotationView被选中时，是否显示气泡（若显示，annotation必须设置了title），默认为YES
            annotationView.canShowCallout = YES;
//            tempAnnotation.isLockedToScreen = YES;
//            _annotation_fix.screenPointToLock = CGPointMake(ScreenWidth/2, ScreenHeight/2);
        }
        else
        {
            annotationView.pinColor = BMKPinAnnotationColorRed;
            annotationView.draggable = YES;
//            annotationView.selected = NO;
            //annotationView被选中时，是否显示气泡（若显示，annotation必须设置了title），默认为YES
//            annotationView.canShowCallout = YES;
            tempAnnotation.isLockedToScreen = NO;
            tempAnnotation.title = @"请长按并拖动定位图标设置围栏区域";
            annotationView.selected = YES;
            NSString *str = [kUserDefaults objectForKey:@"isShowAlertHelp"];
            if (str == nil)
            {
                annotationView.canShowCallout = YES;
            }
            else
            {
                annotationView.canShowCallout = NO;
            }
        }

        return annotationView;
    }
    return nil;
}
#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        
        _mapView = [[BMKMapView alloc] initWithFrame:Rect(0, 0, self.view.width, self.view.height)];
    }
    return _mapView;
}

-(CGPoint) calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius
{
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
}
//初始化多边形
- (BMKPolygon *)polygon
{
    if (!_polygon) {
        



//        coords[1] = CLLocationCoordinate2DMake(39.955, 116.604);
//        coords[2] = CLLocationCoordinate2DMake(39.945, 116.614);
//        coords[3] = CLLocationCoordinate2DMake(39.955, 116.624);
//        coords[4] = CLLocationCoordinate2DMake(39.965, 116.624);
        if (_annotationArray == nil || [_annotationArray count] == 0)
        {
            CLLocationCoordinate2D coords[5] = {0};
            coords[0] = CLLocationCoordinate2DMake(_carLocation.latitude + 0.01, _carLocation.longitude);
            coords[1] = CLLocationCoordinate2DMake(_carLocation.latitude, _carLocation.longitude + 0.01);
            coords[2] = CLLocationCoordinate2DMake(_carLocation.latitude - 0.01, _carLocation.longitude);
            coords[3] = CLLocationCoordinate2DMake(_carLocation.latitude, _carLocation.longitude- 0.01);
            coords[4] = CLLocationCoordinate2DMake(_carLocation.latitude + 0.012, _carLocation.longitude -0.012);
            self.annotationArray = [NSMutableArray arrayWithCapacity:5];
            for (int i = 0; i<5; i++)
            {
                BMKPointAnnotation *annotation1 = [[BMKPointAnnotation alloc] init];
                annotation1.coordinate =  coords[i];//
                //设置标注的标题
                //            annotation1.title = @"标注";
                //            //副标题
                //            annotation1.subtitle = @"可拖拽";
                /**
                 
                 当前地图添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:方法
                 来生成标注对应的View
                 @param annotation 要添加的标注
                 */
                [_annotationArray addObject:annotation1];
                
            }
        }
       
        /**
         根据多个经纬点生成多边形
         
         @param coords 经纬度坐标点数组
         @param count 点的个数
         @return 新生成的BMKPolygon实例
         */
        CLLocationCoordinate2D coords[100];
        for (int i =0;i< [_annotationArray count];i++)
        {
            BMKPointAnnotation *temp = [_annotationArray objectAtIndex:i];
            coords[i] = temp.coordinate;
        }
        _polygon = [BMKPolygon polygonWithCoordinates:coords count:[_annotationArray count]];
       
    }
    [_mapView addAnnotations:_annotationArray];
    return _polygon;
}
//-(void)test
//{
//    /**
//     *判断点是否在多边形内
//     *@param point 待判断的平面坐标点
//     *@param polygon 目标多边形的顶点数组
//     *@param count 目标多边形顶点数组元素个数
//     *@return 如果在内，返回YES，否则返回NO
//     */
//    UIKIT_EXTERN BOOL BMKPolygonContainsPoint(BMKMapPoint point, BMKMapPoint *polygon, NSUInteger count);
//
//    /**
//     *判断点是否在多边形内
//     *@param point 待判断的经纬度点
//     *@param polygon 目标多边形的顶点数组
//     *@param count 目标多边形顶点数组元素个数
//     *@return 如果在内，返回YES，否则返回NO
//     */
//    UIKIT_EXTERN BOOL BMKPolygonContainsCoordinate(CLLocationCoordinate2D point, CLLocationCoordinate2D *polygon, NSUInteger count);
//
//   // 判断点与圆位置关系的示例代码如下：
//    BOOL ptInCircle = BMKCircleContainsCoordinate(CLLocationCoordinate2DMake(39.918,116.408), CLLocationCoordinate2DMake(39.915,116.404), 1000);
//   // 除以上位置关系判断方法外，SDK还提供获取折线上与折线外指定位置最近点的方法。核心代码如下：
////    BMKMapPoint *polylinePoints = new BMKMapPoint[4];//这是C++的写法，下面是OC写法
//    BMKMapPoint *polylinePoints = (BMKMapPoint *)malloc(sizeof(CLLocationCoordinate2D) * 4);
//    polylinePoints[0]= BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.915,116.404));
//    polylinePoints[1]= BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.915,116.454));;
//    polylinePoints[2]= BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.975,116.524));;
//    polylinePoints[3]= BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.855,116.554));
//    BMKMapPoint point = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.815,116.504));
//    BMKMapPoint nearestPoint = BMKGetNearestMapPointFromPolyline(point, polylinePoints, 4);
//
////    [_mapView setRegion:(BMKCoordinateRegion)]
////    [_mapView setMapCenterToScreenPt:(CGPoint)]
//}
-(void)repaintView
{
    if (_initType == 3)
    {
        if (_polygon != nil)
        {
            //    [_mapView removeOverlay:_polygon];
            CLLocationCoordinate2D coords[100] = {0};
            int i = 0;
            for (BMKPointAnnotation *temp in _annotationArray)
            {
                coords[i] = temp.coordinate;
                i++;
            }
            //    _polygon = [BMKPolygon polygonWithCoordinates:coords count:5];
            //
            //    [_mapView addOverlay:_polygon];
            [_polygon setPolygonWithCoordinates:coords count:[_annotationArray count]];
        }
       
    }
    else
    {
        if (_circle != nil) {
            //        CLLocationCoordinate2D coor = _annotation1.coordinate;
            CLLocation*newLocation =[[CLLocation alloc] initWithCoordinate: _annotation1.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
            CLLocation*newLocation2 =[[CLLocation alloc] initWithCoordinate: _annotation2.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
            
            [_circle setCircleWithCenterCoordinate:_annotation1.coordinate radius:[newLocation distanceFromLocation:newLocation2]];
            
        }
    }

    
}

- (BMKCircle *)circle {
    if (!_circle)
    {
        _annotation1 = [[BMKPointAnnotation alloc] init];
        //设置标注的经纬度坐标
        _annotation1.coordinate =  _carLocation;
        //设置标注的标题
        //    _annotation1.title = @"标注";
        //    //副标题
        //    _annotation1.subtitle = @"可拖拽";
        /**
         当前地图添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:方法
         来生成标注对应的View
         @param annotation 要添加的标注
         */
//        [_mapView addAnnotation:_annotation1];
        
        //初始化标注类BMKPointAnnotation的实例
        if (_annotation2 == nil)
        {
            _annotation2 = [[BMKPointAnnotation alloc] init];
            //设置标注的经纬度坐标
            _annotation2.coordinate =  CLLocationCoordinate2DMake(_carLocation.latitude + 0.01, _carLocation.longitude);
        }
        
//        [_mapView addAnnotation:_annotation2];
        
        CLLocation*newLocation =[[CLLocation alloc] initWithCoordinate: _annotation1.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
        CLLocation*newLocation2 =[[CLLocation alloc] initWithCoordinate: _annotation2.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
        //        CLLocationDistance kilometers =[newLocation distanceFromLocation:oldLocation]/1000;
        /**
         根据中心点和半径生成圆
         
         @param coord 中心点的经纬度坐标
         @param radius 半径，单位：米
         @return 新生成的BMKCircle实例
         */
        _circle = [BMKCircle circleWithCenterCoordinate:_annotation1.coordinate radius:[newLocation distanceFromLocation:newLocation2]];
    }
    if (_annotation1 != nil)
    {
        [_mapView addAnnotation:_annotation1];
    }
    if (_annotation2 != nil)
    {
        [_mapView addAnnotation:_annotation2];
    }
    return _circle;
}
#pragma mark actionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //结束
    if(buttonIndex == 6)
    {
        //确定
        TSTimeHMView *locateView = (TSTimeHMView *)actionSheet;
        NSString *temp = [NSString stringWithFormat:@"%@:%@",locateView.hourContent,locateView.minuteContent];
        UIButton *button = [self.view viewWithTag:3];
        [button setTitle:temp forState:UIControlStateNormal];
        NSDictionary *attribtDic2 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        
        NSMutableAttributedString *attribtStr2 = [[NSMutableAttributedString alloc]initWithString:temp attributes:attribtDic2];
        //赋值
        button.titleLabel.attributedText = attribtStr2;
        _endDate = temp;
    }
    //开始
    if(buttonIndex == 5)
    {
        //确定
        TSTimeHMView *locateView = (TSTimeHMView *)actionSheet;
        NSString *temp = [NSString stringWithFormat:@"%@:%@",locateView.hourContent,locateView.minuteContent];
        UIButton *button = [self.view viewWithTag:4];
        [button setTitle:temp forState:UIControlStateNormal];
        NSDictionary *attribtDic2 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        
        NSMutableAttributedString *attribtStr2 = [[NSMutableAttributedString alloc]initWithString:temp attributes:attribtDic2];
        //赋值
        button.titleLabel.attributedText = attribtStr2;
        _startDate = temp;
        
    }
}
-(void)sendRequest_getData
{
    //发验证码
    RequestAction *request = [[RequestAction alloc] init];
    
    request.delegate = self;
    
    [request addAccessory:self];
    request.tag = 2;
    
    //设备号(必填)
    [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.productId forKey:@"productId"];
    //个人id
    [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.customerid forKey:@"customerid"];
    [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.idc forKey:@"idc"];
    [request request_getEfenceInfoByProductId_getGPS];
}
-(void)sendRequest
{
    //发验证码
    RequestAction *request = [[RequestAction alloc] init];
    
    request.delegate = self;
    
    [request addAccessory:self];
    request.tag = 3;
    
    //设备号(必填)
    [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.productId forKey:@"productId"];
    //idc
    [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.idc forKey:@"idc"];
    //报警类型  0全部  1入区    2出区
    [request.parm setObjectFilterNull:[NSString stringWithFormat:@"%d",_alarmType] forKey:@"alarmType"];
    ////围栏点集合  围栏数据点以“|”隔开
    if (_initType == 1)
    {
        
        
//        根据用户指定的两个坐标点，计算这两个点的实际地理距离。核心代码如下:
//        BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.915,116.404));
//        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(38.915,115.404));
//        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
        
        CLLocation*newLocation =[[CLLocation alloc] initWithCoordinate: _annotation1.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
        CLLocation*newLocation2 =[[CLLocation alloc] initWithCoordinate: _annotation2.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
        
        double meter = [newLocation distanceFromLocation:newLocation2];
//        NSString *temp = [NSString stringWithFormat:@"%f,%f|%f,%f|f",_annotation1.coordinate.longitude,_annotation1.coordinate.latitude,_annotation2.coordinate.longitude,_annotation2.coordinate.latitude,meter];
        NSString *tempStr = [NSString stringWithFormat:@"%@,%@|%@,%@|%@",[[NSNumber numberWithDouble:_annotation1.coordinate.longitude] stringValue],[[NSNumber numberWithDouble:_annotation1.coordinate.latitude] stringValue],[[NSNumber numberWithDouble:_annotation2.coordinate.longitude] stringValue],[[NSNumber numberWithDouble:_annotation2.coordinate.latitude] stringValue],[[NSNumber numberWithDouble:meter] stringValue]];
        
        [request.parm setObjectFilterNull:tempStr forKey:@"efencePoints"];
    }
    else if (_initType == 3)
    {
        NSString*tempStr = @"";
        int count = [_annotationArray count];
        for (int i = 0; i < count; i++)
        {
            BMKPointAnnotation *anno = [_annotationArray objectAtIndex:i];
            if (i != count - 1)
            {
                tempStr = [tempStr stringByAppendingString:[NSString stringWithFormat:@"%@,%@|",[[NSNumber numberWithDouble:anno.coordinate.longitude] stringValue],[[NSNumber numberWithDouble:anno.coordinate.latitude] stringValue]]];
                
            }
            else
            {
                tempStr = [tempStr stringByAppendingString:[NSString stringWithFormat:@"%@,%@",[[NSNumber numberWithDouble:anno.coordinate.longitude] stringValue],[[NSNumber numberWithDouble:anno.coordinate.latitude] stringValue]]];
            }
        }
      
        [request.parm setObjectFilterNull:tempStr forKey:@"efencePoints"];
    }
    
    //报警时间范围开始时间
    [request.parm setObjectFilterNull:_startDate forKey:@"startDate"];
    //报警时间范围结束时间
    [request.parm setObjectFilterNull:_endDate forKey:@"endDate"];
    //围栏启用状态：0否；1是
    [request.parm setObjectFilterNull:[NSString stringWithFormat:@"%d",_isEnable] forKey:@"isEnable"];
    //围栏类型  1圆形 2矩形    3多边形
    [request.parm setObjectFilterNull:[NSString stringWithFormat:@"%d",_initType] forKey:@"efenceType"];
    //个人id
    [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.customerid forKey:@"customerid"];
    [request request_SettingFence];
}
- (void)repaintAndResetData {
    if ([SingleDataManager instance].coordinate.latitude != 0)
    {
        
       
        if (_annotation_fix != nil)
        {
            _carLocation = _annotation_fix.coordinate;
        }
        else
        {
            // 转为百度经纬度类型的坐标
            //BMK_COORDTYPE_GPS BMK_COORDTYPE_COMMON  BMK_COORDTYPE_GPS
            //原始的gps转成百度的
            CLLocationCoordinate2D bd09Coord = BMKCoordTrans([SingleDataManager instance].coordinate, BMK_COORDTYPE_GPS,BMK_COORDTYPE_BD09LL);
            _carLocation = bd09Coord;
        }
        //                _carLocation = [SingleDataManager instance].coordinate;
        if (_initType == 1)
        {
            [self initCirclePressed];
        }
        else
        {
            [self initPolygonPressed];
        }
        [self addBottomView];
    }
}

-(void)requestFinished:(__kindof YTKBaseRequest *)request
{
    if (request.tag == 2)//获取
    {
       
       
        
        Response *response =  [Response modelWithJSON:request.responseData];
        if ([@"10000" isEqualToString:response.code])
        {
            //有数据的时
            if ([NomalUtil isValueableObject:response.data])
            {
                EfenceInfoModel *mode = [EfenceInfoModel modelWithJSON:response.data];
                _isEnable = [mode.isEnable intValue];
                _initType = [mode.efenceType intValue];
                _startDate = mode.startDate;
                _endDate = mode.endDate;
                _alarmType = [mode.alarmType intValue];
               
            
                if (_initType == 1)
                {
                    NSArray *array1 = [mode.efencePoints componentsSeparatedByString:@"|"];
                    if ([array1 count] > 2)
                    {
                        NSArray *array2 = [[array1 objectAtIndex:0] componentsSeparatedByString:@","];
                        if ([array2 count] >=2)
                        {
                            double longitude = [[array2 objectAtIndex:0] doubleValue];
                            double latitude = [[array2 objectAtIndex:1] doubleValue];
                            //初始化车的位置
                            _carLocation = CLLocationCoordinate2DMake(latitude, longitude);
                        }
                        NSArray *array3 = [[array1 objectAtIndex:1] componentsSeparatedByString:@","];
                        if ([array3 count] >=2)
                        {
                            double longitude = [[array3 objectAtIndex:0] doubleValue];
                            double latitude = [[array3 objectAtIndex:1] doubleValue];
                            //初始化车的位置
                            _annotation2 = [[BMKPointAnnotation alloc] init];
                            //设置标注的经纬度坐标
                            _annotation2.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                        }
                    }
                    [self initCirclePressed];
                }
                else
                {
                     NSArray *array1 = [mode.efencePoints componentsSeparatedByString:@"|"];
                    self.annotationArray = [NSMutableArray arrayWithCapacity:5];
                    for (NSString *tempStr in array1)
                    {
                        NSArray *array2 = [tempStr componentsSeparatedByString:@","];
                        if ([array2 count] >=2)
                        {
                            double longitude = [[array2 objectAtIndex:0] doubleValue];
                            double latitude = [[array2 objectAtIndex:1] doubleValue];
                            BMKPointAnnotation *annotation1 = [[BMKPointAnnotation alloc] init];
                            annotation1.coordinate =  CLLocationCoordinate2DMake(latitude, longitude);
                            
                            [_annotationArray addObject:annotation1];
                        }
                        BMKPointAnnotation *obj = [_annotationArray firstObject];
                        _carLocation = obj.coordinate;
                    }
                    [self initPolygonPressed];
                }
                [self addBottomView];
            }
            else//没数据时
            {
                [self repaintAndResetData];
            }
          
            
        }
        else
        {
            [self showViewMessage:response.message];
        }
        //增加固定不动的点 重绘参考点
//        [self createFixAnnotationWith:_carLocation];
    }
    else if (request.tag == 3)//设置
    {
        
        
        
        Response *response =  [Response modelWithJSON:request.responseData];
        if ([@"10000" isEqualToString:response.code])
        {
            [self showViewMessage:response.message];
            
            
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
@end
