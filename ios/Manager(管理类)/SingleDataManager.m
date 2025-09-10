//
//  SingleDataManager.m
//  BaseProject
//
//  Created by janker on 2019/2/14.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "SingleDataManager.h"

@implementation SingleDataManager

static id _instace;

+ (instancetype) instance
{
    static dispatch_once_t onceToken;
    //GCD 多线程只进一次
    dispatch_once(&onceToken, ^{
        
        _instace = [[self alloc] init];
        
    });
    
    return _instace;
    
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        _instace = [super allocWithZone:zone];

    });

    return _instace;
}
- (id)copyWithZone:(NSZone *)zone

{
    return _instace;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        //实现ip切换的监听
        //    NSKeyValueObservingOptionNew：提供更改前的值
        //
        //    NSKeyValueObservingOptionOld：提供更改后的值
        //
        //    NSKeyValueObservingOptionInitial：观察最初的值（在注册观察服务时会调用一次触发方法）
        //    NSKeyValueObservingOptionPrior：分别在值修改前后触发方法（即一次修改有两次触发）
//        [self addObserver:self
//                                forKeyPath:@"versionModel"
//                                   options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld
//                                   context:nil];

    }
    return self;
}

//变量监听实现的方法
//#pragma mark- 监听registerSingle
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([@"versionModel" isEqualToString:keyPath])
//    {
////         SingleDataManager *temp = (SingleDataManager *)object;
//
//        if (change != nil)
//        {
//            //前后两设置不一样的时候做处理
//            VersionModel *modelNew = (VersionModel *)[change objectForKey:@"new"];
////            VersionModel *reg2 = (VersionModel *)[change objectForKey:@"old"];
//            if ([NomalUtil isValueableObject:modelNew])
//            {
//                YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
//
//                config.baseUrl = modelNew.businessInterfaceAddress_ssl;
//            }
//        }
//
//
//    }
//    else
//    {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//
//}

//RCT_EXPORT_MODULE(ios);
//RCT_EXPORT_METHOD(pushToViewWithModuleName:(NSString *)moduleName viewControllerName:(NSString *)viewControllerName)
//{
//  [self pushToViewWithReactNativeModuleName:moduleName viewControllerName:viewControllerName animate:YES];
//}

@end
