//
//  UIView+Geometry.m
//  officialDemoNavi
//
//  Created by LiuX on 14-8-25.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//iphonex 812.000000d   375.000000d  724.000000d  375.000000d

#import "UIView+Geometry.h"
//1代表全适配，0代表同比放大
//#define isFitAllScreen 1
@implementation UIView (Geometry)
//self.view.safeAreaInsets.top

- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


-(void)scaleAllSubViewFont
{
    
}

-(void)scaleAllSubViewPoint
{
    
}


-(UIEdgeInsets)scaleWithEdgeInsets:(UIEdgeInsets)edge oldWidth:(CGFloat)oldWidth
{
    //UIButton *button = (UIButton *)self;
    CGFloat top = edge.top;
    CGFloat left = edge.left;
    CGFloat right = edge.right;
    CGFloat bottom = edge.bottom;
    if (top != 0 ||  left != 0||
        right != 0||
        bottom != 0)
    {
        return UIEdgeInsetsMake([self getDefaultScaleLen:top oldWidth:oldWidth], [self getDefaultScaleLen:left oldWidth:oldWidth], [self getDefaultScaleLen:bottom oldWidth:oldWidth], [self getDefaultScaleLen:right oldWidth:oldWidth]);
    }
    return edge;
}





-(void)setFrameLeftTopFromViewLeftTop:(UIView *)view leftToLeftSpace:(CGFloat)leftToLeftSpace topToTopSpace:(CGFloat)topToTopSpace width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    CGFloat viewStartX = RectX(view.frame);
    CGFloat viewStartY = RectY(view.frame);
    //CGFloat viewWith = RectWidth(view.frame);
    //CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(viewStartX + leftToLeftSpace, viewStartY +topToTopSpace, width, height);
}

-(void)setFrameLeftTopFromViewLeftBottom:(UIView *)view leftToLeftSpace:(CGFloat)leftToLeftSpace bottomToTopSpace:(CGFloat)bottomToTopSpace width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    CGFloat viewStartX = RectX(view.frame);
    CGFloat viewStartY = RectY(view.frame);
    //CGFloat viewWith = RectWidth(view.frame);
    CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(viewStartX + leftToLeftSpace, viewStartY + viewHeight +bottomToTopSpace, width, height);
}

-(void)setFrameRightTopFromViewLeftTop:(UIView *)view leftToRightSpace:(CGFloat)leftToRightSpace topToTopSpace:(CGFloat)topToTopSpace width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    CGFloat viewStartX = RectX(view.frame);
    CGFloat viewStartY = RectY(view.frame);
//    CGFloat viewWith = RectWidth(view.frame);
    //CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(viewStartX - width - leftToRightSpace, viewStartY + topToTopSpace, width, height);
}

-(void)setFrameRightTopFromViewRightBottom:(UIView *)view rightToRightSpace:(CGFloat)rightToRightSpace bottomToTopSpace:(CGFloat)bottomToTopSpace width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    CGFloat viewStartX = RectX(view.frame);
    CGFloat viewStartY = RectY(view.frame);
    CGFloat viewWith = RectWidth(view.frame);
    CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(viewStartX + viewWith - width - rightToRightSpace, viewStartY + bottomToTopSpace + viewHeight, width, height);
}

-(void)setFrameLeftTopFromViewRightTop:(UIView *)view rightToLeftSpace:(CGFloat)rightToLeftSpace topToTop:(CGFloat)topToTop width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    CGFloat viewStartX = RectX(view.frame);
    CGFloat viewStartY = RectY(view.frame);
    CGFloat viewWith = RectWidth(view.frame);
    //CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(viewStartX + viewWith + rightToLeftSpace, viewStartY  + topToTop, width, height);
}
-(void)setFrameLeftTopFromViewRightBottom:(UIView *)view rightToLeftSpace:(CGFloat)rightToLeftSpace bottomToTop:(CGFloat)bottomToTop width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    CGFloat viewStartX = RectX(view.frame);
    CGFloat viewStartY = RectY(view.frame);
    CGFloat viewWith = RectWidth(view.frame);
    CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(viewStartX + viewWith + rightToLeftSpace, viewStartY + viewHeight +bottomToTop, width, height);
}

