/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RCTHTTPRequestHandler.h"

#import <mutex>

#import "RCTNetworking.h"
#ifndef __Require_noErr_Quiet
#define __Require_noErr_Quiet(errorCode, exceptionLabel)                      \
do                                                                          \
{                                                                           \
if ( __builtin_expect(0 != (errorCode), 0) )                            \
{                                                                       \
goto exceptionLabel;                                                \
}                                                                       \
} while ( 0 )
#endif
@interface RCTHTTPRequestHandler () <NSURLSessionDataDelegate>

@end

@implementation RCTHTTPRequestHandler
{
    NSMapTable *_delegates;
    NSURLSession *_session;
    std::mutex _mutex;
}

@synthesize bridge = _bridge;
@synthesize methodQueue = _methodQueue;

RCT_EXPORT_MODULE()

- (void)invalidate
{
    dispatch_async(self->_methodQueue, ^{
        [self->_session invalidateAndCancel];
        self->_session = nil;
    });
}

- (BOOL)isValid
{
    // if session == nil and delegates != nil, we've been invalidated
    return _session || !_delegates;
}

#pragma mark - NSURLRequestHandler

- (BOOL)canHandleRequest:(NSURLRequest *)request
{
    static NSSet<NSString *> *schemes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // technically, RCTHTTPRequestHandler can handle file:// as well,
        // but it's less efficient than using RCTFileRequestHandler
        schemes = [[NSSet alloc] initWithObjects:@"http", @"https", nil];
    });
    return [schemes containsObject:request.URL.scheme.lowercaseString];
}

- (NSURLSessionDataTask *)sendRequest:(NSURLRequest *)request
                         withDelegate:(id<RCTURLRequestDelegate>)delegate
{
    // Lazy setup
    if (!_session && [self isValid]) {
        NSOperationQueue *callbackQueue = [NSOperationQueue new];
        callbackQueue.maxConcurrentOperationCount = 1;
        callbackQueue.underlyingQueue = [[_bridge networking] methodQueue];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configuration setHTTPShouldSetCookies:YES];
        [configuration setHTTPCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        [configuration setHTTPCookieStorage:[NSHTTPCookieStorage sharedHTTPCookieStorage]];
        _session = [NSURLSession sessionWithConfiguration:configuration
                                                 delegate:self
                                            delegateQueue:callbackQueue];
        
        std::lock_guard<std::mutex> lock(_mutex);
        _delegates = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory
                                               valueOptions:NSPointerFunctionsStrongMemory
                                                   capacity:0];
    }
    __block NSURLSessionDataTask *task = nil;
    dispatch_sync(self->_methodQueue, ^{
        task = [self->_session dataTaskWithRequest:request];
    });
    {
        std::lock_guard<std::mutex> lock(_mutex);
        [_delegates setObject:delegate forKey:task];
    }
    [task resume];
    return task;
}

- (void)cancelRequest:(NSURLSessionDataTask *)task
{
    {
        std::lock_guard<std::mutex> lock(_mutex);
        [_delegates removeObjectForKey:task];
    }
    [task cancel];
}

