//
//  CWLogFormatter.m
//  CubeWare
//
//  Created by zhuguoqiang on 17/1/14.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWLogFormatter.h"

//@implementation CWLogFormatter
//
//#pragma mark - DDLogFormatter
//
//- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
//    NSString *logLevel = nil;
//    switch (logMessage->_flag)
//    {
//        case DDLogFlagError:
//            logLevel = @"ERROR";
//            break;
//        case DDLogFlagWarning:
//            logLevel = @"WARN";
//            break;
//        case DDLogFlagInfo:
//            logLevel = @"INFO";
//            break;
//        case DDLogFlagDebug:
//            logLevel = @"DEBUG";
//            break;
//        default:
//            logLevel = @"VERBOSE";
//            break;
//    }
//    NSString *timeStr = [self formatTime:logMessage.timestamp];
//    
//#if DEBUG
//    NSString *formatStr = [NSString stringWithFormat:@"%@ %@[%@:%@] [%@] (%@:%lu) %@"
//                           ,timeStr,
//                           logMessage.tag, logMessage.threadName,
//                           logMessage.threadID, logLevel,
//                           logMessage.fileName,
//                           (unsigned long)logMessage->_line,
//                           logMessage->_message];
//    
//#else
//    NSString *formatStr = [NSString stringWithFormat:@"%@ %@[%@:%@] [%@] %@"
//                           ,timeStr, logMessage.tag,
//                           logMessage.threadName,
//                           logMessage.threadID, logLevel,
//                           logMessage->_message];
//#endif
//    return formatStr;
//}
//
//- (NSString *)formatTime:(NSDate *)date
//{
//    int len;
//    char ts[24] = "";
//    size_t tsLen = 0;
//    NSUInteger calendarUnitFlags = (NSCalendarUnitYear     |
//                                    NSCalendarUnitMonth    |
//                                    NSCalendarUnitDay      |
//                                    NSCalendarUnitHour     |
//                                    NSCalendarUnitMinute   |
//                                    NSCalendarUnitSecond);
//    
//    // Calculate timestamp.
//    // The technique below is faster than using NSDateFormatter.
//    if (date) {
//        NSDateComponents *components = [[NSCalendar autoupdatingCurrentCalendar] components:calendarUnitFlags fromDate:date];
//        
//        NSTimeInterval epoch = [date timeIntervalSinceReferenceDate];
//        int milliseconds = (int)((epoch - floor(epoch)) * 1000);
//        
//        len = snprintf(ts, 24, "%04ld-%02ld-%02ld %02ld:%02ld:%02ld:%03d", // yyyy-MM-dd HH:mm:ss:SSS
//                       (long)components.year,
//                       (long)components.month,
//                       (long)components.day,
//                       (long)components.hour,
//                       (long)components.minute,
//                       (long)components.second, milliseconds);
//        
//        tsLen = (NSUInteger)MAX(MIN(24 - 1, len), 0);
//    }
//    
//    NSString *str = [NSString stringWithUTF8String:ts];
//    return  str;
//}
//
//@end
