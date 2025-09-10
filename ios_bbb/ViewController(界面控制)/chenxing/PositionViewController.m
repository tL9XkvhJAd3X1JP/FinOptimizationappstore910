//
//  BMKPolygonOverlayPage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "PositionViewController.h"
#import "TSTimeHMView.h"
#import "AlarmEfenceModel.h"
static NSString *annotationViewIdentifier = @"com.Baidu.BMKPointAnnotation";
//开发者通过此delegate获取mapView的回调方法
@interface PositionViewController ()<BMKMapViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView


@property (nonatomic, strong) BMKPointAnnotation *annotation1; //圆心


@property (nonatomic, assign) CLLocationCoordinate2D carLocation; //车的坐标

//刷新按钮
@property (nonatomic, strong) UIButton *refreshButton;
// 0：是当前位置  1:报警位置
@property (nonatomic, assign) int initType;

@property (nonatomic, strong)NSTimer *timer;//定时器

@property (nonatomic, assign)int timeCount;//时间计数

@property (nonatomic, strong) UILabel *lable3;//位置

@property (nonatomic, strong) UIView *myBottomView;

@property (nonatomic, strong) NSString *longitude_str;

@property (nonatomic, strong) NSString *latitude_str;

@property (nonatomic, strong) NSString *alarmType;//入区或出区


//画围栏
@property (nonatomic, strong) BMKPolygon *polygon; //当前界面的多边形
//放多边形的标注
@property (nonatomic, strong) NSMutableArray *annotationArray;

@property (nonatomic, strong) BMKCircle *circle; //当前界面的圆
@property (nonatomic, strong) BMKPointAnnotation *annotation1_circle; //圆心
@property (nonatomic, strong) BMKPointAnnotation *annotation2_circle; //圆边的点
// 围栏类型  1圆形 2矩形    3多边形
@property (nonatomic, assign) int painType;

@property (nonatomic, assign) int circleDistance;//半径

@property (nonatomic, strong) AlarmEfenceModel *alarmEferceModel;


@end

@implementation PositionViewController
@synthesize lable3;
#pragma mark - View life cycle
-(void)loadView
{
    self.navType = 2;
//    self.title = @"画多边形";
    self.leftNavBtnName = @"返回";
    [super loadView];
}
- (void)viewDidLoad {

    [super viewDidLoad];
    if ([self.viewDic objectForKey:@"initType"] != nil)
    {
        self.initType = [[self.viewDic objectForKey:@"initType"] intValue];
        [self.viewDic removeObjectForKey:@"initType"];
    }
    self.longitude_str = [viewDic objectForKey:@"longitude"];
    self.latitude_str = [viewDic objectForKey:@"latitude"];
    [viewDic removeObjectForKey:@"longitude"];
    [viewDic removeObjectForKey:@"latitude"];
    self.alarmType = [viewDic objectForKey:@"alarmType"];
    [viewDic removeObjectForKey:@"alarmType"];
    self.alarmEferceModel = [viewDic objectForKey:@"AlarmEferceModel"];
    [viewDic removeObjectForKey:@"AlarmEferceModel"];
    [self createMapView];
    [self sendRequest];
  
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(Space_Normal, StatusBarHeight+Space_Normal, 30, 30)];
    [self.view addSubview:button3];
    button3.backgroundColor = [UIColor clearColor];
    [button3 addTarget:self action:@selector(leftNavBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button3 setBackgroundImage:IMAGE_NAMED(@"返回") forState:UIControlStateNormal];
    [button3 setBackgroundImage:IMAGE_NAMED(@"返回按下") forState:UIControlStateHighlighted];
    if (_initType == 0)
    {
        [self addBottomViewWithTime:[NomalUtil getCurrentTimeWithLongLongNum] address:@"暂无当前位置"];
    }
    else if (_initType == 1)
    {
        [self addBottomViewWithTime:[NomalUtil getCurrentTimeWithLongLongNum] address:@"暂无报警位置"];
    }
    
//    //初始化车的位置
//    _carLocation = CLLocationCoordinate2DMake(39.915, 116.404);
//    [self paintPosition];
//    [self addBottomView];
//
}

