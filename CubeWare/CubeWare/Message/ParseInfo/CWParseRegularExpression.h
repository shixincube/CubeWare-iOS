//
//  CWParseRegularExpression.h
//  SPCubeWareDev
//
//  Created by jianchengpan on 2018/4/9.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWParseNodeType.h"

@interface CWParseRegularExpression : NSObject

@property (nonatomic, assign) CWParseNodeType parseType;

@property (nonatomic, copy) NSString *regularExpression;

+(CWParseRegularExpression *)parseRegularExpressionWithParseType:(CWParseNodeType)type andRegularExpression:(NSString *)regularExpression;

@end
