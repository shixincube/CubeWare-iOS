//
//  CDInviteView.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/6.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDInviteView.h"
#import "CDConnectedView.h"
#import "CWToastUtil.h"


typedef enum : NSUInteger {
    InviteView_GroupInviteTypeNone,
    InviteView_GroupInviteTypeCall,
    InviteView_GroupInviteTypeConference,
    InviteView_GroupInviteTypeWhiteBoard,
    InviteView_GroupInviteTypeShareDesktop,
} InviteView_GroupInviteType;

@interface CDInviteView()<CWShareDesktopServiceDelegate,CWConferenceServiceDelegate,CWWhiteBoardServiceDelegate,CWCallServiceDelegate>
/**
 挂断
 */
@property (nonatomic,strong) UIButton *hangupButton;
/**
 接听
 */
@property (nonatomic,strong) UIButton *answerButton;

/**
 邀请人头像
 */
@property (nonatomic,strong) UIImageView *fromUserView;

/**
 邀请人名称
 */
@property (nonatomic,strong) UILabel *fromUserName;

/**
 提示语
 */
@property (nonatomic,strong) UILabel *tipLabel;

/**
 被邀请人列表
 */
@property (nonatomic,strong) UIView *invitesView;

/**
 当前邀请的类型
 */
@property (nonatomic,assign) InviteView_GroupInviteType currentInviteType;

@end


@implementation CDInviteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KWhiteColor;
        [self addSubview:self.fromUserView];
        [self addSubview:self.fromUserName];
        [self addSubview:self.tipLabel];
        [self addSubview:self.hangupButton];
        [self addSubview:self.answerButton];
        [self addSubview:self.invitesView];
        [self setUI];
        //注册代理

         [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWConferenceServiceDelegate),@protocol(CWWhiteBoardServiceDelegate),@protocol(CWCallServiceDelegate)]];
    }
    return self;
}


- (void)showView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
         [[UIApplication sharedApplication].keyWindow addSubview:self];
    });
}

- (void)setUI
{
    [self.fromUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@80);
        make.width.height.mas_equalTo(@100);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [self.fromUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fromUserView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(@30);
    }];

    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fromUserName.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(@30);
    }];

    [self.hangupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.width).offset(-self.width/4);
        make.height.mas_equalTo(@50);
        make.width.mas_equalTo(@130);
         make.top.mas_equalTo(self.invitesView.mas_bottom).offset(10);
    }];
    [self.answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(@(self.width/4));
        make.height.mas_equalTo(@50);
        make.width.mas_equalTo(@130);
        make.top.mas_equalTo(self.hangupButton.mas_top);
    }];
    [self.invitesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(4 * 60));
        make.height.mas_equalTo(@(3 * 55));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.tipLabel.mas_bottom);
    }];
}

- (UIButton *)hangupButton
{
    if (nil == _hangupButton) {
        _hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hangupButton setImage:[UIImage imageNamed:@"hangup"] forState:UIControlStateNormal];
        [_hangupButton setImage:[UIImage imageNamed:@"hangup_selected"] forState:UIControlStateDisabled];
        [_hangupButton setTitle:@"挂断" forState:UIControlStateNormal];
        [_hangupButton setTitleColor:KBlackColor forState:UIControlStateNormal];
        [_hangupButton addTarget:self action:@selector(onClickHandupButton:) forControlEvents:UIControlEventTouchUpInside];
        [_hangupButton setFrame:CGRectMake(0, 0, 100, 60)];
        _hangupButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _hangupButton.centerX = kScreenWidth /3;
        _hangupButton.centerY = self.frame.size.height - 100;
        [_hangupButton setImageEdgeInsets:UIEdgeInsetsMake(-_hangupButton.titleLabel.intrinsicContentSize.height, 0, 0, -_hangupButton.titleLabel.intrinsicContentSize.width)];
        [_hangupButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_hangupButton.imageView.frame.size.width, -(_hangupButton.imageView.frame.size.height ), 0)];
    }
    return _hangupButton;
}

- (UIButton *)answerButton
{
    if (nil == _answerButton) {
        _answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_answerButton setImage:[UIImage imageNamed:@"answer"] forState:UIControlStateNormal];
        [_answerButton setImage:[UIImage imageNamed:@"answer_selected"] forState:UIControlStateDisabled];
        [_answerButton setTitle:@"接听" forState:UIControlStateNormal];
        [_answerButton setTitleColor:KBlackColor forState:UIControlStateNormal];
        [_answerButton addTarget:self action:@selector(onClickAnswerButton:) forControlEvents:UIControlEventTouchUpInside];
        [_answerButton setFrame:CGRectMake(0, 0, 100, 60)];
        _answerButton.centerX = kScreenWidth /3;
        _answerButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _answerButton.centerY = self.frame.size.height - 100;
        [_answerButton setImageEdgeInsets:UIEdgeInsetsMake(-_answerButton.titleLabel.intrinsicContentSize.height, 0, 0, -_answerButton.titleLabel.intrinsicContentSize.width)];
        [_answerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_answerButton.imageView.frame.size.width, -(_answerButton.imageView.frame.size.height ), 0)];
    }
    return _answerButton;
}

