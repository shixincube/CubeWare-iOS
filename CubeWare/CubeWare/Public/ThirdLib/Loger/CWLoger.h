//
//  CWLoger.h
//  CubeWare
//
//  Created by zhuguoqiang on 17/1/14.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#ifndef CWLoger_h
#define CWLoger_h

#define CW_LOG_LEVEL_DEF (DDLogLevel)[CWLogManager CW_loggingLevel]

#import "CocoaLumberjack.h"
#import "CWLogManager.h"
#import "CWLogFormatter.h"

static NSString *gs_CWLogTag = @"CubeWare";

#define CW_LOG_TAG gs_CWLogTag

#define CW_LOG_CONTEXT 0

#define CWLogError(frmt, ...)   LOG_MAYBE(NO,                CW_LOG_LEVEL_DEF, (DDLogFlag)CWLoggingFlagError,   CW_LOG_CONTEXT, CW_LOG_TAG, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define CWLogWarn(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, CW_LOG_LEVEL_DEF, (DDLogFlag)CWLoggingFlagWarn, CW_LOG_CONTEXT, CW_LOG_TAG, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define CWLogInfo(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, CW_LOG_LEVEL_DEF, (DDLogFlag)CWLoggingFlagInfo,    CW_LOG_CONTEXT, CW_LOG_TAG, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define CWLogDebug(frmt, ...)   LOG_MAYBE(LOG_ASYNC_ENABLED, CW_LOG_LEVEL_DEF, (DDLogFlag)CWLoggingFlagDebug,   CW_LOG_CONTEXT, CW_LOG_TAG, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define CWLogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, CW_LOG_LEVEL_DEF, (DDLogFlag)CWLoggingFlagVerbose, CW_LOG_CONTEXT, CW_LOG_TAG, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#endif /* CWLoger_h */
