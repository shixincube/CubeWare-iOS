//
//  CubeMessageEntity+WCDB.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/26.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CubeMessageEntity+CWMessage.h"
#import "CWDiskCacheProtocol.h"
#import <WCDB/WCDB.h>

@interface CubeMessageEntity (WCDB)<WCTTableCoding,CWDiskCacheProtocol>

WCDB_PROPERTY(SN);
WCDB_PROPERTY(sessionId);
WCDB_PROPERTY(type);
WCDB_PROPERTY(messageDirection);
WCDB_PROPERTY(timestamp);
WCDB_PROPERTY(receipted);
WCDB_PROPERTY(needShow);
WCDB_PROPERTY(json);

@end
