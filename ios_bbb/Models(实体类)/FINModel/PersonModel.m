//
//  PersonModel.m
//  BaseProject
//
//  Created by janker on 2019/3/28.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel
+ (NSDictionary *)modelCustomPropertyMapper {
    // 将userId映射到key为id的数据字段
    return @{@"keyId":@"id"};
    // 映射可以设定多个映射字段
    //  return @{@"personId":@[@"id",@"uid",@"ID"]};
}

// 容器类属性 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    //    return @{@"list" : [Shadow class],
    //             @"borders" : Border.class,
    //             @"attachments" : @"Attachment" };
    return @{@"list" : @"DeviceModel"};

}

@end
