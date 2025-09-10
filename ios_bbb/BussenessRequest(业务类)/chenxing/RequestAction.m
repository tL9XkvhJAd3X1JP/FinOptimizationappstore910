//
//  RequestAction.m
//  BaseProject
//
//  Created by janker on 2018/10/30.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "RequestAction.h"
#import "NetWorkCenter.h"

@implementation RequestAction
@synthesize class_func;
-(instancetype)init
{
    //isPostBodyToJson
    self = [super init];
    if (self)
    {
        self.isPostBodyToJson = 2;
        
    }
    return self;
}
#pragma mark -gps delegate
-(void)haveGetLatitudeAndLongitude
{
    [self performSelectorOnMainThread:class_func withObject:nil waitUntilDone:[NSThread isMainThread]];
}
-(void)errorGetLatitudeAndLongitude
{
    if (self.delegate != nil)
    {
        [self.delegate requestFailed:self];
    }

//    if ([params objectForKey:@"errorSend"] != nil)
//    {
//        [self performSelector:class_func];
//    }
//    else if (delegate != nil && [delegate respondsToSelector:@selector(errorNetWork:code:msgId:requestType:)])
//    {
//        //msgid -1
//        [delegate errorNetWork:nil code:constValue_getPlaceErrorCode msgId:_msgId requestType:postReqeust];
//    }
    
}
//- (void)requestGaodePlace
//{
//    class_func = @selector(request_update);
//    [GpsManager instance].gpsType = 0;
//    [GpsManager instance].delegate = self;
//    [[GpsManager instance] begin];
//}
////获取ip 后台发请求的时候用
-(void)request_GetIP_success:(YTKRequestCompletionBlock)success
             failure:(YTKRequestCompletionBlock)failure
{
    self.isPostBodyToJson = 1;
    self.requestBaseUrl = URL_main;
    self.requestEndUrl = @"upgrade/version/channelClient";
    [self startWithCompletionBlockWithSuccess:success failure:failure];
}
-(void)request_getLoginInfo_success:(YTKRequestCompletionBlock)success
                            failure:(YTKRequestCompletionBlock)failure
{
    
    self.requestEndUrl = @"interfaceController/getLoginInfo";
    [self startWithCompletionBlockWithSuccess:success failure:failure];
}
-(void)request_update
{
    self.requestEndUrl = @"/Update.ashx";
    [self start];
}
-(void)request_ControlPwdPassword
{
    self.requestBaseUrl = @"https://remotectrl.wiselink.net.cn";
    self.requestEndUrl = @"/ControlPwdPassword.ashx";

    [self start];
}
//派出所 获取登记地址（注册页面）
-(void)request_getRegisterAddress
{
//    self.requestBaseUrl = @"http://192.168.10.190:18080/evrental/interfaceController/";
//    self.requestBaseUrl = [SingleDataManager instance].versionModel.businessInterfaceAddress_ssl;
    self.requestEndUrl = @"interfaceController/getRegisterAddress";
    [self start];
}

//常驻地所属居/村委会（注册页）－ getLiveOftenAddress
-(void)request_getLiveOftenAddress
{
    
    self.requestEndUrl = @"interfaceController/getLiveOftenAddress";
    [self start];
}

//6.3     注册－ RegisteBike
-(void)request_RegisteBike
{
    
    self.requestEndUrl = @"interfaceController/registeBike";
    [self start];
}

//6.4    根据用户名修改密码 －updatePasswordByLoginname
-(void)request_updatePasswordByLoginname
{
    self.requestEndUrl = @"interfaceController/updatePasswordByLoginname";
    [self start];
}

//6.5    根据手机号查询账号列表－getLoginnameByPhoneNum
-(void)request_getLoginnameByPhoneNum
{
    self.requestEndUrl = @"interfaceController/getLoginnameByPhoneNum";
    [self start];
}
- (void)request_getEfenceInfoByProductId_getGPS
{
    class_func = @selector(request_getEfenceInfoByProductId);
    //0 原始gps 2百度
    [GpsManager instance].gpsType = 0;
    [GpsManager instance].delegate = self;
    [[GpsManager instance] begin];
}

//6.3    根据procutId查询设备的信息，如果有则直接返回没有则这个设备还未设置围栏信息 getEfenceInfoByProductId
-(void)request_getEfenceInfoByProductId
{
    
    self.requestEndUrl = @"interfaceController/getEfenceInfoByProductId";
    [self start];
}
//6.6    设置围栏－ SettingFence
-(void)request_SettingFence
{
   
    
    self.requestEndUrl = @"interfaceController/settingFence";
    [self start];
}

//6.7    验证码－ sendValidateCode
-(void)request_sendValidateCode
{

    self.requestEndUrl = @"interfaceController/sendValidateCode";
    [self start];
}

//6.8        登陆－  getLoginInfo
-(void)request_getLoginInfo
{
  
    self.requestEndUrl = @"interfaceController/getLoginInfo";
    [self start];
}

