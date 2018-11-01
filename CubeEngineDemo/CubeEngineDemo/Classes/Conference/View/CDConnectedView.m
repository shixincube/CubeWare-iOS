//
//  CDConnectedView.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/6.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDConnectedView.h"
#import <UIImageView+WebCache.h>
#import "CWToastUtil.h"
#import "CDWhiteBoardToolView.h"

typedef enum : NSUInteger {
    ConnectedContent_None,
    ConnectedContent_Call,
    ConnectedContent_ShareDesktopType,
    ConnectedContent_ConferenceType,
    ConnectedContent_WhiteBoardType,
} ConnectedContentType;

@interface CDConnectedView ()<CWGroupServiceDelegate,CWConferenceServiceDelegate,CWWhiteBoardServiceDelegate,CDWhiteBoardToolViewDelegate,CWCallServiceDelegate>
/**
 标题
 */
@property (nonatomic,strong) UILabel *title;

/**
 缩小画面
 */
@property (nonatomic,strong) UIButton *narrowButon;

/**
 添加
 */
@property (nonatomic,strong) UIButton *addButton;

/**
 挂断
 */
@property (nonatomic,strong) UIButton *hangupButton;

/**
 话筒
 */
@property (nonatomic,strong) UIButton *muteButton;

/**
 免提
 */
@property (nonatomic,strong) UIButton *handfreeButton;

/**
 关闭摄像头
 */
@property (nonatomic,strong) UIButton *closeCameraButton;

/**
 切换摄像头
 */
@property (nonatomic,strong) UIButton *switchCameraButton;

/**
 已加入成员标题
 */
@property (nonatomic,strong) UILabel *joinTitle;

/**
 已加入成员
 */
@property (nonatomic,strong) UIScrollView *joinMemberView;

/**
 已邀请成员标题
 */
@property (nonatomic,strong) UILabel *inviteTitle;

/**
 已邀请未加入成员
 */
@property (nonatomic,strong) UIScrollView *inviteMemberView;

/**
 白板工具栏
 */
@property (nonatomic,strong) CDWhiteBoardToolView *whiteBoardToolView;

/**
 当前通话类型
 */
@property (nonatomic,assign) ConnectedContentType currentConnectedType;

/**
 media target
 */
@property (nonatomic,strong) NSString *target;


@end

static CDConnectedView *instanceView = nil;

@implementation CDConnectedView

#pragma mark - singleton method

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceView = [[CDConnectedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [instanceView initializeAppearance];
    });
    return instanceView;
}

#pragma mark - Public

- (void)show
{
    if (!self.conference && !self.whiteBoard && !self.callSession) {
        NSLog(@"ConnectedView warming ! :请先设置正确的数据源");
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [instanceView showOrHideAppearance];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    });
}

-(void)remove{
    dispatch_async(dispatch_get_main_queue(), ^{
        [instanceView cleanDataSource];
        [instanceView cleanAppearance];
        [instanceView removeFromSuperview];
    });
}

#pragma mark - private

- (void)cleanDataSource{
    self.whiteBoard = nil;
    self.conference = nil;
    self.currentConnectedType = ConnectedContent_None;
}

- (void)cleanAppearance{
    for (UIView *subView in self.showView.subviews) {
        [subView removeFromSuperview];
    }
    for (UIView *subView in self.joinMemberView.subviews) {
        [subView removeFromSuperview];
    }
    for (UIView *subView in self.inviteMemberView.subviews) {
        [subView removeFromSuperview];
    }
    for (UIView *subView in self.whiteBoarView.subviews) {
        [subView removeFromSuperview];
    }
}

