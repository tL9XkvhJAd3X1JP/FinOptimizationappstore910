//
//  UIView+BDTag.m
//  wsmCarOwner
//
//  Created by janker on 16/5/5.
//  Copyright © 2016年 chenxing. All rights reserved.
//
//#undef就是取消一个宏的定义，之后这个宏所定义的就无效；
//但是可以重新使用#define 进行定义

#import "UIView+BDTag.h"
#undef   KEY_TAGSTRING
#define KEY_TAGSTRING     "UIView.tagString"
#define KEY_frameSTRING     "UIView.frameSTRING"
#define KEY_fontSTRING     "UIView.fontSTRING"
@implementation UIView (BDTag)
@dynamic tagString,resetFrameString,resetFontString;//告诉编译器,属性的setter与getter方法由用户自己实现，不自动生成
//@synthesize的语义是如果你没有手动实现setter方法和getter方法，那么编译器会自动为你加上这两个方法
- (NSString *)resetFontString
{
    
    NSObject *obj = objc_getAssociatedObject(self, KEY_fontSTRING);
    
    if (obj && [obj isKindOfClass:[NSString class]])
    {
        
        return (NSString *)obj;
        
    }
    
    return nil;
    
}



- (void)setResetFontString:(NSString *)value
{
    
    objc_setAssociatedObject(self, KEY_fontSTRING, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (NSString *)resetFrameString
{
    
    NSObject *obj = objc_getAssociatedObject(self, KEY_frameSTRING);
    
    if (obj && [obj isKindOfClass:[NSString class]])
    {
        
        return (NSString *)obj;
        
    }
    
    return nil;
    
}



- (void)setResetFrameString:(NSString *)value
{
    
    objc_setAssociatedObject(self, KEY_frameSTRING, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSString *)tagString
{
    
    NSObject *obj = objc_getAssociatedObject(self, KEY_TAGSTRING);
    
    if (obj && [obj isKindOfClass:[NSString class]])
    {
        
        return (NSString *)obj;
        
    }
    
    return nil;
    
}



- (void)setTagString:(NSString *)value
{
    
    objc_setAssociatedObject(self, KEY_TAGSTRING, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}



- (UIView *)viewWithTagString:(NSString *)value {
    
    if (nil == value) {
        
        return nil;
        
    }
    
    
    
    for (UIView *subview in self.subviews) {
        
        NSString *tag = subview.tagString;
        
        if ([tag isEqualToString:value])
            
        {
            
            return subview;
            
        }
        
    }
    
    
    
    return nil;
    
}


/* simple setting using the layer */
- (void) setCornerRadius : (CGFloat) radius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

- (void) setBorder : (UIColor *) color width : (CGFloat) width  {
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = width;
}

- (void) setShadow : (UIColor *)color opacity:(CGFloat)opacity offset:(CGSize)offset blurRadius:(CGFloat)blurRadius {
    CALayer *l = self.layer;
    l.shadowColor = [color CGColor];
    l.shadowOpacity = opacity;
    l.shadowOffset = offset;
    l.shadowRadius = blurRadius;
}
@end
