//
//  EventUtil.h
//  FinOptimization
//
//  Created by janker on 2019/4/9.
//  Copyright © 2019 Facebook. All rights reserved.
//

//string (NSString)
//number (NSInteger, float, double, CGFloat, NSNumber)
//boolean (BOOL, NSNumber)
//array (NSArray) 可包含本列表中任意类型
//object (NSDictionary) 可包含 string 类型的键和本列表中任意类型的值
//function (RCTResponseSenderBlock)

//#import "RCTEventEmitter.h"
#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
//NS_ASSUME_NONNULL_BEGIN
//RCTEventEmitter
@interface EventUtil :RCTEventEmitter<RCTBridgeModule>
@property (nonatomic, copy) void(^block)(id);
//-(void)goToCashier:(NSDictionary*) result;
//-(void)goToCashier:(NSString*) result;
@property (nonatomic, strong)NSMutableArray *actionArray;
@property (nonatomic, strong)NSMutableDictionary *actionDic;

@end

//NS_ASSUME_NONNULL_END