- (void)initializeAppearance{
    self.backgroundColor = KBlackColor;
    [self addSubview:self.showView];
    [self addSubview:self.whiteBoarView];
    [self addSubview:self.title];
    //[self addSubview:self.narrowButon];
    [self addSubview:self.joinTitle];
    [self addSubview:self.inviteTitle];
    [self addSubview:self.addButton];
    [self addSubview:self.joinMemberView];
    [self addSubview:self.inviteMemberView];
    [self addSubview:self.hangupButton];

    
    [self addSubview:self.closeCameraButton];
    [self addSubview:self.switchCameraButton];
    [self addSubview:self.handfreeButton];
    [self addSubview:self.muteButton];
    [self addSubview:self.whiteBoardToolView];
    [self setUI];
    
    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWConferenceServiceDelegate),@protocol(CWWhiteBoardServiceDelegate),@protocol(CWCallServiceDelegate)]];
}

- (void)setUI
{
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(32);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(@18);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
//    [self.narrowButon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(@40);
//        make.left.mas_offset(@20);
//        make.top.mas_offset(@10);
//    }];

    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@30);
        make.right.mas_equalTo(self.width).offset(-20);
        make.top.mas_equalTo(@30);
    }];

    [self.joinTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title.mas_bottom).offset(23);
        make.height.mas_equalTo(@14);
        make.width.mas_equalTo(@100);
        make.left.mas_equalTo(@18);
    }];
    
    [self.joinMemberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.joinTitle.mas_bottom).offset(10);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(self.mas_width);
        make.left.mas_equalTo(self.joinTitle.mas_left);
    }];
    [self.inviteTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.joinMemberView.mas_bottom).offset(20);
        make.left.mas_equalTo(self.self.joinTitle.mas_left);
        make.height.mas_equalTo(@14);
        make.width.mas_equalTo(@100);
    }];
    [self.inviteMemberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inviteTitle.mas_bottom).offset(10);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(self.mas_width);
        make.left.mas_equalTo(self.joinTitle.mas_left);
    }];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(@(kScreenWidth));
        make.height.mas_equalTo(@(kScreenHeight));
    }];
    [self.whiteBoarView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(@(kScreenWidth));
        make.height.mas_equalTo(@(kScreenWidth*9/16));
    }];
    [self.whiteBoardToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo(25);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(kScreenWidth * 9/16);
    }];

    [self.hangupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];

    [self.handfreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.hangupButton.mas_centerY).offset(18);
        make.centerX.mas_equalTo(self.mas_centerX).offset(-self.width/4 - 20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(58);
    }];

    [self.muteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.handfreeButton.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX).offset(self.width/4 + 20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(58);
    }];
}

- (void)showOrHideAppearance{
//    self.switchCameraButton.hidden = self.currentConnectedType != ConnectedContent_ConferenceType;
//    self.closeCameraButton.hidden = self.currentConnectedType != ConnectedContent_ConferenceType;
    
    if ((self.currentConnectedType == ConnectedContent_ConferenceType && ([self.conference.type isEqualToString:CubeGroupType_Voice_Conference] || [self.conference.type isEqualToString:CubeGroupType_Voice_Call] || [self.conference.type isEqualToString:CubeGroupType_Share_Desktop_Conference])) ||
        self.currentConnectedType != ConnectedContent_ConferenceType || self.currentConnectedType != ConnectedContent_Call) {
        self.switchCameraButton.hidden = YES;
        self.closeCameraButton.hidden = YES;
    }
    
    self.handfreeButton.hidden = self.currentConnectedType == ConnectedContent_WhiteBoardType;
    self.muteButton.hidden = self.currentConnectedType == ConnectedContent_WhiteBoardType;
    self.whiteBoardToolView.hidden = self.currentConnectedType != ConnectedContent_WhiteBoardType;
    
    BOOL callTypeEnable = self.currentConnectedType == ConnectedContent_Call;
    self.inviteTitle.hidden = callTypeEnable;
    self.inviteMemberView.hidden = callTypeEnable;
    self.joinTitle.hidden = callTypeEnable;
    self.inviteMemberView.hidden = callTypeEnable;
    BOOL p2pWhiteBoard = self.currentConnectedType == ConnectedContent_WhiteBoardType && self.whiteBoard.maxNumber == 2;
    self.addButton.hidden = callTypeEnable || p2pWhiteBoard;
}


