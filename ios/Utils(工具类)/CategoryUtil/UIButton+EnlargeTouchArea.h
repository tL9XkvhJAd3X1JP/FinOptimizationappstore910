//
//  UIButton+EnlargeTouchArea.h
//  wsmCarOwner
//
//  Created by janker on 2017/12/22.
//  Copyright © 2017年 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

-(void)renderButtonWithColor:(UIColor *)color image:(UIImage *)image forState:(UIControlState)state renderingMode:(UIImageRenderingMode)renderingMode;
- (void)layoutButtonWithImageTitleSpace:(CGFloat)space;
@end
