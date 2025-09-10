//
//  MyCustomFormatter.m
//  LumberjackDemo
//
//  Created by Jackey on 2017/6/3.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "MyCustomFormatter.h"
#define timeZone_Project [NSTimeZone timeZoneWithAbbreviation:@"HKT"]
@implementation MyCustomFormatter
//保证只创建一次
-(NSDateFormatter*)getDateFormat
{
    static NSDateFormatter* format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[NSDateFormatter alloc] init];
        [format setTimeZone:timeZone_Project];

    });

    return format;
}
- (id)init {
    
    if((self = [super init])) {
        
        threadUnsafeDateFormatter = [self getDateFormat];
        [threadUnsafeDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
    }
    
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"Error   "; break;
        case DDLogFlagWarning  : logLevel = @"Warning "; break;
        case DDLogFlagInfo     : logLevel = @"Info    "; break;
        case DDLogFlagDebug    : logLevel = @"Debug   "; break;
        default                : logLevel = @"Default "; break;
    }
    
    NSString *dateAndTime = [threadUnsafeDateFormatter stringFromDate:(logMessage->_timestamp)];
    NSString *logMsg = logMessage->_message;
    
    return [NSString stringWithFormat:@"[ %@ %@ ] \n%@", logLevel, dateAndTime, logMsg];
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    
    loggerCount++;
    NSAssert(loggerCount <= 1, @"This logger isn't thread-safe");
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    
    loggerCount--;
}

@end