-(UIView *)showView{
    if (!_showView) {
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _showView.backgroundColor = KClearColor;
    }
    return _showView;
}

-(UIView *)whiteBoarView{
    if (!_whiteBoarView) {
        _whiteBoarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*9/16)];
        _whiteBoarView.backgroundColor = KClearColor;
    }
    return _whiteBoarView;
}


- (UIButton *)narrowButon
{
    if (nil == _narrowButon) {
        _narrowButon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_narrowButon setBackgroundImage:[UIImage imageNamed:@"narrow"] forState:UIControlStateNormal];
        [_narrowButon addTarget:self action:@selector(onClickNarrowButton:) forControlEvents:UIControlEventTouchUpInside];
        [_narrowButon setFrame:CGRectMake(20, SafeAreaTopHeight, 40, 40)];
    }
    return _narrowButon;
}
- (UIButton *)addButton
{
    if (nil == _addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"addMember"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(onClickAddButton:) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setFrame:CGRectMake(kScreenWidth-50, SafeAreaTopHeight, 20, 20)];
    }
    return _addButton;
}

- (UILabel *)title
{
    if (nil == _title) {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, kScreenWidth, 40)];
        _title.backgroundColor = KClearColor;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = KWhiteColor;
        _title.font = [UIFont boldSystemFontOfSize:18];
    }
    return _title;
}

- (UIButton *)hangupButton
{
    if (nil == _hangupButton) {
        _hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hangupButton setImage:[UIImage imageNamed:@"hangup"] forState:UIControlStateNormal];
        [_hangupButton setImage:[UIImage imageNamed:@"hangup_selected"] forState:UIControlStateSelected];
        [_hangupButton setTitle:@"挂断" forState:UIControlStateNormal];
        [_hangupButton addTarget:self action:@selector(onClickHandupButton:) forControlEvents:UIControlEventTouchUpInside];
        [_hangupButton setFrame:CGRectMake(0, 0, 100, 60)];
        _hangupButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_hangupButton setImageEdgeInsets:UIEdgeInsetsMake(-_hangupButton.titleLabel.intrinsicContentSize.height-18, 0, 0, -_hangupButton.titleLabel.intrinsicContentSize.width)];
        [_hangupButton setTitleEdgeInsets:UIEdgeInsetsMake(18, -_hangupButton.imageView.frame.size.width, -_hangupButton.imageView.frame.size.height, 0)];
        _hangupButton.titleLabel.textColor = KWhiteColor;
    }
    return _hangupButton;
}

- (UIButton *)handfreeButton
{
    if (nil == _handfreeButton) {
        _handfreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handfreeButton setImage:[UIImage imageNamed:@"handfree"] forState:UIControlStateNormal];
        [_handfreeButton setImage:[UIImage imageNamed:@"handfree_selected"] forState:UIControlStateSelected];
        [_handfreeButton setTitle:@"免提" forState:UIControlStateNormal];
        [_handfreeButton addTarget:self action:@selector(onClickHandfreeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_handfreeButton setFrame:CGRectMake(0, 0, 100, 40)];
        _handfreeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_handfreeButton setImageEdgeInsets:UIEdgeInsetsMake(-_handfreeButton.titleLabel.intrinsicContentSize.height, 0, 0, -_handfreeButton.titleLabel.intrinsicContentSize.width)];
        [_handfreeButton setTitleEdgeInsets:UIEdgeInsetsMake(18, -_handfreeButton.imageView.frame.size.width, -_handfreeButton.imageView.frame.size.height, 0)];
        _handfreeButton.titleLabel.textColor = KWhiteColor;
    }
    return _handfreeButton;
}

