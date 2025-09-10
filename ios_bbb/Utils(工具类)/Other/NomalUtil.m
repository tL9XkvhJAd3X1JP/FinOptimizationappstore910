//
//  NomalUtil.m
//  BaseProject
//
//  Created by janker on 2018/11/14.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "NomalUtil.h"
#define timeZone_Project [NSTimeZone timeZoneWithAbbreviation:@"HKT"]
@implementation NomalUtil
NSInteger sortByString(id obj1, id obj2, void *context)
{
    
    NSString *str1 =(NSString *) obj1; // ibj1  和 obj2 来自与你的数组中，其实，个人觉得是苹果自己实现了一个冒泡排序给大家使用
    
    NSString *str2 =(NSString *) obj2;
    
    return [str1 compare:str2];
    
//    if (num1 < num2)
//    {
//        return NSOrderedDescending;
//    }
//    else if(num1 == num2)
//
//    {
//        return NSOrderedSame;
//    }
//
//    return NSOrderedAscending;
}
//按字母顺序排序
+(NSArray *)dictionarySortByKeysNum:(NSDictionary *)dic
{
    //
    return [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
//    return [[dic allKeys] sortedArrayUsingFunction:sortByString context:nil];
    
}
+(void)removeNullValue:(NSMutableDictionary *)dic
{
    if (dic != nil)
    {
        NSArray *array = [dic allKeys];
        for (NSString* key in array)
        {
            if (![NomalUtil isValueableString:[dic objectForKey:key]])
            {
                [dic removeObjectForKey:key];
            }
        }
    }
   
    
}
//排顺序
+(NSData *)bodyDataSortByKey:(NSDictionary *)dic
{
    if (dic != nil)
    {
        NSArray *keys = [NomalUtil dictionarySortByKeysNum:dic];
        
        NSString *sig= @"";
        for (NSString *key in keys)
        {
            sig = [sig stringByAppendingString:key];
            sig = [sig stringByAppendingString:[dic objectForKeyWithStringValue:key]];
        }
        if (sig.length > 0)
        {
            return [sig dataUsingEncoding:NSUTF8StringEncoding];
        }
    }

    return nil;
}
//urlEncode编码
+(NSString *)urlEncodeStr:(NSString *)input
{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *upSign = [input stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return upSign;
}
//urlEncode解码
+ (NSString *)decoderUrlEncodeStr: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[outputStr length])];
    return [outputStr stringByRemovingPercentEncoding];
}

+(NSString *)getUUID
{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)])
//    {
//
//    }
//    return @"";
}
+(BOOL)popToViewControllWithClassName:(NSString *)className
{
    return [self popToViewControllWithClassName:className animated:YES];
}
+(BOOL)popToViewControllWithClassName:(NSString *)className animated:(BOOL)animated
{
    BOOL isFind = NO;
    //    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController * nav = (UINavigationController *)kRootViewController;
    for (NSInteger i = [nav.viewControllers count] - 1; i >= 0  ;i-- )
    {
        UIViewController *contro = [nav.viewControllers objectAtIndex:i];
        
        if ([contro isKindOfClass:NSClassFromString(className)])
        {
            [nav popToViewController:contro animated:animated];
            isFind = YES;
            return isFind;
        }
    }
    return isFind;
}
+(NSString *)gb2312StringToString:(NSString *)content
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* aData = [content dataUsingEncoding: enc];
    NSString *retStr = [[NSString alloc] initWithData:aData encoding:enc];
    return retStr;
}
+(CGFloat) getViewContentHeight
{
    
    if ([kRootViewController isKindOfClass:NSClassFromString(@"MainTabBarController")])
    {
        return ScreenHeight - NavBarHeight - StatusBarHeight- kTabBarHeight;
    }
    else
    {
        return ScreenHeight - NavBarHeight - StatusBarHeight;
    }
}

+(BOOL) isValueableString:(NSString *)content
{
    if (content != nil && (NSNull *)content != [NSNull null] && ![@"" isEqualToString:content] && ![[content description] isEqualToString:[[NSNull null] description]])
    {
        return YES;
    }
    return NO;
}
+(BOOL) isValueableObject:(NSObject *)obj
{
    if (obj != nil && (NSNull *)obj != [NSNull null])
    {
        return YES;
    }
    return NO;
}
+ (BOOL)isPhoneNum:(NSString *)phoneNum
{
    //为空可能是用户不用填的字段，不做验证，到后面去过滤
    if ([@"" isEqualToString:phoneNum])
    {
        return NO;
    }
    else
    {
        return [self isPhoneNumFilterNull:phoneNum];
    }
}

