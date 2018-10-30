//
//  CWAccountService.m
//  CubeWare
//
//  Created by 曾長歡 on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWAccountService.h"
#import "CWUserModel.h"
#import "CWInfoRefreshDelegate.h"
#import "CubeWareHeader.h"
#import "CWUserDelegate.h"
@interface CWAccountService ()<CubeUserServiceDelegate>
{

}

@end

@implementation CWAccountService

static CWAccountService *sharedSingleton = nil;

-(void)loginUser:(CWUserModel *)user withToken:(NSString *)token{
 
    [[CubeEngine sharedSingleton].userService loginWithCubeId:user.cubeId andCubeToken:token andDisplayName:user.displayName];
}

-(void)logoutWithForce:(BOOL)forceLogout{
    if([CWUserModel currentUser])
    {
        [[CubeEngine sharedSingleton].userService logoutWithForce:forceLogout];
    }
    else
    {
        //直接回掉登出成功
    }
    
}

#pragma mark - CubeUserServiceDelegate
-(void)onLogin:(CubeUser *)user{
	for (id<CWInfoRefreshDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWInfoRefreshDelegate)] ) {
		if([obj respondsToSelector:@selector(changeCurrentUser:)])
		{
			[obj changeCurrentUser:user];
		}
	}
}

-(void)onLogout:(CubeUser *)user{
	for (id<CWInfoRefreshDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWInfoRefreshDelegate)] ) {
		if([obj respondsToSelector:@selector(changeCurrentUser:)])
		{
			[obj changeCurrentUser:nil];
		}
	}
}

-(void)onUserFailed:(CubeError *)error{
	
}

-(void)onDeviceOnline:(CubeDeviceInfo *)deviceInfo andOnlineList:(NSArray<CubeDeviceInfo *> *)onlineDeviceList{
    NSLog(@"其它设备登陆该账号,下线处理");
    for (id<CWInfoRefreshDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWInfoRefreshDelegate)] ) {
        if([obj respondsToSelector:@selector(changeCurrentUser:)])
        {
            [obj changeCurrentUser:nil];
        }
    }
}

-(void)onDeviceOffLine:(CubeDeviceInfo *)deviceInfo andOnlineList:(NSArray<CubeDeviceInfo *> *)onlineDeviceList{
	
}

- (void)onUpdateUser:(CubeUser *)user andError:(CubeError *)error
{
    for (id<CWUserServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWUserServiceDelegate)]) {
        if (user) {
            if([obj respondsToSelector:@selector(updateUserSuccess:)])
            {
                [obj updateUserSuccess:user];
            }
        }
        else
        {
            if([obj respondsToSelector:@selector(updateUserFailed:)])
            {
                [obj updateUserFailed:error];
            }
        }

    }
}
@end
