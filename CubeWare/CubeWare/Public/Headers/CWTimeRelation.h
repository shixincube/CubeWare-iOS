//
//  CWTimeRelation.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#ifndef CWTimeRelation_h
#define CWTimeRelation_h


/**
 时间关系

 - CWTimeRelationLessThan: 小于
 - CWTimeRelationLessThanOrEqual: 小于等于
 - CWTimeRelationGreaterThan: 大于
 - CWTimeRelationGreaterThanOrEqual: 大于等于
 */
typedef NS_ENUM(int, CWTimeRelation) {
    CWTimeRelationLessThan = 1,
    CWTimeRelationLessThanOrEqual = 2,
    CWTimeRelationGreaterThan = 3,
    CWTimeRelationGreaterThanOrEqual = 4
};

#endif /* CWTimeRelation_h */
