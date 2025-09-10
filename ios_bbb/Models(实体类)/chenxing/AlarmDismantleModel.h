//
//  AlarmDismantleModel.h
//  BaseProject
//
//  Created by janker on 2019/2/16.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmDismantleModel : NSObject
@property (strong,nonatomic) NSString * alarmId;
@property (strong,nonatomic) NSString * longitude;//经度
@property (strong,nonatomic) NSString * latitude; //纬度
@property (strong,nonatomic) NSString * alarmTime; //报警时间
@property (strong,nonatomic) NSString * palteNumber; //车牌号
@property (strong,nonatomic) NSString * sn; //设备号
@property (strong,nonatomic) NSString * vin; //VIN号
@property (strong,nonatomic) NSString * brand; //品牌
@property (strong,nonatomic) NSString * customerName; //客户名称
@property (strong,nonatomic) NSString * mobilePhone; //客户电话
@property (strong,nonatomic) NSString * linkmanName; //紧急联系人名称
@property (strong,nonatomic) NSString * linkmanPhone; //紧急联系人电话
@property (strong,nonatomic) NSString * companyName; //公司名称
@property (strong,nonatomic) NSString * groupName; //小组名称

@end

NS_ASSUME_NONNULL_END
