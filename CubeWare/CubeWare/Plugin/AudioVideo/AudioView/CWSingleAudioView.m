//
//  CWAudioView.m
//  CubeWare
//
//  Created by 美少女 on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWSingleAudioView.h"
#import "Masonry.h"
#import "CWVWWaterView.h"
#import "CWColorUtil.h"
#import "CWResourceUtil.h"
#import "CubeWareHeader.h"
#import "CWInfoRefreshDelegate.h"
#import "CWWorkerFinder.h"


@interface CWSingleAudioView ()<CWInfoRefreshDelegate>

/**
 背景图层
 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

/**
 邀请人头像
 */
@property (nonatomic, strong) UIImageView *inviteIconView;

/**
 邀请人名字
 */
@property (nonatomic, strong) UILabel *inviteName;

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
 接听状态描述 例如：正在等待对方接受邀请...
 */
@property (nonatomic, strong) UILabel *connectStateLabel;

/**
 接听状态动画
 */
@property (nonatomic, strong) UIView *connectStateView;

/**
 麦克风按钮
 */
@property (nonatomic, strong) UIButton *microButton;

/**
 麦克风按钮描述文字
 */
@property (nonatomic, strong) UILabel *microLabel;

/**
 免提按钮
 */
@property (nonatomic, strong) UIButton *handsFreeButton;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelButton;

/**
 取消按钮描述
 */
@property (nonatomic, strong) UILabel *cancelLabel;

/**
 免提按钮描述
 */
@property (nonatomic, strong) UILabel *handsFreeLabel;

/**
 缩小窗体按钮
 */
@property (nonatomic, strong) UIButton *zoomOutButton;

/**
 通话时长
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 呼入方向
 */
@property (nonatomic, assign) AudioCallDirection audioCallDirection;

/**
 等待定时器
 */
@property (nonatomic, assign) NSTimer *waitTimer;

/**
 计数
 */
@property (nonatomic, assign) NSInteger timerCount;

/**
 
 */
@property (nonatomic, strong) NSDate *lastDate;

/**
 显示样式
 */
@property (nonatomic, assign) AVShowViewStyle viewStyle;
@end

@implementation CWSingleAudioView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self createView];
        [self addViewConstraints];
        [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWInfoRefreshDelegate)]];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self startAnimation];
}

- (void)createView
{
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.inviteIconView];
    [self addSubview:self.inviteName];
    [self addSubview:self.connectStateLabel];
    [self addSubview:self.connectStateView];
    
    [self addSubview:self.rejectButton];
    [self addSubview:self.rejectLabel];
    [self addSubview:self.answerButton];
    [self addSubview:self.answerLabel];
    
    [self addSubview:self.handsFreeButton];
    [self addSubview:self.handsFreeLabel];
    [self addSubview:self.microButton];
    [self addSubview:self.microLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.cancelLabel];
    
    [self addSubview:self.timeLabel];
    [self addSubview:self.zoomOutButton];
}

- (void)dealloc
{
}

- (void)addViewConstraints
{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.inviteIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 110));
        make.centerX.equalTo(self);
        make.top.equalTo(@90);
    }];
    [self.inviteName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@215);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
    }];
    [self.connectStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.frame.size.height/2 - 30));
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
    }];
    [self.connectStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@60);
        make.size.equalTo(self);
    }];
    
    [self.rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.centerX.equalTo(@(-self.bounds.size.width/4));
        make.bottom.equalTo(self).offset(-100);
    }];
    
    [self.rejectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rejectButton);
        make.top.equalTo(self.rejectButton.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
    }];
    
    [self.answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.centerX.equalTo(@(self.bounds.size.width/4));
        make.bottom.equalTo(self).offset(-100);
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
    [self.microButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.equalTo(self.handsFreeButton);
        make.centerX.equalTo(@((self.bounds.size.width/2 - 65/2)/2+30));
    }];
    [self.microLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-70);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self.microButton);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cancelButton.mas_top).offset(-15);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self);
    }];
    
    [self.zoomOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40,40));
        make.top.equalTo(self.mas_top).offset(20);
        make.left.equalTo(self).offset(11);
    }];
}
#pragma mark - CWInfoManagerDelegate

