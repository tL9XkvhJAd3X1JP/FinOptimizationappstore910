//
//  ProvinceLocationViewController.m
//  FinOptimization
//
//  Created by janker on 2019/4/22.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "ProvinceLocationViewController2.h"
static NSString *annotationViewIdentifier = @"com.Baidu.BMKPointAnnotation";
@interface ProvinceLocationViewController2 ()<BMKMapViewDelegate,BMKDistrictSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (nonatomic, strong)BMKDistrictSearch *search;
@property (nonatomic, strong)NSDictionary *paramDic;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *latitude;
@property (nonatomic, strong)NSString *longitude;
@property (nonatomic, strong) BMKPointAnnotation *annotation1;
@property (nonatomic, strong) UIButton *dealButton;

@end

@implementation ProvinceLocationViewController2
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
//  self.navType = 1;
  self.title = @"报警位置";
  self.leftNavBtnName = @"返回";
  
  [super loadView];
}
- (void)viewWillAppear:(BOOL)animated {
  //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
  [_mapView viewWillAppear];
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  //当mapView即将被隐藏的时候调用，存储当前mapView的状态
  [_mapView viewWillDisappear];
  [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
  //用frame的时候要设置成YES
  //  self.view.translatesAutoresizingMaskIntoConstraints = YES;
  self.paramDic = [NomalUtil dictionaryWithJsonString:[viewDic objectForKey:@"object"]];
  self.latitude = [self.paramDic objectForKey:@"latitude"];
  self.longitude = [self.paramDic objectForKey:@"longitude"];
  
  [self createMapView];
  [super viewDidLoad];
  
  [self searchRequest];
  [self sendRequest];
  // Do any additional setup after loading the view.
}
-(void)sendRequest
{
  [self showNetWaiting];
  RequestAction *request = [[RequestAction alloc] init];
  
  request.delegate = self;
  
  [request addAccessory:self];
  request.tag = 1;
  //纬度
  [request.parm setObjectFilterNull:self.latitude forKey:@"latitude"];
  //经度
  [request.parm setObjectFilterNull:self.longitude forKey:@"longitude"];
//  if (_alarmEferceModel != nil)
//  {
//    //            efencePoints 围栏点集合
//    //            efenceType  围栏类型
//    [request.parm setObjectFilterNull:_alarmEferceModel.fenceValue forKey:@"efencePoints"];
//    [request.parm setObjectFilterNull:_alarmEferceModel.fenceType forKey:@"efenceType"];
//  }
  [request request_getWarningGPS];
}
-(void)searchRequest
{
  if (self.search == nil)
  {
    self.search = [[BMKDistrictSearch alloc] init];
    _search.delegate = self;
    
  }
  BMKDistrictSearchOption *option = [[BMKDistrictSearchOption alloc] init];
  NSString *provice = @"北京";
  
 
  if (_paramDic != nil &&  [NomalUtil isValueableString:[_paramDic objectForKey:@"fenceName"]])
  {
    provice = [_paramDic objectForKey:@"fenceName"];
  }
  option.city = provice;
  //  option.district = @"朝阳区";
  [self showNetWaiting];
  BOOL flag = [_search districtSearch:option];
  if (flag) {
    NSLog(@"district检索发送成功");
  }  else  {
    NSLog(@"district检索发送失败");
    //    self.errorblock([NSArray arrayWithObjects:@"检索失败", nil]);
    [self closeNetWaiting];
    [self showViewMessage:@"检索失败"];
  }
}
-(CGFloat)loadHeaderView
{
  CGFloat spaceH = 5;
  CGFloat spaceW = 10;
  CGFloat labelWidth = self.contentView.width - spaceW*2;
  CGFloat labelHeight = 15;
  if (_headView.superview == nil)
  {
    [self.contentView addSubview:_headView];;
  }
  
  [_headView setFrameInSuperViewCenterTop:nil toTopSpace:0 width:self.contentView.width height:200];
  UILabel *label1 = [_headView viewWithTag:1];
  label1.text = [NSString stringWithFormat:@"车牌号：%@",[_paramDic objectForKey:@"plateNumber"]];
  [label1 setFrameInSuperViewLeftTop:nil toLeftSpace:spaceW toTopSpace:spaceH*2 width:200 height:labelHeight];
  
  UILabel *label2 = [_headView viewWithTag:2];
  label2.text = [_paramDic objectForKey:@"alarmTime1"];
  [label2 setFrameInSuperViewRightTop:nil toRightSpace:spaceW toTopSpace:spaceH*2 width:200 height:labelHeight];
  
  UILabel *lastLable = label1;
  for (int i = 3; i <= 9; i++)
  {
      UILabel *label = [_headView viewWithTag:i];
    
    if (i == 3)
    {
      label.text = [NSString stringWithFormat:@"设备号：%@",[_paramDic objectForKey:@"idc"]];
    }
    else if (i == 4)
    {
      label.text = [NSString stringWithFormat:@"车架号：%@",[_paramDic objectForKey:@"vin"]];
    }
    else if (i == 5)
    {
      label.text = [NSString stringWithFormat:@"车主姓名：%@",[_paramDic objectForKey:@"name"]];
    }
    else if (i == 6)
    {
      label.text = [NSString stringWithFormat:@"车主电话：%@",[_paramDic objectForKey:@"mobile"]];
    }
    else if (i == 7)
    {
      label.text = [NSString stringWithFormat:@"报警类型：%@",[_paramDic objectForKey:@"alarmTypeName"]];
    }
    else if (i == 8)
    {
      label.text = [NSString stringWithFormat:@"报警说明：%@",[_paramDic objectForKey:@"alarmDescribe"]];
    }
    if (i == 9)
    {
      if (self.address == nil)
      {
        self.address = @"";
      }
      label.text = [NSString stringWithFormat:@"详细位置：%@",self.address];
      
      [label setFrameLeftTopFromViewLeftBottom:lastLable leftToLeftSpace:0 bottomToTopSpace:spaceH width:labelWidth height:30];
      label.numberOfLines = 2;
    }
    else
    {
      [label setFrameLeftTopFromViewLeftBottom:lastLable leftToLeftSpace:0 bottomToTopSpace:spaceH width:labelWidth height:labelHeight];
    }
    
    lastLable = label;
  }
  _headView.height = lastLable.bottom + spaceH*2;
  return _headView.height;
}
- (void)createMapView
{
  
  CGFloat headHeight = [self loadHeaderView];
  
  if (!_mapView) {
    
    _mapView = [[BMKMapView alloc] initWithFrame:Rect(0, 0, ScreenWidth_Content, ScreenHeight_Content)];
    //将mapView添加到当前视图中
    [self.contentView addSubview:self.mapView];
     _mapView.delegate = self;
  }
 
  if (_dealButton == nil) {
    _dealButton = [[UIButton alloc] initWithFrame:Rect(0, 0, 47, 47)];
    [self.contentView addSubview:_dealButton];
    [_dealButton setFrameInSuperViewRightBottom:nil toRightSpace:15 toBottomSpace:70 width:-1 height:-1];
    [_dealButton setBackgroundImage:IMAGE_NAMED(@"warn_deal") forState:UIControlStateNormal];
    [_dealButton addTarget:self action:@selector(dealButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  if ([@"0" isEqualToString:[_paramDic objectForKeyWithStringValue:@"hasDeal"]])
  {
    _dealButton.hidden = NO;
  }
  else
  {
     _dealButton.hidden = YES;
  }
  
  self.mapView.frame = Rect(0, headHeight, ScreenWidth_Content, self.contentView.height-headHeight);
//  [self.mapView convertPoint:<#(CGPoint)#> toCoordinateFromView:<#(UIView *)#>]
  //设置mapView的代理
 
  if (_annotation1 == nil)
  {
    _annotation1 = [[BMKPointAnnotation alloc] init];
    double latitude = [_latitude doubleValue];
    double longitude = [_longitude doubleValue];
    //设置标注的经纬度坐标
    _annotation1.coordinate =  CLLocationCoordinate2DMake(latitude, longitude);
    [_mapView addAnnotation:_annotation1];
  }
 
  
  
}

-(void)dealButtonPressed:(UIButton*)button
{
//  [self pushToViewWithReactNativeModuleName:@"WarnDeal" viewControllerName:@"BaseViewController"];
  [self pushToViewWithModuleName4:@"WarnDeal" viewControllerName:@"BaseViewController" object:[viewDic objectForKey:@"object"] animate:YES];
}

/**
 *返回行政区域搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果BMKDistrictSearch
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDistrictResult:(BMKDistrictSearch *)searcher result:(BMKDistrictResult *)result errorCode:(BMKSearchErrorCode)error {
  if (error == BMK_SEARCH_NO_ERROR) {
    //在此处理正常结果
    //result.paths
    for (NSString *path in result.paths) {
      BMKPolygon *polygon = [self transferPathStringToPolygon:path];
      /**
       向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
       来生成标注对应的View
       
       @param overlay 要添加的overlay
       */
      [_mapView addOverlay:polygon];
    }
    _mapView.centerCoordinate = result.center;
    [_mapView setZoomLevel:8];
  }
  else {
    
    [self closeNetWaiting];
    [self showViewMessage:@"检索失败"];
    
  }
}
- (BMKPolygon *)transferPathStringToPolygon:(NSString *)path {
  NSUInteger pathCount = [path componentsSeparatedByString:@";"].count;
  if (pathCount > 0) {
    BMKMapPoint points[pathCount];
    NSArray *pointsArray = [path componentsSeparatedByString:@";"];
    for (NSUInteger i = 0; i < pathCount; i ++) {
      if ([pointsArray[i] rangeOfString:@","].location != NSNotFound) {
        NSArray *coordinates = [pointsArray[i] componentsSeparatedByString:@","];
        points[i] = BMKMapPointMake([coordinates.firstObject doubleValue], [coordinates .lastObject doubleValue]);
      }
    }
    /**
     根据多个点生成多边形
     
     points 直角坐标点数组，这些点将被拷贝到生成的多边形对象中
     count 点的个数
     新生成的多边形对象
     */
    BMKPolygon *polygon = [BMKPolygon polygonWithPoints:points count:pathCount];
    return polygon;
  }
  return nil;
}

#pragma mark - BMKMapViewDelegate
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
      annotationView.image = IMAGE_NAMED(@"car_red");
      //当前view的拖动状态
      //annotationView.dragState;
      //            NSLog(@"0000000000");
    }
    return annotationView;
  }
  return nil;
}
/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
  if ([overlay isKindOfClass:[BMKPolygon class]]) {
    //初始化一个overlay并返回相应的BMKPolygonView的实例
    BMKPolygonView *polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
    //设置polygonView的画笔（边框）颜色
    polygonView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
    //设置polygonView的填充色
    polygonView.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.4];
    //设置polygonView的线宽度
    polygonView.lineWidth = 1;
    //是否为虚线样式，默认NO
    polygonView.lineDash = NO;
    return polygonView;
  }
  return nil;
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
      
      NSDictionary *dic = (NSDictionary *)response.data;
    
      self.address =  [dic objectForKey:@"address"];
      UILabel *label = [_headView viewWithTag:9];
      label.text = [NSString stringWithFormat:@"详细位置：%@",self.address];
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
