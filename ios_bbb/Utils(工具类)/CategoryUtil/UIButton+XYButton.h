//
//  UIButton+XYButton.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/6/1.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^clickButton)(UIButton* pressedButton);
@interface UIButton (XYButton)

@property(nonatomic ,copy)void(^block)(UIButton*);

-(void)addTapBlock:(void(^)(UIButton*btn))block;
-(void)click:(UIButton*)btn;

//渲染button
-(void)renderButtonWithBlock:(clickButton)myBlock font:(UIFont*)font fontColor:(UIColor *)fontColor buttonName:(NSString *)buttonName;
-(void)renderButtonWithBlock:(clickButton)myBlock font:(UIFont*)font fontColor:(UIColor *)fontColor buttonName:(NSString *)buttonName bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end