- (UIButton *)muteButton
{
    if (nil == _muteButton) {
        _muteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteButton setImage:[UIImage imageNamed:@"mute_selected"] forState:UIControlStateNormal];
        [_muteButton setImage:[UIImage imageNamed:@"mute"] forState:UIControlStateSelected];
        [_muteButton setTitle:@"麦克风" forState:UIControlStateNormal];
        [_muteButton addTarget:self action:@selector(onClickMuteButton:) forControlEvents:UIControlEventTouchUpInside];
        [_muteButton setFrame:CGRectMake(0, 0, 100, 40)];
        _muteButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_muteButton setImageEdgeInsets:UIEdgeInsetsMake(-_muteButton.titleLabel.intrinsicContentSize.height, 0, 0, -_muteButton.titleLabel.intrinsicContentSize.width)];
        [_muteButton setTitleEdgeInsets:UIEdgeInsetsMake(18, -_muteButton.imageView.frame.size.width, -_muteButton.imageView.frame.size.height, 0)];
        _muteButton.titleLabel.textColor = KWhiteColor;
    }
    return _muteButton;
}


-(UIButton *)closeCameraButton{
    if (!_closeCameraButton) {
        _closeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeCameraButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_closeCameraButton setTitle:@"关闭摄像头" forState:UIControlStateNormal];
        [_closeCameraButton setTitle:@"开启摄像头" forState:UIControlStateSelected];
        [_closeCameraButton setImage:[UIImage imageNamed:@"closeCamera_default"] forState:UIControlStateNormal];
        [_closeCameraButton setImage:[UIImage imageNamed:@"openCamera_default"] forState:UIControlStateSelected];
        [_closeCameraButton addTarget:self action:@selector(onClickCloseCameraButton:) forControlEvents:UIControlEventTouchUpInside];
        [_closeCameraButton setFrame:CGRectMake(0, 0, 100, 40)];
        _closeCameraButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _closeCameraButton.centerX = kScreenWidth /2 / 2.5;
        _closeCameraButton.centerY = self.frame.size.height - 70 - 50;
        [_closeCameraButton setImageEdgeInsets:UIEdgeInsetsMake(-_closeCameraButton.titleLabel.intrinsicContentSize.height, 0, 0, -_closeCameraButton.titleLabel.intrinsicContentSize.width)];
        [_closeCameraButton setTitleEdgeInsets:UIEdgeInsetsMake(18, -_closeCameraButton.imageView.frame.size.width, -_closeCameraButton.imageView.frame.size.height, 0)];
        _closeCameraButton.titleLabel.textColor = KWhiteColor;
    }
    return _closeCameraButton;
}

-(UIButton *)switchCameraButton{
    if (!_switchCameraButton) {
        _switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchCameraButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_switchCameraButton setTitle:@"切换摄像头" forState:UIControlStateNormal];
        [_switchCameraButton setImage:[UIImage imageNamed:@"switchCamera"] forState:UIControlStateNormal];
        [_switchCameraButton addTarget:self action:@selector(onClickSwitchCameraButton:) forControlEvents:UIControlEventTouchUpInside];
        [_switchCameraButton setFrame:CGRectMake(0, 0, 100, 40)];
        _switchCameraButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _switchCameraButton.centerX = kScreenWidth /2 + (0.5f -1.f/5.f)*kScreenWidth;
        _switchCameraButton.centerY = self.frame.size.height - 70 - 50;
        [_switchCameraButton setImageEdgeInsets:UIEdgeInsetsMake(-_switchCameraButton.titleLabel.intrinsicContentSize.height, 0, 0, -_switchCameraButton.titleLabel.intrinsicContentSize.width)];
        [_switchCameraButton setTitleEdgeInsets:UIEdgeInsetsMake(18, -_switchCameraButton.imageView.frame.size.width, -_switchCameraButton.imageView.frame.size.height, 0)];
        _switchCameraButton.titleLabel.textColor = KWhiteColor;
    }
    return _switchCameraButton;
}



- (UIScrollView *)joinMemberView
{
    if (nil == _joinMemberView) {
        _joinMemberView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _joinMemberView.scrollEnabled = YES;
        _joinMemberView.userInteractionEnabled = YES;
    }
    return _joinMemberView;
}

