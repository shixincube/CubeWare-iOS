//
//  CWDBUtil.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWDBUtil.h"
@implementation CWDBUtil

+(WCTCondition)conditionWithTimestamp:(long long)timestamp andTimeRelation:(CWTimeRelation)relation forProperty:(const WCTProperty &)property{
    WCTCondition condition;
    switch (relation) {
        case CWTimeRelationGreaterThan:
            condition = property > timestamp;
            break;
        case CWTimeRelationGreaterThanOrEqual:
            condition = property >= timestamp;
            break;
        case CWTimeRelationLessThan:
            condition = property < timestamp;
            break;
        case CWTimeRelationLessThanOrEqual:
            condition = property <= timestamp;
            break;
    }
    return condition;
}

+(WCTOrderBy)conditionWithSortType:(CWSortType)sort forProperty:(const WCTProperty &)property{
    return property.order(sort == CWSortTypeDESC ?  WCTOrderedDescending : WCTOrderedAscending);
}

@end
