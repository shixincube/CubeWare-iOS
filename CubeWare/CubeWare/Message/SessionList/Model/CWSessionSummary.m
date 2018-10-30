//
//  CWSessionSummary.m
//  CubeWare
//
//  Created by jianchengpan on 2018/9/4.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CWSessionSummary.h"

@implementation CWSessionSummary

+ (id)fromDictionary:(NSDictionary *)dic {
	return [CubeJsonUtil generateObjectOfClass:[self class] fromDictionary:dic];
}

- (NSMutableDictionary *)toDictionary {
	return [CubeJsonUtil translateObjectToDictionay:self];
}

@end
