//
//  CWGroupDelegate.h
//  CubeWare
//
//  Created by pretty on 2018/9/3.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

@protocol CWGroupServiceDelegate <NSObject>
@optional
/**
 创建成功

 @param group 群组
 */
- (void)createGroup:(CubeGroup *)group from:(CubeUser *)from;

/**
 解散群组

 @param group 群组
 */
- (void)destroyGroup:(CubeGroup *)group from:(CubeUser *)from;

/**
 退出群组

 @param group 群组
 */
- (void)quitGroup:(CubeGroup *)group from:(CubeUser *)from;

/**
 更新群组信息

 @param group 群组
 */
- (void)updateGroup:(CubeGroup *)group from:(CubeUser *)from;

/**
 添加成员成功

 @param group 群组
 @param from 来源
 @param member 加入成员
 */
- (void)addMembersGroup:(CubeGroup *)group from:(CubeUser *)from Member:(NSArray *)member;

/**
 邀请成员成功

 @param group 群组
 @param from 来源
 @param member 已邀请成员
 */
- (void)inviteMembersGroup:(CubeGroup *)group from:(CubeUser *)from Member:(NSArray *)member;
/**
 群组服务错误

 @param error 错误
 */
- (void)groupFail:(CubeError *)error;
@end

