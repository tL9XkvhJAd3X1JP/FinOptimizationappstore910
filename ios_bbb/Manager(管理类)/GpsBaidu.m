//
//  GpsBaidu.m
//  BaseProject
//
//  Created by janker on 2019/2/18.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "GpsBaidu.h"
static GpsBaidu *instance;
@implementation GpsBaidu
@synthesize locationManager,delegate,isReceiveLacation;
//开始定位 background mode要打开，不然会奔溃
+ (GpsBaidu *) instance
{
    static dispatch_once_t onceToken;
    //GCD 多线程只进一次
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
       
    });
    
    return instance;
}
-(void)begin
{
    isReceiveLacation = NO;
    
    if (locationManager == nil)
    {
       
        locationManager = [[BMKLocationManager alloc] init];
//        locationManager.delegate = self;
        
    }
    
    locationManager.delegate = self;
    locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    locationManager.pausesLocationUpdatesAutomatically = NO;
    locationManager.allowsBackgroundLocationUpdates = YES;
    locationManager.locationTimeout = 10;
    locationManager.reGeocodeTimeout = 10;
    //开始定位 background mode要打开，不然会奔溃
    [locationManager startUpdatingLocation];
    
//    kWeakSelf(self);
//    [locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error)
//    {
//        if (weakself.isReceiveLacation)
//        {
//            return;
//        }
//        //获取经纬度和该定位点对应的位置信息
//        if (error == nil && location != nil)
//        {
//            CLLocation *newLocation = location.location;
//            CLLocationDegrees latitude = newLocation.coordinate.latitude;
//            CLLocationDegrees longitude = newLocation.coordinate.longitude;
//
//            [SingleDataManager instance].longitudeStr = [NSString stringWithFormat:@"%f",
//                                                         longitude];
//            [SingleDataManager instance].latitudeStr = [NSString stringWithFormat:@"%f",
//                                                        latitude];
//            [SingleDataManager instance].coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
//
//
//
//            [weakself.delegate getDataSuccess];
//        }
//        else if (error != nil)
//        {
//             [weakself.delegate getDataFail];
//        }
//        weakself.isReceiveLacation = YES;
//        [NSTimer scheduledTimerWithTimeInterval:3
//                                         target:self
//                                       selector:@selector(closeLocation)
//                                       userInfo:nil
//                                        repeats:NO];
//    }];
    
}
#pragma mark - BMKLocationManagerDelegate
/**
 *  @brief 连续定位回调函数。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param location 定位结果，参考BMKLocation。
 *  @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error{
    if (self.isReceiveLacation)
    {
        return;
    }
    //获取经纬度和该定位点对应的位置信息
    if (error == nil && location != nil)
    {
        CLLocation *newLocation = location.location;
        CLLocationDegrees latitude = newLocation.coordinate.latitude;
        CLLocationDegrees longitude = newLocation.coordinate.longitude;
        
        [SingleDataManager instance].longitudeStr = [NSString stringWithFormat:@"%f",
                                                     longitude];
        [SingleDataManager instance].latitudeStr = [NSString stringWithFormat:@"%f",
                                                    latitude];
        [SingleDataManager instance].coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        
        
        
        [self.delegate getDataSuccess];
    }
    else if (error != nil)
    {
        [self.delegate getDataFail];
    }
    self.isReceiveLacation = YES;
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(closeLocation)
                                   userInfo:nil
                                    repeats:NO];
}

/**
 * @brief 该方法为BMKLocationManager提供设备朝向的回调方法。
 * @param manager 提供该定位结果的BMKLocationManager类的实例
 * @param heading 设备的朝向结果
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager
          didUpdateHeading:(CLHeading * _Nullable)heading{

}
-(void) closeLocation
{
    if (locationManager != nil)
    {
        [locationManager stopUpdatingLocation];
    }
}
@end
