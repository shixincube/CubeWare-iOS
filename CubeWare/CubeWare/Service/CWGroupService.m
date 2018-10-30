//
//  CWGroupService.m
//  CubeWare
//
//  Created by pretty on 2018/8/31.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CWGroupService.h"
#import "CubeWareHeader.h"
#import "CWSession.h"
@implementation CWGroupService

- (BOOL)createGroupWithGroup:(CubeGroupConfig *)config
{
    BOOL ret = [[CubeEngine sharedSingleton].groupService createGroupWithGroup:config];
    if (ret) {

    }
    else
    {}
    return  ret;
}

- (BOOL)addMembersWithGroupId:(NSString *)groupId withMembers:(NSArray <NSString *>*)members
{
    BOOL ret = [[CubeEngine sharedSingleton].groupService addMembersWithGroupId:groupId withMembers:members];
    return ret;
}

- (BOOL)inviteMembersWithGroupId:(NSString *)groupId withMembers:(NSArray <NSString *>*)members
{
    BOOL ret = [[CubeEngine sharedSingleton].groupService inviteMembersWithGroupId:groupId withMembers:members];
    return ret;
}

- (BOOL)applyJoinGroupWithGroupId:(NSString *)groupId
{
    BOOL ret = [[CubeEngine sharedSingleton].groupService applyJoinGroupWithGroupId:groupId];
    return ret;
}

- (BOOL)updateGroup:(CubeGroup *)group
{
    BOOL ret = [[CubeEngine sharedSingleton].groupService updateGroupWithGroup:group];
    return ret;
}

- (void)onGroupQuited:(CubeGroup *)group fromUser:(CubeUser *)from
{
    for (id<CWGroupServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWGroupServiceDelegate)]) {
        if([obj respondsToSelector:@selector(quitGroup:from:)])
        {
            [obj quitGroup:group from:from];
        }
    }
    if([from.cubeId isEqualToString:[CubeUser currentUser].cubeId])
    {
        CWSession *session = [[CWSession alloc]initWithSessionId:group.groupId andType:CWSessionTypeGroup];
        [[CubeWare sharedSingleton].messageService deleteSessions:@[session]];
    }
}

- (void)onGroupFailed:(CubeError *)error
{
    for (id<CWGroupServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWGroupServiceDelegate)]) {
        if([obj respondsToSelector:@selector(groupFail:)])
        {
            [obj groupFail:error];
        }
    }
}

- (void)onGroupCreated:(CubeGroup *)group fromUser:(CubeUser *)from
{
    for (id<CWGroupServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWGroupServiceDelegate)]) {
        if([obj respondsToSelector:@selector(createGroup:from:)])
        {
            [obj createGroup:group from:from];
        }
    }
}

- (void)onGroupDestroyed:(CubeGroup *)group fromUser:(CubeUser *)from
{
    for (id<CWGroupServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWGroupServiceDelegate)]) {
        if([obj respondsToSelector:@selector(destroyGroup:from:)])
        {
            [obj destroyGroup:group from:from];
        }
    }
    CWSession *session = [[CWSession alloc]initWithSessionId:group.groupId andType:CWSessionTypeGroup];
    [[CubeWare sharedSingleton].messageService deleteSessions:@[session]];
}

- (void)onGroupUpdated:(CubeGroup *)group fromUser:(CubeUser *)from
{
    for (id<CWGroupServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWGroupServiceDelegate)]) {
        if([obj respondsToSelector:@selector(updateGroup:from:)])
        {
            [obj updateGroup:group from:from];
        }
    }
}

- (void)onMemberAddedWithGroup:(CubeGroup *)group fromUser:(CubeUser *)from withAddMembers:(NSArray <CubeUser *>*)addMembers
{
    for (id<CWGroupServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWGroupServiceDelegate)]) {
        if([obj respondsToSelector:@selector(addMembersGroup:from:Member:)])
        {
            [obj addMembersGroup:group from:from Member:addMembers];
        }
    }
}

- (void)onMemberRemovedWithGroup:(CubeGroup *)group fromUser:(CubeUser *)from withRemovedMembers:(NSArray <CubeUser *>*)removedMembers
{}
- (void)onMasterAddedWithGroup:(CubeGroup *)group fromUser:(CubeUser *)from withAddMasters:(NSArray <CubeUser *>*)addedMasters
{}
- (void)onMasterRemovedWithGroup:(CubeGroup *)group fromUser:(CubeUser *)from withRemovedMasters:(NSArray <CubeUser *>*) removedMasters
{}
- (void)onGroupApplied:(CubeGroup *)group withApplier:(CubeUser *)applier
{}
- (void)onGroupApplyJoinedWithGroup:(CubeGroup *)group fromUser:(CubeUser *)from withApplier:(CubeUser *)applier
{}
- (void)onGroupRejectApplied:(CubeGroup *)group fromUser:(CubeUser *)from withApplier:(CubeUser *)applier
{}
- (void)onGroupInvited:(CubeGroup *)group fromUser:(CubeUser *)from withInvites:(NSArray <CubeUser *> *)invites
{
    for (id<CWGroupServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWGroupServiceDelegate)]) {
        if([obj respondsToSelector:@selector(inviteMembersGroup:from:Member:)])
        {
            [obj inviteMembersGroup:group from:from Member:invites];
        }
    }
}
- (void)onGroupRejectInvited:(CubeGroup *)group fromUser:(CubeUser *)from withRejectMember:(CubeUser *)rejectMember
{}
- (void)onGroupInviteJoined:(CubeGroup *)group fromUser:(CubeUser *)from withJoinMember:(CubeUser *)joinedMember
{}
@end
