//
//  UserInfoModel.m
//  BaseProject
//
//  Created by janker on 2019/2/14.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    // 将userId映射到key为id的数据字段
    return @{@"keyId":@"id"};
    // 映射可以设定多个映射字段
    //  return @{@"personId":@[@"id",@"uid",@"ID"]};
}
//当 JSON 转为 Model 完成后，该方法会被调用。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 可以在这里处理一些数据逻辑，如NSDate格式的转换
    //868120210463219 123456789
//    _idc = @"123456789";

    return YES;
}

// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
//    NSNumber *timestamp = dic[@"timestamp"];
//    if (![timestamp isKindOfClass:[NSNumber class]]) return NO;
//    _createdAt = [NSDate dateWithTimeIntervalSince1970:timestamp.floatValue];
//    return YES;
//}

// 当 Model 转为 JSON 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
//- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
//    if (!_createdAt) return NO;
//    dic[@"timestamp"] = @(n.timeIntervalSince1970);
//    return YES;
//}

@end
