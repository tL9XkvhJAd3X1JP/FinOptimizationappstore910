//
//  BaiduMapViewController.m
//  wsmCarOwner
//
//  Created by wiselink on 14-8-6.
//  Copyright (c) 2014年 chenxing. All rights reserved.
//

#import "PlayBackViewController.h"
//#import "MyNavViewController2.h"
//#import "CalendarView.h"
#import "TSOneLocateView.h"
#import "TSTimeLocateView.h"
#import "TSDateLocateView.h"
#import "DropDownControl.h"
#import "TSTimeHMView.h"
#define BtnBgColor_NewUI   [UIColor colorWithHex:0xFFFFFF alpha:0.2]
#define BtnHighColor_NewUI   [UIColor colorWithHex:0x0dad5c alpha:0.2]


#define BtnBgColorBlack_NewUI   [UIColor colorWithHex:0x000000 alpha:0.8]
#define BtnHighColorW_NewUI   [UIColor colorWithHex:0x008e61]

#define BtnBgColor1_NewUI   [UIColor colorWithHex:0x086744]
#define BtnHighColor1_NewUI   [UIColor colorWithHex:0xFFFFFF alpha:0.2]//[UIColor colorWithHex:0x043a26]

#define ToolBarColor_NewUI   [UIColor colorWithHex:0x2F2F2F]
// 自定义BMKAnnotationView，用于显示运动者
@interface SportAnnotationView1 : BMKAnnotationView

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SportAnnotationView1

@synthesize imageView = _imageView;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setBounds:CGRectMake(0.f, 0.f, 12.f, 22.f)];
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 12.f, 22.f)];
//        _imageView.image = [UIImage imageNamed:@"车1.png"];

        [self addSubview:_imageView];
    }
    return self;
}

-(void)dealloc
{
//    [_imageView release];
//    [super dealloc];
}

@end

@interface PlayBackViewController ()



@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *myContentView;

@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (strong, nonatomic) IBOutlet UIView *startDateView;
@property (strong, nonatomic) IBOutlet UIView *startTimeView;
@property (strong, nonatomic) IBOutlet UIView *endDateView;
@property (strong, nonatomic) IBOutlet UIView *endTimeView;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *suspendButton;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UIButton *hideButton;
- (IBAction)playButtonClick:(id)sender;
- (IBAction)selectButtonClick:(id)sender;
- (IBAction)suspendButtonClick:(id)sender;
- (IBAction)continueButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *playTypeButton;
- (IBAction)playTypeButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *snLabel;

@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;

//@property (retain, nonatomic) CalendarView *calendarView;
@property(assign,nonatomic) long annotationIndex;// 大头针的次序
@property(assign,nonatomic) NSUInteger annotationCount;// 大头针总数量
@property(assign,nonatomic) BOOL isBottomViewShow;// buttomVie是否完全显示
@property(assign,nonatomic) float bottomView_y;

@property (strong, nonatomic) NSArray *annotationArr;
@property (strong, nonatomic) BMKPointAnnotation *playAnnotation;
@property (strong, nonatomic) BMKPointAnnotation *startAnnotation;
@property (strong, nonatomic) BMKPointAnnotation *endAnnotation;
@property (strong, nonatomic) SportAnnotationView1 *sportAnnotationView;
@property (strong, nonatomic) BMKPolyline *polyline;
@property (strong, nonatomic) NSTimer *timer;
@property(assign,nonatomic) long playIndex;
@property(assign,nonatomic) BOOL isPlaying;
@property(assign,nonatomic) float playSpeed;

@property(retain,nonatomic) DropDownControl *dropDownControl;
@property (retain, nonatomic) NSMutableArray *dropDownDataArr;

- (IBAction)dateButtonClick:(id)sender;
- (IBAction)timeButtonClick:(id)sender;
- (IBAction)hideButtonClick:(id)sender;



@end

@implementation PlayBackViewController

#pragma mark systemMethod
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    [super loadView];
}
- (void)viewDidLoad
{
    
//    self.title=@"轨迹回放";
    
//    self.leftNavBtnName = @"返回";
    self.myContentView.frame = self.view.frame;
    BMKMapView *temp = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.myContentView.width, self.myContentView.height)];
//    if (!iPhone5)
//    {
//        temp.height = temp.height - 88;
//    }
    temp.layer.masksToBounds = YES;
    temp.layer.cornerRadius = 5 ;
    self.mapView = temp;
    _mapView.delegate = self;
//    [temp release];
    _mapView.zoomLevel=14;//地图显示级别
    _mapView.showMapScaleBar = YES;//显示比例尺
    //适配比例尺
     _mapView.mapScaleBarPosition = CGPointMake(240,_mapView.frame.size.height - 20);//自定义比例尺的位置
