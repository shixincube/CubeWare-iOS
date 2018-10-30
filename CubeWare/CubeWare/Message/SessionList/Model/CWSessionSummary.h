//
//  CWSessionSummary.h
//  CubeWare
//
//  Created by jianchengpan on 2018/9/4.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWParseNode.h"

@interface CWSessionSummary : NSObject<CubeJSONObject>

@property (nonatomic, assign) long long SN;

@property (nonatomic, assign) long long timestamp;

@property (nonatomic, copy) NSString *summary;

@end