- (void)usersInfoUpdated:(NSArray<CWUserModel *> *)users inSession:(CWSession *)session{
	for (CWUserModel *user in users)
	{
		if([user.cubeId isEqualToString:self.peerCubeId]){
			[self updateUserInfo:user];
			break;
		}
	}
}

#pragma mark - events
- (void)rejectClick:(UIButton *)button
{
    NSLog(@"voiceCall click rejectButton");
    dispatch_async(dispatch_get_main_queue(), ^ {
        BOOL ret = [[CubeEngine sharedSingleton].callService terminateCall:self.peerCubeId];
        if (ret) {
            NSLog(@"正在拒绝 ，请稍候……");
        } else {
            NSLog(@"挂断呼叫  失败");
        }

        self.answerButton.enabled = NO;
        self.rejectButton.enabled = NO;
    });
}

- (void)answerClick:(UIButton *)button
{
    NSLog(@"voiceCall click answerButton");
    dispatch_async(dispatch_get_main_queue(), ^ {
        BOOL ret = [[CubeEngine sharedSingleton].callService answerCallWith:self.peerCubeId];
        if (ret) {
            NSLog(@"已应答  呼叫");
        } else {
            NSLog(@"应答  呼叫失败");
        }
       
        self.answerButton.enabled = NO;
        self.rejectButton.enabled = NO;
    });
}

- (void)microClick:(UIButton *)button
{
    NSLog(@"voiceCall click microButton");
     dispatch_async(dispatch_get_main_queue(), ^ {
         if ([[CubeEngine sharedSingleton].mediaService enableMediaType:CubeMediaTypeAudio forTarget:self.peerCubeId]) {
             button.selected = YES;
             [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeAudio enable:NO forTarget:self.peerCubeId];
         }
         else{
             button.selected = NO;
             [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeAudio enable:YES forTarget:self.peerCubeId];
         }
     });
}

- (void)handsFreeClick:(UIButton *)button
{
    NSLog(@"voiceCall click handsFreeButton");
    NSDate *date = [[NSDate alloc] init];
    if (date.timeIntervalSince1970 - _lastDate.timeIntervalSince1970 > .5f) {
        if ([[CubeEngine sharedSingleton].mediaService speakerEnableForTarget:self.peerCubeId]) {
            [[CubeEngine sharedSingleton].mediaService setSpeakerEnable:NO forTarget:self.peerCubeId];
            button.selected = NO;
        }
        else{
            [[CubeEngine sharedSingleton].mediaService setSpeakerEnable:YES forTarget:self.peerCubeId];
            button.selected = YES;
        }
        _lastDate = date;
    }
}

- (void)cancelClick:(UIButton *)button
{
    NSLog(@"voiceCall click cancelButton");
    dispatch_async(dispatch_get_main_queue(), ^ {
        BOOL ret = [[CubeEngine sharedSingleton].callService terminateCall:self.peerCubeId];
        if (ret) {
            NSLog(@"正在拒绝 ，请稍候……");
        }else {
            NSLog(@"挂断呼叫  失败");
        }
        self.cancelButton.enabled = NO;
    });
}

- (void)zoomOutClick:(UIButton *)button
{
    NSLog(@"voiceCall click reduceButton");
    //缩小窗口
    if (_delegate && [_delegate respondsToSelector:@selector(ZoomOutWindow)])
    {
        [_delegate ZoomOutWindow];
    }
}
#pragma mark - getters and setters

-(UIImageView *)backgroundImageView
{
    if (nil == _backgroundImageView)
    {
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundImageView;
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
        _inviteName.textColor = [UIColor lightGrayColor];
        _inviteName.font = [UIFont fontWithName:@"Helvetica" size:15];
    }
    return _inviteName;
}

- (UILabel *)connectStateLabel
{
    if (nil == _connectStateLabel)
    {
        _connectStateLabel = [[UILabel alloc]init];
        _connectStateLabel.textAlignment = NSTextAlignmentCenter;
        _connectStateLabel.font = [UIFont systemFontOfSize:15];
        _connectStateLabel.textColor = [CWColorUtil colorWithRGB:0xC2C2C2 andAlpha:1.0];;
    }
    return _connectStateLabel;
}