- (UIImageView *)fromUserView
{
    if (nil == _fromUserView)
    {
        _fromUserView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
        _fromUserView.size = CGSizeMake(100, 100);
        _fromUserView.centerX = self.centerX;
        _fromUserView.y = 50;
        _fromUserView.layer.cornerRadius = 50;
        _fromUserView.layer.masksToBounds = YES;
    }
    return _fromUserView;
}

- (UILabel *)fromUserName
{
    if (nil == _fromUserName) {
        _fromUserName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _fromUserName.textColor = KGrayColor;
        _fromUserName.font = [UIFont systemFontOfSize:14];
        _fromUserName.textAlignment = NSTextAlignmentCenter;
        _fromUserName.text = @"邀请人昵称";
    }
    return _fromUserName;
}
- (UILabel *)tipLabel
{
    if (nil == _tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _tipLabel.textColor = KGrayColor;
        _tipLabel.font = [UIFont systemFontOfSize:11];
        _tipLabel.text = @"邀请你加入桌面分享...";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIView *)invitesView
{
    if (nil == _invitesView) {
        _invitesView = [[UIView alloc]initWithFrame:CGRectZero];
        _invitesView.backgroundColor = KClearColor;
    }
    return _invitesView;
}


#pragma mark - Setter Method
- (void)setConference:(CubeConference *)conference
{
    _conference = conference;
    self.currentInviteType = InviteView_GroupInviteTypeConference;
    if ([conference.type isEqualToString:CubeGroupType_Share_Desktop_Conference]) {
        self.tipLabel.text = @"邀请你加入桌面分享...";
    }
    else{
        self.tipLabel.text = @"邀请你加入会议...";
    }
}

-(void)setWhiteBoard:(CubeWhiteBoard *)whiteBoard{
    _whiteBoard = whiteBoard;
    self.currentInviteType = InviteView_GroupInviteTypeWhiteBoard;
    self.tipLabel.text = @"邀请你加入白板演示...";
}

-(void)setShareDesktop:(CubeShareDesktop *)shareDesktop{
    _shareDesktop = shareDesktop;
    self.currentInviteType = InviteView_GroupInviteTypeShareDesktop;
}

-(void)setCallSession:(CubeCallSession *)callSession{
    _callSession = callSession;
    self.currentInviteType = InviteView_GroupInviteTypeCall;
    self.tipLabel.text = callSession.videoEnabled ? @"邀请你进行视频通话..." : @"邀请你进行音频通话...";
    self.invitesView.hidden = YES;
}

- (void)setFrom:(CubeUser *)from
{
    _from = from;
    NSString *displayName = from.displayName;
    if (displayName && [displayName isEqualToString:@""]) {
        displayName = from.cubeId;
    }
    self.fromUserName.text = displayName;
    [self.fromUserView sd_setImageWithURL:[NSURL URLWithString:from.avatar] placeholderImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
}

- (void)setInvites:(NSArray *)invites
{
    _invites = invites;
    for (int i = 0; i < 8; i ++) {
        if (i < _invites.count) {
            CubeUser *member = [_invites objectAtIndex:i];
            UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
            [iconView sd_setImageWithURL:[NSURL URLWithString:member.avatar] placeholderImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
            [iconView setFrame:CGRectMake(i%4 * 60, i/4 * 55 , 50, 50)];
            iconView.layer.cornerRadius = 25;
            iconView.layer.masksToBounds = YES;
            [self.invitesView addSubview:iconView];
        }
    }
}

#pragma mark - Button Method

- (void)onClickHandupButton:(UIButton *)button
{
    if (self.currentInviteType == InviteView_GroupInviteTypeConference) {
        [[CubeWare sharedSingleton].conferenceService rejectConferenceService:self.conference andFrom:self.from];
    }
    else if (self.currentInviteType == InviteView_GroupInviteTypeWhiteBoard){
        [[CubeWare sharedSingleton].whiteBoardService rejectInviteWhiteBoard:self.whiteBoard.whiteboardId andInviter:self.from.cubeId];
    }
    else if (self.currentInviteType == InviteView_GroupInviteTypeCall){
        [[CubeWare sharedSingleton].callService terminalCall:self.callSession.callee.cubeId];
    }
}

- (void)onClickAnswerButton:(UIButton *)button
{
    if (self.currentInviteType == InviteView_GroupInviteTypeConference) {
        [[CubeWare sharedSingleton].conferenceService acceptConferenceService:self.conference andFrom:self.from];
    }
    else if (self.currentInviteType == InviteView_GroupInviteTypeWhiteBoard){
        [[CubeWare sharedSingleton].whiteBoardService acceptInviteWhiteBoard:self.whiteBoard.whiteboardId andInviter:self.from.cubeId];
    }
    else if (self.currentInviteType == InviteView_GroupInviteTypeCall){
        [[CubeWare sharedSingleton].callService answerCall:self.callSession.callee.cubeId];
    }
}


#pragma mark - CWConferenceServiceDelegate
- (void)conferenceFail:(CubeConference *)conference andError:(CubeError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        if([conference.groupId isEqualToString:self.conference.groupId])
//        {
            [CWToastUtil showTextMessage:error.errorInfo andDelay:1.0f];
            [self removeFromSuperview];
//        }
    });
}

- (void)connectedConference:(CubeConference *)conference andView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([conference.groupId isEqualToString:self.conference.groupId]) {
            [self removeFromSuperview];
        }
    });
}

