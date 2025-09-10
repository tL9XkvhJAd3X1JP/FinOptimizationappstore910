//
//  PersonModel.h
//  BaseProject
//
//  Created by janker on 2019/3/28.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonModel : NSObject
@property (strong,nonatomic) NSString* keyId;//
@property (strong,nonatomic) NSString* name;//用户姓名
@property (strong,nonatomic) NSString* sex;//性别 1-男 2-女
@property (strong,nonatomic) NSString* companyName;//工作单位名称
@property (strong,nonatomic) NSString* homeAddress;//家庭地址
@property (strong,nonatomic) NSString* companyAddress;//工作地址
@property (strong,nonatomic) NSString* mobile;//联系电话
@property (strong,nonatomic) NSString* idNumber;//身份证号
@property (strong,nonatomic) NSString* birthday;//生日
@property (strong,nonatomic) NSString* wechat;//微信号
@property (strong,nonatomic) NSString* email;//邮箱地址
@property (strong,nonatomic) NSString* qqNumber;//QQ号码
@property (strong,nonatomic) NSString* createUserId;//创建人id
@property (strong,nonatomic) NSString* createDate;//创建日期
@property (strong,nonatomic) NSString* modifyUserId;//修改人id
@property (strong,nonatomic) NSString* modifyDate;//最后修改时间
@property (strong,nonatomic) NSString* isDelete;//删除状态 0-未删 1-已删
@property (strong,nonatomic) NSString* plateNumber;//车牌号码
@property (strong,nonatomic) NSString* companyId;//所属公司id
@property (strong,nonatomic) NSString* color;//车身颜色
//@property (strong,nonatomic) NSString* modelId;//车辆类型id
//@property (strong,nonatomic) NSString* brand;//车辆品牌
@property (strong,nonatomic) NSString* carType;//车型
@property (strong,nonatomic) NSString* classify;//车辆分类
@property (strong,nonatomic) NSString* level;//车辆归类
@property (strong,nonatomic) NSString* carSerial;//车系
@property (strong,nonatomic) NSString* displacement;//排量
@property (strong,nonatomic) NSString* engine;//发动机号
@property (strong,nonatomic) NSString* vin;//车架号
@property (strong,nonatomic) NSString* productionDate;//出厂日期
@property (strong,nonatomic) NSString* vehiclePrice;//总车价
@property (strong,nonatomic) NSString* carPrice;//车身价
@property (strong,nonatomic) NSString* buyDate;//购买日期
@property (strong,nonatomic) NSString* consultant;//销售顾问
@property (strong,nonatomic) NSString* remark;//备注
@property (strong,nonatomic) NSString* provinceId;//省id
@property (strong,nonatomic) NSString* cityId;//城市id
@property (strong,nonatomic) NSString* needremind;//是否需要预警 1-启用 0-关闭
@property (strong,nonatomic) NSString* riskremind;//是否需要风控 1-启用 0-关闭

//设备信息集合
@property (strong,nonatomic) NSArray* list;

//贷款信息
@property (strong,nonatomic) NSString* cusId;//车主id
@property (strong,nonatomic) NSString* amount;//贷款金额
@property (strong,nonatomic) NSString* period;//贷款期限
@property (strong,nonatomic) NSString* monthSupply;//月供金额
@property (strong,nonatomic) NSString* repaymentDay;//还款日
@property (strong,nonatomic) NSString* repaymentBeginDate;//还款开始日期
@property (strong,nonatomic) NSString* repaymenTendDate;//还款结束日期
@property (strong,nonatomic) NSString* violationTimes;//违约次数
@end

NS_ASSUME_NONNULL_END
