//
//  MyXLWebViewController.h
//  BaseProject
//
//  Created by janker on 2018/11/22.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
//NS_ASSUME_NONNULL_BEGIN

@interface MyXLWebViewController : BaseViewController
@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic,strong) UIProgressView * progressView;
@property (nonatomic) UIColor *progressViewColor;
@property (nonatomic,weak) WKWebViewConfiguration * webConfiguration;
@property (nonatomic, copy) NSString * url;

-(instancetype)initWithUrl:(NSString *)url;

//更新进度条
-(void)updateProgress:(double)progress;

//更新导航栏按钮，子类去实现
-(void)updateNavigationItems;
@end

//NS_ASSUME_NONNULL_END
