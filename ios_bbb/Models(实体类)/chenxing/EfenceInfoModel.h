//
//  EfenceInfoModel.h
//  BaseProject
//
//  Created by janker on 2019/2/18.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EfenceInfoModel : NSObject
@property (strong,nonatomic) NSString * efenceInfoId;
@property (strong,nonatomic) NSString * efenceName;//围栏名称
@property (strong,nonatomic) NSString * alarmType;//预警类型    0全部    1入区    2出区
@property (strong,nonatomic) NSString * startDate;//监控开始时间
@property (strong,nonatomic) NSString * endDate;//监控结束时间
@property (strong,nonatomic) NSString * efenceType;//围栏类型    1圆形    2矩形    3多边形
@property (strong,nonatomic) NSString * remark;//备注
@property (strong,nonatomic) NSString * createDate;//
@property (strong,nonatomic) NSString * modifyDate;//
@property (strong,nonatomic) NSString * customerid;//注册用户id
@property (strong,nonatomic) NSString * isEnable;//是否启用：0否；1是
@property (strong,nonatomic) NSString * fenceid;//编辑接口传递围栏ID
@property (strong,nonatomic) NSString * idc;//
@property (strong,nonatomic) NSString * productId;//设备id
@property (strong,nonatomic) NSString * efencePoints;//围栏点集合

@end

NS_ASSUME_NONNULL_END
