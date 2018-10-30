//
//  CWMultiAudioView.m
//  CubeWare
//
//  Created by 美少女 on 2017/12/28.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWMultiAudioView.h"
#import "CWColorUtil.h"
#import "Masonry.h"
#import "CWApplyjoinCollectionViewCell.h"
#import "CWAudioMembersCollectionViewCell.h"
#import "AFNetworking.h"
#import "CWResourceUtil.h"
#import "CWColorUtil.h"
#import "CWMessageRinging.h"
#import "CWUtils.h"
#import "CWToastUtil.h"
#import "UIImageView+WebCache.h"

static NSString *inviteMembersCellIdentifier = @"inviteMembers";
static NSString *connetMembersCellIdentifier = @"inviteMembers";
@interface CWMultiAudioView ()<UICollectionViewDelegate,UICollectionViewDataSource>
/**
 背景
 */
@property (nonatomic, strong) UIImageView *backgroundView;

/**
 邀请人头像
 */
@property (nonatomic, strong) UIImageView *inviteIconView;

/**
 邀请人名字
 */
@property (nonatomic, strong) UILabel *inviteName;

/**
 接听状态描述 例如：正在等待对方接受邀请...
 */
@property (nonatomic, strong) UILabel *connectStateLabel;

/**
 邀请成员列表
 */
@property (nonatomic, strong) UICollectionView *inviteMembersCollectView;

/**
 通话中成员列表
 */
@property (nonatomic, strong) UICollectionView *connectMembersCollectView;

/**
 通话成员描述
 */
@property (nonatomic, strong) UILabel *inviteMemberLabel;

/**
 群名称
 */
@property (nonatomic, strong) UILabel *groupName;

/**
 网络连接状态
 */
@property (nonatomic, strong) UILabel *netWorkStatusLabel;


/**
 拒绝按钮
 */
@property (nonatomic, strong) UIButton *rejectButton;

/**
 拒绝按钮描述文字
 */
@property (nonatomic, strong) UILabel *rejectLabel;

/**
 接听按钮
 */
@property (nonatomic, strong) UIButton *answerButton;

/**
 接听按钮描述文字
 */
@property (nonatomic, strong) UILabel *answerLabel;

/**
 麦克风按钮
 */
@property (nonatomic, strong) UIButton *microPushButton;

/**
 麦克风按钮描述文字
 */
@property (nonatomic, strong) UILabel *microLabel;

/**
 免提按钮
 */
@property (nonatomic, strong) UIButton *handsFreeButton;

/**
 免提按钮描述
 */
@property (nonatomic, strong) UILabel *handsFreeLabel;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelButton;

/**
 取消按钮描述
 */
@property (nonatomic, strong) UILabel *cancelLabel;

/**
 缩小窗体按钮
 */
@property (nonatomic, strong) UIButton *zoomOutButton;

/**
 通话时长
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 通话状态
 */
@property (nonatomic, strong) UIImageView *timeView;

/**
 添加成员按钮
 */
@property (nonatomic, strong) UIButton *addMemberButton;

/**
 标题栏
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 控件显示类型
 */
@property (nonatomic, assign) AVShowViewStyle viewStyle;

@property (nonatomic, strong) NSDate *lastDate;

/**
 数据
 */
@property (nonatomic,strong) NSMutableArray *dataSource;
@end


@implementation CWMultiAudioView

- (instancetype)initWithFrame:(CGRect)frame withAudioShowStyle:(AVShowViewStyle)style
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.viewStyle = style;
        [self createView];
    }
    return self;
}

- (void)dealloc
{

}