//    if (iPhone5)
//    {
//       
//    }else{
//        _mapView.mapScaleBarPosition = CGPointMake(240,_mapView.frame.size.height-88);//自定义比例尺的位置
//    }
    [self.myContentView insertSubview:_mapView belowSubview:_bottomView] ;
    self.view.backgroundColor = [UIColor clearColor];
    
    [super viewDidLoad];
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(Space_Normal, StatusBarHeight+Space_Normal, 30, 30)];
    [self.view addSubview:button3];
    button3.backgroundColor = [UIColor clearColor];
    [button3 addTarget:self action:@selector(leftNavBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button3 setBackgroundImage:IMAGE_NAMED(@"返回") forState:UIControlStateNormal];
    [button3 setBackgroundImage:IMAGE_NAMED(@"返回按下") forState:UIControlStateHighlighted];
//    [self changeBackgroundViewNeedBlack:YES];

    //初始化 calendarView
//    self.calendarView = [[[NSBundle mainBundle]loadNibNamed:@"CalendarView" owner:self options:nil]lastObject];
//    self.calendarView.left = (self.view.width - self.calendarView.width)/2;
//    self.calendarView.top = 170;
//    [_calendarView setMyCalendarItemDelegate:self];

//    [self setDateLabelWithStartDate:[NSDate date] endDate:[NSDate date]];

    self.selectButton.layer.cornerRadius = 5;
    self.selectButton.clipsToBounds = YES;
    [self.selectButton setBackgroundImage:[NomalUtil imageWithColor:BtnBgColorBlack_NewUI] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[NomalUtil imageWithColor:BtnHighColorW_NewUI] forState:UIControlStateHighlighted];
    
    self.suspendButton.layer.cornerRadius = 5;
    self.suspendButton.clipsToBounds = YES;
    [self.suspendButton setBackgroundImage:[NomalUtil imageWithColor:BtnBgColorBlack_NewUI] forState:UIControlStateNormal];
    [self.suspendButton setBackgroundImage:[NomalUtil imageWithColor:BtnHighColorW_NewUI] forState:UIControlStateHighlighted];
    
    self.continueButton.layer.cornerRadius = 5;
    self.continueButton.clipsToBounds = YES;
    [self.continueButton setBackgroundImage:[NomalUtil imageWithColor:BtnBgColorBlack_NewUI] forState:UIControlStateNormal];
    [self.continueButton setBackgroundImage:[NomalUtil imageWithColor:BtnHighColorW_NewUI] forState:UIControlStateHighlighted];
    
    self.hideButton.layer.cornerRadius = 5;
    self.hideButton.clipsToBounds = YES;
    [self.hideButton setBackgroundImage:[NomalUtil imageWithColor:BtnBgColorBlack_NewUI] forState:UIControlStateNormal];
    [self.hideButton setBackgroundImage:[NomalUtil imageWithColor:BtnHighColorW_NewUI] forState:UIControlStateHighlighted];
    //修改色
    [self.playButton setBackgroundColor:Color_Nomal_Bg];
    
    UIImage *tmpimage =[IMAGE_NAMED(@"下1") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.playTypeButton setTintColor:Color_Nomal_Bg];
    [self.playTypeButton setImage:tmpimage forState:UIControlStateNormal];
    [_playTypeButton addTarget:self action:@selector(speedClick:) forControlEvents:UIControlEventTouchUpInside];
    _dropDownDataArr = [[NSMutableArray alloc]initWithObjects:@"快速回放",@"匀速回放",@"慢速回放", nil];

    [self initCorner];
//    [self initDropDownControl];
    [self initDateTime];
    _isBottomViewShow = YES;
    _bottomView_y = _bottomView.top;
    _playSpeed = 0.1;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    [_bottomView addGestureRecognizer:panGestureRecognizer];
//    [panGestureRecognizer release];
    
    _snLabel.text = @"";
    
    //同比放大一下
    [self.bottomView scaleAllSubViewFrame:310.0];
    
    self.bottomView.bottom = ScreenHeight - SAFE_AREA_INSETS_BOTTOM;
//    _annotationArr=[[NSMutableArray alloc]initWithCapacity:1];

    _playAnnotation = [[BMKPointAnnotation alloc]init];
//    _startAnnotation = [[BMKPointAnnotation alloc]init];
//    _endAnnotation = [[BMKPointAnnotation alloc]init];
//    [self showDemoData];
}
-(void)showDemoData
{
    self.annotationArr = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.055826],@"latitude",
                           [NSNumber numberWithFloat:116.307917],@"longitude",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.055916],@"latitude",
                           [NSNumber numberWithFloat:116.308455],@"longitude",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.055967],@"latitude",
                           [NSNumber numberWithFloat:116.308549],@"longitude",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.056014],@"latitude",
                           [NSNumber numberWithFloat:116.308574],@"longitude",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.056440],@"latitude",
                           [NSNumber numberWithFloat:116.308485],@"longitude",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.056816],@"latitude",
                           [NSNumber numberWithFloat:116.308352],@"longitude",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.057997],@"latitude",
                           [NSNumber numberWithFloat:116.307725],@"longitude",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.058022],@"latitude",
                           [NSNumber numberWithFloat:116.307693],@"longitude",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.058029],@"latitude",
                           [NSNumber numberWithFloat:116.307590],@"longitude",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.057913],@"latitude",
                           [NSNumber numberWithFloat:116.307119],@"longitude",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.057850],@"latitude",
                           [NSNumber numberWithFloat:116.306945],@"longitude",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.057756],@"latitude",
                           [NSNumber numberWithFloat:116.306915],@"longitude",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.057225],@"latitude",
                           [NSNumber numberWithFloat:116.307164],@"longitude",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:40.056134],@"latitude",
                           [NSNumber numberWithFloat:116.307546],@"longitude",
                           nil],
                          nil];
    _annotationCount = [self.annotationArr count];
    [self showAnnotationAndPolyline:self.annotationArr];
}
-(void)initDateTime
{
    _startDateLabel.text = [NomalUtil getStringDateWithNSDate:[NSDate date]];
    _endDateLabel.text = [NomalUtil getStringDateWithNSDate:[NSDate date]];
    _endTimeLabel.text = [[[NomalUtil getStringDateWithNSDate1:[NSDate date]] componentsSeparatedByString:@" "]lastObject];

}

