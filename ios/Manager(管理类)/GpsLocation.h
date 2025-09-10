//
//  GpsLocation.h
//  Doing
//
//  Created by  on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GpsManager.h"
@interface GpsLocation : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isReceiveLacation;
    id <GpsDataDelegate> delegate;
}
@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic,retain) id <GpsDataDelegate> delegate;
+ (GpsLocation *) instance;
-(void)begin;
@end
