/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

//#import <React/RCTBridgeDelegate.h>
#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTBridgeDelegate.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, RCTBridgeDelegate,RCTBridgeModule,BMKLocationAuthDelegate,BMKGeneralDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) BMKMapManager *mapManager; //主引擎类

@end
