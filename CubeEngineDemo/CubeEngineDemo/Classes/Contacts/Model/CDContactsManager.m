//
//  CDContactsManager.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/14.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDContactsManager.h"
@interface CDContactsManager()

/**
 群组信息  key :groupid
 */
//@property (nonatomic,assign) NSMutableDictionary *groupDic;
@end

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
//        self.groupDic = [NSMutableDictionary dictionary];
         [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWGroupServiceDelegate)]];
    }
    return self;
}

- (void)queryFriendList
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

- (void)queryGroupList
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

- (CubeGroup *)getGroupInfo:(NSString *)groupId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupId=%@",groupId];
    NSArray *array = [self.grouplist filteredArrayUsingPredicate:predicate];
    CubeGroup *group = array.firstObject;
    if (group) {
        return group;
    }
    return nil;
}

- (CDLoginAccountModel *)getFriendInfo:(NSString *)cubeId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cubeId=%@",cubeId];
    NSArray *array = [[CDShareInstance sharedSingleton].friendList filteredArrayUsingPredicate:predicate];
    CDLoginAccountModel *model = array.firstObject;
    if (model) {
        return model;
    }
    return nil;
}

#pragma mark -
- (void)updateGrouplist
{
    [self queryGroupList];
}
@end
