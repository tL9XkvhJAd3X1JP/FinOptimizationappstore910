//
//  BaseCacheRequest.m
//  BaseProject
//
//  Created by janker on 2018/11/7.
//  Copyright © 2018 ChenXing. All rights reserved.
//
//#import "NetWorkCenter.h"
#import "BaseCacheRequest.h"
#import "AESCipher.h"
#import "HeaderModel.h"
@implementation BaseCacheRequest
-(instancetype)init
{
//    [NetWorkCenter sharedInstance];
    self = [super init];
    if (self) {
        self.parm = [NSMutableDictionary dictionaryWithCapacity:1];
        //        self.isOpenAES = YES;
    }
    
    return self;
}
-(BOOL)ignoreCache
{
    return NO;
}

#pragma mark - Subclass Override

-(NSInteger)cacheTimeInSeconds
{
    return 10;
}

- (void)requestCompletePreprocessor
{
    [super requestCompletePreprocessor];
}

- (void)requestCompleteFilter
{
    [super requestCompleteFilter];
}

- (void)requestFailedPreprocessor
{
    [super requestFailedPreprocessor];
}

- (void)requestFailedFilter
{
    [super requestFailedFilter];
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

- (NSString *)cdnUrl {
    return @"";
}


- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

- (id)requestArgument {
    return self.parm;
}

- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return argument;
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

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

//- (NSURLRequest *)buildCustomUrlRequest {
//    return nil;
//}

- (BOOL)useCDN {
    return NO;
}

- (BOOL)allowsCellularAccess {
    return YES;
}

- (id)jsonValidator {
    return nil;
}

- (BOOL)statusCodeValidator {
    return [super statusCodeValidator];
}
#pragma mark ————— 如果是加密方式传输，自定义request —————
-(NSURLRequest *)buildCustomUrlRequest{
    
    if (!_isOpenAES) {
        return nil;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_main,self.requestUrl]]];
    
    //加密header部分
    NSString *headerContentStr = [[HeaderModel new] modelToJSONString];
    NSString *headerAESStr = aesEncrypt(headerContentStr);
    [request setValue:headerAESStr forHTTPHeaderField:@"header-encrypt-code"];
    
    NSString *contentStr = [self.requestArgument jsonStringEncoded];
    NSString *AESStr = aesEncrypt(contentStr);
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"text/encode" forHTTPHeaderField:@"Content-Type"];
    
    
    NSData *bodyData = [AESStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:bodyData];
    return request;
    
}
@end