-(void)setFrameLeftBottomFromViewLeftTop:(UIView *)view leftToLeftSpace:(CGFloat)leftToLeftSpace topToBottom:(CGFloat)topToBottom width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    CGFloat viewStartX = RectX(view.frame);
    CGFloat viewStartY = RectY(view.frame);
    //CGFloat viewWith = RectWidth(view.frame);
    //CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(viewStartX + leftToLeftSpace, viewStartY - height -topToBottom, width, height);
}
-(void)setFrameLeftBottomFromViewRightTop:(UIView *)view rightToLeftSpace:(CGFloat)rightToLeftSpace topToBottom:(CGFloat)topToBottom width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    CGFloat viewStartX = RectX(view.frame);
    CGFloat viewStartY = RectY(view.frame);
    CGFloat viewWith = RectWidth(view.frame);
    //CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(viewStartX + viewWith + rightToLeftSpace, viewStartY - height -topToBottom, width, height);
}

-(void)setFrameRightBottomFromViewLeftTop:(UIView *)view leftToRightSpace:(CGFloat)leftToRightSpace topToBottom:(CGFloat)topToBottom width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    CGFloat viewStartX = RectX(view.frame);
    CGFloat viewStartY = RectY(view.frame);
    //CGFloat viewWith = RectWidth(view.frame);
    //CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(viewStartX - width - leftToRightSpace, viewStartY - height -topToBottom, width, height);
    
    
}


-(void)setFrameRightBottomFromViewRightTop:(UIView *)view rightToRightSpace:(CGFloat)rightToRightSpace topToBottom:(CGFloat)topToBottom width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    CGFloat viewStartX = RectX(view.frame);
    CGFloat viewStartY = RectY(view.frame);
    CGFloat viewWith = RectWidth(view.frame);
    //CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(viewStartX + viewWith - rightToRightSpace - width, viewStartY - height -topToBottom, width, height);
}



//把组件放在父view中间
-(void)setFrameInSuperViewCenter:(UIView *)view width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    if (view == nil)
    {
        view = self.superview;
    }
//    CGFloat viewStartX = RectX(view.frame);
//    CGFloat viewStartY = RectY(view.frame);
//    CGFloat viewWith = RectWidth(view.frame);
//    CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(0, 0, width, height);
    self.centerX = view.width/2;
    self.centerY = view.height/2;
}


- (void)filterWith:(CGFloat *)width {
    //定高度，跟据字多少自动计算宽
    if (*width == -2)
    {
        if ([self isKindOfClass:[UILabel class]])
        {
            UILabel *temp = (UILabel *)self;
            *width = [temp.text widthFromFont:temp.font];
            
        }
    }
    else if (*width < 0)
    {
        *width = RectWidth(self.frame);
    }
}

- (void)filterHeight:(CGFloat *)height width:(CGFloat)width {
    //定宽度，跟据字多少自动计算高
    if (*height == -2)
    {
        if ([self isKindOfClass:[UILabel class]])
        {
            UILabel *temp = (UILabel *)self;
            *height = [temp.text heightForFont:temp.font width:width];
        }
    }
    else if (*height < 0)
    {
        *height = RectHeight(self.frame);
    }
}

