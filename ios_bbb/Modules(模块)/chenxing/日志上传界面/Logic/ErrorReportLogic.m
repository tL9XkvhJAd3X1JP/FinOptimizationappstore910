//
//  ErrorReportLogic.m
//  BaseProject
//
//  Created by janker on 2018/11/19.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "ErrorReportLogic.h"
#import "FileUploadAction.h"
@implementation ErrorReportLogic
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        //做一些初始化的工作
        DDLogInfo(@"ErrorReportLogic");
    }
    return self;
}

-(void)requestErrorReport
{
    FileUploadAction *request2 = [[FileUploadAction alloc] init];
    request2.filePath = [NVLogManager shareInstance].getCurrentLogFilePath;
    request2.fileToServerName = @"error";
    request2.delegate = self;
    [request2 addAccessory:self];
    NSString * content_IOS = [NomalUtil gb2312StringToString:[NSString stringWithFormat:@"Base_IOS"]];
    [request2.parm setObjectFilterNull:content_IOS forKey:@"idc"];
    [request2.parm setObjectFilterNull:@"000" forKey:@"type"];
//    [request2 setUploadProgressBlock_file:^(UploadFileRequest * _Nonnull request, NSProgress * _Nonnull progress) {
//        
//    }];
//    [request2 setDownloadProgressBlock_file:^(UploadFileRequest * _Nonnull request, NSProgress * _Nonnull progress) {
//        
//    }];
    [request2 request_errorReport];
}
-(void)requestFinished:(__kindof YTKBaseRequest *)request
{
    //做数据相关的处理

    DLog(@"===========%@",request.responseString);
//    if ([request.requestUrl containsString:@"ControlPwdPassword.ashx"])
//    {
//        //request.responseString
//        Response *res = [Response modelWithJSON:request.responseData];
//
//        NSLog(@"requestFinished111=%@",[res modelDescription]);
//    }
    
    //调用界面的部分做界面相关的处理
    if (_delegate != nil && [_delegate respondsToSelector:@selector(requestFinished:)])
    {
        [_delegate requestFinished:request];
    }
}
-(void)requestFailed:(__kindof YTKBaseRequest *)request
{
    //数据失败做处理
    if (_delegate != nil && [_delegate respondsToSelector:@selector(requestFailed:)])
    {
        [_delegate requestFailed:request];
    }
}
-(void)requestWillStart:(id)request
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(requestWillStart:)])
    {
        [_delegate requestWillStart:request];
    }
}
-(void)requestWillStop:(id)request
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(requestWillStop:)])
    {
        [_delegate requestWillStop:request];
    }
}
-(void)requestDidStop:(id)request
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(requestDidStop:)])
    {
        [_delegate requestDidStop:request];
    }
}
@end
