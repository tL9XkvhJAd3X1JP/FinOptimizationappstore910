//
//  NetWorkCenter.h
//  BaseProject
//
//  Created by janker on 2018/10/31.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(NSString *error);
typedef void(^ProgressBlock)(NSProgress *progress);
@interface NetWorkCenter : NSObject
+ (NetWorkCenter *)sharedInstance;
//-(void)configHttpRequest;
/** 上传图片 **/
+ (void)uploadFileFromData:(id)parameters
                methodName:(NSString *)name
                 apiString:(NSString *)apiString
                  progress:(ProgressBlock)progress
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
+ (void)uploadErrorFileFromData:(id)parameters
                     methodName:(NSString *)name
                       progress:(ProgressBlock)progress
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
