//
//  CubeWare.m
//  CubeWare
//
//  Created by jianchengpan on 2018/8/27.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CubeWare.h"
#import "CWDBManager.h"
#import "CWUserModel.h"

@interface CubeWare()


@end

@implementation CubeWare

+(CubeWare *)sharedSingleton{
	static CubeWare *cw = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		cw = [[CubeWare alloc] init];
	});
	return cw;
}

-(CWMessageService *)messageService{
	if(!_messageService)
	{
		_messageService = [[CWMessageService alloc] init];
	}
	return _messageService;
}

-(CWAccountService *)accountService{
	if(!_accountService)
	{
		_accountService = [[CWAccountService alloc] init];
	}
	return _accountService;
}


-(CWFileService *)fileService{
    if (!_fileService) {
        _fileService = [[CWFileService alloc] init];
    }
    return _fileService;
}

-(CWInfoManager *)infoManager{
	if(!_infoManager)
	{
		_infoManager = [[CWInfoManager alloc] init];
	}
	return _infoManager;
}

- (CWGroupService *)groupService
{
    if (!_groupService) {
        _groupService = [[CWGroupService alloc] init];
    }
    return _groupService;
}


-(CWCallService *)callService{
    if (!_callService) {
        _callService = [[CWCallService alloc] init];
    }
    return _callService;
}

- (CWConferenceService *)conferenceService{
    if (!_conferenceService) {
        _conferenceService = [[CWConferenceService alloc] init];
    }
    return _conferenceService;
}

- (CWShareDesktopService *)shareDesktopService
{
    if (!_shareDesktopService) {
        _shareDesktopService = [[CWShareDesktopService alloc]init];
    }
    return _shareDesktopService;
}

-(CWWhiteBoardService *)whiteBoardService{
    if (!_whiteBoardService) {
        _whiteBoardService = [[CWWhiteBoardService alloc] init];
    }
    return _whiteBoardService;
}

-(NSString *)getDescription{
	return @"";
}

-(BOOL)startWithcubeConfig:(CubeConfig *)config{
	[[CubeEngine sharedSingleton] startWithCubeConfig:config];
	
	[CWDBManager shareManager];
	[CWUserModel currentUser];
	
	[CubeEngine sharedSingleton].messageService.delegate = self.messageService;
	[CubeEngine sharedSingleton].messageService.messageSynchronizer.delegate = self.messageService;
	[CubeEngine sharedSingleton].userService.delegate = self.accountService;
    [CubeEngine sharedSingleton].groupService.delegate = self.groupService;
    [CubeEngine sharedSingleton].callService.delegate = self.callService;
    [CubeEngine sharedSingleton].conferenceService.delegate = self.conferenceService;
    [CubeEngine sharedSingleton].shareDesktopService.delegate = self.shareDesktopService;
    [CubeEngine sharedSingleton].whiteBoardService.delegate = self.whiteBoardService;
    
	return YES;
}

-(void)wakeup{
	[[CubeEngine sharedSingleton] wakeup];
}

-(void)sleep{
	[[CubeEngine sharedSingleton] sleep];
}

-(void)shutdown{
	[[CubeEngine sharedSingleton] shutdown];
}

@end