- (void)createView
{
    [self addSubview:self.backgroundView];

    [self addSubview:self.inviteIconView];
    [self addSubview:self.inviteName];
    [self addSubview:self.groupName];
    [self addSubview:self.inviteMemberLabel];
    [self addSubview:self.inviteMembersCollectView];
    [self addSubview:self.netWorkStatusLabel];
    [self addSubview:self.connectStateLabel];
    [self addSubview:self.rejectButton];
    [self addSubview:self.rejectLabel];
    [self addSubview:self.answerButton];
    [self addSubview:self.answerLabel];
    [self addSubview:self.handsFreeButton];
    [self addSubview:self.handsFreeLabel];
    [self addSubview:self.microPushButton];
    [self addSubview:self.microLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.cancelLabel];

    [self addSubview:self.titleLabel];
    [self addSubview:self.timeView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.zoomOutButton];
    [self addSubview:self.connectMembersCollectView];
    [self addSubview:self.addMemberButton];
    [self isNetWorkReachable];
    [self addWaitingViewConstraints];
}

- (void)addWaitingViewConstraints
{
    //添加约束
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.inviteIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 110));
        make.centerX.equalTo(self);
        make.top.equalTo(@70);
    }];
    [self.inviteName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inviteIconView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
    }];
    
    [self.connectStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inviteName.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
    }];
    
    [self.groupName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.top.equalTo(self.connectStateLabel.mas_bottom).offset(45);
    }];
    
    [self.inviteMemberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.top.equalTo(self.groupName.mas_bottom).offset(10);
    }];
    
    [self.inviteMembersCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(205, 95));
        make.centerX.equalTo(self);
        make.top.equalTo(self.inviteMemberLabel.mas_bottom).offset(5);
    }];
    
    [self.netWorkStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inviteMembersCollectView.mas_bottom).offset(5);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
    }];
    
    [self.rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.centerX.equalTo(@(-self.bounds.size.width/4));
        make.bottom.equalTo(self).offset(-45);
    }];
    [self.rejectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rejectButton);
        make.top.equalTo(self.rejectButton.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
    }];
    [self.answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.centerX.equalTo(@(self.bounds.size.width/4));
        make.bottom.equalTo(self).offset(-45);
    }];
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.answerButton);
        make.top.equalTo(self.answerButton.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
    }];
    [self.handsFreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-100);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.equalTo(@(-(self.bounds.size.width/2 - 65/2)/2-30));
    }];
    
    [self.handsFreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.handsFreeButton);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.bottom.equalTo(self).offset(-70);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.handsFreeButton);
    }];
    [self.cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-70);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self);
    }];
    [self.microPushButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.equalTo(self.handsFreeButton);
        make.centerX.equalTo(@((self.bounds.size.width/2 - 65/2)/2+30));
    }];
    [self.microLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-70);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self.microPushButton);
    }];
    
    [self.zoomOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60,60));
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self).offset(11);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(20);
    }];
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 10));
        make.centerX.equalTo(self).offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeView.mas_right).offset(3);
        make.top.mas_equalTo(self.timeView);
        make.size.mas_equalTo(CGSizeMake(100, 10));
    }];
    [self.addMemberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-11);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self).offset(30);
    }];
    [self.connectMembersCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, self.bounds.size.width));
        make.centerX.equalTo(self);
    }];
}
#pragma mark - events
- (void)rejectClick:(UIButton *)button
{
    NSLog(@"click rejectButton");
    dispatch_async(dispatch_get_main_queue(), ^ {
        [[CubeEngine sharedSingleton].conferenceService quitConference:self.conference.groupId];
        self.answerButton.enabled = NO;
        self.rejectButton.enabled = NO;
    });
}

