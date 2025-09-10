//
//  Response.m
//  BaseProject
//
//  Created by janker on 2018/11/6.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "Response.h"

@implementation Response
//当 JSON 转为 Model 完成后，该方法会被调用。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 可以在这里处理一些数据逻辑，如NSDate格式的转换
    //发现token失效，要跳到主界面
    NSString *code = dic[@"code"];
    if ([@"-1" isEqualToString:code])
    {
        [self performSelector:@selector(loginOut) withObject:self afterDelay:0.2];
    }
//    NSString *token = dic[@"token"];
//    if ([NomalUtil isValueableString:token])
//    {
//        [SingleDataManager instance].token = token;
//        [kUserDefaults setObject:token forKey:@"app_token"];
//        [kUserDefaults synchronize];
//    }
    
    return YES;
}
-(void)loginOut
{
//    [SingleDataManager instance].userInfoModel = nil;
//    [[DataBaseUtil instance] deleteObjWithClass:NSClassFromString(@"UserInfoModel")];
//    //跳到主界面
//    [NomalUtil popToViewControllWithClassName:@"LoginViewController"];
  [self popToViewControllWithClassName:@"Login" animated:NO];
}
-(BOOL)popToViewControllWithClassName:(NSString *)className animated:(BOOL)animated
{
  BOOL isFind = NO;
  //    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  UINavigationController * nav = (UINavigationController *)kRootViewController;
  for (NSInteger i = [nav.viewControllers count] - 1; i >= 0  ;i-- )
  {
    //    UIViewController *contro = [nav.viewControllers objectAtIndex:i];
    BaseViewController *contro = [nav.viewControllers objectAtIndex:i];
    NSString *moduleName = contro.moduleName;
    //    if ([contro isKindOfClass:NSClassFromString(className)])
    if(className != nil && [className isEqualToString:moduleName])
    {
      [nav popToViewController:contro animated:animated];
      isFind = YES;
      return isFind;
    }
  }
  return isFind;
}
// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
//+ (NSArray *)modelPropertyBlacklist {
//    return @[@"test1", @"test2"];
//}
// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
//+ (NSArray *)modelPropertyWhitelist {
//    return @[@"name"];
//}

// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
//    NSNumber *timestamp = dic[@"timestamp"];
//    if (![timestamp isKindOfClass:[NSNumber class]]) return NO;
//    _createdAt = [NSDate dateWithTimeIntervalSince1970:timestamp.floatValue];
//    return YES;
//}

// 当 Model 转为 JSON 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
//- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
//    if (!_createdAt) return NO;
//    dic[@"timestamp"] = @(n.timeIntervalSince1970);
//    return YES;
//}
@end