-(void)setFrameInSuperViewLeftTop:(UIView *)view toLeftSpace:(CGFloat)toLeftSpace toTopSpace:(CGFloat)toTopSpace width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
//    if (view == nil)
//    {
//        view = self.superview;
//    }
    //    CGFloat viewStartX = RectX(view.frame);
    //    CGFloat viewStartY = RectY(view.frame);
    //CGFloat viewWith = RectWidth(view.frame);
    //CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(toLeftSpace, toTopSpace, width, height);
}
-(void)setFrameInSuperViewLeftBottom:(UIView *)view toLeftSpace:(CGFloat)toLeftSpace toBottomSpace:(CGFloat)toBottomSpace width:(CGFloat)width height:(CGFloat)height
{
    //    CGFloat viewStartX = RectX(view.frame);
    //CGFloat viewStartY = RectY(view.frame);
    //CGFloat viewWith = RectWidth(view.frame);
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    if (view == nil)
    {
        view = self.superview;
    }
    CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(toLeftSpace, viewHeight - height - toBottomSpace, width, height);
    //MYLog(@"%@",NSStringFromCGRect(self.frame));
}

-(void)setFrameInSuperViewCenterBottom:(UIView *)view toBottomSpace:(CGFloat)toBottomSpace width:(CGFloat)width height:(CGFloat)height
{
    //    CGFloat viewStartX = RectX(view.frame);
    //CGFloat viewStartY = RectY(view.frame);
    //CGFloat viewWith = RectWidth(view.frame);
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    if (view == nil)
    {
        view = self.superview;
    }
    CGFloat viewHeight = RectHeight(view.frame);
    CGFloat viewWidth = RectWidth(view.frame);
    self.frame = Rect(0, viewHeight - height - toBottomSpace, width, height);
    self.centerX = viewWidth/2;
    //MYLog(@"%@",NSStringFromCGRect(self.frame));
}
-(void)setFrameInSuperViewCenterTop:(UIView *)view toTopSpace:(CGFloat)toTopSpace width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    if (view == nil)
    {
        view = self.superview;
    }
    //    CGFloat viewStartX = RectX(view.frame);
    //    CGFloat viewStartY = RectY(view.frame);
    CGFloat viewWidth = RectWidth(view.frame);
    //CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(0, toTopSpace, width, height);
    self.centerX = viewWidth/2;
}
-(void)setFrameInSuperViewHeightCenterAndLeft:(UIView *)view toLeftSpace:(CGFloat)toLeftSpace width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    if (view == nil)
    {
        view = self.superview;
    }
    //    CGFloat viewStartX = RectX(view.frame);
    //    CGFloat viewStartY = RectY(view.frame);
//    CGFloat viewWidth = RectWidth(view.frame);
    CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(toLeftSpace, (viewHeight-height)/2, width, height);
    
}
-(void)setFrameInSuperViewHeightCenterAndRight:(UIView *)view toRightSpace:(CGFloat)toRightSpace width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    if (view == nil)
    {
        view = self.superview;
    }
    //    CGFloat viewStartX = RectX(view.frame);
    //    CGFloat viewStartY = RectY(view.frame);
    CGFloat viewWidth = RectWidth(view.frame);
    CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(viewWidth - width - toRightSpace, (viewHeight-height)/2, width, height);
    
}
-(void)setFrameInSuperViewRightTop:(UIView *)view toRightSpace:(CGFloat)toRightSpace toTopSpace:(CGFloat)toTopSpace width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    if (view == nil)
    {
        view = self.superview;
    }
//    CGFloat viewStartX = RectX(view.frame);
//    CGFloat viewStartY = RectY(view.frame);
    CGFloat viewWith = RectWidth(view.frame);
    //CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(viewWith - width - toRightSpace, toTopSpace, width, height);
}
-(void)setFrameInSuperViewRightBottom:(UIView *)view toRightSpace:(CGFloat)toRightSpace toBottomSpace:(CGFloat)toBottomSpace width:(CGFloat)width height:(CGFloat)height
{
    //定高度，跟据字多少自动计算宽
    [self filterWith:&width];
    //定宽度，跟据字多少自动计算高
    [self filterHeight:&height width:width];
    if (view == nil)
    {
        view = self.superview;
    }
    //    CGFloat viewStartX = RectX(view.frame);
    //    CGFloat viewStartY = RectY(view.frame);
    CGFloat viewWith = RectWidth(view.frame);
    CGFloat viewHeight = RectHeight(view.frame);
    self.frame = Rect(viewWith - width - toRightSpace, viewHeight - height - toBottomSpace, width, height);
}



