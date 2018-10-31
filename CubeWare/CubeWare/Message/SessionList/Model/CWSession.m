//
//  CWSession.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWSession.h"
#import "CWSessionUtil.h"
#import "CWWorkerFinder.h"

@implementation CWSession
@dynamic json;

-(instancetype)initWithSessionId:(NSString *)sessionId andType:(CWSessionType)type{
    if(self = [super init])
    {
        self.sessionId = sessionId;
        self.sessionType = type;
    }
    return self;
}


-(void)updateWithMessage:(CubeMessageEntity *)message andSummeryHelper:(id<CWMessageServiceDelegate>)helper{
#warning fixed me 时间戳判断问题
//    if(message.timestamp > self.lastesTimestamp)
	{
		NSString *summary = nil;
		if(helper && [helper respondsToSelector:@selector(summaryOfMesssage:forSession:)])
		{
			summary = [helper summaryOfMesssage:message forSession:self];
		}
		
		if(!summary)
		{
			self.summary = [CWSessionUtil sessionSummaryWithMessage:message];
		}
        else
        {
            self.summary = summary;
        }
		
		self.lastesTimestamp = message.timestamp;
	}
}

-(NSString *)appropriateName{
//    NSString *name = [[CubeWare sharedSingleton].infoManager userInfoForCubeId:self.sessionId inSession:nil].appropriateName;
    NSString *sessionname = [[CubeWare sharedSingleton].messageService.delegate getSessionName:nil forSession:self];
    NSString *name =  self.sessionName.length > 0 ? self.sessionName :  self.sessionId;
    return sessionname?sessionname:name;
}

- (BOOL)showNickName{
    return self.sessionType == CWSessionTypeGroup;
}

-(NSString *)json{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:self.sessionId ? self.sessionId : @"" forKey:@"sessionId"];
    [dic setObject:@(self.sessionType) forKey:@"sessionType"];
    [dic setObject:self.summary ? self.summary : @"" forKey:@"summary"];
    [dic setObject:@(self.lastesTimestamp) forKey:@"lastesTimestamp"];
    [dic setObject:@(self.unReadCount) forKey:@"unReadCount"];
    [dic setObject:@(self.topped) forKey:@"topped"];
    [dic setObject:@(self.showNickName) forKey:@"showNickName"];
    [dic setObject:self.conferenceType?self.conferenceType:@"" forKey:@"conferenceType"];
    [dic setObject:self.sessionName?self.sessionName:@"" forKey:@"sessionName"];
    NSString *string = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    return string ? string : @"";
}

-(void)setJson:(NSString *)json{
    if(json)
    {
        NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        [self setValuesForKeysWithDictionary:jsonDic];
    }
}


#pragma mark - kvc

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

#pragma mark - session info repotor

-(void)registerAsSessionInfoRepotor{
	[[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWSessionInfoReportor)]];
}

-(int)reportUnreadCountForSession:(NSString *)sessionId{
	int unreadCount = 0;
	
	unreadCount = !sessionId || (sessionId && [sessionId isEqualToString:self.sessionId]) ? self.unReadCount : 0;
	
	return unreadCount;
}

@end