-(void)initCorner
{
    [self setCornerAndBorder:_startDateView];
    [self setCornerAndBorder:_startTimeView];
    [self setCornerAndBorder:_endDateView];
    [self setCornerAndBorder:_endTimeView];
//    [self setCornerAndBorder:_selectButton];
    [self setCornerAndBorder:_playButton];
//    [self setCornerAndBorder:_suspendButton];
//    [self setCornerAndBorder:_continueButton];
//    [self setCornerAndBorder:_hideButton];
    [self setCornerAndBorder:_playTypeButton];
}

-(void)initDropDownControl
{
    _dropDownDataArr = [[NSMutableArray alloc]initWithObjects:@"快速回放",@"慢速回放", nil];
//    [_dropDownDataArr removeObject:_playTypeButton.titleLabel.text];
    _dropDownControl = [[DropDownControl alloc]initDropDown:_playTypeButton dataSourceArr:_dropDownDataArr cellFont:[UIFont systemFontOfSize:12] dropHeight:40 dropDownId:1 delegate:self];
}

-(void)setCornerAndBorder:(UIView *)view
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
//    view.layer.borderColor = [[UIColor colorWithHexString:@"#008e61"]CGColor];
    view.layer.borderColor = [Color_Nomal_Bg CGColor];
    view.layer.borderWidth = 1;
}

//给view加圆角
-(void)makeCornerWithView:(UIView *)view roundingCorners:(NSUInteger) corner
{
    //加圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
//    [maskLayer release];
}

#pragma mark request
//请求数据
- (void)sendRequestPointAnnotationWithmsgId:(int)msgId
{
//    [self sendRequest];
//    UserRequest *request = [UserRequest initWith:self msgId:msgId];
//    [request.params setObjectFilterNull:[SingleData instance].registerSingle.idc forKey:@"IDC"];
//    [request.params setObjectFilterNull:[NSString stringWithFormat:@"%@ %@:00",_startDateLabel.text,_startTimeLabel.text] forKey:@"StartTime"];
//    [request.params setObjectFilterNull:[NSString stringWithFormat:@"%@ %@:00",_endDateLabel.text,_endTimeLabel.text] forKey:@"EndTime"];
////    [request.params setObjectFilterNull:@"19820000015" forKey:@"idc"];
////    [request.params setObjectFilterNull:@"2017-3-31 10:00:00" forKey:@"StartTime"];
////    [request.params setObjectFilterNull:@"2017-3-31 14:00:00" forKey:@"EndTime"];
//    if (![self isStartDate:[request.params objectForKey:@"StartTime"] lessAndEqualEndDate:[request.params objectForKey:@"EndTime"]])
//    {
//        return;
//    }
//    [request request_GetLocusForTime];
//    [self showNetWaiting];
    
}

#pragma mark dataReceived
//接收数据
//- (void)dataReceived:(NSString *)content msgId:(NSInteger)msgId
//{
//    NSError *error;
//    if (msgId == 100)
//    {
//        [self closeNetWaiting];
//
//        if (self.polyline != nil)
//        {
//            [_mapView removeOverlay:self.polyline];
//        }
//        if (_playAnnotation != nil)
//        {
//            [_mapView removeAnnotation:_playAnnotation];
//        }
//        _isPlaying = NO;
//        _playIndex = 0;
//        NSDictionary *dic = [content objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&error];
//        NSString *result = [dic objectForKey:@"result"];
//        if ([result intValue]==1)
//        {
//            MYLog(@"===%@",dic);
//            NSArray *arr=[dic objectForKey:@"value"];
//            self.annotationArr = arr;
//            _annotationCount=[arr count];
//            if (_annotationCount>0)
//            {
//                [self showAnnotationAndPolyline:arr];
//            }
//            else
//            {
//                [self showAlertInfo:@"无任何行驶记录!"];
//            }
//        }
//        else
//        {
//            [self showAlertInfoWithDic:dic];
//        }
//    }
//}

