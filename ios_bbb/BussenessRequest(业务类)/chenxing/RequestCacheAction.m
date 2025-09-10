//
//  RequestCacheAction.m
//  BaseProject
//
//  Created by janker on 2018/11/8.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "RequestCacheAction.h"

@implementation RequestCacheAction
-(void)request_ControlPwdPassword
{
    self.requestBaseUrl = @"https://remotectrl.wiselink.net.cn";
    self.requestEndUrl = @"/ControlPwdPassword.ashx";
    
    [self start];
}
@end
