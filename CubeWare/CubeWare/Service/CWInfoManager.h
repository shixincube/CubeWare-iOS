//
//  CWInfoManager.h
//  CubeWare
//
//  Created by jianchengpan on 2018/1/12.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CWSession;

@protocol CWInfoManagerDelegate

/**
 请求基础信息

 @discussion session为可选值，当session为空时，请求用户通用的信息，session不为空，请求在某个会话里面特定的用户信息
 
 @param cubeIds 需要提供信息的Cube号
 @param session 会话
 */
-(void)needUsersInfoFor:(NSArray<NSString *> *)cubeIds inSession:(CWSession *)session;

@end

@interface CWInfoManager : NSObject

@property (nonatomic, weak) id<CWInfoManagerDelegate> delegate;

/**
 更新用户信息

 @param users 用户信息列表
 @param session 会话
 */
-(void)updateUsersInfo:(NSArray<CWUserModel *> *)users inSession:(CWSession *)session;

#pragma mark - get cached base info

/**
 获取用户信息

 @param cubeId 用户ID
 @param session 会话
 @return 用户信息
 */
-(CWUserModel *)userInfoForCubeId:(NSString *)cubeId inSession:(CWSession *)session;

@end