#pragma mark otherMethod
//显示坐标点并连线
- (void)showAnnotationAndPolyline:(NSArray *)arr{
    CLLocationCoordinate2D coors[50000] = {0};
    NSMutableArray *annotations=[NSMutableArray arrayWithCapacity:1];
//    double ju=0.0;//当前路线的两个相距最远的点的距离
//    int j=0;//当前路线离起点最远的点
    CLLocationCoordinate2D coorStart;//起点
    for (int i=0;i<[arr count];i++)
    {
        NSDictionary *dic=[arr objectAtIndex:i];
        
        double latitude=[[dic objectForKey:@"latitude"]doubleValue];
        double longitude=[[dic objectForKey:@"longitude"]doubleValue];
        //将GPS坐标转成BAIDU坐标
        //        CLLocationCoordinate2D locationGPS = CLLocationCoordinate2DMake(latitudeGPS, longitudeGPS);
        //        CLLocationCoordinate2D locationBaidu = BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(locationGPS,BMK_COORDTYPE_GPS));
        //        //百度坐标
        //        double latitude=locationBaidu.latitude;
        //        double longitude=locationBaidu.longitude;
        //在地图上指定经纬度插大头针
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude =latitude ;
        coor.longitude =longitude;
        pointAnnotation.coordinate = coor;
        if (i==0)
        {
            coorStart=coor;
            pointAnnotation.title = @"开始" ;
            self.startAnnotation = pointAnnotation;
            //起始点和终点
            [_mapView addAnnotation:pointAnnotation];
            
        }else if(i==[arr count]-1){
            pointAnnotation.title = @"结束";
            self.endAnnotation = pointAnnotation;
            [_mapView addAnnotation:pointAnnotation];
        }
        [annotations addObject:pointAnnotation];
//        [pointAnnotation release];
        
        //为大头针连线赋值
        coors[i].latitude = latitude;
        coors[i].longitude = longitude;
        
        //算出离起点距离最远的点的下标
//        CLLocationDistance juli= [self getCLLocationDistance:coorStart TheTowCoordinate:coor];
//        if (juli>ju) {
//            ju=juli;
//            j=i;
//        }
        
        
    }
    self.polyline = [BMKPolyline polylineWithCoordinates:coors count:[arr count]];
    [_mapView addOverlay:self.polyline];
    
    
    
    NSDictionary *dic = [arr firstObject];
    CLLocationCoordinate2D sc;
    sc.latitude = [[dic objectForKey:@"latitude"] floatValue];
    sc.longitude = [[dic objectForKey:@"longitude"] floatValue];
    
    _playAnnotation.title = @"轨迹";
    _playAnnotation.coordinate = sc;
   
    [_mapView addAnnotation:_playAnnotation];
//    [_mapView showAnnotations:annotations animated:YES];
    [_mapView setCenterCoordinate:sc];
    [_mapView setZoomLevel:18];
//    [_mapView addAnnotations:annotationArr];
//    [annotationArr release];
    
    //设置地图显示范围
//    NSDictionary *dicFastest=[arr objectAtIndex:j];
//    CLLocationCoordinate2D coorFastest;
//    coorFastest.latitude=[[dicFastest objectForKey:@"latitude"]doubleValue];
//    coorFastest.longitude=[[dicFastest objectForKey:@"longitude"]doubleValue];
//    [self setMapRegion:coorStart fastest:coorFastest];
    
    
//    self.timer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(playTrack) userInfo:nil repeats:YES];
}


//runing
- (void)running {
  
    long next = _playIndex + 1;
    if (next >= _annotationArr.count ) {
        next = _playIndex;
    }

    NSDictionary *dic = [_annotationArr objectAtIndex:_playIndex];
    NSDictionary *nextDic = [_annotationArr objectAtIndex:next];
    CLLocationCoordinate2D start_coor;
    start_coor.latitude = [[dic objectForKey:@"latitude"] floatValue];
    start_coor.longitude = [[dic objectForKey:@"longitude"] floatValue];
//    float speed1 = [[dic objectForKey:@"Speed"] floatValue];
    
    CLLocationCoordinate2D end_coor;
    end_coor.latitude = [[nextDic objectForKey:@"latitude"] floatValue];
    end_coor.longitude = [[nextDic objectForKey:@"longitude"] floatValue];
//    float speed2 = [[nextDic objectForKey:@"Speed"] floatValue];
//    double angle = [self findRotation:start_coor toPoint:end_coor] / 180.0 *M_PI;
//    [_mapView setCenterCoordinate:start_coor];
//    float aa= 5.0/(speed1 + speed2);
    kWeakSelf(self);
    [UIView animateWithDuration:_playSpeed animations:^{
        if(weakself.playIndex != next)
        {
            
//            weakself.sportAnnotationView.imageView.transform = CGAffineTransformMakeRotation(angle);
        }
        weakself.playAnnotation.coordinate = start_coor;

    } completion:^(BOOL finished) {
        
        weakself.playIndex++;
        if(weakself.playIndex < weakself.annotationCount && weakself.isPlaying)
        {
            [self running];
        }
        
        
    }];
}

//找到每一次小车运动，需要偏移的角度
-(double) findRotation:(CLLocationCoordinate2D )fromPoint toPoint:(CLLocationCoordinate2D) toPoint {
    double x = toPoint.longitude-fromPoint.longitude;//lng-经度，lat-纬度
    double y = toPoint.latitude-fromPoint.latitude;
    if(x==0){
        return 0;
    }
    if(x>0){
        double z=sqrt(x*x+y*y);
        double jiaodu=round((asin(y/z)/M_PI*180));//最终角度
        if(jiaodu>=0){
            return 90-jiaodu;
        }else{
            return 90+fabs(jiaodu);
        }
    }
    if(x<0){
        double z=sqrt(x*x+y*y);
        double jiaodu=round((asin(y/z)/M_PI*180));//最终角度
        if(jiaodu>=0){
            return 270+jiaodu;
        }else{
            return 270-fabs(jiaodu);
        }
    }
    return 0.0;
}

