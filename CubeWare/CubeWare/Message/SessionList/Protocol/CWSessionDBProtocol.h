//
//  CWSessionDBProtocol.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSortType.h"
#import "CWTimeRelation.h"

@class CWSession;

/**
 会话数据协议
 */
@protocol CWSessionDBProtocol <NSObject>

/**
 保存一个会话

 @param session 待保存的会话
 @return 是否保存成功
 */
-(BOOL)saveOrUpdateSession:(CWSession *)session;

/**
 保存多个会话

 @param sessions 待保存的会话
 @return 是否保存成功
 */
-(BOOL)saveOrUpdateSessions:(NSArray *)sessions;

/**
 删除会话

 @param sessions 待删除的会话列表
 @return 删除结果
 */
-(BOOL)deleteSessions:(NSArray<CWSession *> *)sessions;

/**
 查询指定的会话

 @param sessionId 会话ID
 @return 查询到的会话
 */
-(CWSession *)sessionWithSessionId:(NSString *)sessionId;


/**
 按条件查询会话

 @param timestamp 时间
 @param relation 时间关系
 @param limit 结果条数限制 （-1表示无限制）
 @param sort 排序方式
 @param handler 完成结果
 */
-(void)sessionWithTimestamp:(long long)timestamp relatedBy:(CWTimeRelation)relation andLimit:(int)limit andSortBy:(CWSortType)sort withCompleteHandler:(void(^)(NSMutableArray<CWSession *> *))handler;

/**
 重新统计会话的未读数量

 @param session 待统计的会话
 @return 会话未读数
 */
-(NSInteger)unreadCountForSession:(CWSession *)session;

/**
 将某个session某个时间点之前(包括该时间点)的消息置为已读

 @param time 时间点
 @param session 相关session
 */
-(void)readedMessagesbefore:(long long )time inSession:(CWSession *)session;

@end
