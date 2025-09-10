//
//  EventUtil.h
//  FinOptimization
//
//  Created by janker on 2019/4/9.
//  Copyright © 2019 Facebook. All rights reserved.
//

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
