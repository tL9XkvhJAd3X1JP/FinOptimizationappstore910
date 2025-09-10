//
//  NetWorkCenter.m
//  BaseProject
//
//  Created by janker on 2018/10/31.
//  Copyright © 2018 ChenXing. All rights reserved.
//
//https://github.com/zxy1829760/YTKNetwork-
#import "NetWorkCenter.h"
@implementation NetWorkCenter
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        <#statements#>
//    }
//    return self;
//}
+ (NetWorkCenter *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance configHttpRequest];
    });
    return sharedInstance;
}
+ (AFHTTPSessionManager *)HTTPSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:Client_Id forHTTPHeaderField:@"clientId"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.timeoutInterval = 60.0;
    NSLog(@"Header = %@", manager.requestSerializer.HTTPRequestHeaders);
    return manager;
}
//- (AFHTTPSessionManager *)HTTPSessionManager
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/xml", nil];
//    //application/x-www-form-urlencoded multipart/form-data application/json text/xml
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
////    manager.requestSerializer.timeoutInterval = 60.0;
//    NSLog(@"Header = %@", manager.requestSerializer.HTTPRequestHeaders);
//    return manager;
//}
// YTKNetWork 的配置
-(void)configHttpRequest
{
    //requestSerializerForRequest
    //handleRequestResult
    //valueForHTTPHeaderField
    //setSecurityPolicy
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    
    config.baseUrl = URL_main;
    //    config.baseUrl = @"https://remotectrl.wiselink.net.cn";
    //    config.cdnUrl = @"http://fen.bi";
    if (ProductSever)
    {
        config.debugLogEnabled = NO;
    }
    else
    {
        config.debugLogEnabled = NO;
    }
    
    
    //对https做一些验证
    // 获取证书pingtai_tiantian zxt zxky.wiselink.net.cn.cer
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:URL_https_cer_name ofType:@"cer"];
    //证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // 配置安全模式
    //YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    //    config.baseUrl = k_BASE_URL;
    // config.cdnUrl = @"http://fen.bi";
    // 验证公钥和证书的其他信息，里面做了证书的域名较验
//    AFSecurityPolicy *securityPolicy = [MyAFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    // 允许自建证书
    securityPolicy.allowInvalidCertificates = YES;
    // 校验域名信息
    securityPolicy.validatesDomainName = YES;
    // 添加服务器证书,单向验证; 可采用双证书 双向验证;
    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    [config setSecurityPolicy:securityPolicy];
    
    
    
}

//+ (void)httpsCheck:(NSString *)name
//{
//    AFHTTPSessionManager *manager = [self HTTPSessionManager];
//
//    //需要https的
//    NSMutableArray * arr_https = [NSMutableArray arrayWithObjects:@"/ControlPwdPassword.ashx", nil];
//
//    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
//    //config.baseUrl = @"http://k8.wiselink.net.cn";
//    if ([arr_https containsObject:name])
//    {
//        name = [NSString stringWithFormat:@"%@%@",config.baseUrl,name];
//
//        NSString * urlHostStr = [NSURL URLWithString:name].host;
//        //如果是https，先判断域名：wiselink.net.cn
//        if (!([urlHostStr containsString:@"wiselink.net.cn"] && [urlHostStr containsString:@"wiselink.net.cn"]))
//        {
//            return;
//        }
//
//
//        //https
//        NSData *PKCS12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zxt" ofType:@"cer"]];//证书文件名和文件类型
//        NSSet *cerSet = [NSSet setWithObject:PKCS12Data];
//        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey withPinnedCertificates:cerSet];
//        policy.allowInvalidCertificates = YES;
//        [manager.securityPolicy setValidatesDomainName:YES];
//        manager.securityPolicy = policy;
//        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
//        //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [self checkCredential:manager];
//    }
//
//}

//校验证书
//+(void)checkCredential:(AFURLSessionManager *)manager
//{
//    [manager setSessionDidBecomeInvalidBlock:^(NSURLSession * _Nonnull session, NSError * _Nonnull error) {
//    }];
//    __weak typeof(manager)weakManager = manager;
//    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
//        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//        __autoreleasing NSURLCredential *credential =nil;
//        NSLog(@"authenticationMethod=%@",challenge.protectionSpace.authenticationMethod);
//        //判断服务器要求客户端的接收认证挑战方式，如果是NSURLAuthenticationMethodServerTrust则表示去检验服务端证书是否合法，NSURLAuthenticationMethodClientCertificate则表示需要将客户端证书发送到服务端进行检验
//
//        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//            // 基于客户端的安全策略来决定是否信任该服务器，不信任的话，也就没必要响应挑战
//            if([weakManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
//                // 创建挑战证书（注：挑战方式为UseCredential和PerformDefaultHandling都需要新建挑战证书）
//                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//                // 确定挑战的方式
//                if (credential) {
//                    //证书挑战  设计policy,none，则跑到这里
//                    disposition = NSURLSessionAuthChallengeUseCredential;
//                } else {
//                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//                }
//            } else {
//                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
//            }
//        } else {
//
//            /*
//             //只有双向认证才会走这里
//             // client authentication
//             SecIdentityRef identity = NULL;
//             SecTrustRef trust = NULL;
//             //            NSString *p12 = [[NSBundle mainBundle] pathForResource:@"client"ofType:@"p12"];
//             NSString *p12 = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"pfx"];
//             NSFileManager *fileManager =[NSFileManager defaultManager];
//
//             if(![fileManager fileExistsAtPath:p12])
//             {
//             NSLog(@"client.p12:not exist");
//             }
//             else
//             {
//             NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
//             if ([self extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data])
//             {
//             SecCertificateRef certificate = NULL;
//             SecIdentityCopyCertificate(identity, &certificate);
//             const void*certs[] = {certificate};
//             CFArrayRef certArray =CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
//             credential =[NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
//             disposition =NSURLSessionAuthChallengeUseCredential;
//             }
//             }*/
//        }
//        *_credential = credential;
//        return disposition;
//    }];
//}