//- (double) getAngle:(CLLocationCoordinate2D )fromPoint toPoint:(CLLocationCoordinate2D) toPoint {
//    double slope = [self getSlope:fromPoint toPoint:toPoint];
//    if (slope == 111111.0) {
//        if (toPoint.latitude > fromPoint.latitude) {
//            return 0;
//        } else {
//            return 180;
//        }
//    }
//    float deltAngle = 0;
//    if ((toPoint.latitude - fromPoint.latitude) * slope < 0) {
//        deltAngle = 180;
//    }
//    double radio = atan(slope);
//    double angle = 180 * (radio / M_PI) + deltAngle - 90;
//    return angle;
//}
//
////算斜率
//- (double) getSlope:(CLLocationCoordinate2D )fromPoint toPoint:(CLLocationCoordinate2D) toPoint{
//    if (toPoint.longitude == fromPoint.longitude) {
//        return 111111.0;
//    }
//    double slope = ((toPoint.latitude - fromPoint.latitude) / (toPoint.longitude - fromPoint.longitude));
//    return slope;
//}


-(void)playTrack{
    _playIndex = 0;
    [_mapView removeAnnotation:_playAnnotation];
    NSDictionary *dic = [self.annotationArr objectAtIndex:0];
     CLLocationCoordinate2D start_coor;
        start_coor.latitude = [[dic objectForKey:@"latitude"] floatValue];
        start_coor.longitude = [[dic objectForKey:@"longitude"] floatValue];
        _playAnnotation.title = @"轨迹";
        _playAnnotation.coordinate = start_coor;
        
        [_mapView addAnnotation:_playAnnotation];

//    if (_playIndex<self.annotationArr.count) {
//        
//        CLLocationCoordinate2D start_coor;
//        start_coor.latitude = [[[self.annotationArr objectAtIndex:_playIndex]objectForKey:@"latitude"] floatValue];
//        start_coor.longitude = [[[self.annotationArr objectAtIndex:_playIndex]objectForKey:@"longitude"] floatValue];
//
//        _playIndex = _playIndex + 1;
//        _playAnnotation.title = @"轨迹";
//        _playAnnotation.coordinate = start_coor;
//        
//        [_mapView addAnnotation:_playAnnotation];
////        [_mapView setCenterCoordinate:start_coor];
//    }
//    else
//    {
//        [self.timer invalidate];
//        
//        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"播放结束" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil]show];
//    }
    
}


//设置地图显示范围
- (void)setMapRegion:(CLLocationCoordinate2D )coorStar fastest:(CLLocationCoordinate2D) coorFast{
    
    CLLocationCoordinate2D centerDoor;
    centerDoor.latitude=(coorStar.latitude+coorFast.latitude)/2;
    centerDoor.longitude=(coorStar.longitude+coorFast.longitude)/2;
    
    [_mapView setCenterCoordinate:centerDoor animated:NO];//根据提供的经纬度为中心原点
    BMKCoordinateRegion region = BMKCoordinateRegionMake(centerDoor, BMKCoordinateSpanMake(fabs(coorFast.latitude-coorStar.latitude), fabs(coorFast.longitude-coorStar.longitude)));
    [_mapView setRegion:region animated:NO];//执行设定显示范围
}



//根据起点经纬度和终点经纬度 算出距离
- (CLLocationDistance) getCLLocationDistance:(CLLocationCoordinate2D)coordinateA TheTowCoordinate:(CLLocationCoordinate2D )coordinateB
{
    CLLocationDistance dis;
    dis = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(coordinateA), BMKMapPointForCoordinate(coordinateB)) ;
    
    return dis;
    
}


#pragma mark BMKMapViewDelegate

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    [self running];
}

// 根据anntation生成对应的大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if([@"轨迹" isEqualToString:annotation.title])
    {
        _annotationIndex++;
        static NSString *AnnotationViewID = @"renameMark";
        //    _sportAnnotationView =[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (_sportAnnotationView==nil)
        {
            _sportAnnotationView = [[SportAnnotationView1 alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        //        _sportAnnotationView.imageView.image=[UIImage imageNamed:@"车.png"];
        _sportAnnotationView.draggable = NO;
        _sportAnnotationView.canShowCallout = NO;
        //            _sportAnnotationView.centerOffset = CGPointMake(0, 3);
        _sportAnnotationView.centerOffset = CGPointMake(0, 0);
        _sportAnnotationView.image = [UIImage imageNamed:@"自行车位置"];
        //    else{
        //        if (_annotationIndex==_annotationCount)
        //        {
        //            ((BMKPinAnnotationView*) _temp).image=[UIImage imageNamed:@"mapapi.bundle/images/icon_nav_end.png"];
        //            ((BMKPinAnnotationView*) _temp).animatesDrop = NO;
        //        }else if(_annotationIndex==1)
        //        {
        //            ((BMKPinAnnotationView*)_temp).image=[UIImage imageNamed:@"mapapi.bundle/images/icon_nav_start.png"];
        //            ((BMKPinAnnotationView*)_temp).animatesDrop = NO;
        //        }
        //        else
        //        {
        //            ((BMKPinAnnotationView*)_temp).image=nil;
        //            ((BMKPinAnnotationView*)_temp).animatesDrop = NO;
        //
        //        }
        //
        //    }
        return _sportAnnotationView;
    }
    else if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        static NSString *annotationViewIdentifier = @"annotationViewIdentifier";
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
            annotationView.canShowCallout = NO;
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
            if([@"开始" isEqualToString:annotation.title])
            {
                annotationView.image = IMAGE_NAMED(@"起");
            }
            if ([@"结束" isEqualToString:annotation.title])
            {
                annotationView.image = IMAGE_NAMED(@"终");
            }
            //当前view的拖动状态
            //annotationView.dragState;
            //            NSLog(@"0000000000");
        }
        return annotationView;
    }
    
    return nil;

}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 2.0;
        return polylineView;
    }
    return nil;
}

