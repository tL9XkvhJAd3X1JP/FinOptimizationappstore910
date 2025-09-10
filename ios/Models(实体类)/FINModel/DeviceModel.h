//
//  DeviceModel.h
//  BaseProject
//
//  Created by janker on 2019/3/28.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceModel : NSObject
@property (strong,nonatomic) NSString* sn;//
@property (strong,nonatomic) NSString* snPass;//
@property (strong,nonatomic) NSString* productNo;//设备型号(技术号)
@property (strong,nonatomic) NSString* productType;//设备类型
@property (strong,nonatomic) NSString* idc;//
@property (strong,nonatomic) NSString* installDate;//安装时间
@property (strong,nonatomic) NSString* expireDate;//设备到期时间
@property (strong,nonatomic) NSString* powersupplyMode;//取电方式
@property (strong,nonatomic) NSString* installer;//安装人
@property (strong,nonatomic) NSString* installSite;//安装位置
@property (strong,nonatomic) NSString* ismain;//是否主设备 1-是 0-否
@property (strong,nonatomic) NSString* createDate;//创建日期
@property (strong,nonatomic) NSString* createUserId;//创建人id
@property (strong,nonatomic) NSString* modifyUserId;//修改人id
@property (strong,nonatomic) NSString* modifyDate;//
@property (strong,nonatomic) NSString* isDelete;//是否删除
@property (strong,nonatomic) NSString* companyId;//公司id


@end

NS_ASSUME_NONNULL_END
