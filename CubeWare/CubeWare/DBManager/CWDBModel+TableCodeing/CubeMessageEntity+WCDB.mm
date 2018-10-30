//
//  CubeMessageEntity+WCDB.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/26.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CubeMessageEntity+WCDB.h"

@implementation CubeMessageEntity (WCDB)

#pragma mark - wcdb

WCDB_IMPLEMENTATION(CubeMessageEntity)
WCDB_SYNTHESIZE(CubeMessageEntity, SN);
WCDB_SYNTHESIZE(CubeMessageEntity, sessionId);
WCDB_SYNTHESIZE(CubeMessageEntity, type);
WCDB_SYNTHESIZE(CubeMessageEntity, messageDirection);
WCDB_SYNTHESIZE(CubeMessageEntity, timestamp);
WCDB_SYNTHESIZE(CubeMessageEntity, receipted);
WCDB_SYNTHESIZE(CubeMessageEntity, needShow);
WCDB_SYNTHESIZE(CubeMessageEntity, json);

WCDB_PRIMARY(CubeMessageEntity, SN);

#pragma mark - diskCacheProtocol

+(NSString *)tableName
{
    return @"cw_message";
}

+(Class)tableClass
{
    return [CubeMessageEntity class];
}

@end
