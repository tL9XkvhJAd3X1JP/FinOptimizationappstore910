//
//  FileUploadAction.m
//  BaseProject
//
//  Created by janker on 2018/11/14.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "FileUploadAction.h"

@implementation FileUploadAction
-(void)request_errorReport
{
    self.requestBaseUrl = @"http://cloud.wiselink.net.cn:8805";
    self.requestEndUrl = @"/ErrorReport.ashx";
    
    [self startWithoutCache];
}
@end
