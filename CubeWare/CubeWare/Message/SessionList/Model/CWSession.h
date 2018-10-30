//
//  CWSession.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSessionType.h"
#import "CWMessageServiceDelegate.h"
#import "CWSessionInfoReportor.h"

@class CubeMessageEntity;

@interface CWSession : NSObject<CWSessionInfoReportor>

/**
 会话ID
 */
@property (nonatomic, copy) NSString *sessionId;

/**
 合适的显示名称
 */
@property (nonatomic, readonly) NSString *appropriateName;

/**
 会话类型
 */
@property (nonatomic, assign) CWSessionType sessionType;

/**
 最新消息摘要
 */
@property (nonatomic, copy) NSString *summary;

/**
会话名称
 */
@property (nonatomic,copy) NSString *sessionName;

/**
 最新消息时间
 */
@property (nonatomic, assign) long long lastesTimestamp;

/**
 未读消息数
 */
@property (nonatomic, assign) int unReadCount;

/**
 是否置顶
 */
@property (nonatomic, assign) BOOL topped;

/**
 消息cell是否需要显示昵称
 */
@property (nonatomic, assign) BOOL showNickName;

/**获取json字符串*/
@property (nonatomic, copy) NSString *json;

/**
会议类型
 */
@property (nonatomic,copy) NSString *conferenceType;
/**
 创建会话

 @param sessionId 会话ID
 @param type 会话类型
 @return 会话
 */
-(instancetype)initWithSessionId:(NSString *)sessionId andType:(CWSessionType)type;

/**
 使用消息更新会话

 @param message 消息的时间戳大于会话记录的时间戳才会更新会话信息
 @param helper 获取消息摘要的帮助类
 */
-(void)updateWithMessage:(CubeMessageEntity *)message andSummeryHelper:(id<CWMessageServiceDelegate>)helper;

#pragma mark - session info repotor

/**
 注册成为session的信息报告器
 
 @note 外部谨慎使用，否者可能会导致信息统计错误
 */
-(void)registerAsSessionInfoRepotor;

@end
