//
//  MyAFSecurityPolicy.m
//  BaseProject
//
//  Created by janker on 2018/11/1.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "MyAFSecurityPolicy.h"
//合法的都加在这
#define supportHttpsHost [NSArray arrayWithObjects:@"wiselink.net.cn",nil]
@implementation MyAFSecurityPolicy
//做证书的较验
-(BOOL)evaluateServerTrust:(SecTrustRef)serverTrust forDomain:(NSString *)domain
{
    //对发出去的https请求做个域名较验
    if (domain != nil)
    {
        BOOL isHave = NO;
        for (NSString *host in supportHttpsHost)
        {
            if ([domain hasSuffix:host])
            {
                isHave = YES;
            }
        }
        if (!isHave)
        {
            return NO;
        }
        
    }
    BOOL isPass = [super evaluateServerTrust:serverTrust forDomain:domain];
    return isPass;
}
@end
