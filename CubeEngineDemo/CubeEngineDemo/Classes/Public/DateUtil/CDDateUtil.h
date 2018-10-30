//
//  CDDateUtil.h
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/19.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDDateUtil : NSObject

/**
 将数字 转为星期几 eg : 1 -> 星期天

 @param week 数字描述
 @return 星期几
 */
+ (NSString *)convertToWeekStringWithCalenderWeek:(NSUInteger )week;

/**
 将小于10的数字转为0开头前缀双位数字符串 eg: 1 -> 01

 @param input 数字输入
 @return 双位数字符串
 */
+ (NSString *)convertToZeroPrefixString:(NSUInteger )input;

/**
 将date转为格式字符串 eg:date -> “2018年9月20日 周三 16:00”

 @param date 输入date
 @return 格式字符串
 */
+ (NSString *)convertToFormatDateString:(NSDate *)date;

/**
 将分钟毫秒时长 转为分钟格式字符串 eg:15 * 60 * 1000 -> 15分钟

 @param timeInterval 输入毫秒
 @return 分钟格式字符串
 */
+ (NSString *)convertToMinutesFormatString:(NSTimeInterval )timeInterval;
@end
