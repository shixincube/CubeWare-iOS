//
//  CWSession+WCDB.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWSession+WCDB.h"
#import "CubeMessageEntity+CWMessage.h"
@implementation CWSession (WCDB)

WCDB_IMPLEMENTATION(CWSession)

WCDB_SYNTHESIZE(CWSession,sessionId);
WCDB_SYNTHESIZE(CWSession,sessionType);
WCDB_SYNTHESIZE(CWSession,lastesTimestamp);
WCDB_SYNTHESIZE(CWSession,topped);
WCDB_SYNTHESIZE(CWSession,json);

WCDB_PRIMARY(CWSession,sessionId);

#pragma mark - diskCacheProtocol

+(NSString *)tableName
{
    return @"cw_session";
}

+(Class)tableClass
{
    return [self class];
}

@end

