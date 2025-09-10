//
//  GCDUtil.h
//  BaseProject
//
//  Created by janker on 2019/3/25.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDUtil : NSObject
//1.    同步执行(sync) + 并发队列 在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
+(void)syncThreadAndAsyncQueueWithBlock:(void(^)(void))block;
//2.    异步执行 + 并发队列  可以开启多个线程，任务交替（同时）执行
+(void)asyncThreadAndAsyncQueueWithBlock:(void(^)(void))block;
//回到主线程 不做延时超做
//6 异步执行 + 主队列  只在主线程中执行任务，执行完一个任务，再执行下一个任务。
+(void)asyncThreadAndMainQueueWithBlock:(void(^)(void))block;
//4.    异步执行 + 串行队列       会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务
+(void)asyncThreadAndSyncQueueWithBlock:(void(^)(void))block;
//3.    同步执行 + 串行队列  不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
+(void)syncThreadAndSyncQueueWithBlock:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
