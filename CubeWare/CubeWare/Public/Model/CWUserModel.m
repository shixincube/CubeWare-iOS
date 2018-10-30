//
//  CWUserModel.m
//  CubeWare
//
//  Created by 曾長歡 on 2017/12/26.
//  Copyright © 2017年 shixinyun. All rights reserved.
//
#import <objc/runtime.h>
#import "CWUserModel.h"
#import "CubeWareHeader.h"
#import "CWInfoRefreshDelegate.h"

#define CWCurrentUserStorageKey @"CWUserCurrentUserInfo"
static const char *CWUserModelRemarkNameKey = "CWUserModel_RemarkName";

@implementation CubeUser(CubeWare)

static CWUserModel *sharUser = nil;

+(CWUserModel *)currentUser
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:CWCurrentUserStorageKey];
		dic = dic ? dic : @{};
		sharUser = [CWUserModel fromDictionary:dic];
		[[CWWorkerFinder defaultFinder] registerWorker:sharUser forProtocols:@[@protocol(CWInfoRefreshDelegate)]];
	});
	
	return sharUser.cubeId.length ? sharUser : nil;
}

-(NSString *)remarkName{
	return objc_getAssociatedObject(self, CWUserModelRemarkNameKey);
}

-(void)setRemarkName:(NSString *)remarkName{
	objc_setAssociatedObject(self, CWUserModelRemarkNameKey, remarkName, OBJC_ASSOCIATION_COPY);
}

-(NSString *)appropriateName{
	return self.remarkName.length ? self.remarkName : self.displayName;
}

#pragma mark - CWUserInfoRefreshProtocol

-(void)changeCurrentUser:(CWUserModel *)user{
	if(user)
	{
		[CubeJsonUtil updateObject:sharUser withDictionary:[user toDictionary]];
	}
	else
	{
		[sharUser setValuesForKeysWithDictionary:@{}];
	}
	[[NSUserDefaults standardUserDefaults] setObject:[sharUser toDictionary] forKey:CWCurrentUserStorageKey];
}

-(void)usersInfoUpdated:(NSArray<CWUserModel *> *)users inSession:(CWSession *)session{
	for (CWUserModel *user in users) {
		if([user.cubeId isEqualToString:sharUser.cubeId])
		{
			[CubeJsonUtil updateObject:sharUser withDictionary:[user toDictionary]];
			break;
		}
	}
}

@end
