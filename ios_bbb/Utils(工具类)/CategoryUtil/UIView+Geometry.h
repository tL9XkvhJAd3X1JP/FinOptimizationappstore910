//
//  UIView+Geometry.h
//  officialDemoNavi
//
//  Created by LiuX on 14-8-25.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#import <UIKit/UIKit.h>
@interface UIView (Geometry)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

//+(instancetype)getInstanceWith:(Class)tempClass superView:(UIView *)superView;
//默认加到本界面做子界面
-(instancetype)getSubViewInstanceWith:(Class)tempClass;

-(UIEdgeInsets)scaleWithEdgeInsets:(UIEdgeInsets)edge;


//一个子view和另一个子view的相对位置
-(void)setFrameLeftTopFromViewLeftBottom:(UIView *)view leftToLeftSpace:(CGFloat)leftToLeftSpace bottomToTopSpace:(CGFloat)bottomToTopSpace width:(CGFloat)width height:(CGFloat)height;
-(void)setFrameRightTopFromViewLeftTop:(UIView *)view leftToRightSpace:(CGFloat)leftToRightSpace topToTopSpace:(CGFloat)topToTopSpace width:(CGFloat)width height:(CGFloat)height;
-(void)setFrameLeftTopFromViewRightTop:(UIView *)view rightToLeftSpace:(CGFloat)rightToLeftSpace topToTop:(CGFloat)topToTop width:(CGFloat)width height:(CGFloat)height;
-(void)setFrameLeftTopFromViewRightBottom:(UIView *)view rightToLeftSpace:(CGFloat)rightToLeftSpace bottomToTop:(CGFloat)bottomToTop width:(CGFloat)width height:(CGFloat)height;

-(void)setFrameLeftTopFromViewLeftTop:(UIView *)view leftToLeftSpace:(CGFloat)leftToLeftSpace topToTopSpace:(CGFloat)topToTopSpace width:(CGFloat)width height:(CGFloat)height;



//一个子view在父view中的相对位置
-(void)setFrameInSuperViewCenter:(UIView *)view width:(CGFloat)width height:(CGFloat)height;
-(void)setFrameInSuperViewLeftTop:(UIView *)view toLeftSpace:(CGFloat)toLeftSpace toTopSpace:(CGFloat)toTopSpace width:(CGFloat)width height:(CGFloat)height;
-(void)setFrameInSuperViewLeftBottom:(UIView *)view toLeftSpace:(CGFloat)toLeftSpace toBottomSpace:(CGFloat)toBottomSpace width:(CGFloat)width height:(CGFloat)height;
-(void)setFrameInSuperViewRightTop:(UIView *)view toRightSpace:(CGFloat)toRightSpace toTopSpace:(CGFloat)toTopSpace width:(CGFloat)width height:(CGFloat)height;
-(void)setFrameInSuperViewRightBottom:(UIView *)view toRightSpace:(CGFloat)toRightSpace toBottomSpace:(CGFloat)toBottomSpace width:(CGFloat)width height:(CGFloat)height;
-(void)setFrameInSuperViewCenterBottom:(UIView *)view toBottomSpace:(CGFloat)toBottomSpace width:(CGFloat)width height:(CGFloat)height;
-(void)setFrameInSuperViewCenterTop:(UIView *)view toTopSpace:(CGFloat)toTopSpace width:(CGFloat)width height:(CGFloat)height;
-(void)setFrameLeftBottomFromViewLeftTop:(UIView *)view leftToLeftSpace:(CGFloat)leftToLeftSpace topToBottom:(CGFloat)topToBottom width:(CGFloat)width height:(CGFloat)height;

-(void)setFrameRightBottomFromViewRightTop:(UIView *)view rightToRightSpace:(CGFloat)rightToRightSpace topToBottom:(CGFloat)topToBottom width:(CGFloat)width height:(CGFloat)height;
-(void)setFrameRightBottomFromViewLeftTop:(UIView *)view leftToRightSpace:(CGFloat)leftToRightSpace topToBottom:(CGFloat)topToBottom width:(CGFloat)width height:(CGFloat)height;
-(void)setFrameLeftBottomFromViewRightTop:(UIView *)view rightToLeftSpace:(CGFloat)rightToLeftSpace topToBottom:(CGFloat)topToBottom width:(CGFloat)width height:(CGFloat)height;
-(void)setFrameRightTopFromViewRightBottom:(UIView *)view rightToRightSpace:(CGFloat)rightToRightSpace bottomToTopSpace:(CGFloat)bottomToTopSpace width:(CGFloat)width height:(CGFloat)height;


-(void)setViewTopLeftTopRightCornerWith:(CGFloat)cornerNum;

-(CGFloat)getPicScaleLen:(CGFloat)len;
-(CGFloat)getPicScaleLen2:(CGFloat)len;

//渲染下view
-(void)renderViewWithbgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

-(void)setFrameInSuperViewHeightCenterAndLeft:(UIView *)view toLeftSpace:(CGFloat)toLeftSpace width:(CGFloat)width height:(CGFloat)height;

-(void)setFrameInSuperViewHeightCenterAndRight:(UIView *)view toRightSpace:(CGFloat)toRightSpace width:(CGFloat)width height:(CGFloat)height;

-(void)scaleAllSubViewFrame:(CGFloat)oldWidth;
-(void)setViewBottomLeftBottomRightCornerWith:(CGFloat)cornerNum;
@end
