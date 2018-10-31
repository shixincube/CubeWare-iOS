//
//  CDContactsManager.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/14.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDContactsManager.h"

@implementation CDContactsManager

+ (CDContactsManager *)shareInstance
{
    static CDContactsManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CDContactsManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.grouplist = [NSMutableArray array];
    }
    return self;
}

- (void)getFriendList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *loginInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLogin"];
        NSString *appId = [loginInfoDic objectForKey:@"appId"];
        NSString *cubeId = [loginInfoDic objectForKey:@"cubeId"];
        NSString *queryCubeIdByAppId = [NSString stringWithFormat:@"%@%@",CDServiceHost,QueryCubeIdListByAppId];
        NSDictionary *params = @{
                                 @"appId":appId,
                                 @"page":@(0),
                                 @"rows":@(100)
                                 };

        [[AFHTTPSessionManager manager] POST:queryCubeIdByAppId parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *accountList = responseObject[@"data"][@"list"];
                NSMutableArray *accountModelList = [NSMutableArray array];
                for (NSDictionary *dic in accountList) {
                    CDLoginAccountModel *model = [CDLoginAccountModel fromDictionary:dic];
                    if (![model.cubeId isEqualToString:cubeId]) {
                        [accountModelList addObject:model];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CDShareInstance sharedSingleton].friendList = accountModelList;
                });
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];
    });
}

- (void)getGroupList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[CubeEngine sharedSingleton].groupService queryGroups:0 andCount:100 andBlock:^(CubeGroupQuery *groupQuery) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.grouplist removeAllObjects];
                [self.grouplist addObjectsFromArray:groupQuery.groups];
            });
        }];
    });
}

@end