-(void)viewDidAppear:(BOOL)animated
{
//    if (IOSVersion < 9.0)
//    {
//        MyNavViewController2 * myNav = (MyNavViewController2*)self.navigationController;
//        if ([NomalUtil isValueableObject:myNav.panGestureRecognizer])
//        {
//            myNav.panGestureRecognizer.cancelsTouchesInView = NO;
//        }
//    }
    
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
}


#pragma mark 地图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [super viewWillAppear:animated];
}


#pragma mark 地图将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
//    if (IOSVersion < 9.0)
//    {
//        MyNavViewController2 * myNav = (MyNavViewController2*)self.navigationController;
//        if ([NomalUtil isValueableObject:myNav.panGestureRecognizer])
//        {
//            myNav.panGestureRecognizer.cancelsTouchesInView = YES;
//        }
//    }
    _isPlaying = NO;
    [super viewWillDisappear:animated ];
}
#pragma mark 地图zoomlevel++
-(void)zoomMap:(id)sender
{
    _mapView.zoomLevel = _mapView.zoomLevel++;
}
#pragma mark 地图ZoomLevel--
-(void)subMap:(id)sender
{
    _mapView.zoomLevel = _mapView.zoomLevel--;
}

#pragma mark systemMethod
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//拖动事件
- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
//    NSLog(@"%f",translation.y);
    if (_isBottomViewShow && translation.y > 0)
    {
        _bottomView.frame = CGRectMake(_bottomView.left, _bottomView_y + translation.y, _bottomView.width, _bottomView.height);
    }
    if (!_isBottomViewShow && translation.y < 0)
    {
        _bottomView.frame = CGRectMake(_bottomView.left, _bottomView_y + translation.y, _bottomView.width, _bottomView.height);
    }
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (_isBottomViewShow)
        {
            if (translation.y > 30)
            {
                [self translationView:_bottomView targeCGRect:CGRectMake(_bottomView.left, self.myContentView.height - 46- SAFE_AREA_INSETS_BOTTOM, _bottomView.width, _bottomView.height) isContentViewShow:NO];
            }
            else
            {
                [self translationView:_bottomView targeCGRect:CGRectMake(_bottomView.left, self.myContentView.height - self.bottomView.height- SAFE_AREA_INSETS_BOTTOM, _bottomView.width, _bottomView.height)  isContentViewShow:YES];
            }
        }
        else
        {
            if (translation.y < -30)
            {
                [self translationView:_bottomView targeCGRect:CGRectMake(_bottomView.left, self.myContentView.height - self.bottomView.height- SAFE_AREA_INSETS_BOTTOM, _bottomView.width, _bottomView.height) isContentViewShow:YES];
                
            }
            else
            {
                [self translationView:_bottomView targeCGRect:CGRectMake(_bottomView.left, self.myContentView.height - 46- SAFE_AREA_INSETS_BOTTOM, _bottomView.width, _bottomView.height) isContentViewShow:NO];
            }
        }
        
    }
}

-(void)hideBottomView
{
    [self translationView:_bottomView targeCGRect:CGRectMake(_bottomView.left, self.myContentView.height - 46 - SAFE_AREA_INSETS_BOTTOM, _bottomView.width, _bottomView.height) isContentViewShow:NO];
}

//目标view 向指定的 targeCGRect 滑动,isHandlePanUp 是否是向上滑
//- (void)translationView2:(UIView *)view targeCGRect :(CGRect)targeCGRect{
//    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        view.frame = targeCGRect;
//        _bottomView_y = view.top;
//    } completion:^(BOOL finished) {
//        
//    }];
//}

- (void)translationView:(UIView *)view targeCGRect :(CGRect)targeCGRect isContentViewShow:(BOOL)isContentViewShow
{
    kWeakSelf(self);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.frame = targeCGRect;
    } completion:^(BOOL finished) {
        NSLog(@"%d",isContentViewShow);
        weakself.isBottomViewShow=isContentViewShow;
        weakself.bottomView_y = view.top;
    }];
}


//显示日历
//- (void)showCalendarWithMsgId:(NSString *) msgId
//{
//    _calendarView.msgId = msgId;
//    self.calendarView.alpha = 1;
//    [NomalUtil animateIn:self.calendarView];
//    [_calendarView showCalendar:self.view];
//}

//日期控件选中日期后执行的代理
//- (void)calendarView:(CalendarItem *)calendarView selectDate:(NSDate *)date msgId:(NSString *)msgId
//{
//    if ([msgId isEqualToString:@"1"])
//    {
//        if ([self isStartDate:[NomalUtil getStringDateWithNSDate:date] lessAndEqualEndDate:_endDate])
//        {
//            [self setDateLabelWithStartDate:date endDate:nil];
//            [NomalUtil animateOut:_calendarView];
//        }
//    }
//    else if ([msgId isEqualToString:@"2"])
//    {
//        if ([self isStartDate:_startDate lessAndEqualEndDate:[NomalUtil getStringDateWithNSDate:date]])
//        {
//            [self setDateLabelWithStartDate:nil endDate:date];
//            [NomalUtil animateOut:_calendarView];
//        }
//        
//    }
//}