//按屏幕比例scale显示长度 len组件的长度
-(CGFloat)getDefaultScaleLen:(CGFloat)len oldWidth:(CGFloat)oldWidth
{
    //oldWidth = 320;
    return len*ScreenWidth/oldWidth;
}

//处理图处按iphone6切的问题 len 图片的实际大小
-(CGFloat)getPicScaleLen:(CGFloat)len
{
    return len*640.0/750.0/2 * ScalNum_Width;
}

-(CGFloat)getPicScaleLen2:(CGFloat)len
{
    return len*640.0/750.0*ScalNum_Width;
}




//-(void)touchUpPressed:(id)sender
//{
//    UIView *view = sender;
//    if ([@"" isEqualToString:view.tagString])
//    {
//
//    }
//}

//}

//-(void)addTouchEventTap
//{
//    self.userInteractionEnabled = YES;
//
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    [self addGestureRecognizer:singleTap];
//    [singleTap release];
//}
//- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
//{
//
//    //do something....
//}
//写置顶上两圆角
-(void)setViewTopLeftTopRightCornerWith:(CGFloat)cornerNum
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(cornerNum, cornerNum)]; // UIRectCornerBottomRight通过这个设置
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}
-(void)setViewBottomLeftBottomRightCornerWith:(CGFloat)cornerNum
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerNum, cornerNum)]; // UIRectCornerBottomRight通过这个设置
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}
//默认加到superView界面做子界面
//+(instancetype)getInstanceWith:(Class)tempClass superView:(UIView *)superView
//{
//    //[[NSClassFromString(className) alloc] init]
//    //UIView *view = [[self alloc] init];
//    //    if (self) {
//    //
//    //
//    //    }
//    UIView *temp = [[tempClass alloc] init];
//    if (superView != nil)
//    {
//        [superView addSubview:temp];
//    }
//
//    return temp;
//}
//默认加到本界面做子界面
-(instancetype)getSubViewInstanceWith:(Class)tempClass
{
    UIView *temp = [[tempClass alloc] init];
    [self addSubview:temp];
    return temp;
}

//渲染下view
-(void)renderViewWithbgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    if (cornerRadius > 0)
    {
        [self setCornerRadius:cornerRadius];
    }
    if (borderWidth > 0 && borderColor != nil)
    {
        [self setBorder:borderColor width:borderWidth];
    }
    if (bgColor != nil)
    {
        self.backgroundColor = bgColor;
    }
    
}

