//
//  GpsBaidu.h
//  BaseProject
//
//  Created by janker on 2019/2/18.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//开始定位 background mode要打开，不然会奔溃
@interface GpsBaidu : NSObject<BMKLocationManagerDelegate>
//@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
{
    BMKLocationManager *locationManager;
    BOOL isReceiveLacation;
    id <GpsDataDelegate> delegate;
}
@property (nonatomic,assign) BOOL isReceiveLacation;
@property (nonatomic,strong) BMKLocationManager *locationManager;
@property (nonatomic,strong) id <GpsDataDelegate> delegate;
+ (GpsBaidu *) instance;
-(void)begin;
@end

NS_ASSUME_NONNULL_END