/**
 https证书验证
 */
//+(AFSecurityPolicy*)customSecurityPolicy
//{
//    // /先导入证书
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"zxt" ofType:@"cer"];//证书的路径
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//    // AFSSLPinningModeCertificate 使用证书验证模式 (AFSSLPinningModeCertificate是证书所有字段都一样才通过认证，AFSSLPinningModePublicKey只认证公钥那一段，AFSSLPinningModeCertificate更安全。但是单向认证不能防止“中间人攻击”)
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
//    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    // 如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//    //validatesDomainName 是否需要验证域名，默认为YES；
//    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//    securityPolicy.validatesDomainName = YES;
//    securityPolicy.pinnedCertificates = (NSSet *)@[certData];
////    [[AFHTTPSessionManager manager] setSecurityPolicy:[JYAFNetworkingManager customSecurityPolicy]];
//    [[AFHTTPSessionManager manager] setSecurityPolicy:securityPolicy];
//    return securityPolicy;
//}

//上传Method
#pragma mark-图片文件传
+ (void)uploadFileFromData:(id)parameters
                methodName:(NSString *)name
                 apiString:(NSString *)apiString
                  progress:(ProgressBlock)progress
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    //    NSString *apiString = [NSString stringWithFormat:@"%@%@",APIBaseURLString,name];
//    NSString *apiString = [NSString stringWithFormat:@"%@",[BusinessIPModel businessIPModel].fileInterfaceAddress];
    
    NSLog(@"URL = %@",apiString);
    AFHTTPSessionManager *manager = [self HTTPSessionManager];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [EVUtil writeErrorDataToFile:apiString WithFileName:key_fileName];
    [manager POST:apiString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *fileName = [NSString stringWithFormat:@"%ld.png",[[NSDate date] second]];
        NSData *fileData = parameters[@"Filedata"];
        [formData appendPartWithFileData:fileData name:@"Filedata" fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
        NSLog(@"%@",uploadProgress.description);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [EVUtil writeErrorDataToFile:[NSString stringWithFormat:@"返回结果%@ ---> url:%@",responseObject,task.currentRequest.URL] WithFileName:key_fileName];
        
        NSLog(@"========= message : %@ =========== \n%@",responseObject[@"message"],responseObject);
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [EVUtil writeErrorDataToFile:[NSString stringWithFormat:@"返回结果%@ ---> url:%@",error,task.currentRequest.URL] WithFileName:key_fileName];
        if (failure) {
            failure(error);
        }
    }];
}

//上传error
+ (void)uploadErrorFileFromData:(id)parameters
                     methodName:(NSString *)name
                       progress:(ProgressBlock)progress
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    //    NSString *apiString = [NSString stringWithFormat:@"%@%@",APIBaseURLString,name];
//    NSString *apiString = [NSString stringWithFormat:@"%@",@"http://221.123.179.91:8805/ErrorReport.ashx"];
    NSString *apiString = [NSString stringWithFormat:@"%@",@"http://cloud.wiselink.net.cn:8805/ErrorReport.ashx"];
//{UploadLog} 文件内容必须以这个开头
    
    NSLog(@"URL = %@",apiString);
    NSLog(@"parameters = %@",parameters);
//    AFHTTPSessionManager *manager = [self HTTPSessionManager];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [EVUtil writeErrorDataToFile:apiString WithFileName:key_fileName];
    [manager POST:apiString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString * pathError = parameters[@"error"];
//        NSFileManager * fm = [NSFileManager defaultManager];
//        NSData * errorData = [fm contentsAtPath:pathError];
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:pathError] name:@"error" error:nil];
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:pathError] name:@"error" fileName:@"error2" mimeType:@"application/octet-stream" error:nil];
//        [formData appendPartWithFileData:errorData name:@"error" fileName:@"error2" mimeType:@"text/plain"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%@",uploadProgress.description);
        progress(uploadProgress);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        [EVUtil writeErrorDataToFile:[NSString stringWithFormat:@"返回结果%@ ---> url:%@",responseObject,task.currentRequest.URL] WithFileName:key_fileName];
        if (success) {
            success(string);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [EVUtil writeErrorDataToFile:[NSString stringWithFormat:@"返回结果%@ ---> url:%@",error,task.currentRequest.URL] WithFileName:key_fileName];
        if (failure) {
            failure(error);
        }
    }];
}
@end
