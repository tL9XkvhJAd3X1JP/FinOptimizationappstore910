//
//  RequestAction.h
//  BaseProject
//
//  Created by janker on 2018/10/30.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRequest.h"
#import "GpsManager.h"
//NS_ASSUME_NONNULL_BEGIN

@interface RequestAction : BaseRequest<MyGPSDelegate>
{
    SEL class_func ; //定义一个类方法指针
}
@property SEL class_func;
//@property (strong, nonatomic)NSMutableDictionary *parm;
//
//@property (strong, nonatomic)NSString *requestEndUrl;
//
//@property (strong, nonatomic)NSString *requestBaseUrl;

-(void)request_update;
-(void)request_ControlPwdPassword;
//派出所地址
-(void)request_getRegisterAddress;
//获取ip 后台发请求的时候用
-(void)request_GetIP_success:(YTKRequestCompletionBlock)success
                     failure:(YTKRequestCompletionBlock)failure;
//常驻地所属居/村委会（注册页）－ getLiveOftenAddress
-(void)request_getLiveOftenAddress;
//6.3     注册－ RegisteBike
-(void)request_RegisteBike;
//6.4    根据用户名修改密码 －updatePasswordByLoginname
-(void)request_updatePasswordByLoginname;
//6.5    根据手机号查询账号列表－getLoginnameByPhoneNum
-(void)request_getLoginnameByPhoneNum;
//6.6    设置围栏－ SettingFence
-(void)request_SettingFence;
//6.7    验证码－ sendValidateCode
-(void)request_sendValidateCode;
//6.8        登陆－  getLoginInfo
-(void)request_getLoginInfo;
//6.9    获取拆除报警列表信息- getAlarmDismantle
-(void)request_getAlarmDismantle;
//6.10    围栏预警信息- getAlarmEfence
-(void)request_getAlarmEfence;
//6.11    最新位置信息- getCurrentGPS
-(void)request_getCurrentGPS;
//6.12    最新位置信息- getGPStrack
-(void)request_getGPStrack;
//6.2    根据手机号查询账号是否是在此手机号下的账号- checkPhoneAndLoginname
-(void)request_checkPhoneAndLoginname;
- (void)request_getEfenceInfoByProductId_getGPS;
//6.15    取拆除及预警未读信息- getAlarmUnreadNum
-(void)request_getAlarmUnreadNum;
//6.17    获取地理位置- getWarningGPS
-(void)request_getWarningGPS;
-(void)request_getAlarmUnreadNum_success:(YTKRequestCompletionBlock)success
                                 failure:(YTKRequestCompletionBlock)failure;
-(void)request_getLoginInfo_success:(YTKRequestCompletionBlock)success
                            failure:(YTKRequestCompletionBlock)failure;
//获取用户信息
-(void)request_getInfoByCustomerId_success:(YTKRequestCompletionBlock)success
                                   failure:(YTKRequestCompletionBlock)failure;

//6.1     获取报警记录－getAlarmRecord
-(void)request_getAlarmRecord;
//6.3     报警处理－insertAlarmDeal
-(void)request_insertAlarmDeal;
//6.6    登陆－loginInfo
-(void)request_loginInfo;
//6.7    车辆档案信息（包含车主、车辆、设备、贷款信息－getVehicleFileInfo
-(void)request_getVehicleFileInfo;
@end

//NS_ASSUME_NONNULL_END
