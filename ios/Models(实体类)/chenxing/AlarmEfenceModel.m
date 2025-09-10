//
//  AlarmEfenceModel.m
//  BaseProject
//
//  Created by janker on 2019/2/16.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "AlarmEfenceModel.h"

@implementation AlarmEfenceModel
+ (NSDictionary *)modelCustomPropertyMapper {
    // 将userId映射到key为id的数据字段
    return @{@"alarmId":@"id"};
    // 映射可以设定多个映射字段
    //  return @{@"personId":@[@"id",@"uid",@"ID"]};
}

//当 JSON 转为 Model 完成后，该方法会被调用。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 可以在这里处理一些数据逻辑，如NSDate格式的转换
    //868120210463219
    NSString *timeStr = dic[@"alarmTime"];
    _alarmTime = [NomalUtil getStringDateWithNSDate5:[NomalUtil getNSDateWithSecondNumString:timeStr]];
    
    return YES;
}
@end