- (UIView *)connectStateView
{
    if (nil == _connectStateView)
    {
        _connectStateView = [[UIView alloc]init];
        CWVWWaterView *waterView = [[CWVWWaterView alloc]initWithFrame:self.bounds andLineColor:[CWColorUtil colorWithRGB:0x7a8fdf andAlpha:1.0] andA:3 andB:0];
        CWVWWaterView *waterView1 = [[CWVWWaterView alloc]initWithFrame:self.bounds andLineColor:[CWColorUtil colorWithRGB:0x7a8fdf andAlpha:1.0] andA:1 andB:1];
        CWVWWaterView *waterView2 = [[CWVWWaterView alloc]initWithFrame:self.bounds andLineColor:[CWColorUtil colorWithRGB:0x7a8fdf andAlpha:1.0] andA:4 andB:2];;
        [_connectStateView addSubview:waterView];
        [_connectStateView addSubview:waterView1];
        [_connectStateView addSubview:waterView2];
    }
    return _connectStateView;
}

- (UIButton *)rejectButton
{
    if (nil == _rejectButton)
    {
        _rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rejectButton setBackgroundImage:[CWResourceUtil imageNamed:@"btn_video_hangup_default.png"] forState:UIControlStateNormal];
        [_rejectButton setBackgroundImage:[CWResourceUtil imageNamed:@"btn_video_hangup_highlight.png"] forState:UIControlStateSelected];
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
        _rejectLabel.text = @"拒绝";
    }
    return _rejectLabel;
}

