//
//  NSString+Utilities.m
//  yiweizuche
//
//  Created by rphao on 15/11/2.
//  Copyright (c) 2015年 www.evrental.cn 宜维租车. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (NSString *)firstCharacter
{
  if (self.length > 0) {
    return [self substringToIndex:1];
  }
  
  return nil;
}

- (NSString *)lastCharacter
{
  if (self.length > 0) {
    return [self substringWithRange:NSMakeRange(self.length - 1, 1)];
  }
  
  return nil;
}

- (CGFloat)CGFloatValue
{
#if defined(__LP64__) && __LP64__
  return [self doubleValue];
#else
  return [self floatValue];
#endif
}
- (CGFloat)widthFromFont:(UIFont *)font
{
    CGSize size = [self sizeFromFont:font andHeight:30];
    return size.width;
}
- (CGFloat)heightFromFont:(UIFont *)font andWidth:(CGFloat)width
{
    CGSize size = [self sizeFromFont:font andWidth:width];
    return size.height;
}
- (CGSize) sizeFromFont:(UIFont *)font andWidth:(float)width
{
    static UILabel* label;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        label = [[UILabel alloc] init];
        label.numberOfLines = 0;
    });
    label.font = font;
    label.text = self;
    CGSize sizeToFit = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit;
}

- (CGSize) sizeFromFont:(UIFont *)font andHeight:(float)height
{
    static UILabel* label;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        label = [[UILabel alloc] init];
        label.numberOfLines = 0;
    });
    label.font = font;
    label.text = self;
    CGSize sizeToFit = [label sizeThatFits:CGSizeMake(MAXFLOAT, height)];
    return sizeToFit;
}
- (CGSize) sizeFromFont:(UIFont *)font size:(CGSize)size
{
    static UILabel* label;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        label = [[UILabel alloc] init];
        label.numberOfLines = 0;
    });
    label.font = font;
    label.text = self;
    CGSize sizeToFit = [label sizeThatFits:size];
    return sizeToFit;
}
////
//- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
//{
//  CGRect bounds = [self boundingRectWithSize:size
//                                     options:NSStringDrawingUsesLineFragmentOrigin
//                                  attributes:@{NSFontAttributeName : font}
//                                     context:nil];
//  return bounds.size;
//}

+ (NSString *)stringWithArray:(NSArray *)array
{
  NSMutableString *mulString = [NSMutableString string];
  [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSString *string = (NSString *)obj;
    [mulString appendFormat:@"%@,", string];
  }];
  NSInteger length = [mulString length];
  if (length > 0) {
    [mulString deleteCharactersInRange:NSMakeRange(length - 1, 1)];
  }
  
  return mulString;
}

- (long long)millionSecondsWithHourMinute
{
  NSString *hourStr   = [self substringWithRange:NSMakeRange(0, 2)];
  NSString *minuteStr = [self substringWithRange:NSMakeRange(3, 2)];
  NSInteger hour      = [hourStr intValue];
  NSInteger minute    = [minuteStr intValue];

  return 1000 * (minute * 60 + hour * 3600);
}

+ (NSString *)chineseStringWithNum:(NSInteger)num
{
  switch (num) {
    case 0:
      return @"零";
    case 1:
      return @"一";
    case 2:
      return @"二";
    case 3:
      return @"三";
    case 4:
      return @"四";
    case 5:
      return @"五";
    case 6:
      return @"六";
    case 7:
      return @"七";
    case 8:
      return @"八";
    case 9:
      return @"九";
    default:
      return @"";
  }
}

- (NSString *)shieldingAtPrefixLeng:(NSUInteger)lengPre AtSuffixLeng:(NSUInteger)lengSuf
{
    if (!self.length) {
        return self;
    }
    if (self.length > lengPre+lengSuf) {
        NSUInteger subIndex = self.length-lengSuf-lengPre;
        NSRange subRange = NSMakeRange(lengPre, subIndex);
        NSString *subShieldString = [self substringWithRange:subRange];
        NSUInteger subLeng = subShieldString.length;
        NSMutableString *mutableShield = @"".mutableCopy;
        while (subLeng!=0) {
            subLeng--;
            [mutableShield appendString:@"*"];
        }
        NSMutableString *mutabShieldString = [NSMutableString stringWithString:self];
        [mutabShieldString replaceCharactersInRange:subRange withString:mutableShield];
        return mutabShieldString;
    }else{
        return self;
    }
}

/**
 * 传入参数与url，拼接为一个带参数的url
 **/
