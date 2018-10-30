//
//  CWTimeUtil.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWTimeUtil.h"

@implementation CWTimeUtil

+(long long)currentTimestampe{
    return [[NSDate date] timeIntervalSince1970] * 1000;
}

+(CWTimeSystemHR)getTimeSystemHR{
    static CWTimeSystemHR type = CWTimeSystemUnKnown;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSString *formatStringForHours=[NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
        NSRange containsA=[formatStringForHours rangeOfString:@"a"];
        BOOL hasAMPM=containsA.location!=NSNotFound;//true->12小时
        if (hasAMPM) {
            type = CWTimeSystem12HR;
        }else{
            type = CWTimeSystem24HR;
        }
    });

    return type;
}

@end
