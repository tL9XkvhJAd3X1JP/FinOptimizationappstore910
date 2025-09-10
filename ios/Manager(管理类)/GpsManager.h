//
//  GpsManager.h
//  Doing
//
//  Created by  on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol MyGPSDelegate <NSObject>
- (void) haveGetLatitudeAndLongitude;
- (void) errorGetLatitudeAndLongitude;
@end

@protocol GpsDataDelegate <NSObject>
- (void) getDataSuccess;
- (void) getDataFail;
@end

@interface GpsManager : NSObject<GpsDataDelegate>
{
    id <MyGPSDelegate> delegate;
    int gpsType;
}
//0手机定位　１gaode定位 2百度定位
@property (nonatomic,assign)int gpsType;
@property (nonatomic,retain) id <MyGPSDelegate> delegate;
@property (nonatomic, retain) CLLocationManager *locationManager;
+ (GpsManager *) instance;
- (void) begin;
@end
