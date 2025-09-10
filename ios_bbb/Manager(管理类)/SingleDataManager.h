//
//  SingleDataManager.h
//  BaseProject
//
//  Created by janker on 2019/2/14.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionModel.h"
#import "UserInfoModel.h"
#import "AccountInfoModel.h"
//NS_ASSUME_NONNULL_BEGIN

@interface SingleDataManager : NSObject
@property (nonatomic, strong) VersionModel *versionModel;//版本model
@property (nonatomic, strong) UserInfoModel *userInfoModel;//userinfo
@property (nonatomic, strong) AccountInfoModel *accountInfoModel;
@property (nonatomic, strong) NSString *latitudeStr;
@property (nonatomic, strong) NSString *longitudeStr;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSDate *timeGetPlace;
@property (strong,nonatomic) NSString *token;//放缓存中
+ (instancetype) instance;
@end

//NS_ASSUME_NONNULL_END