-(void)scaleCurrentViewPoint:(CGFloat)oldWidth
{
    if (ScreenWidth/oldWidth != 1 && self.resetFrameString == nil)
    {
        //            MYLog(@"++++%@  %fd  %fd  %fd %fd %fd",NSStringFromCGRect(self.frame),[NomalUtil getViewContentWidth]/320.0,[NomalUtil getViewContentWidth],[NomalUtil getViewContentHeight],screen_width,screen_height);
        CGFloat startX = RectX(self.frame);
        CGFloat startY = RectY(self.frame);
        //            CGFloat with = RectWidth(self.frame);
        //            CGFloat height = RectHeight(self.frame);
        
        if (startX != 0 && startX != ScreenWidth)
        {
            startX *= ScreenWidth/oldWidth;
            //startX = [self roundFloat:startX];
            //startX = floor(startX*100) / 100;
        }
        if (startY != 0 && startY != [NomalUtil getViewContentHeight])
        {
            startY *= ScreenWidth/oldWidth;
            //startY = [self roundFloat:startY];
            //startY = floor(startY*100) / 100;
            
        }
        self.top = startY;
        self.left = startX;
        self.resetFrameString = NSStringFromCGPoint(self.frame.origin);
        //self.frame = Rect(startX, startY, with, height);
        
        
        //            MYLog(@"++++==%@  %fd  %fd  %fd %fd %fd",NSStringFromCGRect(self.frame),[NomalUtil getViewContentWidth]/320.0,[NomalUtil getViewContentWidth],[NomalUtil getViewContentHeight],screen_width,screen_height);
    }
    else if (self.resetFrameString != nil)
    {
        
        if ([self.resetFrameString hasPrefix:@"{"] && ![self.resetFrameString hasPrefix:@"{{"])
        {
            //CGRect frame = CGRectFromString(self.resetFrameString);
            CGPoint point = CGPointFromString(self.resetFrameString);
            self.top = point.y;
            self.left = point.x;
        }
        
    }
}
-(void)scaleCurrentViewFrame:(CGFloat)oldWidth
{
    if (ScreenWidth/oldWidth != 1 && self.resetFrameString == nil)
    {
        //            MYLog(@"++++%@  %fd  %fd  %fd %fd %fd",NSStringFromCGRect(self.frame),[NomalUtil getViewContentWidth]/320.0,[NomalUtil getViewContentWidth],[NomalUtil getViewContentHeight],screen_width,screen_height);
        CGFloat startX = RectX(self.frame);
        CGFloat startY = RectY(self.frame);
        CGFloat with = RectWidth(self.frame);
        CGFloat height = RectHeight(self.frame);
        
        if (startX != 0 && startX != ScreenWidth)
        {
            startX *= ScreenWidth/oldWidth;
            //startX = [self roundFloat:startX];
            //startX = floor(startX*100) / 100;
        }
        if (startY != 0 && startY != ScreenHeight)
        {
            startY *= ScreenWidth/oldWidth;
            //startY = [self roundFloat:startY];
            //startY = floor(startY*100) / 100;
            
        }
        if (with != 0 && with != ScreenWidth)
        {
            with *= ScreenWidth/oldWidth;
            //with = [self roundFloat:with];
            //with = floor(with*100) / 100;
        }
        if (height != 0 && height != ScreenHeight)
        {
            height *= ScreenWidth/oldWidth;
            //height = [self roundFloat:height];
            //height = floor(height*100) / 100;
        }
        if ([self isKindOfClass:[UIButton class]])
        {
            
            UIButton *button = (UIButton *)self;
            [button setTitleEdgeInsets:[self scaleWithEdgeInsets:button.titleEdgeInsets oldWidth:oldWidth]];
            
            [button setImageEdgeInsets:[self scaleWithEdgeInsets:button.imageEdgeInsets oldWidth:oldWidth]];
        }
        self.frame = Rect(startX, startY, with, height);
        self.resetFrameString = NSStringFromCGRect(self.frame);
        
        //            MYLog(@"++++==%@  %fd  %fd  %fd %fd %fd",NSStringFromCGRect(self.frame),[NomalUtil getViewContentWidth]/320.0,[NomalUtil getViewContentWidth],[NomalUtil getViewContentHeight],screen_width,screen_height);
    }
    else if (self.resetFrameString != nil)
    {
        if ([self.resetFrameString hasPrefix:@"{{"])
        {
            self.frame = CGRectFromString(self.resetFrameString);
        }
        
        
    }
}
-(void)scaleAllSubViewFrame:(CGFloat)oldWidth
{
    if ([self isKindOfClass:[UISwitch class]])
    {
        [self scaleCurrentViewPoint:oldWidth];
        return;
    }
    else
    {
        [self scaleCurrentViewFrame:oldWidth];
    }
    
    
    for (UIView* subView in self.subviews)
    {
        if(ScreenWidth/oldWidth == 1)
        {
            break;
        }
        
        
        //do something ...
        if ([subView isKindOfClass:[UIView class]])
        {
            [subView scaleAllSubViewFrame:oldWidth];
        }
        
    }
}
@end