+(BOOL) isPhoneNumFilterNull:(NSString *)phoneNum
{
    if (phoneNum != nil && (NSNull *)phoneNum!= [NSNull null] && [phoneNum length] == 11 && [phoneNum hasPrefix:@"1"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (BOOL) isValidateUserPwd : (NSString *) str
{
    //^[a-zA-Z0-9]{6,16}$
    NSString *str2 = [str stringByReplacingOccurrencesOfString:@"_" withString:@"1"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[a-zA-Z0-9]{0,30}$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str2
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str2.length)];
    
//    [regularexpression release];
    
    if(numberofMatch > 0)
    {
//        MYLog(@"%@ isNumbericString: YES", str);
        return YES;
    }
    
//    MYLog(@"%@ isNumbericString: NO", str);
    return NO;
}
#pragma mark date
+ (NSString *)getHoursDate:(NSString *)content
{
    NSArray *one = [content componentsSeparatedByString:@" "];
    NSString *str2 = [one objectAtIndex:1];
    NSArray *three = [str2 componentsSeparatedByString:@"-"];
    return [three objectAtIndex:0];
}
+ (NSString *)getDate:(NSString *)content
{
    NSArray *one = [content componentsSeparatedByString:@" "];
    NSString *str = [one objectAtIndex:0];
    NSArray *two = [str componentsSeparatedByString:@"/"];
    return [NSString stringWithFormat:@"%@月%@日",[two objectAtIndex:0],[two objectAtIndex:1]];
}

+ (NSString *)getDateAndHours:(NSString *)content
{
    NSArray *one = [content componentsSeparatedByString:@" "];
    NSString *str = [one objectAtIndex:0];
    NSString *str2 = [one objectAtIndex:1];
    NSArray *two = [str componentsSeparatedByString:@"/"];
    NSArray *three = [str2 componentsSeparatedByString:@"-"];
    return [NSString stringWithFormat:@"%@月%@日%@:%@",[two objectAtIndex:0],[two objectAtIndex:1],[three objectAtIndex:0],[three objectAtIndex:1]];
}

+(NSString *)getCurrentDate:(BOOL)isShowSecond
{
    
    NSDate *date = [NSDate date];
    //    NSTimeZone *zone = timeZone_Project;
    //    NSInteger interval = [zone secondsFromGMTForDate: date];
    //    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    NSDateFormatter *dateformat = [self getDateFormat];
    
    //yyyy-MM-dd HH:mm:ss
    if (isShowSecond)
    {
        [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else
    {
        [dateformat setDateFormat:@"yyyy-MM-dd"];
    }
    NSString * content = [dateformat stringFromDate:date];
    //    [dateformat release];
    return content;
}
+(NSString *)getCurrentDateWithFormat:(NSString *)content
{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateformat = [self getDateFormat];
    //yyyy-MM-dd HH:mm:ss
    [dateformat setDateFormat:content];
    
    return [dateformat stringFromDate:date];
}
//保证只创建一次
+(NSDateFormatter*)getDateFormat
{
    static NSDateFormatter* format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[NSDateFormatter alloc] init];
        [format setTimeZone:timeZone_Project];
        //        [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"HKT"]];
        //        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    //    [format setTimeZone:timeZone_Project];
    //    [format setDateStyle:NSDateFormatterFullStyle];
    return format;
}
//秒转成时间
+ (NSString *)convertSecondNumToTimeString:(NSString *)secondNum formatterStr:(NSString*)formatterStr

{
    
    long long time=[secondNum longLongValue];
    //time/1000.0
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *formatter = [self getDateFormat];
    //@"yyyy/MM/dd HH:mm:ss"
    [formatter setDateFormat:formatterStr];
    
    NSString*timeString=[formatter stringFromDate:d];
//    [d release];
    return timeString;
    
}
+(NSString *)getCurrentTimeWithLongLongNum
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    return [[NSNumber numberWithLongLong:time] stringValue];
}
+(NSString *)getCurrentTimeWithSecondNum
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    return [[NSNumber numberWithLongLong:time] stringValue];
}
//距离当前时间beforeSecondNum秒前的时间
+(NSString *)getBeforeTimeBeforeSecondNum:(NSInteger)beforeSecondNum
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] - beforeSecondNum;
    
    return [self convertSecondNumToTimeString:[[NSNumber numberWithLongLong:time] stringValue] formatterStr:@"yyyy-MM-dd"];
}
+ (NSInteger) getMonthOfDaysWithYear:(NSInteger) year month:(NSInteger) month
{
//    MYLog(@"%ld    %ld",(long)year,(long)month);
    int monthday[] = {31,28,31,30,31,30,31,31,30,31,30,31};
    if (month != 1)
    {
        //不是2月
        return monthday[month];
    }
    //2月
    if(year % 4 != 0)
        return 28;
    else if(year % 100 == 0 && year % 400 != 0)
        return 28;
    else
        return 29;
}

