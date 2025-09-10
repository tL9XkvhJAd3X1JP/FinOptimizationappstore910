//
//  EventUtil.m
//  FinOptimization
//
//  Created by janker on 2019/4/9.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EventUtil.h"
//static EventUtil *sharedInstance;
/*
 优化无监听处理的事件
 
 如果你发送了一个事件却没有任何监听处理，则会因此收到一个资源警告。要优化因此带来的额外开销，你可以在你的RCTEventEmitter子类中覆盖startObserving和stopObserving方法。
 */
@implementation EventUtil
@synthesize bridge = _bridge;
+(id)allocWithZone:(NSZone *)zone {
  static EventUtil*sharedInstance =nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
    sharedInstance.actionArray = [NSMutableArray arrayWithCapacity:10];
    sharedInstance.actionDic = [NSMutableDictionary dictionaryWithCapacity:10];
  });
  return sharedInstance;
}
//[self sendEventWithName:@"EventReminder" body:nil];
RCT_EXPORT_MODULE(EventUtil);
-(NSArray *)supportedEvents{
  
//  return @[@"goToCashier",@"goToCashier2"];
  return _actionArray;
}
/**
 * callback 要写在最后面
 */
//RCT_EXPORT_METHOD(handleEvent:(NSDictionary *)userInfo callback:(RCTResponseSenderBlock)callback)
//{
//  NSLog(@"事件信息=====> %@", userInfo);
//  // 切换到主线程，JS 代码是运行在 JS 线程上的
//  dispatch_async(dispatch_get_main_queue(), ^{
//    UIApplication *application = [UIApplication sharedApplication];
//    UINavigationController *navigation = (UINavigationController *)[application keyWindow].rootViewController;
//    NSArray *keys = [userInfo isKindOfClass:[NSDictionary class]] ? userInfo.allKeys : nil;
//    __block BOOL isSuccess = NO;
//    if (keys && keys.count > 0) {
//      NSString *key = [keys firstObject];
//      [navigation.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:NSClassFromString(key)]) {
//          obj.title = [userInfo objectForKey:key];
//          *stop = YES;
//          isSuccess = YES;
//        }
//      }];
//    }
//    if (callback) {
//      callback(@[[NSString stringWithFormat:@"修改导航标题%@", isSuccess ? @"成功" : @"失败"]]);
//    }
//  });
//}
-(void)goToCashier:(NSDictionary*) result eventName:(NSString*)eventName
//-(void)goToCashier:(NSString*) result
{
//  NSLog(@"======== cashierSuccess ========== %@",result);
//  [self sendEventWithName:@"goToCashier" body:@{@"result": result}];
//  [self sendEventWithName:eventName body:result];
}

RCT_EXPORT_METHOD(actionEvent:(NSString *)eventName object:(NSDictionary*)obj)
{

  [self sendEventWithName:eventName body:obj];
//  dispatch_async(dispatch_get_main_queue(), ^{
//    [self sendEventWithName:eventName
//                       body:obj];
//    [[NSNotificationCenter defaultCenter] postNotificationName:eventName
//                                                        object:self
//                                                      userInfo:obj];
//    ReactEventEmit *emit = [ReactEventEmit allocWithZone:nil];
//
//    [self goToCashier:@"fail"];
//    [self goToCashier:obj eventName:eventName];
   


//  });
}
RCT_EXPORT_METHOD(addEventName:(NSString *)eventName)
{
  if (_actionArray == nil)
  {
    self.actionArray = [NSMutableArray arrayWithCapacity:10];
  }
  [_actionArray addObject:eventName];
}

#pragma mark-once callback
//一次回调的时候用
RCT_EXPORT_METHOD(actionEventOnce:(NSString *)eventName object:(NSDictionary*)obj)
{
  
  //  [self sendEventWithName:eventName body:obj];
//  dispatch_async(dispatch_get_main_queue(), ^{
 
  if (obj == nil)
  {
    obj = [NSDictionary dictionary];
  }
    //响应
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:obj,eventName, nil]];
    //移掉
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:eventName object:nil];
//  });
}


