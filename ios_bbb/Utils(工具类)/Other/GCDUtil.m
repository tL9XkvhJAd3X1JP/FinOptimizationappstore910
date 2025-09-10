//
//  GCDUtil.m
//  BaseProject
//
//  Created by janker on 2019/3/25.
//  Copyright © 2019 ChenXing. All rights reserved.
//
/**
 1.    同步执行 + 并发队列   在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 2.    异步执行 + 并发队列  可以开启多个线程，任务交替（同时）执行
 3.    同步执行 + 串行队列  不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 4.    异步执行 + 串行队列       会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务
 5.    同步执行 + 主队列  在不同线程中调用结果也是不一样，在主线程中调用会出现死锁，而在其他线程中则不会。
 6.    异步执行 + 主队列  只在主线程中执行任务，执行完一个任务，再执行下一个任务。
 */

/**
 Dispatch Semaphore 在实际开发中主要用于：
 •    保持线程同步，将异步执行任务转换为同步执行任务
 •    保证线程安全，为线程加锁
 */
#import "GCDUtil.h"
static dispatch_queue_t asyncQueue;
static dispatch_queue_t syncQueue;
static dispatch_once_t onceTokenSyncQueue;
static dispatch_once_t onceTokenAsyncQueue;
//static dispatch_queue_t mainQueue;
@implementation GCDUtil
/** * 一次性代码（只执行一次）dispatch_once */
//- (void)once
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // 只执行1次的代码(这里面默认是线程安全的)
//
//    });
//
//}

//1.    同步执行(sync) + 并发队列 在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
+(void)syncThreadAndAsyncQueueWithBlock:(void(^)(void))block
{
    // 并发队列的创建方法
    //    if (asyncQueue == nil)
    //    {
    //        asyncQueue = dispatch_queue_create("com.wiselink.asyncQueue", DISPATCH_QUEUE_CONCURRENT);
    //    }
    
    dispatch_once(&onceTokenAsyncQueue, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
        asyncQueue = dispatch_queue_create("com.wiselink.asyncQueue", DISPATCH_QUEUE_CONCURRENT);
        NSLog(@"==================one time asyncQueue");
    });
    // 同步执行任务创建方法
    dispatch_sync(asyncQueue, block);
    
}
//2.    异步执行 + 并发队列  可以开启多个线程，任务交替（同时）执行
+(void)asyncThreadAndAsyncQueueWithBlock:(void(^)(void))block
{
    
    // 并发队列的创建方法
    //    if (asyncQueue == nil)
    //    {
    //        asyncQueue = dispatch_queue_create("com.wiselink.asyncQueue", DISPATCH_QUEUE_CONCURRENT);
    //    }
    dispatch_once(&onceTokenAsyncQueue, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
        asyncQueue = dispatch_queue_create("com.wiselink.asyncQueue", DISPATCH_QUEUE_CONCURRENT);
        NSLog(@"==================one time asyncQueue");
    });
    // 异步执行任务创建方法
    dispatch_async(asyncQueue, block);
    
    
}
//3.    同步执行 + 串行队列  不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
+(void)syncThreadAndSyncQueueWithBlock:(void(^)(void))block
{
    
    // 串行队列的创建方法
    //    if (syncQueue == nil)
    //    {
    //        syncQueue = dispatch_queue_create("com.wiselink.syncQueue", DISPATCH_QUEUE_SERIAL);
    //    }
    dispatch_once(&onceTokenSyncQueue, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
        syncQueue = dispatch_queue_create("com.wiselink.syncQueue", DISPATCH_QUEUE_SERIAL);
        NSLog(@"==================one time syncQueue");
    });
    // 同步执行任务创建方法
    dispatch_sync(syncQueue, block);
    
}
//4.    异步执行 + 串行队列       会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务
+(void)asyncThreadAndSyncQueueWithBlock:(void(^)(void))block
{
    
    // 串行队列的创建方法
    //    if (syncQueue == nil)
    //    {
    //        syncQueue = dispatch_queue_create("com.wiselink.syncQueue", DISPATCH_QUEUE_SERIAL);;
    //    }
    dispatch_once(&onceTokenSyncQueue, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
        syncQueue = dispatch_queue_create("com.wiselink.syncQueue", DISPATCH_QUEUE_SERIAL);
        NSLog(@"==================one time syncQueue");
    });
    // 异步执行任务创建方法
    dispatch_async(syncQueue, block);
    
}
//5.    同步执行 + 主队列  在不同线程中调用结果也是不一样，在主线程中调用会出现死锁，而在其他线程中则不会。
+(void)syncThreadAndMainQueueWithBlock:(void(^)(void))block
{
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    // 执行任务创建方法
    dispatch_sync(mainQueue, block);
    
}
//回到主线程
//6 异步执行 + 主队列  只在主线程中执行任务，执行完一个任务，再执行下一个任务。
+(void)asyncThreadAndMainQueueWithBlock:(void(^)(void))block
{
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    // 异步执行任务创建方法
    dispatch_async(mainQueue, block);
    
}
//NSLock *lock = [[NSLock alloc] init];
//[lock lock];
//[lock unlock];
/**
 6.1 GCD 栅栏方法：dispatch_barrier_async
 6.2 GCD 延时执行方法：dispatch_after
 6.3 GCD 一次性代码（只执行一次）：dispatch_once
 6.4 GCD 快速迭代方法：dispatch_apply
 6.5 GCD 队列组：dispatch_group
 有时候我们会有这样的需求：分别异步执行2个耗时任务，然后当2个耗时任务都执行完毕后再回到主线程执行任务。这时候我们可以用到 GCD 的队列组。
 6.5.1 dispatch_group_notify
 监听 group 中任务的完成状态，当所有的任务都执行完成后，追加任务到 group 中，并执行任务。
 6.5.2 dispatch_group_wait
 暂停当前线程（阻塞当前线程），等待指定的 group 中的任务执行完成后，才会往下继续执行。
 6.5.3 dispatch_group_enter、dispatch_group_leave
 dispatch_group_enter 标志着一个任务追加到 group，执行一次，相当于 group 中未执行完毕任务数+1
 dispatch_group_leave 标志着一个任务离开了 group，执行一次，相当于 group 中未执行完毕任务数-1。
 当 group 中未执行完毕任务数为0的时候，才会使dispatch_group_wait解除阻塞，以及执行追加到dispatch_group_notify中的任务。

 */
@end

