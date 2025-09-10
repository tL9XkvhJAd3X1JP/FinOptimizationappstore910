//
//  NomalUtil.h
//  BaseProject
//
//  Created by janker on 2018/11/14.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NomalUtil : NSObject
+(NSString *)gb2312StringToString:(NSString *)content;
+(CGFloat) getViewContentHeight;
+(NSString *)getCurrentDate:(BOOL)isShowSecond;
+(NSString *)getCurrentDateWithFormat:(NSString *)content;
+ (NSInteger) getMonthOfDaysWithYear:(NSInteger) year month:(NSInteger) month;
+(NSString *)getCurrentTimeWithLongLongNum;
+ (UIImage *)imageWithColor:(UIColor *)color;
+(NSString *)getStringDateWithNSDate:(NSDate *)date;
+(NSString *)getStringDateWithNSDate1:(NSDate *)date;
+(NSString *)getStringDateWithNSDate2:(NSDate *)date;
+(NSString *)getStringDateWithNSDate3:(NSDate *)date;
+(NSString *)getStringDateWithNSDate4:(NSDate *)date;

+ (void)messageAction:(UILabel *)theLab changeStrings:(NSMutableArray *)changes andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor font:(UIFont *)font;
+ (void)messageAction:(UILabel *)theLab changeString:(NSString *)change andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor font:(UIFont *)font;
+ (void)messageAction:(UILabel *)theLab startString:(NSString *)start endString:(NSString *)end andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize;
+(BOOL) isValueableString:(NSString *)content;
+(BOOL) isValueableObject:(NSObject *)obj;
+(NSDate *)getNSDateWithNumString:(NSString *)time;
+(NSString *)getStringDateWithNSDate5:(NSDate *)date;
+(NSDate *)getNSDateWithSecondNumString:(NSString *)time;
+ (BOOL)isPhoneNum:(NSString *)phoneNum;
+ (BOOL) isValidateUserPwd : (NSString *) str;
+(BOOL)popToViewControllWithClassName:(NSString *)className;
+(NSString *)getUUID;
+(NSString *)urlEncodeStr:(NSString *)input;
+ (NSString *)decoderUrlEncodeStr: (NSString *) input;
//按字母顺序排序
+(NSArray *)dictionarySortByKeysNum:(NSDictionary *)dic;
//排顺序
+(NSData *)bodyDataSortByKey:(NSDictionary *)dic;
+(void)removeNullValue:(NSMutableDictionary *)dic;
+(BOOL)popToViewControllWithClassName:(NSString *)className animated:(BOOL)animated;
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
