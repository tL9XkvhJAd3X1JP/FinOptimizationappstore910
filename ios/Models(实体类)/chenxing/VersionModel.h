//
//  VersionModel.h
//  BaseProject
//
//  Created by janker on 2019/1/30.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VersionModel : NSObject
@property (strong,nonatomic) NSString *versionCode;//1
@property (strong,nonatomic) NSString *versionName;//1.0.1
@property (strong,nonatomic) NSString *instruction;//智信科源
@property (strong,nonatomic) NSString *clientDownUrl;//升级地址
@property (strong,nonatomic) NSString *createdate;
@property (strong,nonatomic) NSString *clientType;//2
@property (strong,nonatomic) NSString *isForced;//"isForced": 0 是否强制升级
@property (strong,nonatomic) NSString *businessInterfaceAddress;//业务地址
@property (strong,nonatomic) NSString *businessInterfaceAddress_ssl;//https业务地址
@property (strong,nonatomic) NSString *fileInterfaceAddress;//文件上传地址
@property (strong,nonatomic) NSString *minVersionCode;//0
@property (strong,nonatomic) NSString *uploadBluetoothDataUrl;
@property (strong,nonatomic) NSString *innerBusinessInterfaceAddress_ssl;

@end

NS_ASSUME_NONNULL_END
