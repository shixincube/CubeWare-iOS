//
//  CubeWare+Options.h
//  CubeWare
//
//  Created by zhuguoqiang on 17/2/15.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, CWLoggingFlag)
{
    /** Log all errors */
    CWLoggingFlagError = 1 << 0,
    
    /** Log warnings, and all errors */
    CWLoggingFlagWarn = 1 << 1,
    
    /** Log informative messagess, warnings and all errors */
    CWLoggingFlagInfo = 1 << 2,
    
    /** Log debugging messages, informative messages, warnings and all errors */
    CWLoggingFlagDebug = 1 << 3,
    
    /** Log verbose diagnostic information, debugging messages, informative messages, messages, warnings and all errors */
    CWLoggingFlagVerbose = 1 << 4,
};

typedef NS_ENUM (NSUInteger, CWLoggingLevel)
{
    /** Don't log anything */
    CWLoggingLevelOff = 0,
    
    /** Log all errors and fatal messages */
    CWLoggingLevelError = (CWLoggingFlagError),
    
    /** Log warnings, errors and fatal messages */
    CWLoggingLevelWarn = (CWLoggingLevelError | CWLoggingFlagWarn),
    
    /** Log informative, warning and error messages */
    CWLoggingLevelInfo = (CWLoggingLevelWarn | CWLoggingFlagInfo),
    
    /** Log all debugging, informative, warning and error messages */
    CWLoggingLevelDebug = (CWLoggingLevelInfo | CWLoggingFlagDebug),
    
    /** Log verbose diagnostic, debugging, informative, warning and error messages */
    CWLoggingLevelVerbose = (CWLoggingLevelDebug | CWLoggingFlagVerbose),
    
    /** Log everything */
    CWLoggingLevelAll = NSUIntegerMax
};

@interface CWLogManager : NSObject

+ (CWLoggingLevel)CW_loggingLevel;

+ (void)CW_setLoggingLevel:(CWLoggingLevel)level;

@end