- (void)answerClick:(UIButton *)button
{
    NSLog(@"click answerButton");
    [[CWMessageRinging sharedSingleton] stopCallSound];
    [[CWMessageRinging sharedSingleton] stopRingBackSound];
    if ([_conference.type isEqualToString:CubeGroupType_Share_Desktop_Conference]) {
        [CWUtils showLoadingHud];
        //接收屏幕分享邀请的回调

    }else{
        BOOL result = NO;
        BOOL videoEnable = [_conference.type isEqualToString:CubeGroupType_Video_Conference];
#warning todo
//        if([_conference.members objectForKey:@"201506"])
//        {
//            result = [[[CubeEngine sharedSingleton] getConferenceService] joinConference:_conference.conferenceId withVideoEnable:videoEnable];
//        }
//        else
//        {
//            result = [[[CubeEngine sharedSingleton] getConferenceService] applyJoinConference:_conference.conferenceId withVideoEnable:videoEnable];
//        };

       result = [[CubeEngine sharedSingleton].conferenceService joinConference:self.conference.groupId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                NSLog(@"被邀请多人音视频后加入成功,groupCube:%@ founder:%@ groupMembers:%@ type:%@", self.conference.bindGroupId, self.conference.founder, self.conference.members,self.conference.type);
                [CWUtils showLoadingHud];
            }else{
                NSLog(@"被邀请多人音视频后加入失败,groupCube:%@ founder:%@ groupMembers:%@ type:%@", self.conference.bindGroupId, self.conference.founder, self.conference.members,self.conference.type);
                [CWToastUtil showTextMessage:@"申请加入通话失败" andDelay:1.f];
            }
        });
    }
}

- (void)microClick:(UIButton *)button
{
    NSLog(@"click microButton");
    dispatch_async(dispatch_get_main_queue(), ^ {
        NSString *target = [NSString stringWithFormat:@"%d",self.conference.number];
        
        if ([[CubeEngine sharedSingleton].mediaService enableMediaType:CubeMediaTypeAudio forTarget:target]) {
            button.selected = YES;
            [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeAudio enable:NO forTarget:target];
        }
        else{
            button.selected = NO;
            [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeAudio enable:YES forTarget:target];
        }
    });
}

- (void)handsFreeClick:(UIButton *)button
{
    NSLog(@"click handsFreeButton");
    NSDate *date = [[NSDate alloc] init];
    if (date.timeIntervalSince1970 - _lastDate.timeIntervalSince1970 > .5f) {
        NSString *target = [NSString stringWithFormat:@"%d",self.conference.number];
        if ([[CubeEngine sharedSingleton].mediaService speakerEnableForTarget:target]) {
            [[CubeEngine sharedSingleton].mediaService setSpeakerEnable:NO forTarget:target];
            button.selected = NO;
        }
        else{
            [[CubeEngine sharedSingleton].mediaService setSpeakerEnable:YES forTarget:target];
            button.selected = YES;
        }
        _lastDate = date;
    }
}

- (void)cancelClick:(UIButton *)button
{
    NSLog(@"click cancelButton");
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        [[CubeEngine sharedSingleton].conferenceService quitConference:self.conference.groupId];
        self.cancelButton.enabled = NO;
    });
}

- (void)zoomOutClick:(UIButton *)button
{
    NSLog(@"click reduceButton");
    //缩小窗口
    if (_delegate && [_delegate respondsToSelector:@selector(ZoomOutWindow)])
    {
        [_delegate ZoomOutWindow];
    }
}

- (void)addMemberClick:(UIButton *)button
{
    NSLog(@"click addMemberButton");
}
#pragma mark - getters and setters
- (UIView *)backgroundView
{
    if (nil == _backgroundView)
    {
        _backgroundView = [[UIImageView alloc]initWithImage:[CWResourceUtil imageNamed:@"img_video_noanswer_background.png"]];
    }
    return _backgroundView;
}

- (UIImageView *)inviteIconView
{
    if (nil == _inviteIconView)
    {
        _inviteIconView = [[UIImageView alloc]initWithImage:[CWResourceUtil imageNamed:@"defaultAvatar.png"]];//默认头像
        _inviteIconView.layer.cornerRadius = 55.f;
        _inviteIconView.layer.masksToBounds = YES;
    }
    return _inviteIconView;
}

