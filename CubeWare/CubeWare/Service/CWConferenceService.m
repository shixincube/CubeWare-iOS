//
//  CWConferenceService.m
//  CubeWare
//  
//  Created by 美少女 on 2018/1/4.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWConferenceService.h"
#import "CWVideoRootView.h"
#import "CWAudioRootView.h"
#import "CWMessageRinging.h"
#import "CWToastUtil.h"
#import "CWUtils.h"
#import "CWGroupAVManager.h"

@interface CWConferenceService ()
/**
 通话时长定时器
 */
@property (nonatomic , strong) NSTimer *callTimer;

/**
 通话时间
 */
@property (nonatomic , assign) long long timeCount;


@end

@implementation CWConferenceService

//static CWConferenceService *instance = nil;

-(instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

#pragma mark - CubeEngineConferenceServiceDelegate
- (void)onConferenceCreated:(CubeConference *)conference byUser:(CubeUser *)user{
    NSLog(@"onConference created");
    if ([conference.type isEqualToString:CubeGroupType_Share_Desktop_Conference])
    {

    }
    else
    {
        // 此处通过bindGroupId来区分了
        if ([user.cubeId isEqualToString:[CubeEngine sharedSingleton].userService.currentUser.cubeId] && ([conference.bindGroupId hasPrefix:@"g"] || [conference.type isEqualToString:CubeGroupType_Voice_Call])) {
            [[CubeEngine sharedSingleton].conferenceService joinConference:conference.groupId];
        }
        
        for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
            if([obj respondsToSelector:@selector(createConference:byUser:)])
            {
                [obj createConference:conference byUser:user];
            }
        }
    }
}

- (void)onConferenceJoined:(CubeConference *)conference fromUser:(CubeUser *)joinedUser{
    NSLog(@"onConference joined");
    
    for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
        if([obj respondsToSelector:@selector(joinConference:andJoin:)])
        {
            [obj joinConference:conference andJoin:joinedUser];
        }
    }
    
    return;
}

-(void)onConferenceFailed:(CubeConference *)conference withError:(CubeError *)error{
    NSLog(@"onConference failed with error : %@",error);
    if ([conference.type isEqualToString:CubeGroupType_Share_Desktop_Conference])
    {
        for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
            if([obj respondsToSelector:@selector(conferenceFail: andError:)])
            {
                [obj conferenceFail:conference andError:error];
            }
        }
    }
    else
    {
        for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
            if([obj respondsToSelector:@selector(conferenceFail: andError:)])
            {
                [obj conferenceFail:conference andError:error];
            }
        }
    }

}

- (void)onConferenceInvited:(CubeConference *)conference fromUser:(CubeUser *)user andInvites:(NSArray<CubeUser *> *)invites{
    NSLog(@"onConference invited");
    for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
        if([obj respondsToSelector:@selector(inviteConference:andFrom:andInvites:)])
        {
            [obj inviteConference:conference andFrom:user andInvites:invites];
        }
    }
    return;
}

-(void)onConferenceQuited:(CubeConference *)conference fromUser:(CubeUser *)quitMember{
         NSLog(@"onConference quited");
        
        for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
            if([obj respondsToSelector:@selector(quitConference:andQuitMember:)])
            {
                [obj quitConference:conference andQuitMember:quitMember];
            }
        }
}

-(void)onConferenceDestroyed:(CubeConference *)conference byUser:(CubeUser *)user{
    NSLog(@"onConference destroyed");
    for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
        if([obj respondsToSelector:@selector(destroyConference:byUser:)])
        {
            [obj destroyConference:conference byUser:user];
        }
    }
    return;
}

-(void)onConferenceAcceptInvited:(CubeConference *)conference fromUser:(CubeUser *)inviteUser byUser:(CubeUser *)joinedMember{
    NSLog(@"onConferenceAccept invited");
    
    [[CubeEngine sharedSingleton].conferenceService joinConference:conference.groupId];
    for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
        if([obj respondsToSelector:@selector(joinConference:andJoin:)])
        {
            [obj joinConference:conference andJoin:joinedMember];
        }
    }
    return;
    
    
    
    if ([conference.type isEqualToString:CubeGroupType_Share_Desktop_Conference])
    {
        [[CubeEngine sharedSingleton].conferenceService joinConference:conference.groupId];
        for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
            if([obj respondsToSelector:@selector(joinConference:andJoin:)])
            {
                [obj joinConference:conference andJoin:joinedMember];
            }
        }
    }
    else
    {
        
    }
}

-(void)onConferenceRejectInvited:(CubeConference *)conference fromUser:(CubeUser *)inviteUser byUser:(CubeUser *)rejectUser{
    NSLog(@"onConferenceReject invited");
    for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
        if([obj respondsToSelector:@selector(rejectInviteConference:fromUser:byUser:)])
        {
            [obj rejectInviteConference:conference fromUser:inviteUser byUser:rejectUser];
        }
    }
    return;
    
    
    
    
    if ([conference.type isEqualToString:CubeGroupType_Share_Desktop_Conference])
    {

        for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
            if([obj respondsToSelector:@selector(rejectInviteConference:fromUser:byUser:)])
            {
                [obj rejectInviteConference:conference fromUser:inviteUser byUser:rejectUser];
            }
        }
    }
    else
    {

    }
}

