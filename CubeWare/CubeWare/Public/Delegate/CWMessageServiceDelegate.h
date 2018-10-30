//
//  CWMessageServiceDelegate.h
//  SPCubeWareDev
//
//  Created by jianchengpan on 2018/3/30.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CWSession;

@protocol CWMessageServiceDelegate <NSObject>

@optional

/**
 消息是否需要被显示
 
 @note 暂时只开放自定义消息给外部判断
 
 @param msg 待显示的消息
 @return 是否显示
 */
-(BOOL)needShowMessage:(CubeMessageEntity *)msg;

/**
 获取消息的摘要信息,返回nil，表示交由内部处理
 
 @param msg 待处理的消息
 @param session 消息所属会话
 @return 消息摘要
 */
-(NSString *)summaryOfMesssage:(CubeMessageEntity *)msg forSession:(CWSession *)session;

/**
 统计自定义消息的未读数量

 内部统计其余消息的未读数,不实现此方法，则忽略所有自定义消息的数量统计
 
 @param messages 自定义消息
 @param session 自定义消息所属会话
 @return 未读数
 */
-(NSInteger)unreadCountOfCustomMessages:(NSArray<CubeMessageEntity *> *)messages forSession:(CWSession *)session;

/**
 会话的未读数量即将改变
 
 代理实现此方法，会屏蔽内部的 '收到消息播放声音' 等功能
 
 @param oldUnreadCount 旧的未读数量
 @param newUnreadCount 新的未读数量
 @param session 改变的会话
 */
-(void)unreadCountWillChangeFrom:(NSInteger)oldUnreadCount to:(NSInteger)newUnreadCount forSession:(CWSession *)session;

/**
 所有未读消息数改变

 @param oldAllUnreadCount 旧的所有未读数量
 @param newAllUnreadCount 新的所有未读数量
 */
-(void)allUnreadCountChangeFrom:(NSInteger)oldAllUnreadCount to:(NSInteger)newAllUnreadCount;

/**
获取会话名称

 @param message 消息
 @param session 会话
 @return 会话名称
 */
-(NSString *)getSessionName:(CubeMessageEntity *)message forSession:(CWSession *)session;

/**
 获取会话是否需要更新

 @param message 消息
 @param session 会话
 @return 是否需要更新会话
 */
- (BOOL)shouldUpdateSessionWithMessage:(CubeMessageEntity *)message session:(CWSession *)session;

/**
 获取用户信息

 @param cubeId 用户cube
 @return 用户信息
 */
- (NSString *)getAvatorUrl:(NSString *)cubeId;
@end
