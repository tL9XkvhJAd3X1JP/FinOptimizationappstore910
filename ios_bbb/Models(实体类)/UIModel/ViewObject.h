//
//  ViewObject.h
//  BaseProject
//
//  Created by janker on 2019/3/27.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenderObject.h"
#import "FrameObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface ViewObject : NSObject
//渲染对象
@property (strong,nonatomic) RenderObject *renderObject;
//排版本对象
@property (strong,nonatomic) FrameObject *frameObject;
//子ViewObject对象
@property (strong,nonatomic) NSMutableDictionary *childViewDic;
//父viewObject的标识
@property (strong,nonatomic) NSString *superViewObjectKey;

//相关的界面标识
@property (strong,nonatomic) NSMutableArray *relationalViewObjectKey;

//界面对象标识
@property (strong,nonatomic) NSString *key;

//自己要把自己创建出来
@property (strong,nonatomic) UIView *view;

@end

NS_ASSUME_NONNULL_END
