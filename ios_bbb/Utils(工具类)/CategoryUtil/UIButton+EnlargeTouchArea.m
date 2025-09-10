//
//  UIButton+EnlargeTouchArea.m
//  wsmCarOwner
//调用：[settingBtn setEnlargeEdgeWithTop:30 right:30 bottom:30 left:30];
//这样btn的点击范围就扩大了30
//  Created by janker on 2017/12/22.
//  Copyright © 2017年 chenxing. All rights reserved.
//

#import "UIButton+EnlargeTouchArea.h"
 #import <objc/runtime.h>
@implementation UIButton (EnlargeTouchArea)
static char topNameKey;

static char rightNameKey;

static char bottomNameKey;

static char leftNameKey;


- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left

{
    
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}


- (CGRect) enlargedRect

{
    
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    
    if (topEdge && rightEdge && bottomEdge && leftEdge)
        
    {
        
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          
                          self.bounds.origin.y - topEdge.floatValue,
                          
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
        
    }
    
    else
        
    {
        
        return self.bounds;
        
    }
    
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event

{
    
    CGRect rect = [self enlargedRect];
    //MYLog(@"%@",NSStringFromCGRect(rect));
    if (CGRectEqualToRect(rect, self.bounds))
        
    {
        
        return [super pointInside:point withEvent:event];
        
    }
    
    return CGRectContainsPoint(rect, point) ? YES : NO;
    
}

-(void)renderButtonWithColor:(UIColor *)color image:(UIImage *)image forState:(UIControlState)state renderingMode:(UIImageRenderingMode)renderingMode
{
//    1.UIImageRenderingModeAutomatic  // 根据图片的使用环境和所处的绘图上下文自动调整渲染模式。
//    2.UIImageRenderingModeAlwaysOriginal   // 始终绘制图片原始状态，不使用Tint Color。
//    3.UIImageRenderingModeAlwaysTemplate   // 始终根据Tint Color绘制图片，忽略图片的颜色信息。
    

    [self setTintColor:color];
    //UIImageRenderingModeAlwaysTemplate
    [self setImage:[image imageWithRenderingMode:renderingMode] forState:state];
    [self setTitleColor:color forState:state];
    self.titleLabel.backgroundColor = Color_Clear;
    [self setBackgroundImage:nil forState:state];
    self.backgroundColor = Color_Clear;
}

//上下结构
- (void)layoutButtonWithImageTitleSpace:(CGFloat)space
{
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
    CGFloat labelHeight = self.titleLabel.intrinsicContentSize.height;
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}
@end