-(void)onConnectedToConference:(CubeConference *)conference{
    NSLog(@"onConnectedToConference");
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *remoteVideoView;
        if ([conference.type isEqualToString:CubeGroupType_Video_Conference] ||
            [conference.type isEqualToString:CubeGroupType_Share_Desktop_Conference] ||
            [conference.type isEqualToString:CubeGroupType_Video_Call]) {
            remoteVideoView = [[CubeEngine sharedSingleton].mediaService getRemoteViewForTarget:[NSString stringWithFormat:@"%d",conference.number]];
            CGRect remoteFrame = CGRectMake(0, 0, UIScreenWidth, UIScreenWidth * 9/16);
            remoteVideoView.frame = remoteFrame;
        }
        else if ([conference.type isEqualToString:CubeGroupType_Voice_Conference] ||
                 [conference.type isEqualToString:CubeGroupType_Voice_Call]){
            remoteVideoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth * 9/16)];
            UILabel *showLable = [[UILabel alloc] init];
            showLable.text = @"正在进行多人语音通话...";
            showLable.textColor = [UIColor whiteColor];
            [remoteVideoView addSubview:showLable];
            showLable.textAlignment = NSTextAlignmentCenter;
            [showLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(remoteVideoView);
                make.size.mas_equalTo(CGSizeMake(UIScreenWidth, 30));
            }];
        }

        for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
            if([obj respondsToSelector:@selector(connectedConference:andView:)])
            {
                [obj connectedConference:conference andView:remoteVideoView];
            }
        }
    });
    return;

    
    
    if ([conference.type isEqualToString:CubeGroupType_Share_Desktop_Conference]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *remoteVideoView = [[CubeEngine sharedSingleton].mediaService getRemoteViewForTarget:[NSString stringWithFormat:@"%d",conference.number]];
            CGRect remoteFrame = CGRectMake(0, 0, UIScreenWidth, UIScreenWidth*9/16);
            remoteVideoView.frame = remoteFrame;
            for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
                if([obj respondsToSelector:@selector(connectedConference:andView:)])
                {
                    [obj connectedConference:conference andView:remoteVideoView];
                }
            }
        });
    }
    else
    {

    }
}

-(void)onConnecteingConference:(CubeConference *)conference{
    if ([conference.type isEqualToString:CubeGroupType_Share_Desktop_Conference])
    {
        if([[CubeEngine sharedSingleton].mediaService enableMediaType:CubeMediaTypeVideo forTarget:[NSString stringWithFormat:@"%d",conference.number]])
        {
            [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeVideo enable:NO forTarget:[NSString stringWithFormat:@"%d",conference.number]];
        }
    }
    else
    {
        if([conference.type isEqualToString:CubeGroupType_Video_Conference]
           || [conference.type isEqualToString:CubeGroupType_Mux_Conference]
           ||[conference.type isEqualToString:CubeGroupType_Video_Call])
        {
            if(![[CubeEngine sharedSingleton].mediaService enableMediaType:CubeMediaTypeVideo forTarget:[NSString stringWithFormat:@"%d",conference.number]])
            {
                [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeVideo enable:YES forTarget:[NSString stringWithFormat:@"%d",conference.number]];
            }
        }
        
    }
}

- (void)onAudioEnabled:(BOOL)enable inConference:(CubeConference *)conference {

}


- (void)onConferenceAcceptInvitedOther:(CubeConference *)conference from:(CubeUser *)from joinedMember:(CubeUser *)joinedMember {

}


- (void)onConferenceCreatedOther:(CubeConference *)conference from:(CubeUser *)from {

}


- (void)onConferenceDestroyedOther:(CubeConference *)conference from:(CubeUser *)from {

}


- (void)onConferenceInvitedOther:(CubeConference *)conference from:(CubeUser *)from invites:(NSArray *)invites {

}


- (void)onConferenceJoinedOther:(CubeConference *)conference joinedMember:(CubeUser *)joinedMember {

}


- (void)onConferenceQuitedOther:(CubeConference *)conference quitMember:(CubeUser *)quitMember {

}


- (void)onConferenceRejectInvitedOther:(CubeConference *)conference from:(CubeUser *)from rejectMember:(CubeUser *)rejectMember {

}


- (void)onConferenceUpdated:(CubeConference *)conference {
    NSLog(@"onConferenceUpdated = %@",[conference toDictionary]);

    for (id<CWConferenceServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWConferenceServiceDelegate)]) {
        if([obj respondsToSelector:@selector(updateConference:)])
        {
            [obj updateConference:conference];
        }
    }
    return;
    
     if ([conference.type isEqualToString:CubeGroupType_Share_Desktop_Conference]) {

     }
    else
    {

    }
}


