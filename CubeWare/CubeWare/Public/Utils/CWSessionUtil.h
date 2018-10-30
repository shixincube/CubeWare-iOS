//
//  CWSessionUtil.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSession.h"
#import "CWTimeUtil.h"
#import "CWMessageUtil.h"

@interface CWSessionUtil : NSObject

#pragma mark - message cell

/**
 获取显示内容需要的cell类

 @param content 显示内容
 @return 显示类
 */
+(Class)cellClassForContent:(id)content;

#pragma mark - session

/**
 获取消息所属的会话的ID

 @param msg 判断消息消息
 @return 会话ID
 */
+(NSString *)sessionIdForMessage:(CubeMessageEntity *)msg;

/**
 获取消息所属会话的类型

 @param msg 待判断消息
 @return 会话类型
 */
+(CWSessionType)sessionTypeForMessage:(CubeMessageEntity *)msg;

/**
 使用消息创建会话

 @param msg 源消息
 @return 会话
 */
+(CWSession *)sessionWithMessage:(CubeMessageEntity *)msg;

/**
 获取消息摘要

 @param msg 待处理的消息
 @return 消息摘要
 */
+(NSString *)sessionSummaryWithMessage:(CubeMessageEntity *)msg;

#pragma mark - sort

/**
 排序指定的会话列表

 @param sessions 待处理的会话列表
 @return 排序后的列表
 */
+(NSMutableArray *)sortSessions:(NSMutableArray *)sessions;

/**
 反转消息列表，并根据提供的时间间隔添加时间节点指示，添加的时间节点为NSNumber类型
 
 @param messages 待处理的消息列表
 @param interval 添加时间节点指示的时间间隔(单位 seconds)
 @param basis 基准消息，以此消息作为起点，计算时间节点，不提供，则使用消息列表里面的最后一个作为基准消息
 @return 处理结果
 */
+(NSMutableArray *)revertMessages:(NSMutableArray *)messages withTimeIndicateInterval:(int)interval onBasisOf:(CubeMessageEntity *)basis;

#pragma mark - time

/**
 获取指定--消息时间戳--格式化后的时间字符串

 @param timestamp 待处理的时间戳(ms)
 @return 格式化后的字符串
 */
+(NSString *)messageTimeStringWithTimestamp:(long long)timestamp;

/**
 获取指定--会话时间戳--格式化后的时间字符串
 
 @param timestamp 待处理的时间戳（ms）
 @return 格式化的时间字符串
 */
+(NSString *)sessionTimeStringWithTimestamp:(long long)timestamp;

/**
 获取通知类消息

 @param msg 消息体
 @return 通知消息
 */
+ (NSString *)sessionTipStringWith:(CubeMessageEntity *)msg;

@end
