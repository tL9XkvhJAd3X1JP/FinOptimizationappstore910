//
//  GpsManager.m
//  Doing
//
//  Created by  on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GpsManager.h"
//#import "GpsGaode.h" //删地图
#import "GpsLocation.h"
#import "GpsBaidu.h"
static GpsManager *instance;
@implementation GpsManager
@synthesize delegate,gpsType;

-(void)dealloc
{
//    [delegate release];
//    [_locationManager release];
//    [super dealloc];
}
+ (GpsManager *) instance
{
    static dispatch_once_t onceToken;
    //GCD 多线程只进一次
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    
    return instance;
}
-(long) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    return timeInterval/60;
}
- (void) begin
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
    {
        //        1.在info.plist中加入：
        //        NSLocationAlwaysUsageDescription＝YES
        //        NSLocationWhenInUseUsageDescription＝YES
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager *temp = [[CLLocationManager alloc] init];
        self.locationManager = temp;
        //获取授权认证
        //        [locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
//        [temp release];
        //        [locationManager release];
    }
//    MAIN(^{
    
        if(!([CLLocationManager locationServicesEnabled] &&
             [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied))
        {
            kWeakSelf(self);
            MAIN(^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在手机设置-隐私中开启定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
//                [alert release];
                [weakself.delegate errorGetLatitudeAndLongitude];
            });
            return;
        }
        //|| ([SingleData instance].timeGetPlace != nil && [self compareCurrentTime:[SingleData instance].timeGetPlace] > 10)
        if ([SingleDataManager instance].latitudeStr == nil || [SingleDataManager instance].timeGetPlace == nil || ([SingleDataManager instance].timeGetPlace != nil && [self compareCurrentTime:[SingleDataManager instance].timeGetPlace] > 10))
        {
            NSDate *date = [[NSDate alloc] init];
            [SingleDataManager instance].timeGetPlace = date;
//            [date release];
            //        gpsType = 0;
            if (gpsType == 1)
            {
                //删地图
//                [GpsGaode instance].delegate = self;
//                [[GpsGaode instance] begin];
            }
            else if (gpsType == 0)
            {
                [GpsLocation instance].delegate = self;
                [[GpsLocation instance] begin];
                
            }
            else if (gpsType == 2)
            {
                [GpsBaidu instance].delegate = self;
                [[GpsBaidu instance] begin];
                
            }
        }
        else
        {
            [delegate haveGetLatitudeAndLongitude];
        }
        
        
//    });

}
- (void) getDataSuccess
{
    [delegate haveGetLatitudeAndLongitude];
}

- (void) getDataFail
{
    if (gpsType == 1)
    {
        gpsType = 0;
        [GpsLocation instance].delegate = self;
        [[GpsLocation instance] begin];
    }
    if (gpsType == 2)
    {
        gpsType = 0;
        [GpsLocation instance].delegate = self;
        [[GpsLocation instance] begin];
    }
    else
    {
        gpsType = 0;
        [delegate errorGetLatitudeAndLongitude];
    }
}
@end
