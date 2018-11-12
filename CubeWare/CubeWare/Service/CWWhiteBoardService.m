//
//  CWWhiteBoardService.m
//  CubeWare
//
//  Created by Ashine on 2018/9/13.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CWWhiteBoardService.h"
#import "CubeWareGlobalMacro.h"
#import "CWMessageUtil.h"
@interface CWWhiteBoardService()

/**
 超时定时器，超过1分钟就发送挂断请求
 */
@property (nonatomic,strong) NSTimer *waitTimer;
/**
 通话时间
 */
@property (nonatomic ,assign) long long timeCount;

/**
 白板Id
 */
@property (nonatomic,strong) NSString *whiteBoardId;


/**
 正在演示中的白板..
 */
@property (nonatomic,strong) CubeWhiteBoard *currentWhiteBoard;


@end
@implementation CWWhiteBoardService

#pragma mark - api

-(void)joinWhiteBoard:(NSString *)whiteBoardId{
    [[CubeEngine sharedSingleton].whiteBoardService joinWhiteBoard:whiteBoardId];
}

-(void)quitWhiteBoard:(NSString *)whiteBoardId{
    [[CubeEngine sharedSingleton].whiteBoardService  quitWhiteBoard:whiteBoardId];
}

-(void)inviteMemberInWhiteBoardId:(NSString *)whiteBoardId andMembers:(NSArray<NSString *> *)members{
    [[CubeEngine sharedSingleton].whiteBoardService inviteMembersInWhiteBoard:whiteBoardId withMembers:members];
}

-(void)acceptInviteWhiteBoard:(NSString *)whiteboardId andInviter:(NSString *)cubeId{
    [[CubeEngine sharedSingleton].whiteBoardService acceptInviteWhiteBoard:whiteboardId andCubeId:cubeId];
}

- (void)rejectInviteWhiteBoard:(NSString *)whiteboardId andInviter:(NSString *)cubeId{
    [[CubeEngine sharedSingleton].whiteBoardService rejectInviteWhiteBoard:whiteboardId andCubeId:cubeId];
}

-(BOOL)currentWhiteboardActing{
    return self.currentWhiteBoard ? YES : NO;
}


#pragma mark - CubeWhiteBoardServiceDelegate

-(void)onWhiteboardCreated:(CubeWhiteBoard *)whiteboard from:(CubeUser *)from{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (whiteboard.maxNumber == 2) {
            //p2p
            self.whiteBoardId = whiteboard.whiteboardId;
            [self beginTimer];
        }
        UIView *whiteBoardView = [[CubeEngine sharedSingleton].whiteBoardService getView];
        CGRect remoteFrame = CGRectMake( 0,0, UIScreenWidth, UIScreenWidth*9/16);
        for (id<CWWhiteBoardServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWWhiteBoardServiceDelegate)]) {
            if([obj respondsToSelector:@selector(whiteBoardCreate:from:andView:)])
            {
                [obj whiteBoardCreate:whiteboard from:from andView:whiteBoardView];
            }
        }
        [self insertCustomMessage:whiteboard andUser:from andContent:@"create_wb"];
    });
}

-(void)onWhiteboardQuited:(CubeWhiteBoard *)whiteboard quitedMember:(CubeUser *)quitedMember{
    if ([whiteboard.whiteboardId isEqualToString:self.currentWhiteBoard.whiteboardId]) {
        self.currentWhiteBoard = nil;
    }
    if (whiteboard.maxNumber == 2) {
        [self stopTimer];
    }
    for (id<CWWhiteBoardServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWWhiteBoardServiceDelegate)]) {
        if([obj respondsToSelector:@selector(whiteBoardQuit:quitMember:)])
        {
            [obj whiteBoardQuit:whiteboard quitMember:quitedMember];
        }
    }
    [self insertCustomMessage:whiteboard andUser:quitedMember andContent:@"destory_wb"];
}

-(void)onWhiteboardDestroyed:(CubeWhiteBoard *)whiteboard from:(CubeUser *)from{
    if ([whiteboard.whiteboardId isEqualToString:self.currentWhiteBoard.whiteboardId]) {
        self.currentWhiteBoard = nil;
    }
    if (whiteboard.maxNumber == 2) {
        [self stopTimer];
    }
    for (id<CWWhiteBoardServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWWhiteBoardServiceDelegate)]) {
        if([obj respondsToSelector:@selector(whiteBoardDestroy:from:)])
        {
            [obj whiteBoardDestroy:whiteboard from:from];
        }
    }
    [self insertCustomMessage:whiteboard andUser:from andContent:@"destory_wb"];
}