- (void)onVideoEnabled:(BOOL)enable inConference:(CubeConference *)conference {

}

#warning update to Engine 3.0
- (BOOL)isVideoOrVoiceCall:(CubeConference *)conference
{
//    return conference.type == ConferenTypeVoiceCall || conference.type == ConferenTypeVideoCall;
	return NO;
}

- (BOOL)areHeadphonesPluggedIn {
    NSArray *availableOutputs = [[AVAudioSession sharedInstance] currentRoute].outputs;
    for (AVAudioSessionPortDescription *portDescription in availableOutputs) {
        if ([portDescription.portType isEqualToString:AVAudioSessionPortHeadphones]) {
            return YES;
        }
    }
    return NO;
}

- (void)configureAVAudioSession
{
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    BOOL headphoneEnable = [self areHeadphonesPluggedIn];
    //设置免提按钮可用状态
    if (headphoneEnable) {
        [[CWVideoRootView VideoRootView] setHandFreeEnable:NO];
        [[CWAudioRootView AudioRootView] setHandFreeEnable:NO];
    } else {
        [[CWVideoRootView VideoRootView] setHandFreeEnable:YES];
        [[CWAudioRootView AudioRootView] setHandFreeEnable:YES];
    }
    NSString* category = [AVAudioSession sharedInstance].category;
    AVAudioSessionCategoryOptions options = [AVAudioSession sharedInstance].categoryOptions;
    // Respect old category options if category is
    // AVAudioSessionCategoryPlayAndRecord. Otherwise reset it since old options
    // might not be valid for this category.
    if ([category isEqualToString:AVAudioSessionCategoryPlayAndRecord]) {
        if (!headphoneEnable) {
            options |= AVAudioSessionCategoryOptionDefaultToSpeaker;
        } else {
            options &= ~AVAudioSessionCategoryOptionDefaultToSpeaker;
        }
    } else {
        options = AVAudioSessionCategoryOptionDefaultToSpeaker;
    }
}

#warning update to Engine 3.0
- (BOOL)isCurrentConference:(CubeConference *)conference{
//    NSString *confId = conference.conferenceId;
//    NSString *groupAvConfId = [CWGroupAVManager sharedSingleton].conference.conferenceId;
//    NSString *engineConfId = [[CubeEngine sharedSingleton] session].conference.conferenceId;
//    BOOL avManageConf = [[CWGroupAVManager sharedSingleton].conference.conferenceId isEqualToString:conference.conferenceId];
//    BOOL engineConf = [[[CubeEngine sharedSingleton] session].conference.conferenceId isEqualToString:conference.conferenceId];
//    return avManageConf || engineConf;
	return YES;
}

#pragma mark - 远程桌面流程使用
- (void)inviteConference:(CubeConference *)conference  andInvites:(NSArray *)invites
{
    BOOL ret = [[CubeEngine sharedSingleton].conferenceService inviteMembers:invites intoConference:conference.groupId];
    if (ret) {

    }
    else
    {
         NSLog(@"引擎处理inviteConference指令失败");
    }
}
- (void)quitConferenceService:(CubeConference *)conference
{
    BOOL ret = [[CubeEngine sharedSingleton].conferenceService quitConference:conference.groupId];
    if (ret) {

    }
    else
    {
        NSLog(@"引擎处理quitConference指令失败");
    }
}

- (void)rejectConferenceService:(CubeConference *)conference andFrom:(CubeUser *)user
{
   BOOL ret =  [[CubeEngine sharedSingleton].conferenceService rejectInviteFrom:user.cubeId withConferenceId:conference.groupId];
    if (ret) {

    }
    else
    {
        NSLog(@"引擎处理rejectConference指令失败");
    }
}

- (void)acceptConferenceService:(CubeConference *)conference andFrom:(CubeUser *)user
{
    BOOL ret = [[CubeEngine sharedSingleton].conferenceService acceptInviteFrom:user.cubeId withConferenceId:conference.groupId];
    if (ret) {

    }
    else
    {
        NSLog(@"引擎处理acceptConference指令失败");
    }
}


-(void)joinConference:(CubeConference *)conference
{
    BOOL ret = [[CubeEngine sharedSingleton].conferenceService joinConference:conference.groupId];
    if (ret) {

    }
    else
    {
        NSLog(@"引擎处理joinConference指令失败");
    }
}

-(void)queryConferenceWithConferenceType:(NSArray *)conferenceTypes
                                groupIds:(NSArray *)groupIds
                              completion:(void(^)(NSArray *conferences))completion
                                 failure:(void(^)(CubeError *error))failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[CubeEngine sharedSingleton].conferenceService queryConferenceWithConferenceType:@[] groupIds:groupIds completion:^(NSArray *conferences) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(conferences);
            });
        } failure:^(CubeError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }];
    });
}

@end
