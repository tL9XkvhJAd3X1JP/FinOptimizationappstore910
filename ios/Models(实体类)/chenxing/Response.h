//
//  Response.h
//  BaseProject
//
//  Created by janker on 2018/11/6.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Response : NSObject
//@property (strong,nonatomic) NSString *currTime;
//@property (strong,nonatomic) NSString *result;
//@property (strong,nonatomic) NSString *message;
//@property (strong,nonatomic) NSString *value;
//@property (strong,nonatomic) NSString *ctrlPwdLastTime;
@property (strong,nonatomic) NSString *isSuccess;
@property (strong,nonatomic) NSString *code;
@property (strong,nonatomic) NSString *message;
@property (strong,nonatomic) NSString *validateCode;
@property (strong,nonatomic) NSObject *data;
@property (strong,nonatomic) NSString *token;
@end

NS_ASSUME_NONNULL_END