//6.9    获取拆除报警列表信息- getAlarmDismantle
-(void)request_getAlarmDismantle
{
    
    self.requestEndUrl = @"interfaceController/getAlarmDismantle";
    [self start];
}

//6.10    围栏预警信息- getAlarmEfence
-(void)request_getAlarmEfence
{
    
    
    self.requestEndUrl = @"interfaceController/getAlarmEfence";
    [self start];
}

//6.11    最新位置信息- getCurrentGPS
-(void)request_getCurrentGPS
{
    //设备号
    [self.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.idc forKey:@"idc"];
    
    self.requestEndUrl = @"interfaceController/getCurrentGPS";
    [self start];
}

//6.12    最新位置信息- getGPStrack
-(void)request_getGPStrack
{
    
    self.requestEndUrl = @"interfaceController/getGPStrack";
    [self start];
}
//6.2    根据手机号查询账号是否是在此手机号下的账号- checkPhoneAndLoginname
-(void)request_checkPhoneAndLoginname
{

    self.requestEndUrl = @"interfaceController/checkPhoneAndLoginname";
    [self start];
}

//6.15    取拆除及预警未读信息- getAlarmUnreadNum
-(void)request_getAlarmUnreadNum
{
//    //设备号
//    [self.parm setObjectFilterNull:@"" forKey:@"idc"];
//    //拆除预警最大ID
//    [self.parm setObjectFilterNull:@"" forKey:@"dismantleID"];
//    //围栏最大ID
//    [self.parm setObjectFilterNull:@"" forKey:@"efenceID"];
    self.requestEndUrl = @"interfaceController/getAlarmUnreadNum";
    [self start];
}
//6.15    取拆除及预警未读信息- getAlarmUnreadNum
-(void)request_getAlarmUnreadNum_success:(YTKRequestCompletionBlock)success
                     failure:(YTKRequestCompletionBlock)failure
{
    self.requestEndUrl = @"interfaceController/getAlarmUnreadNum";
    [self startWithCompletionBlockWithSuccess:success failure:failure];
}
//6.17    获取地理位置- getWarningGPS
-(void)request_getWarningGPS
{
    
    self.requestEndUrl = @"interfaceController/getWarningGPS";
    [self start];
}
//获取用户信息
-(void)request_getInfoByCustomerId_success:(YTKRequestCompletionBlock)success
                                   failure:(YTKRequestCompletionBlock)failure
{
    
    self.requestEndUrl = @"interfaceController/getInfoByCustomerId";
//    [self start];
    [self.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.customerid forKey:@"customerid"];
    [self startWithCompletionBlockWithSuccess:success failure:failure];
}


//6.1     获取报警记录－getAlarmRecord
-(void)request_getAlarmRecord
{
    [self.parm setObjectFilterNull:@"" forKey:@"companyId"];
    self.requestEndUrl = @"interfaceController/getAlarmRecord";
    [self start];
}
//6.3     报警处理－insertAlarmDeal
-(void)request_insertAlarmDeal
{
//    参数名    解释    类型    备注
//    alarmId    报警表主键id    String    必填
//    state    处理状态 0-未处理 1-排查中 2-已处理 3-忽略    String
//    situation    排查情况    String
//    faultReason    故障原因    String
//    processingMode    处理方式    String
//    processingResult    处理结果    String
//    processingExplain    处理说明    String
//    modifyUserId    最后处理人id    String
    
    [self.parm setObjectFilterNull:@"" forKey:@"alarmId"];
    [self.parm setObjectFilterNull:@"" forKey:@"state"];
    [self.parm setObjectFilterNull:@"" forKey:@"situation"];
    [self.parm setObjectFilterNull:@"" forKey:@"faultReason"];
    [self.parm setObjectFilterNull:@"" forKey:@"processingMode"];
    [self.parm setObjectFilterNull:@"" forKey:@"processingResult"];
    [self.parm setObjectFilterNull:@"" forKey:@"processingExplain"];
    [self.parm setObjectFilterNull:@"" forKey:@"modifyUserId"];
    self.requestEndUrl = @"interfaceController/insertAlarmDeal";
    [self start];
}

//6.6    登陆－loginInfo
-(void)request_loginInfo
{
    [self.parm setObjectFilterNull:@"" forKey:@"username"];
    [self.parm setObjectFilterNull:@"" forKey:@"password"];
    self.requestEndUrl = @"interfaceController/loginInfo";
    [self start];
}

//6.7    车辆档案信息（包含车主、车辆、设备、贷款信息－getVehicleFileInfo
-(void)request_getVehicleFileInfo
{
    //用户id
    [self.parm setObjectFilterNull:@"" forKey:@"cusId"];
    [self.parm setObjectFilterNull:@"" forKey:@"companyId"];
    self.requestEndUrl = @"interfaceController/getVehicleFileInfo";
    [self start];
}
@end
