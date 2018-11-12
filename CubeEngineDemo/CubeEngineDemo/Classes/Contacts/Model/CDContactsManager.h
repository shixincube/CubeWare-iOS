//
//  CDContactsManager.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/14.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDContactsManager : NSObject
+ (CDContactsManager *)shareInstance;

/**
 群组列表
 */
@property (nonatomic,strong) NSMutableArray * grouplist;

/**
 获取群组列表
 */
- (void)queryGroupList;

/**
获取好友列表
 */
- (void)queryFriendList;

/**
 获取对应群组信息

 @param groupId 群组ID
 @return 群组
 */
- (CubeGroup *)getGroupInfo:(NSString *)groupId;


/**
 获取对应用户信息

 @param cubeId 用户Cube
 @return 用户信息
 */
- (CDLoginAccountModel *)getFriendInfo:(NSString *)cubeId;


@end
