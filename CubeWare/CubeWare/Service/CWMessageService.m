//
//  CWMessageService.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWMessageService.h"

#import "CWMessageDBProtocol.h"
#import "CWSessionDBProtocol.h"
#import "CWSessionRefreshDelegate.h"
#import "CWFileRefreshDelegate.h"
#import "CWSessionInfoReportor.h"

#import "CWSessionUtil.h"
#import "CWMessageUtil.h"
#import "CWMessageRinging.h"
#import "CWWorkerFinder.h"

static dispatch_queue_t cubeware_message_queue = NULL;

@implementation CWMessageService

-(instancetype)init{
	if(self = [super init])
	{
		cubeware_message_queue = dispatch_queue_create("cubeware_message_queue", DISPATCH_QUEUE_SERIAL);
		[[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWFileServiceDelegate)]];
	}
	return self;
}

#pragma mark - collection info
-(void)collectionUnreadCountInfo{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		int unreadCount = 0;
		for (id<CWSessionInfoReportor> repotor in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWSessionInfoReportor)]) {
			unreadCount += [repotor reportUnreadCountForSession:nil];
		}
        for (id<CWMessageServiceDelegate> repotor in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWMessageServiceDelegate)]) {
            [repotor allUnreadCountChangeFrom:self.allUnreadCount to:unreadCount];
        }
		self.allUnreadCount = unreadCount;
	});
}

#pragma mark - send new message
-(void)sendMessage:(CubeMessageEntity *)message forSession:(CWSession *)session{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if([[CubeEngine sharedSingleton].messageService sendMessage:message])
		{
			[self processMessagesInSameSession:@[message]];
		}
	});
}

//- (void)sendAVMsbody:(NSString *)body type:(CWCustomMessageType)type forSession:(CubeSession *)session{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        CubeCustomMessage *customMessage = [CWMessageUtil avMsgCustomMessageForSession:session body:body type:type];
//        customMessage.status = CubeMessageStatusSucceed;
//        [self processMessagesInSameSession:@[customMessage]];
//    });
//}

- (void)deleteMessage:(CubeMessageEntity *)message forSession:(CWSession *)session
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[CubeEngine sharedSingleton].messageService deleteMessage:message.SN]) {
            id<CWMessageDBProtocol> msgDB = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWMessageDBProtocol)] firstObject];
            BOOL ret =  [msgDB deleteMessageWithMessageSN:message.SN];
            if (ret) {
                //获取session
                message.needShow = NO;
                id<CWSessionDBProtocol> sessionDB = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWSessionDBProtocol)] lastObject];
                NSArray *messages = [msgDB messagesWithTimestamp:[CWTimeUtil currentTimestampe] relatedBy:CWTimeRelationLessThan andLimit:10 andSortBy:CWSortTypeDESC forSession:session.sessionId];
                CubeMessageEntity *lastMessage = [messages firstObject];
                CWSession *session = [self sessionForMessage:lastMessage];
                [self updateSessions:@[session] withDB:sessionDB];
                [self notifyMessagesUpdated:@[message] inSession:session];
            }
            else
            {
            }
        }
        else
        {

        }
    });
}

#pragma mark - manage message

- (BOOL)resendMessage:(CubeMessageEntity *)msg{
    BOOL result = [[CubeEngine sharedSingleton].messageService reSendMessage:msg];
    
    if(result && msg.status == CubeMessageStatusFailed)
    {
        msg.status = CubeMessageStatusSending;
        [self processMessagesInSameSession:@[msg]];
    }
    
    return result;
}

- (BOOL)recallMessage:(CubeMessageEntity *)msg{
    BOOL result = [[CubeEngine sharedSingleton].messageService recallMessage:msg.SN];
    
    return result;
}

#pragma mark - manage session

-(void)updateSessions:(NSArray<CWSession *> *)sessions{
	[self updateSessions:sessions withDB:nil];
}

-(void)updateSessions:(NSArray<CWSession *> *)sessions withDB:(id<CWSessionDBProtocol>)sessionDB{
	id<CWSessionDBProtocol> db = sessionDB;

	if(!db)
	{
		//获取session
		db = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWSessionDBProtocol)] firstObject];
	}
	
	[db saveOrUpdateSessions:sessions];
	[self notifySessionsUpdated:sessions];
}