- (UILabel *)inviteName
{
    if(nil == _inviteName)
    {
        _inviteName = [[UILabel alloc]init];
        _inviteName.textAlignment = NSTextAlignmentCenter;
        _inviteName.textColor = [CWColorUtil colorWithRGB:0xffffff andAlpha:1.0];
        _inviteName.font = [UIFont systemFontOfSize:12];
    }
    return _inviteName;
}

- (UILabel *)connectStateLabel
{
    if (nil == _connectStateLabel)
    {
        _connectStateLabel = [[UILabel alloc]init];
        _connectStateLabel.textAlignment = NSTextAlignmentCenter;
        _connectStateLabel.font = [UIFont systemFontOfSize:12];
        _connectStateLabel.textColor = [CWColorUtil colorWithRGB:0xffffff andAlpha:1.0];
        _connectStateLabel.text = @"邀请你参与语音通话";
    }
    return _connectStateLabel;
}

- (UILabel *)groupName
{
    if (nil == _groupName)
    {
        _groupName = [[UILabel alloc]init];
        _groupName.textAlignment = NSTextAlignmentCenter;
        _groupName.font = [UIFont systemFontOfSize:17];
        _groupName.textColor = [CWColorUtil colorWithRGB:0xffffff andAlpha:1.0];
        _groupName.text = @"群组名字";
    }
    return _groupName;
}

- (UILabel *)inviteMemberLabel
{
    if (nil == _inviteMemberLabel)
    {
        _inviteMemberLabel = [[UILabel alloc]init];
        _inviteMemberLabel.textAlignment = NSTextAlignmentCenter;
        _inviteMemberLabel.font = [UIFont systemFontOfSize:12];
        _inviteMemberLabel.textColor = [CWColorUtil colorWithRGB:0xffffff andAlpha:0.6];
        _inviteMemberLabel.text = @"通话成员";
    }
    return _inviteMemberLabel;
}

- (UICollectionView *)inviteMembersCollectView
{
    if (nil == _inviteMembersCollectView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = 15;
        CGFloat itemWH = 40;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = margin;
        _inviteMembersCollectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _inviteMembersCollectView.backgroundColor = [UIColor clearColor];
        
        [_inviteMembersCollectView registerClass:[CWApplyjoinCollectionViewCell class] forCellWithReuseIdentifier:inviteMembersCellIdentifier];
        _inviteMembersCollectView.dataSource = self;
        _inviteMembersCollectView.delegate = self;
        _inviteMembersCollectView.alwaysBounceHorizontal = NO;
    }
    return _inviteMembersCollectView;
}

- (UICollectionView *)connectMembersCollectView
{
    if (nil == _connectMembersCollectView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = 0;
        CGFloat itemWH = UIScreenWidth/3;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = margin;
        _connectMembersCollectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _connectMembersCollectView.backgroundColor = [UIColor clearColor];
        [_connectMembersCollectView registerClass:[CWAudioMembersCollectionViewCell class] forCellWithReuseIdentifier:connetMembersCellIdentifier];
        _connectMembersCollectView.dataSource = self;
        _connectMembersCollectView.delegate = self;
        _connectMembersCollectView.alwaysBounceHorizontal = NO;
    }
    return _connectMembersCollectView;
}

- (UILabel *)netWorkStatusLabel
{
    if (nil == _netWorkStatusLabel)
    {
        _netWorkStatusLabel = [[UILabel alloc]init];
        _netWorkStatusLabel.textAlignment = NSTextAlignmentCenter;
        _netWorkStatusLabel.font = [UIFont systemFontOfSize:12];
        _netWorkStatusLabel.textColor = [CWColorUtil colorWithRGB:0xffffff andAlpha:0.6];
    }
    return _netWorkStatusLabel;
}