RCT_EXPORT_METHOD(addEventOnce:(NSString *)eventName callBack:(RCTResponseSenderBlock)callback)
{
//  self.block = callback;
  
  if ([_actionDic objectForKey:eventName] == nil)
  {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callBack:)
                                                 name:eventName
                                               object:nil];
  }
  [_actionDic setObjectFilterNull:callback forKey:eventName];
  

}

RCT_EXPORT_METHOD(removeEventOnce:(NSString *)eventName)
{

  [[NSNotificationCenter defaultCenter] removeObserver:self name:eventName object:nil];
  [_actionDic removeObjectForKey:eventName];

}
- (void)callBack:(NSNotification *)notification
{
  if (notification != nil)
  {
    for (NSString *key in notification.userInfo)
    {
      self.block = [_actionDic objectForKey:key];
      if (self.block)
      {
        //notification.userInfo
        NSArray * array = nil;
        if (notification.userInfo != nil)
        {
          array = [NSArray arrayWithObjects:notification.userInfo, nil];
        }
        else
        {
          array = [NSArray arrayWithObjects:[NSDictionary dictionary], nil];
        }
        self.block(array);
        self.block = nil;
      }
    }
  }
  
  
}

//  进行设置发送事件通知给JavaScript端
//- (void)calendarEventReminderReceived:(NSNotification *)notification
//{
//  NSString *name = [notification userInfo][@"name"];
//  [self.bridge.eventDispatcher sendAppEventWithName:@"EventReminder"
//                                               body:@{@"name": name}];
//}




//RCT_EXPORT_METHOD(addEvent:(NSString *)eventName block:(void(^)(NSDictionary*))block)
//{
//
//  self.block = block;
//  //  [self sendEventWithName:eventName body:obj];
//  dispatch_async(dispatch_get_main_queue(), ^{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(emitEventInternal:)
//                                                 name:eventName
//                                               object:nil];
//  });
//}
//- (void)emitEventInternal:(NSNotification *)notification
//{
//  if (self.block)
//  {
//    self.block(notification.userInfo);
//  }
//
//}
//RCT_EXPORT_METHOD(addEvent:(NSString *)eventName object:(NSDictionary*)obj)
//{
//
//  //  [self sendEventWithName:eventName body:obj];
//  dispatch_async(dispatch_get_main_queue(), ^{
//    [self addEvent:eventName object:obj];
//  });
//}
#pragma mark- rewrite
//- (NSArray<NSString *> *)supportedEvents {
//  return @[@"SpotifyHelper"];
//}
//
//// 在添加第一个监听函数时触发
//- (void)startObserving
//{
//  hasListeners = YES;
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(emitEventInternal:)
//                                               name:@"event-emitted"
//                                             object:nil];
//}
//
//- (void)stopObserving
//{
//  hasListeners = NO;
//  [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//- (void)emitEventInternal:(NSNotification *)notification
//{
//
//  if (hasListeners)
//  { // Only send events if anyone is listening
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//      [self sendEventWithName:@"SpotifyHelper"
//                         body:notification.userInfo];
//    });
//  }
//}
//
//+ (void)emitEventWithName:(NSString *)name andPayload:(NSDictionary *)payload
//{
//  [[NSNotificationCenter defaultCenter] postNotificationName:@"event-emitted"
//                                                      object:self
//                                                    userInfo:payload];
//}

// Remaining methods
//RCT_EXPORT_METHOD(addListener:(NSString *)eventName)
//RCT_EXPORT_METHOD(removeListeners:(double)count)

//- (void)CollectionProductSuccessForRNAction:(NSNotification*)notification {
//
//  dispatch_async(dispatch_get_main_queue(), ^{
//    [self sendEventWithName:@"EventReminder_CollectionProductSuccessForRN" body:nil];
//  });
//
//}
//- (void)startObserving {
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(CollectionProductSuccessForRNAction:)
//                                               name:@"CollectionProductSuccessForRN"
//                                             object:nil];
//}
//- (void)stopObserving {
//  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CollectionProductSuccessForRN"object:nil];
//}
@end