-(void)deleteSessions:(NSArray<CWSession *> *)sessions{
	[self deleteSessions:sessions withDB:nil];
}

-(void)deleteSessions:(NSArray<CWSession *> *)sessions withDB:(id<CWSessionDBProtocol>)sessionDB{
	__block id<CWSessionDBProtocol> db = sessionDB;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if(!db)
		{
			//获取session
			db = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWSessionDBProtocol)] firstObject];
		}
		
		if([db deleteSessions:sessions])
		{
			[self notifySessionsDeleted:sessions];
		}
	});
}

-(void)resetSessionUnreadCount:(CWSession *)session{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id<CWSessionDBProtocol> sessionDB = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWSessionDBProtocol)] firstObject];
        [sessionDB readedMessagesbefore:[CWTimeUtil currentTimestampe] inSession:session];
        session.unReadCount = 0;
        [sessionDB saveOrUpdateSession:session];
        [self notifySessionsUpdated:@[session]];
        [self sendReceiptInfoForSession:session withMessage:nil];
    });
}

-(void)sendReceiptInfoForSession:(CWSession *)session withMessage:(CubeMessageEntity *)message{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		id<CWMessageDBProtocol> msgDB = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWMessageDBProtocol)] firstObject];
		CubeMessageEntity *msg = message;
		if(!msg)
		{
		   msg = [[msgDB messagesWithTimestamp:[CWTimeUtil currentTimestampe] relatedBy:CWTimeRelationLessThanOrEqual andLimit:1 andSortBy:CWSortTypeDESC forSession:session.sessionId] firstObject];
		}
		
		if(!msg.receiptTimestamp)
		{
//			[[CubeEngine sharedSingleton].messageService sendAllMessageReceipt:msg.SN];
		}
	});
}

#pragma mark - CubeMessageServiceDelegate

-(void)onMessageReceived:(CubeMessageEntity *)message{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self processMessagesInSameSession:@[message]];
	});
}

-(void)onMessageSent:(CubeMessageEntity *)message{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self processMessagesInSameSession:@[message]];
	});
}

-(void)onMessageFailed:(CubeMessageEntity *)message withError:(CubeError *)error{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if(message)
		{
			[self processMessagesInSameSession:@[message]];
		}
	});
}

-(void)onMessageRecalled:(CubeMessageEntity *)message{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString *noteString = [NSString stringWithFormat:@"%@撤回了一条消息",message.messageDirection == CubeMessageDirectionSent ? @"你" : message.sender.displayName];
		CubeCustomMessage *recallMsg = [CWMessageUtil tipMessageWithContent:noteString forSession:[CWSessionUtil sessionWithMessage:message]];
		recallMsg.timestamp = message.timestamp;
		[self processMessagesInSameSession:@[message]];
	});
}

- (void)onDownloadComplete:(CubeMessageEntity *)message{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self processMessagesInSameSession:@[message]];
        [self notifyFileMessageComple:message];
    });
}

- (void)onDownloading:(CubeMessageEntity *)message withProcessed:(long long)processed withTotal:(long long)total{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [self notifyFileMessageProgressUpdate:message withProcessed:processed withTotal:total];
    });
}

-(void)onReceiptAll:(CubeMessageEntity *)lastMessage from:(CubeDeviceInfo *)deviceInfo{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //获取session
//        id<CWSessionDBProtocol> sessionDB = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWSessionDBProtocol)] firstObject];
//        CWSession *session = [self sessionForMessage:lastMessage];
//
//        [sessionDB readedMessagesbefore:lastMessage.timestamp inSession:session];
//
//        session.unReadCount = [sessionDB unreadCountForSession:session];
//
//        [sessionDB saveOrUpdateSession:session];
//
//        [self notifySessionsUpdated:@[session]];
//    });

}

#pragma mark - sync message
-(void)onMessageSyncBegin{
	
}

-(void)onMessagesSyncing:(NSDictionary *)msgDic{
	for (NSString *sessionId in msgDic.allKeys) {
		NSArray *messageArray = [msgDic objectForKey:sessionId];
		[self processMessagesInSameSession:messageArray];
	}
}

-(void)onMessageSyncEnd{
	
}

