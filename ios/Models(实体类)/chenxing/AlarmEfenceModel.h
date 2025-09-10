//
//  AlarmEfenceModel.h
//  BaseProject
//
//  Created by janker on 2019/2/16.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmEfenceModel : NSObject
@property (strong,nonatomic) NSString * alarmId; //围栏ID
@property (strong,nonatomic) NSString * alarmTime;//报警时间
@property (strong,nonatomic) NSString * longitude;//报警经度
@property (strong,nonatomic) NSString * latitude;//报警纬度
@property (strong,nonatomic) NSString * fenceName;//围栏名称
@property (strong,nonatomic) NSString * alarmType;//围栏类型

@property (strong,nonatomic) NSString * fenceValue;//围栏坐标
@property (strong,nonatomic) NSString * fenceType;//1圆形2矩形3多边形

@end

NS_ASSUME_NONNULL_END
