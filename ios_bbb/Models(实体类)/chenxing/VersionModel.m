//
//  VersionModel.m
//  BaseProject
//
//  Created by janker on 2019/1/30.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "VersionModel.h"

@implementation VersionModel
//+ (NSDictionary *)modelCustomPropertyMapper {
//    // 将personId映射到key为id的数据字段
//    return @{@"personId":@"id"};
//    // 映射可以设定多个映射字段
//    //  return @{@"personId":@[@"id",@"uid",@"ID"]};
//}
// 黑白名单不同时使用
// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
//+ (NSArray *)modelPropertyBlacklist {
//    return @[@"sex", @"languages"];
//}
//// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
//+ (NSArray *)modelPropertyWhitelist {
//    return @[@"eats"];
//}

//// 字典转模型
//+ (nullable instancetype)modelWithDictionary:(NSDictionary *)dictionary;
//// json转模型
//+ (nullable instancetype)modelWithJSON:(id)json;
//// 模型转NSObject
//- (nullable id)modelToJSONObject;
//// 模型转NSData
//- (nullable NSData *)modelToJSONData;
//// 模型转json字符串
//- (nullable NSString *)modelToJSONString;
//// 模型深拷贝
//- (nullable id)modelCopy;
//// 判断模型是否相等
//- (BOOL)modelIsEqual:(id)model;
//// 属性数据映射，用来定义多样化数据时转换声明
//+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper;
//// 属性自定义类映射，用来实现自定义类的转换声明
//+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass;
//// 属性黑名单，该名单属性不转换为model
//+ (nullable NSArray<NSString *> *)modelPropertyBlacklist;
//// 属性白名单，只有该名单的属性转换为model
//+ (nullable NSArray<NSString *> *)modelPropertyWhitelist;
//// JSON 转为 Model 完成后，该方法会被调用，返回false该model会被忽略
//// 同时可以在该model中做一些，转换不能实现的操作，如NSDate类型转换
//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic;
//// Model 转为 JSON 完成后，该方法会被调用，返回false该model会被忽略
//// 同时可以在该model中做一些，转换不能实现的操作，如NSDate类型转换
//- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic

// YYPersonModel.m
// 当 JSON 转为 Model 完成后，该方法会被调用。
//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
//    // 可以在这里处理一些数据逻辑，如NSDate格式的转换
//    return YES;
//}
//
//// 当 Model 转为 JSON 完成后，该方法会被调用。
//- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
//    return YES;
//}

// 容器类属性 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"shadows" : [Shadow class],
//             @"borders" : Border.class,
//             @"attachments" : @"Attachment" };
//}

@end
