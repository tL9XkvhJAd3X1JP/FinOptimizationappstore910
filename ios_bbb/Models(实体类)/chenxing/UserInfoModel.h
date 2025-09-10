//
//  UserInfoModel.h
//  BaseProject
//
//  Created by janker on 2019/2/14.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject
@property (strong,nonatomic) NSString * keyId;//主键id
@property (strong,nonatomic) NSString * customername;//姓名
@property (strong,nonatomic) NSString * sex;//性别 男:1,女:2
@property (strong,nonatomic) NSString * mobilephone;//手机号码
@property (strong,nonatomic) NSString * loginname;//登录用户名
@property (strong,nonatomic) NSString * password;//登录密码
@property (strong,nonatomic) NSString * idnumber;//身份证号码
@property (strong,nonatomic) NSString * linkmanname;//紧急联系人姓名
@property (strong,nonatomic) NSString * linkmansex;//联系人性别 男:1,女:2
@property (strong,nonatomic) NSString * linkmanphone;//紧急联系人电话
@property (strong,nonatomic) NSString * linkmanidnumber;//紧急联系人身份证号码
@property (strong,nonatomic) NSString * frontidcard;//使用人身份证正面照片
@property (strong,nonatomic) NSString * reverseidcard;//使用人身份证反面照片
@property (strong,nonatomic) NSString * frontphoto;//正面免冠照片
@property (strong,nonatomic) NSString * againsttheft;//防盗账号
@property (strong,nonatomic) NSString * volunteer;//志愿者
@property (strong,nonatomic) NSString * state;//1:审核中,2:通过审核 3未通过审核
@property (strong,nonatomic) NSString * createddate;//创建时间
@property (strong,nonatomic) NSString * createdby;//创建人
@property (strong,nonatomic) NSString * modifydate;//修改时间
@property (strong,nonatomic) NSString * modifyby;//修改人
@property (strong,nonatomic) NSString * brand;//电动车品牌
@property (strong,nonatomic) NSString * generatornumber;//电动车车机号
@property (strong,nonatomic) NSString * vin;//车架号
@property (strong,nonatomic) NSString * bikephoto;//电动车上牌后照片
@property (strong,nonatomic) NSString * userprove;//电动车使用证明
@property (strong,nonatomic) NSString * sn;//SN
@property (strong,nonatomic) NSString * idc;//idc
@property (strong,nonatomic) NSString * imei;//防盗定位终端设备IMEI码
@property (strong,nonatomic) NSString * customerid;//会员表主键
@property (strong,nonatomic) NSString * paltenumber;//车牌号
@property (strong,nonatomic) NSString * color;//电动车颜色
@property (strong,nonatomic) NSString * buytime;//购买时间
@property (strong,nonatomic) NSString * accidentinsurance;//驾驶人意外保险,1:50/年,2:100/年,3:200/年
@property (strong,nonatomic) NSString * companyid;//公司Id(派出所)
@property (strong,nonatomic) NSString * groupid;//小组Id(村委会)
@property (strong,nonatomic) NSString * companyName;//公司名称(派出所)

@property (strong,nonatomic) NSString * groupName;//小组名称(村委会)

@property (strong,nonatomic) NSString *productId;  //设备id

@property (strong,nonatomic) NSString *bindingDate;//轨迹查询的时候用
@end

NS_ASSUME_NONNULL_END
