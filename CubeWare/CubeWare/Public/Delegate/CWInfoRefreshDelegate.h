//
//  CWUserInfoRefreshProtocol.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWUserModel.h"

@class CWSession;

@protocol CWInfoRefreshDelegate <NSObject>

@optional
/**
 当前用户切换

 @param user 最新用户
 */
-(void)changeCurrentUser:(CWUserModel *)user;

/**
 用户信息改变
 @discussion 当指定session时,只通知该会话用户信息更新，否则通知全部会话信息更新，一般用于更新指定群会话中个人昵称改变
 
 @param users 用户信息列表
 @param session 会话
 */
-(void)usersInfoUpdated:(NSArray<CWUserModel *> *)users inSession:(CWSession *)session;

@end