- (UIButton *)answerButton
{
    if (nil == _answerButton)
    {
        _answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_answerButton setBackgroundImage:[CWResourceUtil imageNamed:@"btn_anwser_default.png"] forState:UIControlStateNormal];
        [_answerButton setBackgroundImage:[CWResourceUtil imageNamed:@"btn_anwser_highlight.png"] forState:UIControlStateSelected];
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

        [_handsFreeButton setImage:[CWResourceUtil imageNamed:@"btn_handfree_voice_selected.png"] forState:UIControlStateNormal];
        [_handsFreeButton setImage:[CWResourceUtil imageNamed:@"btn_handfree_voice_default.png"] forState:UIControlStateSelected];
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
        [_cancelButton setBackgroundImage:[CWResourceUtil imageNamed:@"btn_video_hangup_default.png"] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[CWResourceUtil imageNamed:@"btn_video_hangup_highlight.png"] forState:UIControlStateSelected];
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

- (UIButton *)microButton
{
    if (nil == _microButton)
    {
        _microButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_microButton setImage:[CWResourceUtil imageNamed:@"btn_mute_voice_default.png"] forState:UIControlStateNormal];
        [_microButton setImage:[CWResourceUtil imageNamed:@"btn_mute_voice_selected.png"] forState:UIControlStateSelected];
        [_microButton addTarget:self action:@selector(microClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _microButton;
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
        [_zoomOutButton setImage:[CWResourceUtil imageNamed:@"narrow_voice_btn_normal.png"] forState:UIControlStateNormal];
        [_zoomOutButton setImage:[CWResourceUtil imageNamed:@"narrow_voice_btn_normal.png"] forState:UIControlStateHighlighted];
        [_zoomOutButton addTarget:self action:@selector(zoomOutClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zoomOutButton;
}

- (UILabel *)timeLabel
{
    if (nil == _timeLabel)
    {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [CWColorUtil colorWithRGB:0x737373 andAlpha:1.0];
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}
#pragma mark - public method
- (void)setSingleAudioShowStyle:(AVShowViewStyle)style
{
    self.viewStyle = style;
    switch (style) {
        case CallInStyle:
        {
            //呼入
            self.microLabel.hidden = YES;
            self.microButton.hidden = YES;
            self.handsFreeLabel.hidden = YES;
            self.handsFreeButton.hidden = YES;
            self.cancelButton.hidden = YES;
            self.cancelLabel.hidden = YES;
            self.connectStateLabel.text = [self getConnectStr];
            self.zoomOutButton.hidden = YES;
            self.timeLabel.hidden = YES;
            self.answerButton.enabled = YES;
            self.rejectButton.enabled = YES;
            self.answerLabel.hidden = NO;
            self.answerButton.hidden = NO;
            self.rejectButton.hidden = NO;
            self.rejectLabel.hidden = NO;
        }
            break;
        case CallOutStyle:
        {
            //呼出
            [self startWaitTimer];
            self.answerLabel.hidden = YES;
            self.answerButton.hidden = YES;
            self.rejectButton.hidden = YES;
            self.rejectLabel.hidden = YES;
            self.zoomOutButton.hidden = YES;
            self.timeLabel.hidden = YES;
            self.connectStateLabel.text = [self getConnectStr];
            self.cancelLabel.text = @"取消";
            self.cancelButton.enabled = YES;
            self.microLabel.hidden = NO;
            self.microButton.hidden = NO;
            self.handsFreeLabel.hidden = NO;
            self.handsFreeButton.hidden = NO;
            self.cancelButton.hidden = NO;
            self.cancelLabel.hidden = NO;
        }
            break;
        default:
        {
            //接听中
            self.answerLabel.hidden = YES;
            self.answerButton.hidden = YES;
            self.rejectButton.hidden = YES;
            self.rejectLabel.hidden = YES;
            self.zoomOutButton.hidden = NO;
            self.timeLabel.hidden = NO;
            self.cancelLabel.text = @"挂断";
            self.connectStateLabel.text = [self getConnectStr];
            self.answerButton.enabled = YES;
            self.rejectButton.enabled = YES;
            self.microLabel.hidden = NO;
            self.microButton.hidden = NO;
            self.handsFreeLabel.hidden = NO;
            self.handsFreeButton.hidden = NO;
            self.cancelButton.hidden = NO;
            self.cancelLabel.hidden = NO;
            self.cancelButton.enabled = YES;
        }
            break;
    }
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

-(void)setConnectingTime:(NSString *)connectingTime{
    _connectingTime = connectingTime;
    self.timeLabel.text = _connectingTime;
}


-(void)setPeerCubeId:(NSString *)peerCubeId{
    _peerCubeId = peerCubeId;
	CWUserModel * user = [[CubeWare sharedSingleton].infoManager userInfoForCubeId:peerCubeId inSession:nil];
    if(user){
        [self updateUserInfo:user];
    }else{
         [[CubeWare sharedSingleton].infoManager.delegate needUsersInfoFor:@[peerCubeId] inSession:nil];
    }
   
}

- (void)updateUserInfo:(CWUserModel *)user{
    self.inviteName.text = user.appropriateName;
    [self.inviteIconView sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
}
#pragma mark - privite method
- (void)startAnimation
{
    for (UIView *tempView in self.connectStateView.subviews) {
        if([tempView isKindOfClass:[CWVWWaterView class]]){
            [(CWVWWaterView *)tempView startAnimation];
        }
    }
}

- (void)startWaitTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nil != _waitTimer)
        {
            [_waitTimer invalidate];
            _waitTimer = nil;
        }
        _waitTimer =  [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                   target:self
                                                 selector:@selector(didWaitTimerTrigger)
                                                 userInfo:nil
                                                  repeats:YES];
    });
}

-(void)didWaitTimerTrigger
{
    self.timerCount++;
    if(self.timerCount>=4){
        self.timerCount=0;
    }
    NSString *defaultStr = [self getConnectStr];
    switch (self.timerCount) {
        case 0:
            self.connectStateLabel.text = defaultStr;
            break;
        case 1:
            self.connectStateLabel.text = [defaultStr stringByAppendingString:@"."];break;
        case 2:
            self.connectStateLabel.text = [defaultStr stringByAppendingString:@".."];break;
        case 3:
            self.connectStateLabel.text = [defaultStr stringByAppendingString:@"..."];break;
        default:
            break;
    }
}

- (NSString *)getConnectStr
{
    switch (self.viewStyle) {
        case CallInStyle:
        {
            return @"邀请您参与语音通话";
        }
        case  CallOutStyle:
        {
            return @"正在等待对方接受邀请";
        }
        default:
        {
            return @"语音通话中...";
        }
    }
}
@end
