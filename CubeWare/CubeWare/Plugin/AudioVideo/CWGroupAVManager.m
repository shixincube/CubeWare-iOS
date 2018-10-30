//
//  CWGroupAVManager.m
//  CubeWare
//
//  Created by Mario on 2017/7/7.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWGroupAVManager.h"

@implementation CWGroupAVManager

- (instancetype)init{
    self=[super init];
    if(self)
    {
        
    }
    return self;
}

+ (CWGroupAVManager *)sharedSingleton
{
    static CWGroupAVManager *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)pushGroupAVStackKey:(NSString *)groupCube andObject:(CubeConference *)confe
{
    if (groupCube) {
        [self.conferenceDic setObject:confe forKey:groupCube];
    }
}

-(CubeConference *)getGroupAVStack:(NSString *)groupCube
{
    if (groupCube) {
        return [self.conferenceDic objectForKey:groupCube];
    }
    return nil;
}

-(void)remove:(NSString *)groupCube
{
    if (groupCube) {
        [self.conferenceDic removeObjectForKey:groupCube];
    }
}

-(void)removeAll
{
    [self.conferenceDic removeAllObjects];
}

-(NSMutableDictionary *)conferenceDic
{
    if (!_conferenceDic) {
        _conferenceDic = [[NSMutableDictionary alloc] init];
    }
    return _conferenceDic;
}

-(NSMutableDictionary *)memberDic
{
    if (!_memberDic) {
        _memberDic = [[NSMutableDictionary alloc] init];
    }
    return _memberDic;
}

@end
