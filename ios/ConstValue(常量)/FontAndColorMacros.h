//
//  FontAndColorMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

//字体大小和颜色配置

#ifndef FontAndColorMacros_h
#define FontAndColorMacros_h

#pragma mark -  间距区

//默认间距
#define KNormalSpace 12.0f

#define Space_Normal 12.0f

#pragma mark -  颜色区

#define Color_ViewBackground_blue  [UIColor colorWithHexString:@"0e5db7" alpha:1]
//界面背景色
#define Color_ViewBackground  [UIColor colorWithHexString:@"FFFFFF" alpha:1]
//导航栏背景色
#define Color_NavBackground  [UIColor clearColor]
//无色
#define Color_Clear  [UIColor clearColor]
//边框色
#define Color_border  [UIColor colorWithHexString:@"0E5DB7" alpha:1]

//选中色
#define Color_yellow_select  [UIColor colorWithIntRGBred:253 green:217 blue:11 alpha:1]

//经常用的一种背景色
#define Color_Nomal_Bg  [UIColor colorWithHexString:@"1262AD" alpha:0.9]

//半透明
#define Color_Nomal_Harf_White  [UIColor colorWithHexString:@"FFFFFF" alpha:0.8]

//经常用的按钮背景色
#define Color_button_Bg  [UIColor colorWithHexString:@"49AEE8" alpha:1]

#define Color_button_Bg_half_white  [UIColor colorWithHexString:@"FFFFFF" alpha:0.2]

//字体蓝色
#define Color_Nomal_Font_Blue  [UIColor colorWithHexString:@"1262AD" alpha:1]
//字体白色
#define Color_Nomal_Font_White  [UIColor colorWithHexString:@"FFFFFF" alpha:1]
//字体灰
#define Color_Nomal_Font_Gray  [UIColor colorWithHexString:@"303030" alpha:1]
//蓝色背景中的字体灰
#define Color_Nomal_Font_BlueGray  [UIColor colorWithHexString:@"FEFBFB" alpha:1]
//可点击的白色
#define Color_Nomal_Font_PressedWhite  [UIColor colorWithHexString:@"FAFCFD" alpha:1]
//橘红色
#define Color_Nomal_red  [UIColor colorWithHexString:@"ff4500" alpha:1]



////主题色 导航栏颜色
#define CNavBgColor  [UIColor colorWithHexString:@"00AE68"]
//#define CNavBgColor  [Ulor colorWithHexString:@"ffffff"]
#define CNavBgFontColor  [UIColor colorWithHexString:@"ffffff"]

//默认页面背景色
#define CViewBgColor [UIColor colorWithHexString:@"f2f2f2"]

//分割线颜色
#define CLineColor [UIColor colorWithHexString:@"ededed"]

//次级字色
#define CFontColor1 [UIColor colorWithHexString:@"1f1f1f"]

//再次级字色
#define CFontColor2 [UIColor colorWithHexString:@"5c5c5c"]


#pragma mark -  字体区


#define FFont_Default_Small_12 [UIFont systemFontOfSize:12.0f*ScalNum_Width]

#define FFont_Default [UIFont systemFontOfSize:15.0f*ScalNum_Width]

#define FFont_Default_14 [UIFont systemFontOfSize:14.0f*ScalNum_Width]

#define FFont_Default_Big [UIFont systemFontOfSize:17.0f*ScalNum_Width]

#define FFont_Default_Small [UIFont systemFontOfSize:13.0f*ScalNum_Width]

#endif /* FontAndColorMacros_h */
