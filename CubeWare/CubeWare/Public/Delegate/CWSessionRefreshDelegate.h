//
//  CWSessionRefreshProtocol.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CubeMessageEntity;
@class CWSession;

@protocol CWSessionRefreshProtocol <NSObject>

@optional
/**
 某个会话里面消息有更新(增、删、改)
 返回是否能处理这些消息,返回YES，表示消息已被处理，取消对消息的未读数量统计

 @param messages 待处理的消息列表,按时间戳降序排序
 @param session 消息所属会话
 @return 是否已处理
 */
-(BOOL)messagesUpdated:(NSArray<CubeMessageEntity *> *)messages forSession:(CWSession *)session;

/**
 会话已更新

 @param sessions 更新的会话列表
 */
-(void)sessionsUpdated:(NSArray<CWSession *> *)sessions;

/**
 会话删除通知

 @param sessions 已删除的会话
 */
-(void)sessionsDeleted:(NSArray<CWSession *> *)sessions;

@end