- (UIScrollView *)inviteMemberView
{
    if (nil == _inviteMemberView) {
        _inviteMemberView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _inviteMemberView.scrollEnabled = YES;
        _inviteMemberView.userInteractionEnabled = YES;
    }
    return _inviteMemberView;
}

- (UILabel *)joinTitle
{
    if (nil == _joinTitle) {
        _joinTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _joinTitle.backgroundColor = KClearColor;
        _joinTitle.textAlignment = NSTextAlignmentLeft;
        _joinTitle.textColor = KWhiteColor;
        _joinTitle.font = [UIFont boldSystemFontOfSize:13];
        _joinTitle.text = @"已加入成员";
    }
    return _joinTitle;
}

- (UILabel *)inviteTitle
{
    if (nil == _inviteTitle) {
        _inviteTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _inviteTitle.backgroundColor = KClearColor;
        _inviteTitle.textAlignment = NSTextAlignmentLeft;
        _inviteTitle.textColor = KWhiteColor;
        _inviteTitle.font = [UIFont boldSystemFontOfSize:13];
        _inviteTitle.text = @"已邀请成员";
    }
    return _inviteTitle;
}


-(CDWhiteBoardToolView *)whiteBoardToolView{
    if (!_whiteBoardToolView) {
        _whiteBoardToolView = [[CDWhiteBoardToolView alloc] initWithFrame:CGRectMake(0, 0, 25, kScreenWidth*9/16)];
        _whiteBoardToolView.backgroundColor = KWhiteColor;
        _whiteBoardToolView.delegate = self;
    }
    return _whiteBoardToolView;
}

#pragma mark - Setter Method
- (void)setGroupType:(NSString *)groupType
{
    _groupType = groupType;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([groupType isEqualToString:CubeGroupType_Share_Desktop_Conference]) {
            self.title.text = @"屏幕分享";
        }
        else if ([groupType isEqualToString:CubeGroupType_Voice_Conference] || [groupType isEqualToString:CubeGroupType_Voice_Call])
        {
            self.title.text = @"多人语音";
        }
        else if ([groupType isEqualToString:CubeGroupType_Share_WB])
        {
            self.title.text = @"白板展示";
        }
        else
        {
            self.title.text = @"多人视频";
        }
    });
}

- (void)setConference:(CubeConference *)conference
{
    _conference = conference;
    [self setMemberViewWithGroup:conference];
    self.groupType = _conference.type;
    self.currentConnectedType = ConnectedContent_ConferenceType;
    self.target = [NSString stringWithFormat:@"%d",conference.number];
}

//-(void)setShareDesktop:(CubeShareDesktop *)shareDesktop{
//    _shareDesktop = shareDesktop;
//    if (self.currentConnectedType == ConnectedContent_None) {
//        [self setMemberViewWithGroup:shareDesktop];
//    }
//
//    self.currentConnectedType = ConnectedContent_ShareDesktopType;
//}

-(void)setWhiteBoard:(CubeWhiteBoard *)whiteBoard{
    _whiteBoard = whiteBoard;
    [self setMemberViewWithGroup:whiteBoard];
    self.groupType = CubeGroupType_Share_WB;
    self.currentConnectedType = ConnectedContent_WhiteBoardType;
}

-(void)setCallSession:(CubeCallSession *)callSession{
    _callSession = callSession;
    self.currentConnectedType = ConnectedContent_Call;
    if (callSession.callDirection == CubeCallDirectionIncoming) {
        self.title.text = callSession.callee.displayName;
    }
    else
    {
        self.title.text = callSession.caller.displayName;
    }
}


