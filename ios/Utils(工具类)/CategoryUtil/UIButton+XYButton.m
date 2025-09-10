//
//  UIButton+XYButton.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/6/1.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "UIButton+XYButton.h"

@implementation UIButton (XYButton)

-(void)setBlock:(void(^)(UIButton*))block

{
    
    objc_setAssociatedObject(self,@selector(block), block,OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addTarget:self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside];
    
}

-(void(^)(UIButton*))block

{
    
    return objc_getAssociatedObject(self,@selector(block));
    
}

-(void)addTapBlock:(void(^)(UIButton*))block

{
    
    self.block= block;
    
    [self addTarget:self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)click:(UIButton*)btn

{
    
    if(self.block) {
        
        self.block(btn);
        
    }
    
}

//渲染button
-(void)renderButtonWithBlock:(clickButton)myBlock font:(UIFont*)font fontColor:(UIColor *)fontColor buttonName:(NSString *)buttonName
{
    if (myBlock != nil)
    {
        [self addTapBlock:myBlock];
    }
    [self setTitle:buttonName forState:UIControlStateNormal];
    if (fontColor != nil)
    {
        [self setTitleColor:fontColor forState:UIControlStateNormal];
    }
    if (font != nil)
    {
        [self.titleLabel setFont:font];
    }
    
    
}

-(void)renderButtonWithBlock:(clickButton)myBlock font:(UIFont*)font fontColor:(UIColor *)fontColor buttonName:(NSString *)buttonName bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    [self renderButtonWithBlock:myBlock font:font fontColor:fontColor buttonName:buttonName];
    [self renderViewWithbgColor:bgColor cornerRadius:cornerRadius borderColor:borderColor borderWidth:borderWidth];
}
@end
