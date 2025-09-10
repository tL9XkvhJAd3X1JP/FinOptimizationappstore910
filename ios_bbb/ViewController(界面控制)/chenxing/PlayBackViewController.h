//
//  BaiduMapViewController.h
//  wsmCarOwner
//
//  Created by wiselink on 14-8-6.
//  Copyright (c) 2014年 chenxing. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface PlayBackViewController : BaseViewController<BMKMapViewDelegate,UIActionSheetDelegate>
//@property(retain,nonatomic) BMKAnnotationView* midAnnotation;//除起点和终点以外的所有点
@property (strong,nonatomic)BMKMapView *mapView;//地图
@property (strong,nonatomic)NSMutableDictionary *dicData;//上个页面传过来的数据


@end
