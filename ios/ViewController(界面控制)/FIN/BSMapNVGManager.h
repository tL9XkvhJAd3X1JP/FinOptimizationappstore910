//
//  BSMapNVGManager.h
//  yiweizuche
//
//  Created by FPS on 2017/4/12.
//  Copyright © 2017年 www.bagechuxing.cn. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,BSMapNVGMode) {
    
    BSMapNVGModeWithWalking = 1,
    BSMapNVGModeWithDriving,
    BSMapNVGModeWithTransit,
    
};

typedef NS_ENUM(NSInteger,BSMapType) {
    
    BSMapTypeWithBaidu = 1,
    BSMapTypeWithGaode,
    BSMapTypeWithTencent,
    
};

#define kBMKMapSchemes      @"baidumap"
#define kBMKMapSchemesURL   [kBMKMapSchemes stringByAppendingString:@"://"]
#define kAMapSchemes        @"iosamap"
#define kAMapSchemesURL     [kAMapSchemes stringByAppendingString:@"://"]
#define kQQMapSchemes        @"qqmap"
#define kQQMapSchemesURL    [kQQMapSchemes stringByAppendingString:@"://"]


@interface BSMapNVGManager : NSObject

//+ (void)openNavigateWithToCoordinate:(CLLocationCoordinate2D)toCoor
//                             mapType:(BSMapType)type
//                        navigateMode:(BSMapNVGMode)mode;
+ (void)openNavigateWithToCoordinate:(CLLocationCoordinate2D)toCoor
                             mapType:(BSMapType)type
                        navigateMode:(BSMapNVGMode)mode ViewDic:(NSMutableDictionary *)viewDic;

@end