-(void)setDateLabelWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    if (startDate != nil)
    {
        _startDateLabel.text = [NomalUtil getStringDateWithNSDate:startDate];
        self.startDate = [NomalUtil getStringDateWithNSDate:startDate];
    }
    if (endDate != nil)
    {
        _endDateLabel.text = [NomalUtil getStringDateWithNSDate:endDate];
        self.endDate = [NomalUtil getStringDateWithNSDate:endDate];
    }
//    _pageIndex = 1;
//    [self sendRequestTrackPlayBack];
}


//开始时间小于等于结束时间 返回yes
-(BOOL)isStartDate:(NSString *)startDate lessAndEqualEndDate:(NSString *)endDate
{
    NSString *nowDate = [NomalUtil getStringDateWithNSDate2:[NSDate date]];
    if ( [endDate compare:nowDate] != NSOrderedAscending && [endDate compare:nowDate] != NSOrderedSame)
    {
        [self showViewMessage:@"结束时间不能大于当前时间"];
        return NO;
    }
    
    if ( [startDate compare:endDate] != NSOrderedAscending && [startDate compare:endDate] != NSOrderedSame)
    {
        [self showViewMessage:@"结束时间不能小于开始时间"];
        return NO;
    }
    return YES;
    
}


- (void)dealloc {
    
//    [_bottomView release];
//    [_dropDownControl release];
//    [_mapView release];
//    [_dicData release];
//    [_contentView release];
//    [_startDateLabel release];
//    [_endDateLabel release];
//    [_startDateView release];
//    [_startTimeView release];
//    [_endDateView release];
//    [_endTimeView release];
//    [_annotationArr release];
//    [_playAnnotation release];
//    [_startDate release];
//    [_endDate release];
//    [_calendarView release];
//    [_timer release];
//    [_selectButton release];
//    [_playButton release];
//    [_suspendButton release];
//    [_continueButton release];
//    [_hideButton release];
//    [_startTimeLabel release];
//    [_endTimeLabel release];
//    [_playTypeButton release];
//
//    [_dropDownDataArr release];
//    [_snLabel release];
//    [_polyline release];
//    [super dealloc];
}
- (IBAction)speedClick:(id)sender {
    //    [self showCalendarWithMsgId:[NSString stringWithFormat:@"%ld",button.tag]];
    
//    UIButton *button = (UIButton *)sender;
    //    NSString *tip = @"开始日期";
    //    if(button.tag != 1)
    //    {
    //        tip = @"结束日期";
    //    }
    TSOneLocateView *loa = [TSOneLocateView initWithTitle:@"" delegate:self data:_dropDownDataArr];
    loa.buttonIndex = 9;
    [loa showInView:self.view];
    
    [loa setFirstValues:[_dropDownDataArr indexOfObject:_playTypeButton.titleLabel.text]];
    
}
- (IBAction)dateButtonClick:(id)sender {
//    [self showCalendarWithMsgId:[NSString stringWithFormat:@"%ld",button.tag]];
    
    UIButton *button = (UIButton *)sender;
//    NSString *tip = @"开始日期";
//    if(button.tag != 1)
//    {
//        tip = @"结束日期";
//    }
    TSDateLocateView *loa = [TSDateLocateView initWithTitle:@"" delegate:self];
    loa.buttonIndex = button.tag;
    [loa showInView:self.view];
    if (button.tag == 1)
    {
        [loa setFirstValuesWithStr:_startDateLabel.text];
    }
    else if (button.tag == 2)
    {
        [loa setFirstValuesWithStr:_endDateLabel.text];
    }
    
}

- (IBAction)timeButtonClick:(id)sender {
    
    UIButton *button = (UIButton *)sender;

    TSTimeHMView *loa = [TSTimeHMView initWithTitle:@"" delegate:self];
    loa.buttonIndex = button.tag;
    [loa showInView:self.view];
    
    if (button.tag == 3)
    {
        [loa setFirstValuesWithStr:_startTimeLabel.text];
    }
    else if (button.tag == 4)
    {
        [loa setFirstValuesWithStr:_endTimeLabel.text];
    }
  
}

