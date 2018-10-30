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


#pragma mark - CubeWhiteBoardServiceDelegate

-(void)onWhiteboardCreated:(CubeWhiteBoard *)whiteboard from:(CubeUser *)from{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *whiteBoardView = [[CubeEngine sharedSingleton].whiteBoardService getView];
        CGRect remoteFrame = CGRectMake(0, 0, UIScreenWidth, UIScreenWidth*9/16);
        whiteBoardView.frame = remoteFrame;
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
    for (id<CWWhiteBoardServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWWhiteBoardServiceDelegate)]) {
        if([obj respondsToSelector:@selector(whiteBoardQuit:quitMember:)])
        {
            [obj whiteBoardQuit:whiteboard quitMember:quitedMember];
        }
    }
    [self insertCustomMessage:whiteboard andUser:quitedMember andContent:@"destory_wb"];
}

-(void)onWhiteboardDestroyed:(CubeWhiteBoard *)whiteboard from:(CubeUser *)from{
    for (id<CWWhiteBoardServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWWhiteBoardServiceDelegate)]) {
        if([obj respondsToSelector:@selector(whiteBoardDestroy:from:)])
        {
            [obj whiteBoardDestroy:whiteboard from:from];
        }
    }
    [self insertCustomMessage:whiteboard andUser:from andContent:@"destory_wb"];
}

-(void)onWhiteboardInvited:(CubeWhiteBoard *)whiteboard from:(CubeUser *)from user:(NSArray<CubeGroupMember *> *)invites{
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
    dispatch_async(dispatch_get_main_queue(), ^{
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
    NSLog(@"error = %@",error.errorInfo);
    for (id<CWWhiteBoardServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWWhiteBoardServiceDelegate)]) {
        if([obj respondsToSelector:@selector(whiteBoardFailed:error:)])
        {
            [obj whiteBoardFailed:whiteboard error:error];
        }
    }
}

#pragma mark - privite method

- (void)insertCustomMessage:(CubeWhiteBoard *)whiteboard andUser:(CubeUser *)user andContent:(NSString *)content
{
    NSLog(@"whiteboard = %@", [whiteboard toDictionary]);
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
