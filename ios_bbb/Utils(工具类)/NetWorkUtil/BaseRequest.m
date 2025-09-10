//
//  BaseRequest.m
//  BaseProject
//
//  Created by janker on 2018/11/1.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "BaseRequest.h"
#import "AESCipher.h"
#import "HeaderModel.h"
//#import "NetWorkCenter.h"
@implementation BaseRequest
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.parm = [NSMutableDictionary dictionaryWithCapacity:1];
//        self.isOpenAES = YES;
    }
    
    return self;
}

#pragma mark - Subclass Override

- (void)requestCompletePreprocessor
{
    [super requestCompletePreprocessor];
}
//数据返回的时候可以加过滤
- (void)requestCompleteFilter
{
    //日志 NSLog NVLogInfo
    NVLogDebug(@"request_header=%@ \n response_header%@",self.requestHeaderFieldValueDictionary,self.response.allHeaderFields);
    NVLogInfo(@"%@\nrequest.responseString: %@", [self description] ,self.responseString);
    
    //登录和注册的时候
    if ([@"interfaceController/getLoginInfo" isEqualToString:self.requestEndUrl] || [@"interfaceController/registeBike" isEqualToString:self.requestEndUrl])
    {
        if (self.response != nil && self.response.allHeaderFields != nil)
        {
            NSString *token = [self.response.allHeaderFields objectForKey:@"token"];
            if ([NomalUtil isValueableString:token])
            {
                [SingleDataManager instance].token = token;
                [kUserDefaults setObject:token forKey:@"app_token"];
                [kUserDefaults synchronize];
            }
        }
//        NSLog(@"-------------------");
    }
    [super requestCompleteFilter];
}

- (void)requestFailedPreprocessor
{
    [super requestFailedPreprocessor];
}

