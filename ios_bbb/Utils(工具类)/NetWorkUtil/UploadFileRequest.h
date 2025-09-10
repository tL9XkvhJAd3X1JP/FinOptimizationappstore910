//
//  UploadFileRequest.h
//  BaseProject
//
//  Created by janker on 2018/11/14.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadFileRequest : YTKRequest
//@property (nonatomic, copy) NSString *url;
@property (strong, nonatomic)NSMutableDictionary *parm;
@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, copy) NSString *fileToServerName;
@property (nonatomic, strong) UIImage *image;
@property (strong, nonatomic)NSString *requestEndUrl;

@property (strong, nonatomic)NSString *requestBaseUrl;
//获取上传进度uploadProgressBlock
@property(nonatomic, copy) void(^uploadProgressBlock_file)(UploadFileRequest *request, NSProgress * progress);

@property(nonatomic, copy) void(^downloadProgressBlock_file)(UploadFileRequest *request, NSProgress * progress);
@end

NS_ASSUME_NONNULL_END