// set inviteView data appearance
- (void)setMemberViewWithGroup:(CubeGroup *)group
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *subView in self.joinMemberView.subviews) {
            [subView removeFromSuperview];
        }
        for (UIView *subView in self.inviteMemberView.subviews) {
            [subView removeFromSuperview];
        }
        
        if (group) {
            for (int i = 0; i < group.members.count ; i ++) {
                CubeUser *member = [group.members objectAtIndex:i];
                UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
                [iconView sd_setImageWithURL:[NSURL URLWithString:member.avatar] placeholderImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
                [iconView setFrame:CGRectMake(i * 45, 0, 40, 40)];
                iconView.layer.cornerRadius = 20;
                iconView.layer.masksToBounds = YES;
                [self.joinMemberView addSubview:iconView];
            }
            self.joinMemberView.contentSize = CGSizeMake(group.members.count * 45 , 0);
            
            //      NSMutableArray *invitesArray = [NSMutableArray array];
            for (int i = 0; i < group.invites.count ; i ++) {
                CubeUser *member = [group.invites objectAtIndex:i];
                UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
                [iconView sd_setImageWithURL:[NSURL URLWithString:member.avatar] placeholderImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
                [iconView setFrame:CGRectMake(i * 45, 0, 40, 40)];
                iconView.layer.cornerRadius = 20;
                iconView.layer.masksToBounds = YES;
                [self.inviteMemberView addSubview:iconView];
            }
            self.inviteMemberView.contentSize = CGSizeMake(group.invites.count * 45 , 0);
        }
    });
}




#pragma mark - events
- (void)onClickNarrowButton:(UIButton *)button
{
    //缩小
    [self removeFromSuperview];
}

- (void)onClickAddButton:(UIButton *)button
{
    //跳转到选择联系人界面
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickAddMoreMembers:)]) {
        [self.delegate onClickAddMoreMembers:self];
    }
}

- (void)onClickHandupButton:(UIButton *)button
{
    if (self.currentConnectedType == ConnectedContent_WhiteBoardType){
        [[CubeWare sharedSingleton].whiteBoardService quitWhiteBoard:self.whiteBoard.whiteboardId];
    }
    else if (self.currentConnectedType == ConnectedContent_ShareDesktopType){
        
    }
    else if (self.currentConnectedType == ConnectedContent_ConferenceType){
        [[CubeWare sharedSingleton].conferenceService quitConferenceService:self.conference];
    }
    else if (self.currentConnectedType == ConnectedContent_Call){
        [[CubeWare sharedSingleton].callService terminalCall:self.callSession.callee.cubeId];
    }
    
    [instanceView remove];
}


- (void)onClickHandfreeButton:(UIButton *)button
{
    if ([[CubeEngine sharedSingleton].mediaService speakerEnableForTarget:self.target]) {
        [[CubeEngine sharedSingleton].mediaService setSpeakerEnable:NO forTarget:self.target];
        button.selected = YES;
    }
    else{
        [[CubeEngine sharedSingleton].mediaService setSpeakerEnable:YES forTarget:self.target];
        button.selected = NO;
    }
}
- (void)onClickMuteButton:(UIButton *)button
{
    if ([[CubeEngine sharedSingleton].mediaService enableMediaType:CubeMediaTypeAudio forTarget:self.target]) {
        button.selected = YES;
        [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeAudio enable:NO forTarget:self.target];
    }
    else{
        button.selected = NO;
        [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeAudio enable:YES forTarget:self.target];
    }
}

- (void)onClickCloseCameraButton:(UIButton *)button
{
//    NSLog(@"click close camera ..");
    if(!button.isSelected)
    {
        [button setSelected:YES];
        [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeVideo enable:YES forTarget:self.target];
    }
    else
    {
        [button setSelected:NO];
        [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeVideo enable:NO forTarget:self.target];
    }

}

- (void)onClickSwitchCameraButton:(UIButton *)button
{
    NSLog(@"click switch camera ..");
    [[CubeEngine sharedSingleton].mediaService switchCameraForTarget:self.target];
}

#pragma mark - CDWhiteBoardToolView
- (void)onCilckTapBtn{
    [[CubeEngine sharedSingleton].whiteBoardService zoom:1.2f];
    [[CubeEngine sharedSingleton].whiteBoardService zoom:1.0f];
    [[CubeEngine sharedSingleton].whiteBoardService unSelect];
}

