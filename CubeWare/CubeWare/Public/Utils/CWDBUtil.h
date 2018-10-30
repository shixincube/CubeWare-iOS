//
//  CWDBUtil.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>
#import "CWTimeRelation.h"
#import "CWSortType.h"
@interface CWDBUtil : NSObject


/**
 生成时间条件

 @param timestamp 时间
 @param relation 时间比较关系
 @param property 需要比较的属性
 @return 生成的时间条件
 */
+(WCTCondition)conditionWithTimestamp:(long long)timestamp andTimeRelation:(CWTimeRelation)relation forProperty:(const WCTProperty &)property;


/**
 生成排序条件

 @param sort 排序方式
 @param property 需要排序的属性
 @return 排序条件
 */
+(WCTOrderBy)conditionWithSortType:(CWSortType)sort forProperty:(const WCTProperty &)property;

@end
