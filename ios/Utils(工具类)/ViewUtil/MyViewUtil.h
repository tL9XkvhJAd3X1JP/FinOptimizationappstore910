//
//  MyViewUtil.h
//  BaseProject
//
//  Created by janker on 2018/11/16.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyViewUtil : NSObject
//把常用的组件封装一下
+(void)renderButtonWith:(UIButton *)button block:(void(^)(UIButton*))block;
@end

NS_ASSUME_NONNULL_END