-(void)onClickPencilBtn{
    [[CubeEngine sharedSingleton].whiteBoardService selectPencil];
}

-(void)onClickEllipseBtn{
    [[CubeEngine sharedSingleton].whiteBoardService selectEllipse];
}

-(void)onClickFileBtn{
    
}

-(void)onClickArrowBtn{
    [[CubeEngine sharedSingleton].whiteBoardService selectArrow];
}

-(void)onClickCleanUpBtn{
    [[CubeEngine sharedSingleton].whiteBoardService  cleanup];
}


#pragma mark - CWGroupServiceDelegate
- (void)destroyGroup:(CubeGroup *)group from:(CubeUser *)from
{
    
}

- (void)groupFail:(CubeError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CWToastUtil showTextMessage:error.errorInfo andDelay:1.0f];
    });
}

#pragma mark - CWWhiteBoardServiceDelegate
-(void)whiteBoardCreate:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser{
    
}

-(void)whiteBoardQuit:(CubeWhiteBoard *)whiteBoard quitMember:(CubeUser *)quitMember{
    if (![quitMember.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
        self.whiteBoard = whiteBoard;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.whiteBoard.whiteboardId isEqualToString:whiteBoard.whiteboardId]) {
            [instanceView remove];
        }
        });
    }
}

-(void)whiteBoardDestroy:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.whiteBoard.whiteboardId isEqualToString:whiteBoard.whiteboardId]) {
             [instanceView remove];
        }
    });
}

-(void)whiteBoardInvite:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser invites:(NSArray<CubeGroupMember *> *)invites{
    
}

-(void)whiteBoardJoin:(CubeWhiteBoard *)whiteBoard joinedMember:(CubeUser *)joinedMember andView:(UIView *)view{
    if (![joinedMember.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
        // reload member
        self.whiteBoard = whiteBoard;
    }
}

-(void)whiteBoardAcceptInvite:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser joinedMember:(CubeUser *)joinedMember{
    
}

-(void)whiteBoardRejectInvite:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser rejectMember:(CubeUser *)rejectMember{
    
}

-(void)whiteBoardFailed:(CubeWhiteBoard *)whiteBoard error:(CubeError *)error{
    
}




#pragma mark - CWConferenceServiceDelegate

-(void)connectedConference:(CubeConference *)conference andView:(UIView *)view{
}

- (void)joinConference:(CubeConference *)conference andJoin:(CubeUser *)joiner
{
    self.conference = conference;
}

- (void)conferenceFail:(CubeConference *)conference andError:(CubeError *)error
{
    // 区分error 创建失败 需移除view , 否则不需要移除view
//    dispatch_async(dispatch_get_main_queue(), ^{
////        [CWToastUtil showTextMessage:error.errorInfo andDelay:1.0f];
//        [self removeFromSuperview];
//    });
}

- (void)quitConference:(CubeConference *)conference andQuitMember:(CubeUser *)quiter
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.conference = conference;
        if ([quiter.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
            [instanceView remove];
        }
    });
}

- (void)updateConference:(CubeConference *)conference
{
    //更新会议
    _conference = conference;
}

- (void)rejectInviteConference:(CubeConference *)conference fromUser:(CubeUser *)inviteUser byUser:(CubeUser *)rejectUser
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self removeFromSuperview];
    });
}

- (void)destroyConference:(CubeConference *)conference byUser:(CubeUser *)user
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [CWToastUtil showTextMessage:@"会议被销毁" andDelay:1.0f];
        [instanceView remove];
    });
}

#pragma mark - CWCallServiceDelegate
-(void)callEnded:(CubeCallSession *)callSession from:(CubeUser *)from{
    if (![[CubeWare sharedSingleton].whiteBoardService currentWhiteboardActing]) { //当前如果没进行白板演示
        dispatch_async(dispatch_get_main_queue(), ^{
            [instanceView remove];
        });
    }
}



@end