//刷新位置按
-(void)buttonPressed1:(UIButton *)button
{
    //改变车辆位置
//    [self paintPosition];
    [self sendRequest];
}
-(void)changeButtonSecond
{
    if (_timeCount == 0)
    {
        //刷新位置
        [self buttonPressed1:nil];
    }
    
    if (_timeCount == 0)
    {
        _timeCount = 120;
    }
    [_refreshButton setTitle:NSStringFormat(@"位置刷新(%ds)",_timeCount) forState:UIControlStateNormal];
    _timeCount --;
}
-(void)startTimer
{
    if (_initType == 0)
    {
        if (_timer == nil)
        {
            // 创建定时器
            _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(changeButtonSecond) userInfo:nil repeats:YES];
            // 将定时器添加到runloop中，否则定时器不会启动
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            //立即执行
            [_timer fire];
        }
    }
   

}
-(void)stopTimer
{
    if (_initType == 0)
    {
        // 停止定时器
        [_timer invalidate];
        _timer = nil;
        
    }
   
}
-(void)addBottomViewWithTime:(NSString *)time address:(NSString *)address
{
    if (_myBottomView != nil)
    {
        [_myBottomView removeFromSuperview];
    }
    CGFloat space = 10;
//    CGFloat space2 = 5;
    UIView *bottomView = [self.view getSubViewInstanceWith:[UIView class]];
    bottomView.backgroundColor = Color_Nomal_Bg;
    self.myBottomView = bottomView;
    [bottomView setFrameInSuperViewCenterBottom:nil toBottomSpace:SAFE_AREA_INSETS_BOTTOM_NotZero width:ScreenWidth - Space_Normal*2 height:100];
    [bottomView setCornerRadius:5];
    [bottomView setBorder:[UIColor whiteColor] width:1];
    CGFloat lineHeight = 25;
    UILabel *lable1 = (UILabel *)[bottomView getSubViewInstanceWith:[UILabel class]];
    lable1.font = FFont_Default;
    lable1.textColor = Color_Nomal_Font_BlueGray;
    lable1.text = @"当前位置";
    if (_initType == 1)
    {
        lable1.text = [NSString stringWithFormat:@"报警位置（%@）",_alarmType];
    }
    [lable1 setFrameInSuperViewLeftTop:nil toLeftSpace:space toTopSpace:space width:[lable1.text widthForFont:lable1.font] height:lineHeight];
    
    if (_initType == 0 && ![@"暂无当前位置" isEqualToString:address])
    {
        UILabel *lable2 = (UILabel *)[bottomView getSubViewInstanceWith:[UILabel class]];
        lable2.font = FFont_Default_14;
        lable2.textColor = Color_Nomal_Font_BlueGray;
        //@"2019年01月12日"
        
        lable2.text = NSStringFormat(@"定位时间：%@",[NomalUtil getStringDateWithNSDate1:[NomalUtil getNSDateWithNumString:time]]);
        [lable2 setFrameInSuperViewRightTop:nil toRightSpace:space toTopSpace:space width:[lable2.text widthForFont:lable2.font] height:25];
    }
    
    
    lable3 = (UILabel *)[bottomView getSubViewInstanceWith:[UILabel class]];
    lable3.font = FFont_Default_Small;
    lable3.textColor = Color_Nomal_Font_BlueGray;
    lable3.numberOfLines = 0;
    lable3.text = address;
    CGSize size = [lable3.text sizeFromFont:lable3.font andWidth:bottomView.width - space*2];
    [lable3 setFrameLeftTopFromViewLeftBottom:lable1 leftToLeftSpace:0 bottomToTopSpace:5 width:bottomView.width - space*2 height:size.height];
    bottomView.height = lable3.bottom + space + 3;
    
    if (_initType == 0)
    {
        _refreshButton = (UIButton *)[self.view getSubViewInstanceWith:[UIButton class]];
        
        _refreshButton.backgroundColor = Color_Nomal_Font_Blue;
        [_refreshButton setTitle:NSStringFormat(@"位置刷新(%ds)",_timeCount) forState:UIControlStateNormal];
        [_refreshButton setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
        _refreshButton.titleLabel.font = FFont_Default_Small;
        [_refreshButton setCornerRadius:4];
        [_refreshButton setFrameRightBottomFromViewRightTop:bottomView rightToRightSpace:0 topToBottom:20 width:120 height:30];
        [_refreshButton addTarget:self action:@selector(buttonPressed1:) forControlEvents:UIControlEventTouchUpInside];
        [_refreshButton setImage:IMAGE_NAMED(@"PIN_small") forState:UIControlStateNormal];
        [_refreshButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 3)];
        [_refreshButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    }
    
//    [_refreshButton setImage:IMAGE_NAMED(@"PIN_small_black") forState:UIControlStateHighlighted];
//    [_refreshButton setTitleColor:Color_Nomal_Font_Gray forState:UIControlStateHighlighted];
    
}
//-(UIStatusBarStyle)StatusBarStyle
//{
//    return UIStatusBarStyleDefault;
//}
//初始化多边形


//保存上次绘的图
-(void)clearOverlay
{
    [_mapView removeAnnotation:_annotation1];
}

//清缓存，不保存上次绘的图
-(void)clearOverlayAndCache:(BOOL)isCircle
{
    if (_mapView != nil)
    {
        [_mapView removeAnnotation:_annotation1];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
    [super viewWillAppear:animated];
    [self startTimer];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated {
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
    [super viewWillDisappear:animated];
    [self stopTimer];
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

}

#pragma mark - BMKMapViewDelegate


- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState fromOldState:(BMKAnnotationViewDragState)oldState
{
    //    NSLog(@"didChangeDragState");
//    [self repaintView];
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
        if (!annotationView) {
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
            if (_initType == 0)
            {
                annotationView.image = IMAGE_NAMED(@"位置");
            }
            if (_initType == 1)
            {
                annotationView.image = IMAGE_NAMED(@"位置1");
            }
            //当前view的拖动状态
            //annotationView.dragState;
            //            NSLog(@"0000000000");
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





- (void)paintPosition
{

    if (_annotation1 == nil)
    {
        _annotation1 = [[BMKPointAnnotation alloc] init];
        //设置标注的经纬度坐标
        _annotation1.coordinate =  _carLocation;
        [_mapView addAnnotation:_annotation1];
    }
    else
    {
        [_annotation1 setCoordinate:_carLocation];
        
    }
    [_mapView setCenterCoordinate:_carLocation];
    [_mapView setZoomLevel:15];
}

-(void)sendRequest
{
    if (_initType == 0)
    {
        _timeCount = 120;
        //当前位置
        RequestAction *request = [[RequestAction alloc] init];
        
        request.delegate = self;
        
        [request addAccessory:self];
        request.tag = 2;
        
        [request request_getCurrentGPS];
    }
    //1:报警位置
    else if (_initType == 1)
    {
        RequestAction *request = [[RequestAction alloc] init];
        
        request.delegate = self;
        
        [request addAccessory:self];
        request.tag = 1;
        //纬度
        [request.parm setObjectFilterNull:self.latitude_str forKey:@"latitude"];
        //经度
        [request.parm setObjectFilterNull:self.longitude_str forKey:@"longitude"];
        if (_alarmEferceModel != nil)
        {
//            efencePoints 围栏点集合
//            efenceType  围栏类型
            [request.parm setObjectFilterNull:_alarmEferceModel.fenceValue forKey:@"efencePoints"];
            [request.parm setObjectFilterNull:_alarmEferceModel.fenceType forKey:@"efenceType"];
        }
        [request request_getWarningGPS];
        
    }
}
-(void)requestFinished:(__kindof YTKBaseRequest *)request
{
    if (request.tag == 2)//当前位置
    {
        //request.responseString
        Response *response =  [Response modelWithJSON:request.responseData];
        if ([@"10000" isEqualToString:response.code])
        {
            //验证码做本地较验
            //        self.validateCode = response.validateCode;
            NSDictionary * dic = (NSDictionary *)response.data;
           
            double latitude = [[dic objectForKey:@"latitude"] doubleValue];
            double longitude = [[dic objectForKey:@"longitude"] doubleValue];
            if (latitude != 0 && longitude != 0)
            {
                //初始化车的位置
                _carLocation = CLLocationCoordinate2DMake(latitude, longitude);
                [self paintPosition];
                [self addBottomViewWithTime:[dic objectForKey:@"gpsTime"] address:[dic objectForKey:@"address"]];
            }
            else
            {
                [self addBottomViewWithTime:[NomalUtil getCurrentTimeWithLongLongNum] address:@"暂无当前位置"];
            }
            
        }
        else
        {
             [self showViewMessage:response.message];
        }

        
//        [self showViewMessage:response.message];
        
    }
    else if (request.tag == 1)//报警位置
    {
        //request.responseString
        Response *response =  [Response modelWithJSON:request.responseData];
        if ([@"10000" isEqualToString:response.code])
        {
            NSDictionary * dic = (NSDictionary *)response.data;
            //waringPos
            NSString *waringPos = [dic objectForKeyWithStringValue:@"waringPos"];
            NSString *efencePoints = [dic objectForKeyWithStringValue:@"efencePoints"];
            NSString *efenceType = [dic objectForKeyWithStringValue:@"efenceType"];
            
           NSString *address = [dic objectForKeyWithStringValue:@"address"];
            if (waringPos != nil)
            {
                NSArray *array = [waringPos componentsSeparatedByString:@","];
                if ([array count] >= 2)
                {
                    self.longitude_str = array[0];
                    self.latitude_str = array[1];
                }
                
            }
            double latitude = [_latitude_str doubleValue];
            double longitude = [_longitude_str doubleValue];
            if (latitude != 0 && longitude != 0)
            {
                //初始化车的位置
                _carLocation = CLLocationCoordinate2DMake(latitude, longitude);
                [self paintPosition];
                [self addBottomViewWithTime:nil address:address];
                //画围栏
                if (_alarmEferceModel != nil)
                {
//                    _alarmEferceModel.fenceType = efenceType;
//                    _alarmEferceModel.fenceValue = efencePoints;
                    //圆
                    if ([@"1" isEqualToString:efenceType])
                    {
                        NSArray *array1 = [efencePoints componentsSeparatedByString:@"|"];
                        if ([array1 count] >= 2)
                        {
                            NSArray *array2 = [[array1 objectAtIndex:0] componentsSeparatedByString:@","];
                            if ([array2 count] >=2)
                            {
                                double longitude = [[array2 objectAtIndex:0] doubleValue];
                                double latitude = [[array2 objectAtIndex:1] doubleValue];
                                //初始化车的位置
                                //初始化车的位置
                                _annotation1_circle = [[BMKPointAnnotation alloc] init];
                                //设置标注的经纬度坐标
                                _annotation1_circle.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                            }
                            NSArray *array3 = [[array1 objectAtIndex:1] componentsSeparatedByString:@","];
                            if ([array3 count] >=2)
                            {
                                double longitude = [[array3 objectAtIndex:0] doubleValue];
                                double latitude = [[array3 objectAtIndex:1] doubleValue];
                                //初始化车的位置
                                _annotation2_circle = [[BMKPointAnnotation alloc] init];
                                //设置标注的经纬度坐标
                                _annotation2_circle.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                            }
                            else if ([array3 count] == 1)
                            {
                                _circleDistance = [[array3 objectAtIndex:0] intValue];
                            }
                        }
                        [self initCirclePressed];
                    }
                    else
                    {
                        NSArray *array1 = [efencePoints componentsSeparatedByString:@"|"];
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
                            
                        }
                        [self initPolygonPressed];
                    }
                }
                
//                [self paintPosition];
//                [self addBottomViewWithTime:nil address:dicStr];
            }
            else
            {
                [self addBottomViewWithTime:[NomalUtil getCurrentTimeWithLongLongNum] address:@"暂无报警位置"];
            }
            
        }
        else
        {
            [self showViewMessage:response.message];
        }
        
        
        //        [self showViewMessage:response.message];
        
    }
    
}
-(void)requestFailed:(__kindof YTKBaseRequest *)request
{
    [super requestFailed:request];
}
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
#pragma mark -画围栏

/**
 * 获取缩放级别
 * @param distance 2点之间距离
 * @return int zoomLevel
 */
- (int) getZoomLevel:(double)distance
{
    int zoomLevel[] = { 22,21,20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6,5, 4, 3 };
    
    //对应级别单位
//    NSString *zoomLevelStr[] = [ ]; // 单位/m
    NSArray*zoomLevelStr = [NSArray arrayWithObjects:@"2",@"5",@"10", @"20", @"50", @"100", @"200", @"500", @"1000",
                            @"2000", @"5000", @"10000", @"20000", @"25000", @"50000", @"100000",
                            @"200000", @"500000", @"1000000", @"2000000", nil];
    int mid = (int) (distance/5);
    NSInteger
    count = [zoomLevelStr count];
    for (int i = 0; i < count; i++)
    {
        if (i < count - 1)
        {
            
            int left = [zoomLevelStr[i] intValue];
            int right = [zoomLevelStr[i+1] intValue];
            if (mid < left)
            {
                return zoomLevel[i];
                
            }
            else if (mid > left && mid < right)
            {
                return zoomLevel[i + 1];
                
            }
            
        }
        else
        {
            return 3;
            
        }
        
    }
    return 18;
    
}

//初始化多边形
-(void)initPolygonPressed
{
    
//    [self clearOverlay];
    
    [_mapView addOverlay:self.polygon];
    
    double max_latitude = 0;
    double min_latitude = 1000;
    double max_longitude = 0;
    double min_longitude = 1000;
    //把当前位置也加进去算
    [_annotationArray addObject:_annotation1];
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
    CLLocation*newLocation =[[CLLocation alloc] initWithCoordinate: _annotation1.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
    CLLocation*newLocation2 =[[CLLocation alloc] initWithCoordinate: center altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
    double distance = [newLocation distanceFromLocation:newLocation2];
    //15
    [_mapView setZoomLevel:[self getZoomLevel:distance]];

    
}
- (BMKPolygon *)polygon
{
    if (!_polygon) {
        
        
        CLLocationCoordinate2D coords[100];
        for (int i =0;i< [_annotationArray count];i++)
        {
            BMKPointAnnotation *temp = [_annotationArray objectAtIndex:i];
            coords[i] = temp.coordinate;
        }
        _polygon = [BMKPolygon polygonWithCoordinates:coords count:[_annotationArray count]];
        
    }
//    [_mapView addAnnotations:_annotationArray];
    return _polygon;
}
//初始化圆
-(void)initCirclePressed
{
//    [self clearOverlay];
    
    [_mapView addOverlay:self.circle];
    
    //圆心到报警点的中心
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((_annotation1_circle.coordinate.latitude + _annotation1.coordinate.latitude)/2, (_annotation1_circle.coordinate.longitude + _annotation1.coordinate.longitude)/2);
    
//    [_mapView setCenterCoordinate:_annotation1_circle.coordinate];
    [_mapView setCenterCoordinate:center];
//    [_mapView setZoomLevel:15];
    
//    CLLocation*newLocation =[[CLLocation alloc] initWithCoordinate: _annotation1.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
//    CLLocation*newLocation2 =[[CLLocation alloc] initWithCoordinate: _annotation2_circle.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
//    double distance = [newLocation distanceFromLocation:newLocation2];
    //15
    [_mapView setZoomLevel:[self getZoomLevel:_circleDistance]];
    
}
- (BMKCircle *)circle {
    if (!_circle)
    {
//        CLLocation*newLocation =[[CLLocation alloc] initWithCoordinate: _annotation1_circle.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
//        CLLocation*newLocation2 =[[CLLocation alloc] initWithCoordinate: _annotation2_circle.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
        //        CLLocationDistance kilometers =[newLocation distanceFromLocation:oldLocation]/1000;
        /**
         根据中心点和半径生成圆
         
         @param coord 中心点的经纬度坐标
         @param radius 半径，单位：米
         @return 新生成的BMKCircle实例
         */
//        [newLocation distanceFromLocation:newLocation2]
        _circle = [BMKCircle circleWithCenterCoordinate:_annotation1_circle.coordinate radius:_circleDistance];
    }

    return _circle;
}
@end