#pragma mark - NSURLSession delegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    id<RCTURLRequestDelegate> delegate;
    {
        std::lock_guard<std::mutex> lock(_mutex);
        delegate = [_delegates objectForKey:task];
    }
    [delegate URLRequest:task didSendDataWithProgress:totalBytesSent];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    // Reset the cookies on redirect.
    // This is necessary because we're not letting iOS handle cookies by itself
    NSMutableURLRequest *nextRequest = [request mutableCopy];
    
    NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
    nextRequest.allHTTPHeaderFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    completionHandler(nextRequest);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)task
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    id<RCTURLRequestDelegate> delegate;
    {
        std::lock_guard<std::mutex> lock(_mutex);
        delegate = [_delegates objectForKey:task];
    }
    [delegate URLRequest:task didReceiveResponse:response];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)task
    didReceiveData:(NSData *)data
{
    id<RCTURLRequestDelegate> delegate;
    {
        std::lock_guard<std::mutex> lock(_mutex);
        delegate = [_delegates objectForKey:task];
    }
    [delegate URLRequest:task didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    id<RCTURLRequestDelegate> delegate;
    {
        std::lock_guard<std::mutex> lock(_mutex);
        delegate = [_delegates objectForKey:task];
        [_delegates removeObjectForKey:task];
    }
    [delegate URLRequest:task didCompleteWithError:error];
}

//RN集成自签名https及双向认证-ios
//https://www.jianshu.com/p/23fe8630a755
#pragma mark parsing HTTP response headers
static NSArray * AFPublicKeyTrustChainForServerTrust(SecTrustRef serverTrust) {
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    CFIndex certificateCount = SecTrustGetCertificateCount(serverTrust);
    NSMutableArray *trustChain = [NSMutableArray arrayWithCapacity:(NSUInteger)certificateCount];
    for (CFIndex i = 0; i < certificateCount; i++) {
        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, i);
        
        SecCertificateRef someCertificates[] = {certificate};
        CFArrayRef certificates = CFArrayCreate(NULL, (const void **)someCertificates, 1, NULL);
        
        SecTrustRef trust;
        __Require_noErr_Quiet(SecTrustCreateWithCertificates(certificates, policy, &trust), _out);
        
        SecTrustResultType result;
        __Require_noErr_Quiet(SecTrustEvaluate(trust, &result), _out);
        
        [trustChain addObject:(__bridge_transfer id)SecTrustCopyPublicKey(trust)];
        
    _out:
        if (trust) {
            CFRelease(trust);
        }
        
        if (certificates) {
            CFRelease(certificates);
        }
        
        continue;
    }
    CFRelease(policy);
    
    return [NSArray arrayWithArray:trustChain];
}
- (SecKeyRef)p_getPublicKeyRefrenceFromData:(NSData *)data
{
    SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)data);
    SecPolicyRef myPoliscy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate, myPoliscy, &myTrust);
    SecTrustResultType trustResult;
    if (status==noErr) {
        //status =
        SecTrustEvaluate(myTrust, &trustResult);
    }
    SecKeyRef securityKey = SecTrustCopyPublicKey(myTrust);
    
    CFRelease(myCertificate);
    CFRelease(myPoliscy);
    CFRelease(myTrust);
    
    return securityKey;
}

