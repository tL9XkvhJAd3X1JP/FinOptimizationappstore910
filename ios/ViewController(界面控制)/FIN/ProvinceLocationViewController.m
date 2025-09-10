//
//  ProvinceLocationViewController.m
//  FinOptimization
//
//  Created by janker on 2019/4/22.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "ProvinceLocationViewController.h"

@interface ProvinceLocationViewController ()<BMKMapViewDelegate,BMKDistrictSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong)BMKDistrictSearch *search;

@end

@implementation ProvinceLocationViewController
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//  self = [super initWithNibName:[self className] bundle:nibBundleOrNil];
//  if (self) {
//    // Custom initialization
//  }
//  return self;
//}
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
  
  [super viewDidLoad];
  [self createMapView];
  [self searchRequest];
    // Do any additional setup after loading the view.
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
  NSDictionary * dic = [viewDic objectForKey:@"object"];
  if ([dic objectForKey:@"provice"] != nil)
  {
    provice = [dic objectForKey:@"provice"];
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
- (void)createMapView
{
  
  if (!_mapView) {
    
    _mapView = [[BMKMapView alloc] initWithFrame:Rect(0, 0, ScreenWidth_Content, ScreenHeight_Content)];
  }
  //将mapView添加到当前视图中
  [self.contentView addSubview:self.mapView];
  self.mapView.frame = Rect(0, 100, ScreenWidth_Content, ScreenHeight_Content);
  //设置mapView的代理
  _mapView.delegate = self;
  
  
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
    polygonView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
    //设置polygonView的填充色
    polygonView.fillColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.4];
    //设置polygonView的线宽度
    polygonView.lineWidth = 1;
    //是否为虚线样式，默认NO
    polygonView.lineDash = YES;
    return polygonView;
  }
  return nil;
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
