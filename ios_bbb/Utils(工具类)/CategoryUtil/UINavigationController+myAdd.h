//
//  UINavigationController+myAdd.h
//  BaseProject
//
//  Created by janker on 2018/11/21.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (myAdd)
-(instancetype)getCurrentViewControllerClass:(NSString *)ClassName;
-(BOOL)popToAppViewControllerWith:(NSString *)ClassName animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