- (void)requestFailedFilter
{
    //日志
    NVLogInfo(@"%@\nrequest.responseString: %@", [self description] ,self.responseString);
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
    if ([@"1" isEqualToString:Is_Use_Https])
    {
        if ([SingleDataManager instance].versionModel != nil && [SingleDataManager instance].versionModel.businessInterfaceAddress_ssl != nil)
        {
            return [SingleDataManager instance].versionModel.businessInterfaceAddress_ssl;
        }
    }
    else
    {
        if ([SingleDataManager instance].versionModel != nil && [SingleDataManager instance].versionModel.businessInterfaceAddress != nil)
        {
            return [SingleDataManager instance].versionModel.businessInterfaceAddress;
        }
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
//    NSString *temp = [NSString stringWithFormat:@"%@\n%@",self.requestUrl,self.parm.description];
//    DDLogInfo(@"%@",self.description);
    if ([SingleDataManager instance].userInfoModel != nil)
    {
        [self.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.customerid forKey:@"login_userId"];
        [self.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.password forKey:@"login_password"];
        [self.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.loginname forKey:@"login_name"];
    }
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
    
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:Client_Id,@"clientId",@"application/json",@"Content-Type",@"2",@"appFlag", nil];
//    NSLog(@"head==%@",dic);
    return _requestHeaderDic;
//    return nil;
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
//    NSString * temp = [NSString stringWithFormat:@"%@%@",URL_main,self.requestUrl];
//    NSString *temp2 = [self.requestArgument jsonStringEncoded];
//    DDLogInfo(@"request ===%@\n%@",temp,temp2);
    //只在升级的时候用一下
    if (_isPostBodyToJson > 0)
    {
        [NomalUtil removeNullValue:self.requestArgument];
        //requestUrl = requestEndUrl 一样的
        //self.requestBaseUrl = self.baseUrl 一样的
//        NSString *connectUrl = [NSString stringWithFormat:@"%@%@",URL_main,self.requestUrl];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:connectUrl]];
//
//        [[NVLogManager shareInstance] writeLogString:[NSString stringWithFormat:@"connectUrl====%@",connectUrl]];
        NSString *connectUrl = nil;
        if (self.requestBaseUrl != nil && self.requestBaseUrl.length > 0)
        {
            connectUrl = [NSString connectUrl:self.requestArgument url:[NSString stringWithFormat:@"%@%@",self.requestBaseUrl,self.requestUrl]];
//            [[NVLogManager shareInstance] writeLogString:[NSString stringWithFormat:@"connectUrl requestBaseUrl====%@",connectUrl]];
            NVLogInfo(@"%@",[NSString stringWithFormat:@"connectUrl requestBaseUrl====%@",connectUrl]);
            connectUrl = [NSString connectUrl:nil url:[NSString stringWithFormat:@"%@%@",self.requestBaseUrl,self.requestUrl]];
        }
        else
        {
            connectUrl = [NSString connectUrl:self.requestArgument url:[NSString stringWithFormat:@"%@%@",self.baseUrl,self.requestUrl]];
//            [[NVLogManager shareInstance] writeLogString:[NSString stringWithFormat:@"connectUrl baseUrl====%@",connectUrl]];
            NVLogInfo(@"%@",[NSString stringWithFormat:@"connectUrl baseUrl====%@",connectUrl]);
            connectUrl = [NSString connectUrl:nil url:[NSString stringWithFormat:@"%@%@",self.baseUrl,self.requestUrl]];
        }
        
//        connectUrl = [connectUrl stringByURLEncode]
         connectUrl = [connectUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:connectUrl]];
       
//        [request setAllHTTPHeaderFields:[self requestHeaderFieldValueDictionary]];
        
        
        NSError *errorJSON = nil;
      
        NSData *dataJSON = nil;
        NSData *dataJSONSign = nil;
       self.requestHeaderDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:Client_Id,@"clientId",@"2",@"appFlag", nil];
        //||_isPostBodyToJson == 2
        if (_isPostBodyToJson == 1)
        {
            dataJSON = [NSJSONSerialization dataWithJSONObject:self.requestArgument options:NSJSONWritingPrettyPrinted error:&errorJSON];
            [_requestHeaderDic setObjectFilterNull:@"application/json" forKey:@"Content-Type"];
        }
        else
        {
             NSString* query = AFQueryStringFromParameters(self.requestArgument);
            //%20是比较老一点的写法，现在的做法是：url中的“？”前的空格要转义成“%20”，“？”之后的空格要转义成“+”！
//            query = [query stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
//            NSString* queryFlag = [NSString connectUrl:self.requestArgument url:@""];
            dataJSON = [query dataUsingEncoding:NSUTF8StringEncoding];
            dataJSONSign = [NomalUtil bodyDataSortByKey:self.requestArgument];
            if (dataJSONSign != nil)
            {
                [_requestHeaderDic setObjectFilterNull:[[NSString alloc] initWithData:dataJSONSign encoding:NSUTF8StringEncoding] forKey:@"sign1"];
            }
            [_requestHeaderDic setObjectFilterNull:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
        }
//        NSString *paramsString = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];//[paraDict JSONString];
//        NSLog(@"字典转字符串 = %@",paramsString);

        [request setHTTPMethod:@"POST"];
        
//        [request setValue:@"text/encode" forHTTPHeaderField:@"Content-Type"];
        //token\timestamp\sign
        NSString *timestamp = [NomalUtil getCurrentTimeWithLongLongNum];
        
        //headerDic +timestamp
        [_requestHeaderDic setObjectFilterNull:timestamp forKey:@"timestamp"];
        //headerDic +token
        NSString *token = [SingleDataManager instance].token;
        [_requestHeaderDic setObjectFilterNull:token forKey:@"token"];
        //token\timestamp\sign
        NSMutableData *dataContent = [NSMutableData dataWithCapacity:3];
        //token
        if ([NomalUtil isValueableString:token])
        {
            
            [dataContent appendData:[token dataUsingEncoding:NSUTF8StringEncoding]];
        }
        //timestamp
        if ([NomalUtil isValueableString:timestamp])
        {
            
            [dataContent appendData:[timestamp dataUsingEncoding:NSUTF8StringEncoding]];
        }
        //body
        
        if (dataJSONSign != nil)
        {
            [dataContent appendData:dataJSONSign];
        }
        //加盐
        [dataContent appendData:[@"e10adc3949ba59abbe56e057f20f888e" dataUsingEncoding:NSUTF8StringEncoding]];
        //sign = (token+timestamp+body+盐)md5
        NSString *signMd5 = [[dataContent md5String] uppercaseString];
        
        //headerDic +sign
        [_requestHeaderDic setObjectFilterNull:signMd5 forKey:@"sign"];
        //注册和登录接口做一个加参数
        if ([@"interfaceController/getLoginInfo" isEqualToString:self.requestUrl] || [@"interfaceController/registeBike" isEqualToString:self.requestUrl])
        {
            
            [_requestHeaderDic setObjectFilterNull:[self.requestArgument objectForKey:@"loginname"] forKey:@"userName"];
            [_requestHeaderDic setObjectFilterNull:[self.requestArgument objectForKey:@"password"] forKey:@"password"];
            
            [_requestHeaderDic setObjectFilterNull:[NomalUtil getUUID] forKey:@"phoneID"];
        }
        //加头文件 这个有效的 requestHeaderFieldValueDictionary这个有调用但无效
        [request setAllHTTPHeaderFields:_requestHeaderDic];
        //加body
        [request setHTTPBody:dataJSON];
        return request;
    }
    if (!_isOpenAES) {
        //requestUrl = requestEndUrl 一样的
        //self.requestBaseUrl = self.baseUrl 一样的
        if (self.requestBaseUrl != nil && self.requestBaseUrl.length > 0)
        {
            NSString *connectUrl = [NSString connectUrl:self.requestArgument url:[NSString stringWithFormat:@"%@%@",self.requestBaseUrl,self.requestUrl]];
            NVLogInfo(@"%@",[NSString stringWithFormat:@"connectUrl requestBaseUrl====%@",connectUrl]);
        }
        else
        {
            NSString *connectUrl = [NSString connectUrl:self.requestArgument url:[NSString stringWithFormat:@"%@%@",self.baseUrl,self.requestUrl]];
            NVLogInfo(@"%@",[NSString stringWithFormat:@"connectUrl baseUrl====%@",connectUrl]);
        }
       
        return nil;
    }
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_main,self.requestUrl]]];
    
    //加密header部分
    NSString *headerContentStr = [[HeaderModel new] modelToJSONString];
    NSString *headerAESStr = aesEncrypt(headerContentStr);
    [request setValue:headerAESStr forHTTPHeaderField:@"header-encrypt-code"];
    
    NSString *contentStr = [self.requestArgument jsonStringEncoded];
    //AES 128
    NSString *AESStr = aesEncrypt(contentStr);
    //AES 256
//    NSString *AESStr = [NSData AES256EncryptWithPlainText:contentStr];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"text/encode" forHTTPHeaderField:@"Content-Type"];
    
    
    NSData *bodyData = [AESStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:bodyData];
    
    return request;
    
}
@end
