//
//  AlarmDealModel.h
//  BaseProject
//
//  Created by janker on 2019/3/28.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmDealModel : NSObject
@property (strong,nonatomic) NSString* keyId;//记录id
@property (strong,nonatomic) NSString* alarmId;//报警表主键id
@property (strong,nonatomic) NSString* state;//处理状态 0-未处理 1-排查中 2-已处理 3-忽略
@property (strong,nonatomic) NSString* situation;//排查情况
@property (strong,nonatomic) NSString* faultReason;//故障原因
@property (strong,nonatomic) NSString* processingMode;//处理方式
@property (strong,nonatomic) NSString* processingResult;//处理结果
@property (strong,nonatomic) NSString* processingExplain;//处理说明
@property (strong,nonatomic) NSString* modifyuserid;//最后处理人id

@end

NS_ASSUME_NONNULL_END
