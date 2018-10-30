//
//  CWMessageService.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWMessageServiceDelegate.h"
#import "CWCustomMessageType.h"
#import "CWFileService.h"

@protocol CWSessionInfoReportor;

@interface CWMessageService : NSObject<CubeMessageServiceDelegate,CWFileServiceDelegate>

@property (nonatomic, assign) int allUnreadCount;

@property (nonatomic, weak) id<CWMessageServiceDelegate> delegate;

#pragma mark - collection info

/**
 重新(从CWSessionInfoReportor)收集未读信息
 */
-(void)collectionUnreadCountInfo;

#pragma mark - send new message

/**
 发送消息

 @param message 消息
 @param session 消息所属会话
 */
-(void)sendMessage:(CubeMessageEntity *)message forSession:(CWSession *)session;


///**
// 发送音视频处理的提示消息
//
// @param body 消息内容
// @param type 消息类型
// @param session 消息会话
// */
//- (void)sendAVMsbody:(NSString *)body type:(CWCustomMessageType)type forSession:(CubeSession *)session;



/**
 删除消息

 @param message 消息体
 @param session 会话
 */
- (void)deleteMessage:(CubeMessageEntity *)message forSession:(CWSession *)session;

#pragma mark - manage message

/**
 重发消息
 
 @param msg 待重发的消息
 @return 是否处理成功
 */
- (BOOL)resendMessage:(CubeMessageEntity *)msg;

/**
 撤回消息

 @param msg 待撤回消息
 @return 是否处理成功
 */
- (BOOL)recallMessage:(CubeMessageEntity *)msg;

#pragma mark - manage session

/**
 更新会话
 
 手动更新会话后，调用此方法通知内部更新和保存
 
 @param sessions 待处理的更新
 */
-(void)updateSessions:(NSArray<CWSession *> *)sessions;

/**
 删除会话

 @param sessions 待删除的会话
 */
-(void)deleteSessions:(NSArray<CWSession *> *)sessions;

/**
 重置会话的消息未读数
 重置消息的回执属性，保存更新后的会话，并发送回执消息 (-sendReceiptInfoForSession:)
 
 @param session 待处理的会话
 */
-(void)resetSessionUnreadCount:(CWSession *)session;

/**
 发送会话的回执信息
 
 提供消息，则使用提供的消息去发送回执，否则查询最新的消息去发送回执
 @param session 会话
 @param message 消息(为nil，则查询最近收到的消息，去发送回执)
 */
-(void)sendReceiptInfoForSession:(CWSession *)session withMessage:(CubeMessageEntity *)message;

/**
 处理在统一会话里面的消息更新
 
 @note 消息列表要求降序排序
 @param messages 待处理的消息
 */
- (void)processMessagesInSameSession:(NSArray *)messages;

@end