- (UIButton *)rejectButton
{
    if (nil == _rejectButton)
    {
        _rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rejectButton setImage:[CWResourceUtil imageNamed:@"btn_video_hangup_default.png"] forState:UIControlStateNormal];
        [_rejectButton setImage:[CWResourceUtil imageNamed:@"btn_video_hangup_highlight.png"] forState:UIControlStateSelected];
        [_rejectButton addTarget:self action:@selector(rejectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rejectButton;
}

- (UILabel *)rejectLabel
{
    if (nil == _rejectLabel)
    {
        _rejectLabel = [[UILabel alloc]init];
        _rejectLabel.textColor = [CWColorUtil colorWithRGB:0xC2C2C2 andAlpha:1.0];;
        _rejectLabel.font = [UIFont systemFontOfSize:14];
        _rejectLabel.textAlignment = NSTextAlignmentCenter;
        _rejectLabel.text = @"取消";
    }
    return _rejectLabel;
}

- (UIButton *)answerButton
{
    if (nil == _answerButton)
    {
        _answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_answerButton setImage:[CWResourceUtil imageNamed:@"btn_anwser_default.png"] forState:UIControlStateNormal];
        [_answerButton setImage:[CWResourceUtil imageNamed:@"btn_anwser_highlight.png"] forState:UIControlStateSelected];
        [_answerButton addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answerButton;
}

- (UILabel *)answerLabel
{
    if (nil == _answerLabel)
    {
        _answerLabel = [[UILabel alloc]init];
        _answerLabel.textColor = [CWColorUtil colorWithRGB:0xC2C2C2 andAlpha:1.0];
        _answerLabel.font = [UIFont systemFontOfSize:14];
        _answerLabel.textAlignment = NSTextAlignmentCenter;
        _answerLabel.text = @"接听";
    }
    return _answerLabel;
}

- (UIButton *)handsFreeButton
{
    if (nil == _handsFreeButton)
    {
        _handsFreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handsFreeButton setImage:[CWResourceUtil imageNamed:@"btn_video_handfree_default.png"] forState:UIControlStateNormal];
        [_handsFreeButton setImage:[CWResourceUtil imageNamed:@"btn_video_handfree_selected.png"] forState:UIControlStateSelected];
        [_handsFreeButton addTarget:self action:@selector(handsFreeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _handsFreeButton;
}

- (UILabel *)handsFreeLabel
{
    if (nil == _handsFreeLabel)
    {
        _handsFreeLabel = [[UILabel alloc]init];
        _handsFreeLabel.textAlignment = NSTextAlignmentCenter;
        _handsFreeLabel.textColor = [CWColorUtil colorWithRGB:0x737373 andAlpha:1.0];
        _handsFreeLabel.font = [UIFont systemFontOfSize:14];
        _handsFreeLabel.text = @"免提";
    }
    return _handsFreeLabel;
}

- (UIButton *)cancelButton
{
    if (nil == _cancelButton)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[CWResourceUtil imageNamed:@"btn_video_hangup_default.png"] forState:UIControlStateNormal];
        [_cancelButton setImage:[CWResourceUtil imageNamed:@"btn_video_hangup_highlight.png"] forState:UIControlStateSelected];
        [_cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)cancelLabel
{
    if (nil == _cancelLabel)
    {
        _cancelLabel = [[UILabel alloc]init];
        _cancelLabel.text = @"取消";
        _cancelLabel.textAlignment = NSTextAlignmentCenter;
        _cancelLabel.textColor = [CWColorUtil colorWithRGB:0x737373 andAlpha:1.0];
        _cancelLabel.font = [UIFont systemFontOfSize:14];
    }
    return _cancelLabel;
}

- (UIButton *)microPushButton
{
    if (nil == _microPushButton)
    {
        _microPushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_microPushButton setImage:[CWResourceUtil imageNamed:@"btn_video_mute_default.png"] forState:UIControlStateNormal];
        [_microPushButton setImage:[CWResourceUtil imageNamed:@"btn_video_mute_selected.png"] forState:UIControlStateSelected];
        [_microPushButton addTarget:self action:@selector(microClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _microPushButton;
}

- (UILabel *)microLabel
{
    if (nil == _microLabel)
    {
        _microLabel = [[UILabel alloc]init];
        _microLabel.textAlignment = NSTextAlignmentCenter;
        _microLabel.textColor = [CWColorUtil colorWithRGB:0x737373 andAlpha:1.0];
        _microLabel.font = [UIFont systemFontOfSize:14];
        _microLabel.text = @"麦克风";
    }
    return _microLabel;
}

- (UIButton *)zoomOutButton
{
    if (nil == _zoomOutButton)
    {
        _zoomOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zoomOutButton setImage:[CWResourceUtil imageNamed:@"narrow_groupav_btn_normal.png"] forState:UIControlStateNormal];
        [_zoomOutButton setImage:[CWResourceUtil imageNamed:@"narrow_groupav_btn_normal.png"] forState:UIControlStateHighlighted];
        [_zoomOutButton addTarget:self action:@selector(zoomOutClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zoomOutButton;
}

- (UIImageView *)timeView
{
    if (nil == _timeView)
    {
        _timeView = [[UIImageView alloc]init];
        _timeView.image = [CWResourceUtil imageNamed:@"img_titleimage_video3.png"];
    }
    return _timeView;
}

- (UILabel *)timeLabel
{
    if (nil == _timeLabel)
    {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:11.f];
        _timeLabel.textColor = [CWColorUtil colorWithRGB:0xffffff andAlpha:1];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.text = @"00:00";
    }
    return _timeLabel;
}

- (UIButton *)addMemberButton
{
    if (nil == _addMemberButton)
    {
        _addMemberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addMemberButton setImage:[CWResourceUtil imageNamed:@"btn_videoaddmember_default.png"] forState:UIControlStateNormal];
        [_addMemberButton setImage:[CWResourceUtil imageNamed:@"btn_videoaddmember_default.png"] forState:UIControlStateHighlighted];
        [_addMemberButton addTarget:self action:@selector(addMemberClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addMemberButton;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"群组名字";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [CWColorUtil colorWithRGB:0xffffff andAlpha:1];
        
    }
    return _titleLabel;
}

//-(void)setConference:(Conference *)conference
//{
//    _conference = conference;
//}
#pragma mark - public method
- (void)setMultiAudioShowStyle:(AVShowViewStyle)style
{
    self.viewStyle = style;
    [self reloadView];
}

- (void)setHandFreeEnable:(BOOL)enable
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.handsFreeButton.enabled = enable;
        //如果当前已经接听
        if (self.answerButton.selected)
        {
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        }
        else
        {
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
        }
    });
}

- (void)setConnectingTime:(NSString *)connectingTime{
    _connectingTime = connectingTime;
    self.timeLabel.text = connectingTime;
}

- (void)updateCollectView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.connectMembersCollectView reloadData];
    });
}


#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if(self.inviteMembersCollectView == collectionView)
//    {
//
//    }
//    else
//    {
//
//    }
////    return _dataSource.count;
//    return self.conference.members.allKeys.count;
	return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.inviteMembersCollectView){
        CWApplyjoinCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:inviteMembersCellIdentifier forIndexPath:indexPath];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        
        return cell;
    }else if (collectionView == self.connectMembersCollectView){
        CWAudioMembersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:connetMembersCellIdentifier forIndexPath:indexPath];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.avatarImageView.image = [CWResourceUtil imageNamed:@"defaultAvatar.png"];
        return cell;
    }
    return nil;
    static NSString * string = @"collect";
    if(self.inviteMembersCollectView == collectionView)
    {
        CWApplyjoinCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
        if (!cell) {
            cell = [[CWApplyjoinCollectionViewCell alloc] init];
        }
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
//        if (_dataSource.count) {
//            if (indexPath.row >= _dataSource.count) {
//                SPLogError(@"cell out of bounds");
//                return nil;
//            }
//            CWUserNickModel *model = _dataSource[indexPath.row];
//            NSURL * url = [NSURL URLWithString:model.avatarUrl];
//            UIImage *image = [CWUtils cacheImageForKey:url];
//            if (!image){
//                image = [CWResourceUtil imageNamed:@"img_original_user.png"];
//            }
//            [cell.imageView sd_setImageWithURL:url placeholderImage:image];
//            SPLogDebug(@"userNickModeluserNickModelAvatarUrl:%@", model.avatarUrl);
//        }
        UIImage *  image = [CWResourceUtil imageNamed:@"defaultAvatar.png"];
//        [cell.imageView sd_setImageWithURL:nil placeholderImage:image];
        cell.imageView.image = image;

        return cell;
    }
    else
    {
        CWAudioMembersCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
        if (!cell) {
            cell = [[CWAudioMembersCollectionViewCell alloc] init];
        }
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.backgroundColor = [UIColor clearColor];
//        CWGroupAVModel *model = nil;
//        @synchronized (self.dataSource) {
//            model = _dataSource[indexPath.row];
//        }
//
//        [cell refresh:model mineUserModel:_mineUserModel];

        return cell;
    }
}

