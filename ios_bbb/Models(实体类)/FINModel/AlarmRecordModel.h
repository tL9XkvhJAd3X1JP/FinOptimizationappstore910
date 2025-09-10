//
//  AlarmRecordModel.h
//  BaseProject
//
//  Created by janker on 2019/3/28.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmRecordModel : NSObject
@property (strong,nonatomic) NSString* alarmType;//报警类型
@property (strong,nonatomic) NSString* alarmName;//报警名称
@property (strong,nonatomic) NSString* alarmTypeCount;//报警类型数量
@end

NS_ASSUME_NONNULL_END
