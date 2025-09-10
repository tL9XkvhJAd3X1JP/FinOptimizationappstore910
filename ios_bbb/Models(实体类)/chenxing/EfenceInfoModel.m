//
//  EfenceInfoModel.m
//  BaseProject
//
//  Created by janker on 2019/2/18.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "EfenceInfoModel.h"

@implementation EfenceInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    // 将userId映射到key为id的数据字段
    return @{@"efenceInfoId":@"id"};
    // 映射可以设定多个映射字段
    //  return @{@"personId":@[@"id",@"uid",@"ID"]};
}
@end
