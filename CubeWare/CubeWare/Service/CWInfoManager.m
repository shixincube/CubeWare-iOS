//
//  CWInfoManager.m
//  CubeWare
//
//  Created by jianchengpan on 2018/1/12.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWInfoManager.h"
#import "CWInfoRefreshDelegate.h"
#import "CubeWareHeader.h"
#import "CWSession.h"

@interface CWInfoManager()

/**
 //存储结构
 @{identifier:obj}
 identifier = cubeid(+sessionID)
 */
@property (nonatomic, strong) NSCache *usersInfoCache;

@end

@implementation CWInfoManager

-(instancetype)init{
	if(self = [super init])
	{
		_usersInfoCache = [[NSCache alloc] init];
		_usersInfoCache.countLimit = 1000;
	}
	return self;
}

-(void)updateUsersInfo:(NSArray<CWUserModel *> *)users inSession:(CWSession *)session{
	if(users.count)
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSString *sessionIdent = session.sessionType == CWSessionTypeGroup && session.sessionId ? [@"+" stringByAppendingString:session.sessionId] : @"";
			for (CWUserModel *user in users) {
				NSString *identifier = [user.cubeId stringByAppendingString:sessionIdent];
				[self.usersInfoCache setObject:user forKey:identifier];
			}
			
			NSArray *listeners = [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWInfoRefreshDelegate)];
			for (id<CWInfoRefreshDelegate> listener in listeners) {
				if([listener respondsToSelector:@selector(usersInfoUpdated:inSession:)])
				{
					[listener usersInfoUpdated:users inSession:session];
				}
			}
		});
	}
}

#pragma mark - cached base info

-(CWUserModel *)userInfoForCubeId:(NSString *)cubeId inSession:(CWSession *)session{
	NSString *identifier = session && session.sessionType == CWSessionTypeGroup ? [cubeId stringByAppendingFormat:@"+%@",session.sessionId] : cubeId;
	return [self.usersInfoCache objectForKey:identifier];
}

@end
