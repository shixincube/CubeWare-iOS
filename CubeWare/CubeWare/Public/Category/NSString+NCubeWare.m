//
//  NSString+NCubeWare.m
//  CubeWare
//
//  Created by luchuan on 2018/1/9.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "NSString+NCubeWare.h"

@implementation NSString (NCubeWare)

+(instancetype)stringWithTimeInterval:(NSTimeInterval) duration{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:duration];
    NSDateFormatter * datefmt = [[NSDateFormatter alloc] init];
    datefmt.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    datefmt.dateFormat = @"HH:mm:ss";
    return [datefmt stringFromDate:date];
}

@end
