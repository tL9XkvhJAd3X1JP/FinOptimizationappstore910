//
//  NSString+Utilities.h
//  yiweizuche
//
//  Created by rphao on 15/11/2.
//  Copyright (c) 2015年 www.evrental.cn 宜维租车. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utilities)

- (NSString *)firstCharacter;
- (NSString *)lastCharacter;

- (CGFloat)CGFloatValue;

//- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/*
*  将Array转换为以“,”分隔的String
*
*  @param array a list with NSString element
*/

+ (NSString *)stringWithArray:(NSArray *)array;

/**
 *  将时间转化为毫秒
 *
 *  @return 时间对应的毫秒值
 */
- (long long)millionSecondsWithHourMinute;//09:40

/**
 *  数字0-9 转化为中文对应的 零－九
 *
 *  @param num  数字
 *
 *  @return 数字对应的中文
 */
+ (NSString *)chineseStringWithNum:(NSInteger)num;
/*!
 *    @brief  将文本中间段以***显示 例:188****8888
 *    @param  lengPre显示部分的前缀长度
 *    @param  lengSuf显示部分的后缀长度
 */
- (NSString *)shieldingAtPrefixLeng:(NSUInteger)lengPre AtSuffixLeng:(NSUInteger)lengSuf;
/*!
 *    @brief  将URL与参数拼接
 *    @param  params参数 urlLink请求连接
 */
+(NSString *) connectUrl:(NSDictionary *)params url:(NSString *) urlLink;

/*!
 *    @brief 格式化float类型 例如:1.100 = 1.1
 * 
 * */
+ (NSString *)floatValueWithFormat:(float)value;

//格式话小数 四舍五入类型
+ (NSString *)decimalwithFormat:(NSString *)format floatV:(float)floatV;

/*!
 *    @brief  格式化时间 例: timeDuration<60 为xx分钟，timeDuration>60 为xx小时xx分钟
 *    @param  timeDuration秒数
 */
+ (NSString *)humanReadableForTimeInterval:(NSTimeInterval)timeDuration;
/*!
 *    @brief  格式化时间 例: timeDuration<60 为xx分钟，timeDuration>60 为xx小时xx分钟
 *    @param  timeDuration分钟数
 */
+ (NSString *)humanReadableForTimeDuration:(NSInteger)timeDuration;
/*!
 *    @brief  格式化距离 xx公里
 *    @param  distance 米
 */
+ (NSString *)humanReadableForDistance:(CGFloat)distance;

+ (NSString *)passwordNewPlhorder;
+ (NSString *)passwordPlhorder;
- (CGSize) sizeFromFont:(UIFont *)font andWidth:(float)width;
- (CGFloat)widthFromFont:(UIFont *)font;
- (CGSize) sizeFromFont:(UIFont *)font andHeight:(float)height;
- (CGSize) sizeFromFont:(UIFont *)font size:(CGSize)size;
- (CGFloat)heightFromFont:(UIFont *)font andWidth:(CGFloat)width;
@end
