//
//  CWGroupService.h
//  CubeWare
//
//  Created by pretty on 2018/8/31.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWGroupDelegate.h"

@interface CWGroupService : NSObject<CubeGroupServiceDelegate>
/**
 创建群组

 @param config 群组信息
 */
- (BOOL)createGroupWithGroup:(CubeGroupConfig *)config;

/**
 添加组成员

 @param groupId 群组Id
 @param members 群成员
 */
- (BOOL)addMembersWithGroupId:(NSString *)groupId withMembers:(NSArray <NSString *>*)members;

/**
 邀请成员

 @param groupId 群组ID
 @param members 成员
 @return 是否操作成功
 */
- (BOOL)inviteMembersWithGroupId:(NSString *)groupId withMembers:(NSArray <NSString *>*)members;
/**
 申请加入群

 @param groupId 群组ID
 @return 是否发送指令成功
 */
- (BOOL)applyJoinGroupWithGroupId:(NSString *)groupId;

/**
 更新群组

 @param group 群组
 @return 是否发送成功
 */
- (BOOL)updateGroup:(CubeGroup *)group;
@end