+(NSString *) connectUrl:(NSDictionary *)params url:(NSString *) urlLink
{
    // 初始化参数变量
    NSString *str = @"?";
    if (urlLink == nil || [@"" isEqualToString:urlLink])
    {
        str = @"";
        urlLink = @"";
    }
    // 快速遍历参数数组
    for(id key in params) {
//        NSLog(@"key :%@  value :%@", key, [params objectForKey:key]);
        str = [NSString stringWithFormat:@"%@%@",str,key];
        str = [NSString stringWithFormat:@"%@=",str];
//        NSString* encodedString = [[params objectForKey:key] stringByURLEncode];
//        NSString* encodedString = [[params objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        NSString* encodedString = [NomalUtil urlEncodeStr:[params objectForKey:key]];
//        str = [NSString stringWithFormat:@"%@%@",str,encodedString];
        
        str = [NSString stringWithFormat:@"%@%@",str,[params objectForKey:key]];

        str = [NSString stringWithFormat:@"%@&",str];
    }
    // 处理多余的&以及返回含参url
    if (str.length > 1) {
        // 去掉末尾的&
        str = [str substringToIndex:str.length - 1];
        // 返回含参url
        return [urlLink stringByAppendingString:str];
    }
    if (urlLink != nil)
    {
        return urlLink;
    }
    return nil;
}
/** 格式化float类型 */
+ (NSString *)floatValueWithFormat:(float)value
{
    NSString *str = [NSString stringWithFormat:@"%.2f",value];
    return str;
//    NSString *subStr = nil;
//    NSString *formatStr = nil;
//    
//    NSInteger index = 0;
//    while (1) {
//        
//        index ++;
//        
//        NSRange range = NSMakeRange(str.length-index, 1);
//        subStr = [str substringWithRange:range];
//        
//        BOOL isSub = subStr.integerValue>0;
//        BOOL dian  = [subStr isEqualToString:@"."];
//        if (isSub || dian) {
//            
//            NSInteger temp = dian?0:1;
//            formatStr = [str substringToIndex:str.length-index+temp];
//            break;
//        }
//        
//    }
//    return formatStr;
}

//格式话小数 四舍五入类型
+ (NSString *)decimalwithFormat:(NSString *)format floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

//格式化时间(秒)
+ (NSString *)humanReadableForTimeInterval:(NSTimeInterval)timeDuration
{
    return [self humanReadableForTimeDuration:timeDuration/60];
}
//格式化时间(分钟)
+ (NSString *)humanReadableForTimeDuration:(NSInteger)timeDuration
{
    NSString *humanReadable = nil;
    
    // 分.
    if (timeDuration < 60)
    {
        humanReadable = [NSString stringWithFormat:@"%ld分钟", (long)timeDuration];
    }
    // 小时.
    else
    {
        humanReadable = [NSString stringWithFormat:@"%ld小时", (long)timeDuration / 60];
        
        double remainder = fmod(timeDuration, 60.0);
        
        if (remainder != 0)
        {
            NSString *remainderHumanReadable = [self humanReadableForTimeDuration:remainder];
            
            humanReadable = [humanReadable stringByAppendingString:remainderHumanReadable];
        }
    }
    return humanReadable;
}
//格式化距离（米）
+ (NSString *)humanReadableForDistance:(CGFloat)distance
{
    NSString *humanReadable = nil;
    
    NSInteger theLength = (NSInteger)distance;
    
    // 米.
    if (theLength < 1000)
    {
        humanReadable = [NSString stringWithFormat:@"%ld米", (long)theLength];
    }
    // 公里.
    else
    {
#define WCLUtilityZeroEnd @".0"
        
        humanReadable = [NSString stringWithFormat:@"%.1f", theLength / 1000.0];
        
        BOOL zeroEnd = [humanReadable hasSuffix:WCLUtilityZeroEnd];
        
        // .0结尾, 去掉尾数.
        if (zeroEnd)
        {
            humanReadable = [humanReadable substringWithRange:NSMakeRange(0, humanReadable.length - WCLUtilityZeroEnd.length)];
        }
        
        humanReadable = [humanReadable stringByAppendingString:@"公里"];
    }
    
    return humanReadable;
}

+ (NSString *)passwordNewPlhorder
{
    return @"输入新密码(数字、字母或下划线 6-8位)";
}

+ (NSString *)passwordPlhorder
{
    return @"输入密码(数字、字母或下划线 6-8位)";
}

@end