+(NSString *)getStringDateWithNSDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [self getDateFormat];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr =  [dateFormatter stringFromDate:date];
    return dateStr;
}
+(NSDate *)getNSDateWithNumString:(NSString *)time
{
    if (time != nil)
    {
        return [[NSDate alloc]initWithTimeIntervalSince1970:time.longLongValue/1000.0];
    }
    return nil;
}
+(NSDate *)getNSDateWithSecondNumString:(NSString *)time
{
    if (time != nil)
    {
        return [[NSDate alloc]initWithTimeIntervalSince1970:time.longLongValue];
    }
    return nil;
}
+(NSString *)getStringDateWithNSDate1:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [self getDateFormat];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr =  [dateFormatter stringFromDate:date];
    return dateStr;
}
+(NSString *)getStringDateWithNSDate2:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [self getDateFormat];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr =  [dateFormatter stringFromDate:date];
    return dateStr;
}

+(NSString *)getStringDateWithNSDate3:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [self getDateFormat];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr =  [dateFormatter stringFromDate:date];
    return dateStr;
}

+(NSString *)getStringDateWithNSDate5:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [self getDateFormat];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *dateStr =  [dateFormatter stringFromDate:date];
    return dateStr;
}

+(NSString *)getStringDateWithNSDate4:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [self getDateFormat];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr =  [dateFormatter stringFromDate:date];
    return dateStr;
}


+(NSDate *)getNSDateWithStr:(NSString*)dateStr
{
    NSDateFormatter *dateFormatter = [self getDateFormat];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    //    [dateFormatter release];
    return date;
}

+(NSDate *)getNSDateWithStr:(NSString *)dateStr forMateStr:(NSString *)forMateStr
{
    
    NSDateFormatter *dateFormatter = [self getDateFormat];
    [dateFormatter setDateFormat:forMateStr];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    //    [dateFormatter release];
    
    return date;
}

+(NSMutableArray *)getNextDaysFromToday:(NSString *)dateStr nextDayNum:(int)nextDayNum
{
    return [self getNextDaysFromToday:dateStr nextDayNum:nextDayNum type:0];
}

+(NSMutableArray *)getNextDaysFromToday:(NSString *)dateStr nextDayNum:(int)nextDayNum type:(int) type
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:nextDayNum];
    if (dateStr != nil)
    {
        
        NSDateFormatter *dateFormatter = [self getDateFormat];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:dateStr];
        
        //        [dateFormatter release];
        
        //        NSTimeInterval interval = [date timeIntervalSince1970];
        
        //        NSDateFormatter *dateformat = [self getDateFormat];
        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
        [dateformat setTimeZone:timeZone_Project];
        [dateformat setDateFormat:@"yyyy-MM-dd EEEE"];
        //以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
        //        NSInteger interval = [timeZone_Project secondsFromGMTForDate: date];
        double interval = 0;
        double num;
        
        for (int i = 0; i < nextDayNum; i++)
        {
            num = interval + 24 * 60 * 60 * i;
            NSDate *localeDate = [date dateByAddingTimeInterval: num];
            NSString *dateContent = [dateformat stringFromDate:localeDate];
            if (type == 1)
            {
                dateContent = [dateContent substringFromIndex:[dateContent length] - 4];
            }
            [array addObject:dateContent];
        }
//        [dateformat release];
        
    }
    
    return array;
}
+ (NSString *)changeDateFromDoubleToDate:(NSString *) numStr
{
    return [self changeDateFromDoubleToDate:numStr type:0];
}
//+ (NSString *) getDateStringFromNowAddingTime:(NSInteger) addingTime formatter:(NSString *)formatter
//{
//
//    NSDate *date = [NSDate date];
//
//    NSTimeZone *zone = timeZone_Project;
////    NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序默认的时区
////    NSInteger interval = [zone secondsFromGMTForDate:date];//以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
////    NSDate *localeDate = [[NSDate date] dateByAddingTimeInterval:interval];
////    NSTimeInterval timeInterval2 = [localeDate timeIntervalSince1970];
//
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
//
//    NSDate *date2 = [localeDate dateByAddingTimeInterval:addingTime];
//
//    NSDateFormatter *dateFormatter = [self getDateFormat];
//    [dateFormatter setDateFormat:formatter];
//    NSString *str = [dateFormatter stringFromDate:date2];
////    [dateFormatter release];
//    return str;
//}

