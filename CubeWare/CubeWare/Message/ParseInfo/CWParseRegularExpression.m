//
//  CWParseRegularExpression.m
//  SPCubeWareDev
//
//  Created by jianchengpan on 2018/4/9.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import "CWParseRegularExpression.h"

@implementation CWParseRegularExpression

+(CWParseRegularExpression *)parseRegularExpressionWithParseType:(CWParseNodeType)type andRegularExpression:(NSString *)regularExpression{
	CWParseRegularExpression *re = [CWParseRegularExpression new];
	
	re.parseType = type;
	re.regularExpression = regularExpression;
	
	return re;
}

@end
