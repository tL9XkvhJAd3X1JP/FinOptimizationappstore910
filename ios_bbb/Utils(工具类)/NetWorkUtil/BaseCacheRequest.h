//
//  BaseCacheRequest.h
//  BaseProject
//
//  Created by janker on 2018/11/7.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseCacheRequest : YTKRequest
@property (strong, nonatomic)NSMutableDictionary *parm;

@property (strong, nonatomic)NSString *requestEndUrl;

@property (strong, nonatomic)NSString *requestBaseUrl;
@property(nonatomic,assign)BOOL isOpenAES;//是否开启加密 默认不开启
@end

NS_ASSUME_NONNULL_END