+ (NSString *) changeDateFromDoubleToDate:(NSString *) numStr type:(int)type
{
    if (numStr == nil)
    {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[numStr doubleValue]/1000];
    //    NSTimeZone *zone = timeZone_Project;
    //    NSInteger interval = [zone secondsFromGMTForDate: date];
    //    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    
    NSDateFormatter *dateformat=[self getDateFormat];
    if (type == 1)
    {
        [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else if(type == 0)
    {
        [dateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else if(type == 2)
    {
        [dateformat setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSString *content = [dateformat stringFromDate:date];
    //    [dateformat release];
    
    return content;
}
+ (NSString *) changeDate:(NSString *) date
{
    return [self compareCurrentTime:[NSDate dateWithTimeIntervalSince1970:[date doubleValue]/1000]];
}
+ (BOOL)dateAIsLongThanDateB:(NSDate *) dateA DateB:(NSDate *)dateB
{
    if ([dateA compare:dateB] ==  NSOrderedDescending)
    {
        return YES;
    }
    return NO;
}

+ (NSString *) compareCurrentTime:(NSDate*) compareDate
{
    
    
    //    NSDateFormatter *dateformat = [self getDateFormat];
    //    NSDate *date = [NSDate date];
    //    [NomalUtil getCurrentDate:￼]
    //    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceDate:date];
    //    [compareDate timeIntervalSinceDate:date]
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
//    MYLog(@"%fd",timeInterval);
    long temp = 0;
    
    NSString *result;
    
    if (timeInterval > 0)
    {
        if (timeInterval < 60)
        {
            
            result = [NSString stringWithFormat:@"刚刚"];
            
        }
        else if((temp =timeInterval /60) < 60)
        {
            
            result = [NSString stringWithFormat:@"%ld分钟后",temp];
            
        }
        else if((temp = temp/60) < 24)
        {
            
            result = [NSString stringWithFormat:@"%ld小时后",temp];
            
        }
        else if((temp = temp/24) < 30)
        {
            
            result = [NSString stringWithFormat:@"%ld天后",temp];
            
        }
        else if((temp = temp/30) <12)
        {
            
            result = [NSString stringWithFormat:@"%ld月后",temp];
            
        }
        else
        {
            temp = temp/12;
            result = [NSString stringWithFormat:@"%ld年后",temp];
        }
        
    }
    else
    {
        timeInterval = -timeInterval;
        
        
        if (timeInterval < 60)
        {
            
            result = [NSString stringWithFormat:@"刚刚"];
            
        }
        else if((temp =timeInterval /60) < 60)
        {
            
            result = [NSString stringWithFormat:@"%ld分钟前",temp];
            
        }
        else if((temp = temp/60) < 24)
        {
            
            result = [NSString stringWithFormat:@"%ld小时前",temp];
            
        }
        else if((temp = temp/24) < 30)
        {
            
            result = [NSString stringWithFormat:@"%ld天前",temp];
            
        }
        else if((temp = temp/30) <12)
        {
            
            result = [NSString stringWithFormat:@"%ld月前",temp];
            
        }
        else
        {
            temp = temp/12;
            result = [NSString stringWithFormat:@"%ld年前",temp];
        }
        
    }
    
    return  result;
}

+ (NSString *) compareCurrentTimeBackDays:(NSDate*) compareDate
{
    NSTimeInterval timeInterval = [compareDate timeIntervalSinceNow];
    
    timeInterval = -timeInterval;
    
    long long temp = timeInterval /(60 * 60 *24);
    NSString *result = @"0";
    if (temp > 0)
    {
        result = [NSString stringWithFormat:@"%lld",temp];
    }
    return result;
}

+ (long long) compareCurrentTimeWithLongLong:(NSDate*) compareDate
{
    NSTimeInterval timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    return timeInterval;
}

+(NSDate *)changeLonglongToNSDate:(NSString *)max
{
    return [NSDate dateWithTimeIntervalSince1970:[max longLongValue]/1000];
}


+(NSDate *)changeDateFormStringToNSDate:(NSString *)date
{
    
    NSDateFormatter *dateFormatter = [self getDateFormat];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:date];
    
}

+(NSDate *)changeDateFormStringToNSDate:(NSString *)date formatter:(NSString *)formatter
{
    
    NSDateFormatter *dateFormatter = [self getDateFormat];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:date];
    
}

+(NSString *)changeDateStringTolonglong:(NSString *)date
{
    NSTimeInterval time = [[self changeDateFormStringToNSDate:date] timeIntervalSince1970];
    return [[NSNumber numberWithLongLong:time *1000] stringValue];
}
#pragma mark -image
//  颜色转换为背景图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark 修改部分字的色和大小
/**
 *改变字符串中具体某字符串的颜色
 */
+ (void)messageAction:(UILabel *)theLab changeStrings:(NSMutableArray *)changes andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor font:(UIFont *)font
{
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, [strAtt length])];
    
    for (NSString *change in changes)
    {
        NSRange markRange = [tempStr rangeOfString:change];
        [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
        //    [strAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:fontSize] range:markRange];
        [strAtt addAttribute:NSFontAttributeName value:font range:markRange];
    }
    
    
    theLab.attributedText = strAtt;
//    [strAtt release];
}

+ (void)messageAction:(UILabel *)theLab changeString:(NSString *)change andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor font:(UIFont *)font
{
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, [strAtt length])];
    
    NSRange markRange = [tempStr rangeOfString:change];
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
    //    [strAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:fontSize] range:markRange];
    [strAtt addAttribute:NSFontAttributeName value:font range:markRange];
    
    
    theLab.attributedText = strAtt;
//    [strAtt release];
}

/*
 *x*y
 *改变字符start 和 end 之间的字符的颜色 和 字体大小
 */
+ (void)messageAction:(UILabel *)theLab startString:(NSString *)start endString:(NSString *)end andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize
{
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, [strAtt length])];
    // 'x''y'字符的范围
    NSRange tempRange = NSMakeRange(0, 0);
    if ([self judgeStringIsNull:start])
    {
        tempRange = [tempStr rangeOfString:start];
    }
    NSRange tempRangeOne = NSMakeRange([strAtt length], 0);
    if ([self judgeStringIsNull:end])
    {
        tempRangeOne =  [tempStr rangeOfString:end];
    }
    // 更改字符颜色
    NSRange markRange = NSMakeRange(tempRange.location+tempRange.length, tempRangeOne.location-(tempRange.location+tempRange.length));
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
    // 更改字体
    // [strAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20] range:NSMakeRange(0, [strAtt length])];
    [strAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:fontSize] range:markRange];
    theLab.attributedText = strAtt;
