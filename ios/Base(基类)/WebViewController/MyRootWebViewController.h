//
//  MyRootWebViewController.h
//  BaseProject
//
//  Created by janker on 2018/11/22.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "MyXLWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyRootWebViewController : MyXLWebViewController

//在多级跳转后，是否在返回按钮右侧展示关闭按钮
@property(nonatomic,assign) BOOL isShowCloseBtn;
@end

NS_ASSUME_NONNULL_END
