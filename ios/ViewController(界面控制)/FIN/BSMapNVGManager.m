//
//  BSMapNVGManager.m
//  yiweizuche
//
//  Created by FPS on 2017/4/12.
//  Copyright © 2017年 www.bagechuxing.cn. All rights reserved.
//

#import "BSMapNVGManager.h"
#import <UIKit/UIKit.h>
//#import "BSShareLocation.h"
//#import <JZLocationConverter.h>
#import "JZLocationConverter.h"

@implementation BSMapNVGManager

+ (NSString *)stringBaiduWithMode:(BSMapNVGMode)mode
{
    switch (mode) {
        case BSMapNVGModeWithDriving:
            return @"driving";
            break;
        case BSMapNVGModeWithWalking:
            return @"walking";
            break;
        case BSMapNVGModeWithTransit:
            return @"transit";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)stringGaodeWithMode:(BSMapNVGMode)mode
{
    switch (mode) {
        case BSMapNVGModeWithDriving:
            return @"car";
            break;
        case BSMapNVGModeWithWalking:
            return @"walk";
            break;
        case BSMapNVGModeWithTransit:
            return @"bus";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)stringTencentWithMode:(BSMapNVGMode)mode
{
    switch (mode) {
        case BSMapNVGModeWithDriving:
            return @"drive";
            break;
        case BSMapNVGModeWithWalking:
            return @"walk";
            break;
        case BSMapNVGModeWithTransit:
            return @"bus";
            break;
        default:
            break;
    }
    return @"";
}

+ (void)openNavigateWithToCoordinate:(CLLocationCoordinate2D)toCoor
                             mapType:(BSMapType)type
                        navigateMode:(BSMapNVGMode)mode ViewDic:(NSMutableDictionary *)viewDic
{
    NSString *schemesUrl = nil, *urlString = nil;
    
    if (type == BSMapTypeWithBaidu) {
        
        schemesUrl = kBMKMapSchemesURL;
        urlString = [NSString stringWithFormat:@"%@map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=%@&coord_type=bd09ll",schemesUrl,toCoor.latitude,toCoor.longitude,[viewDic objectForKeyFilterNSNull:@"formatted_address"],[self stringBaiduWithMode:mode]];//gcj02
        
    }else{
        
        CLLocationCoordinate2D toCoor_wgs84 = [self bd09ToGcj02:toCoor];
        if (type == BSMapTypeWithGaode){
            
            schemesUrl = kAMapSchemesURL;
            
            urlString = [NSString stringWithFormat:@"%@navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&mode=%@",schemesUrl,toCoor_wgs84.latitude,toCoor_wgs84.longitude,[self stringGaodeWithMode:mode]];
            
        }else if (type == BSMapTypeWithTencent){
            
            schemesUrl = kQQMapSchemesURL;
//            CLLocationCoordinate2D currCoor_wgs84 = [self bd09ToGcj02:[BSShareLocation shareLocation].coordinate];
            urlString = [NSString stringWithFormat:@"%@map/routeplan?from=我的位置&type=%@&to=%@&tocoord=%f,%f&coord_type=1&policy=0",schemesUrl,[self stringTencentWithMode:mode],[viewDic objectForKeyFilterNSNull:@"formatted_address"],toCoor_wgs84.latitude,toCoor_wgs84.longitude];
            
        }
    }
    
    
    if (!schemesUrl) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"地图类型有误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    BOOL install = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:schemesUrl]];
    if (install) {
        
        if (!toCoor.latitude || !toCoor.longitude) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"目标位置有误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
        NSString *utf8UrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:utf8UrlString]];
        
    }else{
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您未安装此应用" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

+ (CLLocationCoordinate2D)bd09ToGcj02:(CLLocationCoordinate2D)bd09Coor
{
    return [JZLocationConverter bd09ToGcj02:bd09Coor];
}

@end
