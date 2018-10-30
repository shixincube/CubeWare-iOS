//
//  CDShareInstance.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/8/29.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDShareInstance.h"

@implementation CDShareInstance

+ (CDShareInstance *)sharedSingleton{
    static CDShareInstance *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CDShareInstance alloc] init];
    });
    return instance;
}


-(NSArray *)friendList{
    NSMutableArray *ret = [NSMutableArray array];
    for (CDLoginAccountModel *model in _friendList) {
        if (![model.cubeId isEqualToString:_loginModel.cubeId]) {
            [ret addObject:model];
        }
    }
    return ret;
}

@end
