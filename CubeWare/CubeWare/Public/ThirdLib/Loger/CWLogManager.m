//
//  CubeWare+Options.m
//  CubeWare
//
//  Created by zhuguoqiang on 17/2/15.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWLogManager.h"

#ifdef DEBUG
static CWLoggingLevel kCWLoggingLevel = CWLoggingLevelDebug;
#else
static CWLoggingLevel kCWLoggingLevel = CWLoggingLevelInfo;
#endif

@implementation CWLogManager

+ (CWLoggingLevel) CW_loggingLevel;
{
    return kCWLoggingLevel;
}

+ (void) CW_setLoggingLevel:(CWLoggingLevel)level;
{
    kCWLoggingLevel = level;
}

@end
