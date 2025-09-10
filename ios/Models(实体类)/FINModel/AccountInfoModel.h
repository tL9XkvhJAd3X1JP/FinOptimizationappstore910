//
//  AccountInfoModel.h
//  BaseProject
//
//  Created by janker on 2019/3/28.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountInfoModel : NSObject
@property (strong,nonatomic) NSString* keyId;//主键
@property (strong,nonatomic) NSString* username;//用户登录名
@property (strong,nonatomic) NSString* password;//用户登录密码
@property (strong,nonatomic) NSString* realname;//用户真实姓名
@property (strong,nonatomic) NSString* mobile;//用户电话
@property (strong,nonatomic) NSString* isLogin;//是否允许登录 1-是 0-否
@property (strong,nonatomic) NSString* lastLoginDate;//最后登录时间
@property (strong,nonatomic) NSString* isDelete;//是否删除 0-未删除 1-已删除
@property (strong,nonatomic) NSString* createUserId;//创建人id
@property (strong,nonatomic) NSString* createDate;//创建时间
@property (strong,nonatomic) NSString* companyId;//所属公司id


@end

NS_ASSUME_NONNULL_END
