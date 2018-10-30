//
//  CWSession+WCDB.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWSession.h"
#import <WCDB/WCDB.h>
#import "CWDiskCacheProtocol.h"

@interface CWSession (WCDB)<WCTTableCoding,CWDiskCacheProtocol>

WCDB_PROPERTY(sessionId);
WCDB_PROPERTY(sessionType);
WCDB_PROPERTY(lastesTimestamp);
WCDB_PROPERTY(topped);
WCDB_PROPERTY(json);

@end
