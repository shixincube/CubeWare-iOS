//
//  CWShareDesktopService.m
//  CubeWare
//
//  Created by pretty on 2018/9/6.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CWShareDesktopService.h"
#import "CubeWareHeader.h"
@implementation CWShareDesktopService


- (void)onShareDesktopCreated:(CubeShareDesktop *)sd fromUser:(CubeUser *)fromUser
{


}

- (void)onShareDesktopQuitd:(CubeShareDesktop *)sd fromUser:(CubeUser *)fromUser
{

}

- (void)onShareDesktopDestroyed:(CubeShareDesktop *)sd fromUser:(CubeUser *)fromUser
{

}
- (void)onShareDesktopRejectInvited:(CubeShareDesktop *)sd fromUser:(CubeUser *)fromUser andRejectMember:(CubeUser *)rejectMember
{
    for (id<CWShareDesktopServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWShareDesktopServiceDelegate)]) {
        if([obj respondsToSelector:@selector(rejectInviteShareDesktop:)])
        {
            [obj rejectInviteShareDesktop:sd];
        }
    }
}

- (void)onShareDesktopInvited:(CubeShareDesktop *)sd fromUser:(CubeUser *)fromUser andInvites:(NSArray<CubeUser *> *)invites
{
    for (id<CWShareDesktopServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWShareDesktopServiceDelegate)]) {
        if([obj respondsToSelector:@selector(inviteShareDesktop:andFrom:andInvites:)])
        {
            [obj inviteShareDesktop:sd andFrom:fromUser andInvites:invites];
        }
    }
}

- (void)onShareDesktopJoined:(CubeShareDesktop *)sd fromJoinMember:(CubeUser *)joinedMember
{
    UIView *remoteView = [[[CubeEngine sharedSingleton] shareDesktopService ]getShareDesktopView];
    for (id<CWShareDesktopServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWShareDesktopServiceDelegate)]) {
        if([obj respondsToSelector:@selector(joinShareDesktop:andView:)])
        {
            [obj joinShareDesktop:sd andView:remoteView];
        }
    }
}

- (void)onShareDesktopInviteJoined:(CubeShareDesktop *)sd fromUser:(CubeUser *)fromUser andJoinedMember:(CubeUser *)joinedMembe
{

}

- (void)onShareDesktopFailed:(CubeError *)error
{
    NSLog(@"error = %@",error);
    for (id<CWShareDesktopServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWShareDesktopServiceDelegate)]) {
        if([obj respondsToSelector:@selector(shareDesktopFail:)])
        {
            [obj shareDesktopFail:error];
        }
    }
}

@end