BOOL AFSecKeyIsEqualToKey(SecKeyRef key1, SecKeyRef key2) {
#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
    return [(__bridge id)key1 isEqual:(__bridge id)key2];
#else
    return [AFSecKeyGetData(key1) isEqual:AFSecKeyGetData(key2)];
#endif
}
- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    //挑战处理类型为 默认
    /*
     NSURLSessionAuthChallengePerformDefaultHandling：默认方式处理
     NSURLSessionAuthChallengeUseCredential：使用指定的证书
     NSURLSessionAuthChallengeCancelAuthenticationChallenge：取消挑战
     */
    __weak typeof(self) weakSelf = self;
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengeUseCredential;
    __block NSURLCredential *credential = nil;
    
    
    
    //  [self debugCredential:challenge.proposedCredential];
    
    //    credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    //  [self debugCredential:credential];
    // sessionDidReceiveAuthenticationChallenge是自定义方法，用来如何应对服务器端的认证挑战
    //host
    //    NSLog(@"%@", [NSString stringWithFormat:@"_+_+_+_+_+_+_+_+_+_+_+_+_+_+=%@",challenge.protectionSpace.host]);
    // 而这个证书就需要使用credentialForTrust:来创建一个NSURLCredential对象
    //NSURLAuthenticationMethodServerTrust NSURLAuthenticationMethodClientCertificate
    //  其中https中对于服务端的证书的认证质询（认证服务端身份），不论是CA证书还是自建证书，验证类型都是 NSURLAuthenticationMethodServerTrust。
    //  当服务端要验证客户端证书发起的认证质询的类型是NSURLAuthenticationMethodClientCertificate
    
    
    //  if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    //  {
    //    // 创建挑战证书（注：挑战方式为UseCredential和PerformDefaultHandling都需要新建挑战证书）
    //    credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    //    // 确定挑战的方式
    //    if (credential) {
    //      //证书挑战  设计policy,none，则跑到这里
    //      disposition = NSURLSessionAuthChallengeUseCredential;
    //    } else {
    //      disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    //    }
    //  }
    //  else
    //  {
    // client authentication
    //只要是https就去挑战证书
    //service.zhixinkeyuan.com zxky.wiselink.net.cn
    //challenge.protectionSpace.host
    //服务端用错了证书
    NSMutableData * cerData = [NSMutableData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"service.zhixinkeyuan.com" ofType:@"cer"]];
    
    SecKeyRef mypublicKey = [weakSelf p_getPublicKeyRefrenceFromData:cerData];
    
    //这里直接把证书包装对象拿到，
    SecTrustRef serverTrust = [challenge.protectionSpace serverTrust];
    //  NSLog(@"+++++++++++++DEBUG Credential: [%@]",serverTrust);
    NSArray *array = AFPublicKeyTrustChainForServerTrust(serverTrust);
    BOOL flag = NO;
    for (id skr in array)
    {
        //    NSLog(@"+++++++++++++DEBUG array: [%@]",skr);
        flag = AFSecKeyIsEqualToKey(mypublicKey, (__bridge SecKeyRef)skr);
        if (flag)
        {
            break;
        }
    }
    CFRelease(mypublicKey);
    //验证不通过
    if (!flag)
    {
        if (completionHandler) {
            completionHandler(disposition, credential);
        }
        return;
    }
    
    //server  zxky.wiselink.net.cn
    // sessionDidReceiveAuthenticationChallenge是自定义方法，用来如何应对服务器端的认证挑战
    
    // 而这个证书就需要使用credentialForTrust:来创建一个NSURLCredential对象
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        // 创建挑战证书（注：挑战方式为UseCredential和PerformDefaultHandling都需要新建挑战证书）
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        // 确定挑战的方式
        if (credential) {
            //证书挑战  设计policy,none，则跑到这里
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        // client authentication
        SecIdentityRef identity = NULL;
        SecTrustRef trust = NULL;
        NSString *p12 = [[NSBundle mainBundle] pathForResource:@"zxky.wiselink.net.cn" ofType:@"p12"];
        NSFileManager *fileManager =[NSFileManager defaultManager];
        
        if(![fileManager fileExistsAtPath:p12])
        {
            NSLog(@"zxky.wiselink.net.cn.p12:not exist");
        }
        else
        {
            NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
            
            if ([[weakSelf class]extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data])
            {
                SecCertificateRef certificate = NULL;
                SecIdentityCopyCertificate(identity, &certificate);
                const void*certs[] = {certificate};
                CFArrayRef certArray =CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                credential =[NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                disposition =NSURLSessionAuthChallengeUseCredential;
                CFRelease(certArray);
            }
        }
        
    }
    
    //完成挑战
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
    
    
}
//- (void)debugCredential:(NSURLCredential*) credential
//{
//
//  NSLog(@"+++++++++++++DEBUG Credential: [%@]",credential);
//  NSLog(@"+++++++++++++credential identity: %@", credential.identity);
//  NSLog(@"+++++++++++credential cert: %@", credential.certificates);
//  NSLog(@"++++++++++credential persistence: %lu", (unsigned long)credential.persistence);
//
//}
+(BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;
    //client certificate password wiselink hs1Mshd1
    NSDictionary*optionsDictionary = [NSDictionary dictionaryWithObject:@"wiselink"
                                                                 forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    
    if(securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = (CFDictionaryRef)CFArrayGetValueAtIndex(items,0);
        const void*tempIdentity =NULL;
        tempIdentity= CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void*tempTrust =NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failedwith error code %d",(int)securityError);
        return NO;
    }
    return YES;
}

@end