- (void)rejectInviteConference:(CubeConference *)conference fromUser:(CubeUser *)inviteUser byUser:(CubeUser *)rejectUser
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([conference.groupId isEqualToString:self.conference.groupId] && [rejectUser.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
            [self removeFromSuperview];
        }
    });
}

-(void)acceptInviteConference:(CubeConference *)conference fromUser:(CubeUser *)inviterUser byUser:(CubeUser *)accpetUser{
    if ([conference.groupId isEqualToString:self.conference.groupId] && [accpetUser.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId])
    {
         [[CubeWare sharedSingleton].conferenceService joinConference:conference];
    }
}

- (void)destroyConference:(CubeConference *)conference byUser:(CubeUser *)user
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([conference.groupId isEqualToString:self.conference.groupId])
        {
            [CWToastUtil showTextMessage:@"会议被销毁" andDelay:1.0f];
            [self removeFromSuperview];
        }
    });
}


- (void)joinConference:(CubeConference *)conference andJoin:(CubeUser *)joiner {
    
}


- (void)quitConference:(CubeConference *)conference andQuitMember:(CubeUser *)quiter {
    
}


- (void)updateConference:(CubeConference *)conference {
    
}


#pragma mark - CWWhiteBoardServiceDelegate
-(void)whiteBoardCreate:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser andView:(UIView *)view{
    
}

-(void)whiteBoardQuit:(CubeWhiteBoard *)whiteBoard quitMember:(CubeUser *)quitMember{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([quitMember.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId] && [self.whiteBoard.whiteboardId isEqualToString:whiteBoard.whiteboardId]) {
            [self removeFromSuperview];
        }
    });
}

-(void)whiteBoardDestroy:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.whiteBoard.whiteboardId isEqualToString:whiteBoard.whiteboardId]) {
            [self removeFromSuperview];
        }
    });
}

-(void)whiteBoardInvite:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser invites:(NSArray<CubeGroupMember *> *)invites{
    
}

-(void)whiteBoardAcceptInvite:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser joinedMember:(CubeUser *)joinedMember{
    if ([whiteBoard.groupId isEqualToString:self.whiteBoard.groupId] && [joinedMember.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
        [[CubeWare sharedSingleton].whiteBoardService joinWhiteBoard:whiteBoard.whiteboardId];
    }
}

-(void)whiteBoardRejectInvite:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser rejectMember:(CubeUser *)rejectMember{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([whiteBoard.groupId isEqualToString:self.whiteBoard.groupId] && [rejectMember.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
            [self removeFromSuperview];
        }
    });
}

-(void)whiteBoardJoin:(CubeWhiteBoard *)whiteBoard joinedMember:(CubeUser *)joinedMember andView:(UIView *)view{
    if ([joinedMember.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
            CDConnectedView *connectedView = [CDConnectedView shareInstance];
            [connectedView.whiteBoarView addSubview:view];
            connectedView.whiteBoard = whiteBoard;
            [connectedView show];
        });
    }
}
-(void)whiteBoardFailed:(CubeWhiteBoard *)whiteBoard error:(CubeError *)error{
    
}

#pragma mark - CWCallServiceDelegate
-(void)newCall:(CubeCallSession *)callSession from:(CubeUser *)from{
    
}

-(void)callRing:(CubeCallSession *)callSession from:(CubeUser *)from{
    
}

-(void)callConnected:(CubeCallSession *)callSession from:(CubeUser *)from andRemoteView:(UIView *)remoteView andLocalView:(UIView *)localView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        CDConnectedView *connectedView = [CDConnectedView shareInstance];
        [connectedView.showView addSubview:remoteView];
        if (localView) {
            [connectedView.showView addSubview:localView];
        }
        connectedView.callSession = callSession;
        [connectedView show];
    });
}

-(void)callEnded:(CubeCallSession *)callSession from:(CubeUser *)from{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

-(void)callFailed:(CubeCallSession *)callSession error:(CubeError *)error from:(CubeUser *)from{
    
}



@end
