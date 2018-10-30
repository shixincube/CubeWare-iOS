//
//  CubeMessageEntity+CWMessage.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/26.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWParseInfo.h"

@interface CubeMessageEntity (CWMessage)

@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, copy) NSString *json;

@property (nonatomic, assign) BOOL needShow;

@property (nonatomic, strong) CWParseInfo *parseInfo;

+(instancetype)objectWithJson:(NSString *)jsonString;

@end
