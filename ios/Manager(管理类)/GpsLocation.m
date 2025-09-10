//
//  GpsLocation.m
//  Doing
//
//  Created by  on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GpsLocation.h"

static GpsLocation *instance;
@implementation GpsLocation
@synthesize locationManager,delegate;
-(void)dealloc
{
//    [delegate release];
//    [locationManager release];
//    [super dealloc];
}

+ (GpsLocation *) instance
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
        locationManager = [[CLLocationManager alloc] init];
        //kCLLocationAccuracyBestForNavigation kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager.delegate = self;
        //修改当前位置的获取精度
        [locationManager startUpdatingLocation];
    }

}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *newLocation = [locations lastObject];
    CLLocationDegrees latitude = newLocation.coordinate.latitude;
    CLLocationDegrees longitude = newLocation.coordinate.longitude;

    [SingleDataManager instance].longitudeStr = [NSString stringWithFormat:@"%f",
                                                 longitude];
    [SingleDataManager instance].latitudeStr = [NSString stringWithFormat:@"%f",
                                                latitude];
    [SingleDataManager instance].coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    if (isReceiveLacation)
    {
        return;
    }
    isReceiveLacation = YES;
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(closeLocation)
                                   userInfo:nil
                                    repeats:NO];
    //google
    //    MARGCSearchOption* searchOption = [[[MARGCSearchOption alloc]init]autorelease];
    //    searchOption.config = @"RGC"; //这个是默认的，函数声明的头文件有注释
    ////    searchOption.authKey = gaodeKey; //这个就是你申请的key
    //    searchOption.coors = [NSString stringWithFormat:@"%f,%f;",newLocation.coordinate.longitude, newLocation.coordinate.latitude];
    //
    //    MASearch *search = [[[MASearch alloc] initWithSearchKey:gaodeKey Delegate:self] autorelease];
    //     [search gpsOffsetSearchWithOption:searchOption];
    
    //    [delegate haveGetLatitudeAndLongitude];
    
    [delegate getDataSuccess];
}

//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation
//{
//    CLLocationDegrees latitude = newLocation.coordinate.latitude;
//    CLLocationDegrees longitude = newLocation.coordinate.longitude;
//    //NSLog(@"%f    %f     %f  %@",latitude,longitude,newLocation.horizontalAccuracy,[[[NSDate alloc] init] description]);//%g
//
//    [SingleDataManager instance].longitudeStr = [NSString stringWithFormat:@"%f",
//                                    longitude];
//    [SingleDataManager instance].latitudeStr = [NSString stringWithFormat:@"%f",
//                                   latitude];
//    [SingleDataManager instance].coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
//    if (isReceiveLacation)
//    {
//        return;
//    }
//    isReceiveLacation = YES;
//    [NSTimer scheduledTimerWithTimeInterval:3
//                                     target:self
//                                   selector:@selector(closeLocation)
//                                   userInfo:nil
//                                    repeats:NO];
//    //google
////    MARGCSearchOption* searchOption = [[[MARGCSearchOption alloc]init]autorelease];
////    searchOption.config = @"RGC"; //这个是默认的，函数声明的头文件有注释
//////    searchOption.authKey = gaodeKey; //这个就是你申请的key
////    searchOption.coors = [NSString stringWithFormat:@"%f,%f;",newLocation.coordinate.longitude, newLocation.coordinate.latitude];
////
////    MASearch *search = [[[MASearch alloc] initWithSearchKey:gaodeKey Delegate:self] autorelease];
////     [search gpsOffsetSearchWithOption:searchOption];
//
////    [delegate haveGetLatitudeAndLongitude];
//    [delegate getDataSuccess];
//
//}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"lllll");
	if (isReceiveLacation)
	{
		return;
	}
	isReceiveLacation = YES;
    
    [CLLocationManager locationServicesEnabled];
	//[manager stopUpdatingLocation];
//    [delegate haveGetLatitudeAndLongitude];
    [delegate getDataFail];
}
-(void) closeLocation
{
    if (locationManager != nil)
    {
        [locationManager stopUpdatingLocation];
    }
}

#pragma mark gaode
//-(void) gpsOffsetSearch:(MARGCSearchOption *)gpsOffSearchOption Result:(MARGCSearchResult *)result
//{
//    MARGCItem* rgcInfo = [result.rgcItemArray objectAtIndex:0];
//    //返回的结果result是一个array来的，因为可以同时查找很多组经纬度值，不过我上面代码我只写了一组，所以只取第一个object就行了
//    MYLog(@"%f  %f",[rgcInfo.x floatValue],[rgcInfo.y floatValue]);
////    currentLocation.longitude = [rgcInfo.x floatValue];        //取出经度值
////    currentLocation.latitude = [rgcInfo.y floatValue];  //取出纬度值
//}
@end
