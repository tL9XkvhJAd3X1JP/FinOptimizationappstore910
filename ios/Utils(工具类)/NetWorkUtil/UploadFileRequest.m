//
//  UploadFileRequest.m
//  BaseProject
//
//  Created by janker on 2018/11/14.
//  Copyright © 2018 ChenXing. All rights reserved.
//
//https://www.jianshu.com/p/461e15f92069 相关学习
#import "UploadFileRequest.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
@implementation UploadFileRequest
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.parm = [NSMutableDictionary dictionaryWithCapacity:1];
        
    }
    
    return self;
}
- (id)requestArgument {
    return self.parm;
}
-(NSString *)requestUrl
{
    if (self.requestEndUrl != nil)
    {
        return self.requestEndUrl;
    }
    return @"";
}
-(NSString *)baseUrl
{
    if (self.requestBaseUrl != nil)
    {
        return self.requestBaseUrl;
    }
    return @"";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeHTTP;
}
//设置上传图片 所需要的 HTTP HEADER
//This can be use to construct HTTP body when needed in POST request. Default is nil.
- (AFConstructingBlock)constructingBodyBlock
{
//    UIImage *image = self.image;
    WS(weakSelf);
    return ^(id<AFMultipartFormData> formData) {
      
        if (weakSelf.filePath != nil && weakSelf.fileToServerName != nil)
        {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:weakSelf.filePath] name:weakSelf.fileToServerName error:nil];
        }
        else if (weakSelf.image != nil)
        {
            NSData *data = UIImagePNGRepresentation(weakSelf.image);
            NSString *name = @"file";
            NSString *fileName = @"upload";
            NSString *type = @"image/png";
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:type];
        }
        
    };
}
//- (AFConstructingBlock)constructingBodyBlock
//{
//    return nil;
//}
#pragma mark 上传进度
- (AFURLSessionTaskProgressBlock) resumableUploadProgressBlock {
    WS(weakSelf);
//    [UIProgressView setProgressWithUploadProgressOfTask]
    AFURLSessionTaskProgressBlock block = ^void(NSProgress * progress){
        if (self.uploadProgressBlock_file) {
            self.uploadProgressBlock_file(weakSelf, progress);
        }
    };
    return block;
}

- (AFURLSessionTaskProgressBlock) resumableDownloadProgressBlock {
    WS(weakSelf);
    AFURLSessionTaskProgressBlock block = ^void(NSProgress * progress){
        if (self.downloadProgressBlock_file) {
            self.downloadProgressBlock_file(weakSelf, progress);
        }
    };
    return block;
}
//resumableDownloadProgressBlock
@end