-(void)onWhiteboardInvited:(CubeWhiteBoard *)whiteboard from:(CubeUser *)from user:(NSArray<CubeGroupMember *> *)invites{
    // 如果在音视频通话中 , 忽略白板邀请
    BOOL isCalling = NO;
    id currentCall = [[CubeEngine sharedSingleton].mediaService currentCallWithCallType:CubeCallTypeCall|CubeCallTypeConfernce].firstObject;
    if (currentCall) {
        for (CubeGroupMember *member in invites) {
            if ([member.cubeId isEqualToString:[CubeEngine sharedSingleton].userService.currentUser.cubeId]) {
                isCalling = YES;
                break;
            }
        }
    }
    
    if (isCalling) {
        [[CubeEngine sharedSingleton].whiteBoardService rejectInviteWhiteBoard:whiteboard.whiteboardId andCubeId:from.cubeId];
        return;
    }
    
    // 如果在白板中 , 忽略其它的白板邀请
    BOOL isWhiteBoardActing = [self currentWhiteboardActing];
    if (isWhiteBoardActing) {
        return;
    }
    
    for (id<CWWhiteBoardServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWWhiteBoardServiceDelegate)]) {
        if([obj respondsToSelector:@selector(whiteBoardInvite:from:invites:)])
        {
            [obj whiteBoardInvite:whiteboard from:from invites:invites];
        }
    }
    if(whiteboard.maxNumber == 2 && ![from.cubeId isEqualToString:[CubeUser currentUser].cubeId])
    {
        [self insertCustomMessage:whiteboard andUser:from andContent:@"create_wb"];
    }
}

-(void)onWhiteboardAcceptInvited:(CubeWhiteBoard *)whiteboard from:(CubeUser *)from joinedMember:(CubeUser *)joinedMember{
    for (id<CWWhiteBoardServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWWhiteBoardServiceDelegate)]) {
        if([obj respondsToSelector:@selector(whiteBoardAcceptInvite:from:joinedMember:)])
        {
            [obj whiteBoardAcceptInvite:whiteboard from:from joinedMember:joinedMember];
        }
    }
}

-(void)onWhiteboardRejectInvited:(CubeWhiteBoard *)whiteboard from:(CubeUser *)from rejectMember:(CubeUser *)rejectMember{
    for (id<CWWhiteBoardServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWWhiteBoardServiceDelegate)]) {
        if([obj respondsToSelector:@selector(whiteBoardRejectInvite:from:rejectMember:)])
        {
            [obj whiteBoardRejectInvite:whiteboard from:from rejectMember:rejectMember];
        }
    }

    if(![rejectMember.cubeId isEqualToString:[CubeUser currentUser].cubeId])
    {
        [self insertCustomMessage:whiteboard andUser:rejectMember andContent:@"destory_wb"];
    }
}

-(void)onWhiteboardJoined:(CubeWhiteBoard *)whiteboard joinedMember:(CubeUser *)joinedMember{
    if ([joinedMember.cubeId isEqualToString:[CubeEngine sharedSingleton].userService.currentUser.cubeId]) { //if self join
        self.currentWhiteBoard = whiteboard;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (whiteboard.maxNumber == 2) {
            [self stopTimer];
        }
        UIView *whiteBoardView = [[CubeEngine sharedSingleton].whiteBoardService getView];
        CGRect remoteFrame = CGRectMake(0, 0, UIScreenWidth, UIScreenWidth*9/16);
        whiteBoardView.frame = remoteFrame;
        for (id<CWWhiteBoardServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWWhiteBoardServiceDelegate)]) {
            if([obj respondsToSelector:@selector(whiteBoardJoin:joinedMember:andView:)])
            {
                [obj whiteBoardJoin:whiteboard joinedMember:joinedMember andView:whiteBoardView];
            }
        }
    });
}

-(void)onWhiteboardFailed:(CubeWhiteBoard *)whiteboard error:(CubeError *)error{
    [self stopTimer];
    for (id<CWWhiteBoardServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWWhiteBoardServiceDelegate)]) {
        if([obj respondsToSelector:@selector(whiteBoardFailed:error:)])
        {
            [obj whiteBoardFailed:whiteboard error:error];
        }
    }
}

#pragma mark - privite method
- (void)beginTimer
{
    //开启一个通话计时器
    if (self.waitTimer) {
        [self.waitTimer invalidate];
        self.waitTimer = nil;
    }
    self.waitTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(openTimer:) userInfo:nil repeats:YES];
    self.timeCount = 0;
}

- (void)openTimer:(NSTimer *)timer
{
     self.timeCount ++;
    if (self.timeCount == 60)//60s 一对一白板未接听后 主动挂断
    {
        [[CubeWare sharedSingleton].whiteBoardService quitWhiteBoard:self.whiteBoardId];
    }
}

- (void)stopTimer
{
    self.whiteBoardId = nil;
    if (self.waitTimer) {
        [self.waitTimer invalidate];
        self.waitTimer = nil;
    }

}
- (void)insertCustomMessage:(CubeWhiteBoard *)whiteboard andUser:(CubeUser *)user andContent:(NSString *)content
{
    if(whiteboard && whiteboard.maxNumber == 2)
    {
        CubeCustomMessage *customMessage = [CWMessageUtil customMessageWithWhiteBoard:whiteboard fromUser:user andContent:content];
        if(customMessage)
        {
            customMessage.status = CubeMessageStatusSucceed;
            [[CubeWare sharedSingleton].messageService processMessagesInSameSession:@[customMessage]];
        }
    }
}


@end