//    [strAtt release];
}

/**
 *改变字符串中所有数字的颜色
 */
+ (void)setRichNumberWithLabel:(UILabel*)label Color:(UIColor *)color FontSize:(CGFloat)size {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSString *temp = nil;
    for(int i =0; i < [attributedString length]; i++) {
        temp = [label.text substringWithRange:NSMakeRange(i, 1)];
        if ([self isPureInt:temp]) {
            //            [attributedString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
            //                                             color, NSForegroundColorAttributeName,
            //                                             [UIFont systemFontOfSize:size],NSFontAttributeName, nil, nil]
            //                                      range:NSMakeRange(i, 1)];
            [attributedString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             color, NSForegroundColorAttributeName,
                                             [UIFont fontWithName:@"CourierNewPS-ItalicMT" size:size],NSFontAttributeName, nil, nil]
                                      range:NSMakeRange(i, 1)];
        }
    }
    label.attributedText = attributedString;
//    [attributedString release];
    
}
/**
 *判断字符串是否不全为空
 */
+ (BOOL)judgeStringIsNull:(NSString *)string
{
    if ([[string class] isSubclassOfClass:[NSNumber class]])
    {
        return YES;
    }
    BOOL result = NO;
    if (string != nil && string.length > 0)
    {
        for (int i = 0; i < string.length; i ++)
        {
            NSString *subStr = [string substringWithRange:NSMakeRange(i, 1)];
            if (![subStr isEqualToString:@" "] && ![subStr isEqualToString:@""])
            {
                result = YES;
            }
        }
    }
    return result;
}
/**
 *此方法是用来判断一个字符串是不是整型.
 *如果传进的字符串是一个字符,可以用来判断它是不是数字
 */
+ (BOOL)isPureInt:(NSString *)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int value;
    return [scan scanInt:&value] && [scan isAtEnd];
}
@end
