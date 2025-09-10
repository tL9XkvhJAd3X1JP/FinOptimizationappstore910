//
//  MyViewUtil.m
//  BaseProject
//
//  Created by janker on 2018/11/16.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "MyViewUtil.h"

@implementation MyViewUtil
//把常用的组件封装一下
+(void)renderButtonWith:(UIButton *)button block:(void(^)(UIButton*))block
{
    [button renderButtonWithBlock:block font:SYSTEMFONT(15) fontColor:UIColorHex(@"FFF000") buttonName:@"保存" bgColor:UIColorHex(@"FFF000") cornerRadius:0 borderColor:nil borderWidth:0];
}
@end
