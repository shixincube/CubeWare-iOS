//
//  CDDateUtil.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/19.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDDateUtil.h"

@implementation CDDateUtil

+(NSString *)convertToWeekStringWithCalenderWeek:(NSUInteger)week{
    NSString *weekString;
    switch (week) {
        case 1:
            weekString = @"星期天";
            break;
        case 2:
            weekString = @"星期一";
            break;
        case 3:
            weekString = @"星期二";
            break;
        case 4:
            weekString = @"星期三";
            break;
        case 5:
            weekString = @"星期四";
            break;
        case 6:
            weekString = @"星期五";
            break;
        case 7:
            weekString = @"星期六";
            break;
        default:
            break;
    }
    return weekString;
}

+ (NSString *)convertToZeroPrefixString:(NSUInteger )input{
    NSString *ret;
    if (input < 10) {
        ret = [NSString stringWithFormat:@"0%lu",input];
    }
    else{
        ret = [NSString stringWithFormat:@"%lu",input];
    }
    return ret;
}


+ (NSString *)convertToFormatDateString:(NSDate *)date{
    if (!date) {
        date = [NSDate date];
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger year = [calendar component:NSCalendarUnitYear fromDate:date];
    NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:date];
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:date];
    NSInteger hour = [calendar component:NSCalendarUnitHour fromDate:date];
    NSInteger minute = [calendar component:NSCalendarUnitMinute fromDate:date];
    NSInteger week = [calendar component:NSCalendarUnitWeekday fromDate:date];
    NSString *weekString = [CDDateUtil convertToWeekStringWithCalenderWeek:week];
    NSString *hourString = [CDDateUtil convertToZeroPrefixString:hour];
    NSString *minuteString = [CDDateUtil convertToZeroPrefixString:minute];
    
    NSString *showString = [NSString stringWithFormat:@"%zd年%zd月%zd日 %@ %@:%@",year,month,day,weekString,hourString,minuteString];
    NSLog(@"----- select string : %@",showString);
    return showString;
}

+(NSString *)convertToMinutesFormatString:(NSTimeInterval)timeInterval{
    if (timeInterval) {
        return [NSString stringWithFormat:@"%.0lf分钟",timeInterval / 60000];
    }
    return @"0分钟";
}

@end
