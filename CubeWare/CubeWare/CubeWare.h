//
//  CubeWare.h
//  CubeWare
//
//  Created by jianchengpan on 2018/8/27.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWAccountService.h"
#import "CWInfoManager.h"
#import "CWMessageService.h"
#import "CWGroupService.h"
#import "CWWorkerFinder.h"
#import "CWFileService.h"
#import "CWCallService.h"
#import "CWConferenceService.h"
#import "CWShareDesktopService.h"
#import "CWWhiteBoardService.h"

@interface CubeWare : NSObject

/**
 账号服务
 */
@property (nonatomic, strong) CWAccountService *accountService;

/**
 消息服务
 */
@property (nonatomic, strong) CWMessageService *messageService;


/**
 文件服务
 */
@property (nonatomic, strong) CWFileService *fileService;

/**
 信息新管理
 */
@property (nonatomic, strong) CWInfoManager *infoManager;

/**
 群组
 */
@property (nonatomic,strong) CWGroupService *groupService;

/**
 音视频服务
 */
@property (nonatomic,strong) CWCallService *callService;

/**
 会议服务
 */
@property (nonatomic,strong) CWConferenceService *conferenceService;

/**
 远程桌面服务
 */
@property (nonatomic,strong) CWShareDesktopService *shareDesktopService;

/**
 白板服务
 */
@property (nonatomic,strong) CWWhiteBoardService *whiteBoardService;


/**
 单例方法
 */
+ (CubeWare *)sharedSingleton;

/**
 获取对应版本信息
 
 @return 版本信息 例如2.1.x
 */
- (NSString *)getDescription;

/**
 启动引擎
 
 @param config 引擎配置
 @return 返回魔方引擎是否启动成功。如果返回 <code>YES</code> 则表示引擎启动成功，否则表示引擎启动失败。
 */
- (BOOL)startWithcubeConfig:(CubeConfig *)config;

/** 停止CubeWare，CubeWare停止所有工作，并释放内存。
 *
 * @note 此方法必须在 UI 线程中调用。
 */
- (void)shutdown;

/** 暂停CubeWare。
 *
 * 暂停CubeWare工作时，CubeWare会暂停所有正在进行的实时协作操作。
 *
 * @see UIApplicationDelegate#applicationWillResignActive 被回调时应当调用该方法。
 */
- (void)sleep;

/** 恢复CubeWare工作。
 *
 * 恢复CubeWare时，CubeWare会恢复到工作状态。
 *
 * @see UIApplicationDelegate#applicationDidBecomeActive 被回调时应当调用该方法。
 */
- (void)wakeup;


@end