#pragma mark - process messages
/**消息列表要求降序排序*/
- (void)processMessagesInSameSession:(NSArray *)messages{
	dispatch_async(cubeware_message_queue, ^{
		//获取session
		id<CWSessionDBProtocol> sessionDB = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWSessionDBProtocol)] lastObject];

		//解析消息
		static BOOL responseNeedShow = NO;
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			responseNeedShow = self.delegate && [self.delegate respondsToSelector:@selector(needShowMessage:)];
		});
		
		for (CubeMessageEntity *msg in messages) {
            if(responseNeedShow)
            {
                msg.needShow =  [self.delegate needShowMessage:msg];
            }
			msg.parseInfo = [CWMessageUtil parseInfoWithMessage:msg];
		}
        //获取最近一条
        CubeMessageEntity *lastMessage = [self lastEntityWithMessages:messages];
        if (!lastMessage) {
            return;
        }
        CWSession *session = [self sessionForMessage:lastMessage];
		//保存消息
		id<CWMessageDBProtocol> messageDB = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWMessageDBProtocol)] lastObject];
		[messageDB saveOrUpdateMessages:messages];
		
		BOOL handledMessage = [self notifyMessagesUpdated:messages inSession:session];
		
		if(handledMessage)
		{
			session.unReadCount = 0;
			if([[messages firstObject] messageDirection] == CubeMessageDirectionReceived)
			{
				[sessionDB readedMessagesbefore:[CWTimeUtil currentTimestampe] inSession:session];
				[self sendReceiptInfoForSession:session withMessage:[messages firstObject]];
			}
		}
		else
		{
			//拆分分离自定义消息，自定义消息和非自定义消息分开统计
			NSMutableArray *normalMessages = [NSMutableArray array];
			NSMutableArray *customMessages = [NSMutableArray array];
            BOOL needShake = NO;
			for (CubeMessageEntity *m in messages) {
				m.type == CubeMessageTypeCustom ? [customMessages addObject:m] : [normalMessages addObject:m];
                if (m.type == CubeMessageTypeCustom) {
                  NSString *operate = [m.header objectForKey:@"operate"];
                    if ([operate isEqualToString:@"shake"]) {
                        needShake = YES;
                    }
                }
			}
			
			NSInteger customUnreadCount = 0;
//            if(customMessages.count && self.delegate && [self.delegate respondsToSelector:@selector(unreadCountOfCustomMessages:forSession:)])
//            {
				customUnreadCount = [self unreadCountOfCustomMessages:customMessages forSession:session];
//            }
			NSInteger normalUnreadCount = [self unreadCountOfMessages:normalMessages forSession:session];
			
			NSInteger newUnreadCount = session.unReadCount + normalUnreadCount + customUnreadCount;
			
			if(newUnreadCount > session.unReadCount)
			{
				if(self.delegate && [self.delegate respondsToSelector:@selector(unreadCountWillChangeFrom:to:forSession:)])
				{
					[self.delegate unreadCountWillChangeFrom:session.unReadCount to:newUnreadCount forSession:session];
				}
				else
				{
					[[CWMessageRinging sharedSingleton] playMessageSound];
                    if (needShake) {
                        [[CWMessageRinging sharedSingleton] shake];
                    }
				}
			}
			session.unReadCount = newUnreadCount;

		}
        // 判断当前消息是否需要更新会话列表
        BOOL shouldUpdateSession = YES;
        if (self.delegate && [self.delegate respondsToSelector:
                              @selector(shouldUpdateSessionWithMessage:session:)]) {
            shouldUpdateSession = [self.delegate shouldUpdateSessionWithMessage:messages.firstObject session:session];
        }
        if (shouldUpdateSession) {
            [self updateSessions:@[session] withDB:sessionDB];
        }
	});
}

#pragma mark - file service delegate
- (void)onFileUploadSuccess:(CubeFileMessage *)message{
	[self sendMessage:message forSession:[CWSessionUtil sessionWithMessage:message]];
}

-(void)onFileServiceFailed:(CubeFileMessage *)message andError:(CubeError *)error{
	message.status = CubeMessageStatusFailed;
	[self processMessagesInSameSession:@[message]];
}

- (void)onFileDownloadSuccess:(CubeFileMessage *)message
{
    [self processMessagesInSameSession:@[message]];
}