- (IBAction)hideButtonClick:(id)sender
{
    [self hideBottomView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 || buttonIndex == 2)
    {
        TSDateLocateView *locateView = (TSDateLocateView *)actionSheet;
        NSString *month = (locateView.monthContent.length < 2)?[NSString stringWithFormat:@"0%@",locateView.monthContent]:locateView.monthContent;
        NSString *day = (locateView.dayContent.length < 2)?[NSString stringWithFormat:@"0%@",locateView.dayContent]:locateView.dayContent;
        NSString *tempDate = [NSString stringWithFormat:@"%@-%@-%@",locateView.yearContent,month,day];
        
        if (buttonIndex == 1)
        {
            _startDateLabel.text = tempDate;
        }
        else if(buttonIndex == 2)
        {
            _endDateLabel.text = tempDate;
        }
    }
    else if (buttonIndex == 3 || buttonIndex == 4)
    {
        TSTimeLocateView *locateView = (TSTimeLocateView *)actionSheet;
        NSString *tempTime = [NSString stringWithFormat:@"%@:%@",locateView.hourContent,locateView.minuteContent];
        if (buttonIndex == 3)
        {
            _startTimeLabel.text = tempTime;
        }
        else if(buttonIndex == 4)
        {
            _endTimeLabel.text = tempTime;
        }
    }
    else if (buttonIndex == 9)
    {
        TSOneLocateView *locateView = (TSOneLocateView *)actionSheet;
        [self selectedText:locateView.titleName dropDownId:0];
    }
}
- (IBAction)playButtonClick:(id)sender {
    if (_annotationArr == nil || _annotationArr.count == 0)
    {
        [self showViewMessage:@"请先查询轨迹路线!"];
    }
    else
    {
        _isPlaying = YES;
        [self hideBottomView];
        [self playTrack];
    }
    
}

- (IBAction)selectButtonClick:(id)sender {
    
//    [self sendRequestPointAnnotationWithmsgId:100];//请求数据
    [self sendRequest];
}

- (IBAction)suspendButtonClick:(id)sender {
    _isPlaying = NO;
}

- (IBAction)continueButtonClick:(id)sender {
    if(!_isPlaying && _playIndex < _annotationArr.count)
    {
        _isPlaying = YES;
        [self running];
    }
    
}
- (IBAction)playTypeButtonClick:(id)sender {
    [_dropDownControl refreshDataSourceArr:[NSArray arrayWithArray:_dropDownDataArr]];
    [_dropDownControl showOrHideDropDown:1];
}

-(void)selectedText:(NSString *)selectText dropDownId:(int)dropDownId
{
//    [_dropDownDataArr addObject:_playTypeButton.titleLabel.text];
//    [_dropDownDataArr removeObject:selectText];
    [_playTypeButton setTitle:selectText forState:UIControlStateNormal];
    SWITCH(selectText)
    {
        CASE(@"匀速回放")
        {
            _playSpeed = 0.1;
            break;
        }
        CASE(@"快速回放")
        {
            _playSpeed = 0.05;
            break;
        }
        CASE(@"慢速回放")
        {
            _playSpeed = 0.2;
            break;
        }
    }
}

//登录
-(void)sendRequest
{
    _isPlaying = NO;
    RequestAction *request = [[RequestAction alloc] init];
    
//    request = [[RequestAction alloc] init];
    
    //[request.baseUrl ];
    
    request.delegate = self;
    
    [request addAccessory:self];
    request.tag = 1;
    
    //设备号
    [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.idc forKey:@"idc"];
    [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.bindingDate forKey:@"bindingDate"];

    [request.parm setObjectFilterNull:[NSString stringWithFormat:@"%@ %@",_startDateLabel.text,_startTimeLabel.text] forKey:@"starttime"];
    [request.parm setObjectFilterNull:[NSString stringWithFormat:@"%@ %@",_endDateLabel.text,_endTimeLabel.text] forKey:@"endtime"];

    if (![self isStartDate:[request.parm objectForKey:@"starttime"] lessAndEqualEndDate:[request.parm objectForKey:@"endtime"]])
    {
        return;
    }
    
    [request request_getGPStrack];
    
    //    [self pushToViewWithClassName:@"MainViewController"];
    //    [self getIpAndVersionRequest];
    //    //开始时间 date类型
    //    [request.parm setObjectFilterNull:@"" forKey:@"starttime"];
    //    //结束时间 date类型
    //    [request.parm setObjectFilterNull:@"" forKey:@"endtime"];
    //    [request.params setObjectFilterNull:@"19820000015" forKey:@"idc"];
    //    [request.params setObjectFilterNull:@"2017-3-31 10:00:00" forKey:@"StartTime"];
    //    [request.params setObjectFilterNull:@"2017-3-31 14:00:00" forKey:@"EndTime"];
}
#pragma mark -responseData
-(void)requestFinished:(__kindof YTKBaseRequest *)request
{
    if (request.tag == 1)
    {
        //request.responseString
        Response *response =  [Response modelWithJSON:request.responseData];
        //         NSLog(@"%@",response);
        if ([@"10000" isEqualToString:response.code])
        {
            _isPlaying = NO;
            _playIndex = 0;
            self.annotationArr = (NSArray *)response.data;
            if (self.polyline != nil)
            {
                [_mapView removeOverlay:self.polyline];
            }
            if (_playAnnotation != nil)
            {
                [_mapView removeAnnotation:_playAnnotation];
            }
            
            if (_startAnnotation != nil)
            {
                [_mapView removeAnnotation:_startAnnotation];
            }
            if (_endAnnotation != nil)
            {
                [_mapView removeAnnotation:_endAnnotation];
            }
            
            _annotationCount = [self.annotationArr count];
            if ([self.annotationArr count] > 0)
            {
                
                [self showAnnotationAndPolyline:self.annotationArr];
            }
            else
            {
                [self showViewMessage:@"无任何行驶记录!"];
            }
            
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
    
    
}
-(void)requestFailed:(__kindof YTKBaseRequest *)request
{
    [super requestFailed:request];
}
@end




