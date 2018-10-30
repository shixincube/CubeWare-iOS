//
//  CWMessageDBProtocol.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWTimeRelation.h"
#import "CWSortType.h"
@class CubeMessageEntity;

/**
 消息数据协议
 */
@protocol CWMessageDBProtocol <NSObject>

/**
 插入或修改一条数据
 
 @param msg 待插入的消息
 @return 是否更新成功
 */
-(BOOL)saveOrUpdateMessage:(CubeMessageEntity *)msg;

/**
 插入多条消息
 
 @param msgs 待插入的消息列表
 @return 是否更新成功
 */
-(BOOL)saveOrUpdateMessages:(NSArray<CubeMessageEntity *> *)msgs;

/**
 查询指定消息
 
 @param SN 消息ID
 @return 消息
 */
-(CubeMessageEntity *)messageWithMessageSN:(long long)SN;

/**
 按条件查询消息
 
 @param timestamp 时间
 @param relation 时间关系
 @param limit 数量限制(limit < 0表示无数量限制)
 @param sort 查询结果排序方式
 @param sessionId 会话ID
 @return 查询的消息列表
 */
-(NSMutableArray<CubeMessageEntity *> *)messagesWithTimestamp:(long long)timestamp relatedBy:(CWTimeRelation)relation andLimit:(int)limit andSortBy:(CWSortType)sort forSession:(NSString *)sessionId;

/**
 异步条件查询消息
 
 @param timestamp 时间
 @param relation 时间关系
 @param limit 数量限制(limit < 0表示无数量限制)
 @param sort 查询结果按时间的排序方式
 @param sessionId 会话ID
 @param handler 查询结果回掉
 */
-(void)messagesWithTimestamp:(long long)timestamp relatedBy:(CWTimeRelation)relation andLimit:(int)limit andSortBy:(CWSortType)sort forSession:(NSString *)sessionId withCompleteHandler:(void(^)(NSMutableArray<CubeMessageEntity *> *))handler;

/**
 按条件查询特定类型的消息

 @param type 消息类型
 @param timestamp 时间
 @param relation 时间关系
 @param limit 数量限制(limit < 0表示无数量限制)
 @param sort 查询结果按时间的排序方式
 @param sessionId 会话ID ,如果为空，则查询本地所有该类型的消息
 @return 查询结果
 */
-(NSMutableArray<CubeMessageEntity *> *)messagesWithType:(CubeMessageType)type andTimestamp:(long long)timestamp relatedBy:(CWTimeRelation)relation andLimit:(int)limit andSortBy:(CWSortType)sort forSession:(NSString *)sessionId;

/**
 异步按条件查询特定类型的消息
 
 @param type 消息类型
 @param timestamp 时间
 @param relation 时间关系
 @param limit 数量限制(limit < 0表示无数量限制)
 @param sort 查询结果按时间的排序方式
 @param sessionId 会话ID 如果为空，则查询本地所有该类型的消息
 @param handler 查询结果回掉
 */
-(void)messagesWithType:(CubeMessageType)type andTimestamp:(long long)timestamp relatedBy:(CWTimeRelation)relation andLimit:(int)limit andSortBy:(CWSortType)sort forSession:(NSString *)sessionId withCompleteHandler:(void(^)(NSMutableArray<CubeMessageEntity *> *))handler;

/**
 会话最近收到的消息

 @param sessionId 会话ID
 @return 消息
 */
-(CubeMessageEntity *)latestReceivedMessageForSession:(NSString *)sessionId;

/**
 会话中最早一条未读消息

 @param sessionId 会话id
 @return 未读消息
 */
-(CubeMessageEntity *)oldestUnreadMessageForSession:(NSString *)sessionId;

/**
 删除数据库中某一条消息

 @param SN 消息SN
 @return 是否删除成功
 */
-(BOOL)deleteMessageWithMessageSN:(long long)SN;

#pragma mark - count message

/**
 会话中某条消息(包括此消息)以后的有效消息(需要显示在界面上的)数量

 @param message 比较消息
 @param sessionId 会话ID
 @return 消息数量
 */
-(NSInteger)countMessagesAfter:(CubeMessageEntity *)message inSession:(NSString *)sessionId;

@end