#pragma mark - privite method
-(void)isNetWorkReachable
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                self.netWorkStatusLabel.text = @"正在使用手机流量";
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                self.netWorkStatusLabel.text = @"您正在使用WiFi网络,通话免费";
            }
                break;
            default:
                break;
        }
    }];
    [mgr startMonitoring];
}

- (void)reloadView
{
    if (CallInStyle == self.viewStyle)
    {
        self.inviteIconView.hidden = NO;
        self.inviteName.hidden= NO;
        self.groupName.hidden= NO;
        self.inviteMemberLabel.hidden= NO;
        self.inviteMembersCollectView.hidden= NO;
        self.netWorkStatusLabel.hidden= NO;
        self.connectStateLabel.hidden= NO;
        self.rejectButton.hidden= NO;
        self.rejectLabel.hidden= NO;
        self.answerButton.hidden= NO;
        self.answerLabel.hidden= NO;
        self.rejectButton.enabled = YES;
        self.answerButton.enabled = YES;

        self.handsFreeButton.hidden = YES;
        self.handsFreeLabel.hidden = YES;
        self.microPushButton.hidden = YES;
        self.microLabel.hidden = YES;
        self.cancelButton.hidden = YES;
        self.cancelLabel.hidden = YES;
        self.titleLabel.hidden = YES;
        self.timeView.hidden = YES;
        self.timeLabel.hidden = YES;
        self.zoomOutButton.hidden = YES;
        self.connectMembersCollectView.hidden = YES;
        self.addMemberButton.hidden = YES;

    }
    else
    {
        self.inviteIconView.hidden = YES;
        self.inviteName.hidden= YES;
        self.groupName.hidden= YES;
        self.inviteMemberLabel.hidden= YES;
        self.inviteMembersCollectView.hidden= YES;
        self.netWorkStatusLabel.hidden= YES;
        self.connectStateLabel.hidden= YES;
        self.rejectButton.hidden= YES;
        self.rejectLabel.hidden= YES;
        self.answerButton.hidden= YES;
        self.answerLabel.hidden= YES;

        self.handsFreeButton.hidden = NO;
        self.handsFreeLabel.hidden = NO;
        self.microPushButton.hidden = NO;
        self.microLabel.hidden = NO;
        self.cancelButton.hidden = NO;
        self.cancelLabel.hidden = NO;
        self.titleLabel.hidden = NO;
        self.timeView.hidden = NO;
        self.timeLabel.hidden = NO;
        self.zoomOutButton.hidden = NO;
        self.connectMembersCollectView.hidden = NO;
        self.addMemberButton.hidden = NO;
        self.handsFreeButton.enabled = YES;
        self.microPushButton.enabled = YES;
        self.cancelButton.enabled = YES;
    }
}
@end