#pragma mark - session tool
- (CubeMessageEntity *)lastEntityWithMessages:(NSArray *)messages
{
    CubeMessageEntity *latestMsg = nil;
    // 强行排序一次
    messages = [messages sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CubeMessageEntity * msg1 = obj1;
        CubeMessageEntity * msg2 = obj2;
        if(msg1.timestamp < msg2.timestamp) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    for (CubeMessageEntity *msg in messages) {
        if(msg.needShow == YES){
            latestMsg = msg;
            break;
        }
    }
    return latestMsg;
}

-(CWSession *)sessionForMessage:(CubeMessageEntity *)message{
    //获取session
    id<CWSessionDBProtocol> sessionDB = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWSessionDBProtocol)] firstObject];
    CWSession *session = [sessionDB sessionWithSessionId:[CWSessionUtil sessionIdForMessage:message]];
    if(!session)
    {
        session = [CWSessionUtil sessionWithMessage:message];
    }
    
	[session updateWithMessage:message andSummeryHelper:self.delegate];
    if(self.delegate &&[self.delegate respondsToSelector:@selector(getSessionName:forSession:)])
    {
        session.sessionName = [self.delegate getSessionName:message forSession:session];
    }
    return session;
}

-(NSInteger)unreadCountOfMessages:(NSArray<CubeMessageEntity *> *)messages forSession:(CWSession *)session{
	NSInteger unreadCount = 0;
	for (CubeMessageEntity *msg in messages) {
		if(!msg.receipted && msg.messageDirection == CubeMessageDirectionReceived && msg.type != CubeMessageTypeReceipt)
		{
			unreadCount += 1;
		}
	}
	return unreadCount;
}

-(NSInteger)unreadCountOfCustomMessages:(NSArray<CubeMessageEntity *> *)messages forSession:(CWSession *)session
{
    NSInteger unreadCount = 0;
    for (CubeMessageEntity *msg in messages) {
        NSString *operate = [msg.header objectForKey:@"operate"];
        if ([operate isEqualToString:@"shake"]||[operate isEqualToString:@"videoCall"]||[operate isEqualToString:@"voiceCall"]) {
            if(!msg.receipted && msg.messageDirection == CubeMessageDirectionReceived)
            {
                unreadCount += 1;
            }
        }
    }
    return unreadCount;
}

#pragma mark - notify tool
-(void)notifySessionsUpdated:(NSArray *)updatedSessions{
    //通知会话更新
    for (id<CWSessionRefreshProtocol> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWSessionRefreshProtocol)]) {
        if([obj respondsToSelector:@selector(sessionsUpdated:)])
        {
            [obj sessionsUpdated:updatedSessions];
        }
    }
}

-(void)notifySessionsDeleted:(NSArray *)DeletedSessions{
	//通知会话已删除
	for (id<CWSessionRefreshProtocol> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWSessionRefreshProtocol)]) {
		if([obj respondsToSelector:@selector(sessionsDeleted:)])
		{
			[obj sessionsDeleted:DeletedSessions];
		}
	}
}

-(BOOL)notifyMessagesUpdated:(NSArray *)updatedMessages inSession:(CWSession *)session{
    BOOL handledMessage = NO;
    //通知消息更新
    for (id<CWSessionRefreshProtocol> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWSessionRefreshProtocol)]) {
        if([obj respondsToSelector:@selector(messagesUpdated:forSession:)])
        {
            if([obj messagesUpdated:updatedMessages forSession:session])
            {
                handledMessage = YES;
            }
        }
    }
    return handledMessage;
}
- (void)notifyFileMessageProgressUpdate:(CubeMessageEntity *)message withProcessed:(long long)processed withTotal:(long long)total{
    for (id <CWFileRefreshDelegate> obj in [[CWWorkerFinder defaultFinder]findWorkerForProtocol:@protocol(CWFileRefreshDelegate) ]) {
        if([obj respondsToSelector:@selector(fileMessageDownloading:withProcessed:withTotal:)]){
            [obj fileMessageDownloading:message withProcessed:processed withTotal:total];
        }
    }
}
- (void)notifyFileMessageComple:(CubeMessageEntity *)message{
    for (id <CWFileRefreshDelegate> obj in [[CWWorkerFinder defaultFinder]findWorkerForProtocol:@protocol(CWFileRefreshDelegate) ]) {
        if([obj respondsToSelector:@selector(fileMessageDownLoadComplete:)]){
            [obj fileMessageDownLoadComplete:message];
        }
    }
}

@end
