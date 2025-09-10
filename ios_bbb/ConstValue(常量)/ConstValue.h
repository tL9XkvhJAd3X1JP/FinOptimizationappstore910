//
//  ConstValue.h
//  BaseProject
//
//  Created by janker on 2018/10/30.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#ifndef ConstValue_h
#define ConstValue_h

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavBarHeight 44.0f
//34px(像素尺寸)=17pt(开发尺寸)
#define IphoneX_BottomH 17.0f
#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenWidth_Content ScreenWidth
//#define ScreenHeight_Content getScreenHeightContent()
#define ScreenHeight_Content [NomalUtil getViewContentHeight]
#define AppVersion getAppVersion()
#define IOSVersion getSystemVertion()
#define ConstString_appVersion @"ConstString_appVersion"
//自定义 能把string所有的长度都打出来
#ifdef DEBUG //开发阶段
#define NSLog(format,...) printf("%s \n",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else //发布阶段
#define NSLog(...)
#endif

//typedef void(^refreshBlock)(UIButton* pressedButton);
//typedef void(^refreshBlock)(void);
#define SAFE_AREA_INSETS_TOP mySafeAreaInsets().top

#define SAFE_AREA_INSETS_BOTTOM mySafeAreaInsets().bottom
//距离底部一点空间
#define SAFE_AREA_INSETS_BOTTOM_NotZero mySafeAreaInsetsNotZero().bottom

//#define WeakSelf __weak typeof(self) weakSelf = self;

#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

#define BACKGROUND(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define ScalNum_Width getScalNumWidth()
#define ScalNum_Height getScalNumHeight()
//UIkit相关代码要在主线程执行
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)
NS_INLINE CGFloat getScreenHeightContent(){
    return ScreenHeight - NavBarHeight - StatusBarHeight;
}
NS_INLINE CGFloat getScalNumWidth()
{
    //以iphone6为参考大小 开发长度的比例算，适配小屏幕
    CGFloat len = ScreenWidth/375.0;
    if (len < 1)
    {
        return len;
    }
    else
    {
        return 1.0;
    }
//    return len;
}
NS_INLINE CGFloat getScalNumHeight()
{
    //以iphone6为参考大小 开发长度的比例算，适配小屏幕
    CGFloat len = ScreenHeight/667.0;
    if (len < 1)
    {
        return len;
    }
    else
    {
        return 1.0;
    }
    //    return len;
}
NS_INLINE float getSystemVertion()
{
    static float version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //        version = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
        version = [[[UIDevice currentDevice] systemVersion] floatValue];
        
    });
    
    return version;
}
NS_INLINE NSString* getAppVersion()
{
    static NSString* version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
    });
    return version;
    
}
NS_INLINE UIEdgeInsets mySafeAreaInsets(void)
{
    
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    
    if (@available(iOS 11.0, *)) {
        
        safeAreaInsets = [[[[UIApplication sharedApplication] delegate]window]safeAreaInsets];
        
    }
    
    return safeAreaInsets;
    
}
NS_INLINE UIEdgeInsets mySafeAreaInsetsNotZero(void)
{
    
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    
    if (@available(iOS 11.0, *)) {
        
        safeAreaInsets = [[[[UIApplication sharedApplication] delegate]window]safeAreaInsets];
        
    }
    if (safeAreaInsets.bottom == 0)
    {
        safeAreaInsets.bottom = 20*ScalNum_Height;
    }
    return safeAreaInsets;
    
}
#endif /* ConstValue_h */
