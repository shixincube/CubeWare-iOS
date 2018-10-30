//
//  CDWaitView.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/26.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//


#import "CDWaitView.h"
#import "CDConnectedView.h"
#import "CWResourceUtil.h"

@interface CDWaitView () <CWCallServiceDelegate>

/**
 被邀请人头像
 */
@property (nonatomic,strong) UIImageView *toUserView;

/**
 邀请人名称
 */
@property (nonatomic,strong) UILabel *toUserName;

/**
 提示语
 */
@property (nonatomic,strong) UILabel *tipLabel;

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


@end

@implementation CDWaitView

#pragma mark - Initialize method
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance{
    self.backgroundColor = KWhiteColor;
    [self addSubview:self.toUserView];
    [self addSubview:self.toUserName];
    [self addSubview:self.tipLabel];
    [self addSubview:self.hangupButton];
    [self addSubview:self.muteButton];
    [self addSubview:self.handfreeButton];
    
    [self setAllConstraints];
    
    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWCallServiceDelegate)]];
}

- (void)initializeDataSource{
    [self.toUserView sd_setImageWithURL:[NSURL URLWithString:self.callSession.callee.avatar] placeholderImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
    self.toUserName.text = self.callSession.callee.displayName ? self.callSession.callee.displayName : self.callSession.callee.cubeId;
}

- (void)setAllConstraints{
    [self.toUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@80);
        make.width.height.mas_equalTo(@100);
        make.centerX.equalTo(self);
    }];
    
    [self.toUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.toUserView.mas_bottom).offset(20);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(@30);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.toUserName.mas_bottom).offset(30);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(@30);
    }];
    
}

#pragma mark - Setter Method
-(void)setCallSession:(CubeCallSession *)callSession{
    _callSession = callSession;
    [self initializeDataSource];
}

#pragma mark - Getter Method

- (UILabel *)tipLabel
{
    if (nil == _tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _tipLabel.textColor = KGrayColor;
        _tipLabel.font = [UIFont systemFontOfSize:11];
        _tipLabel.text = @"正在等待对方接受通话邀请...";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIImageView *)toUserView
{
    if (nil == _toUserView)
    {
        _toUserView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
        _toUserView.size = CGSizeMake(100, 100);
        _toUserView.centerX = self.centerX;
        _toUserView.y = 50;
        _toUserView.layer.cornerRadius = 50;
        _toUserView.layer.masksToBounds = YES;
    }
    return _toUserView;
}

- (UILabel *)toUserName
{
    if (nil == _toUserName) {
        _toUserName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _toUserName.textColor = KGrayColor;
        _toUserName.font = [UIFont systemFontOfSize:14];
        _toUserName.textAlignment = NSTextAlignmentCenter;
        _toUserName.text = @"邀请人昵称";
    }
    return _toUserName;
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
        [_hangupButton setFrame:CGRectMake(0, 0, 130, 60)];
        _hangupButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _hangupButton.centerX = kScreenWidth /2.f;
        _hangupButton.centerY = self.frame.size.height - 100;
        [_hangupButton setImageEdgeInsets:UIEdgeInsetsMake(-_hangupButton.titleLabel.intrinsicContentSize.height, 0, 0, -_hangupButton.titleLabel.intrinsicContentSize.width)];
        [_hangupButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_hangupButton.imageView.frame.size.width, -(_hangupButton.imageView.frame.size.height ), 0)];
        
    }
    return _hangupButton;
}

- (UIButton *)muteButton
{
    if (nil == _muteButton) {
        _muteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteButton setImage:[CWResourceUtil imageNamed:@"btn_mute_voice_default.png"] forState:UIControlStateNormal];
        [_muteButton setImage:[CWResourceUtil imageNamed:@"btn_mute_voice_selected.png"] forState:UIControlStateSelected];
        [_muteButton setTitle:@"静音" forState:UIControlStateNormal];
        [_muteButton addTarget:self action:@selector(onClickMuteButton:) forControlEvents:UIControlEventTouchUpInside];
        [_muteButton setFrame:CGRectMake(0, 0, 100, 40)];
        [_muteButton setTitleColor:KBlackColor forState:UIControlStateNormal];
        _muteButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _muteButton.centerX = kScreenWidth /2 + (0.5f -1.f/5.f)*kScreenWidth;
        _muteButton.centerY = self.frame.size.height - 70;
        [_muteButton setImageEdgeInsets:UIEdgeInsetsMake(-_muteButton.titleLabel.intrinsicContentSize.height, 0, 0, -_muteButton.titleLabel.intrinsicContentSize.width)];
        [_muteButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_muteButton.imageView.frame.size.width, -_muteButton.imageView.frame.size.height, 0)];
        _muteButton.titleLabel.textColor = KWhiteColor;
    }
    return _muteButton;
}

- (UIButton *)handfreeButton
{
    if (nil == _handfreeButton) {
        _handfreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handfreeButton setImage:[CWResourceUtil imageNamed:@"btn_handfree_voice_default.png"] forState:UIControlStateNormal];
        [_handfreeButton setImage:[CWResourceUtil imageNamed:@"btn_handfree_voice_selected.png"] forState:UIControlStateSelected];
        [_handfreeButton setTitle:@"免提" forState:UIControlStateNormal];
        [_handfreeButton addTarget:self action:@selector(onClickHandfreeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_handfreeButton setFrame:CGRectMake(0, 0, 100, 40)];
        [_handfreeButton setTitleColor:KBlackColor forState:UIControlStateNormal];
        _handfreeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _handfreeButton.centerX = kScreenWidth /2 / 2.5;
        _handfreeButton.centerY = self.frame.size.height - 70;
        [_handfreeButton setImageEdgeInsets:UIEdgeInsetsMake(-_handfreeButton.titleLabel.intrinsicContentSize.height, 0, 0, -_handfreeButton.titleLabel.intrinsicContentSize.width)];
        [_handfreeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_handfreeButton.imageView.frame.size.width, -_handfreeButton.imageView.frame.size.height, 0)];
        _handfreeButton.titleLabel.textColor = KWhiteColor;
    }
    return _handfreeButton;
}

#pragma mark - Button Method
- (void)onClickHandupButton:(UIButton *)sender{
    NSLog(@"click handup btn");
    [[CubeWare sharedSingleton].callService terminalCall:self.callSession.callee.cubeId];
}

- (void)onClickMuteButton:(UIButton *)sender{
    NSLog(@"click mute btn");
    if ([[CubeEngine sharedSingleton].mediaService enableMediaType:CubeMediaTypeAudio forTarget:self.callSession.callee.cubeId]) {
        sender.selected = YES;
        [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeAudio enable:NO forTarget:self.callSession.callee.cubeId];
    }
    else{
        sender.selected = NO;
        [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeAudio enable:YES forTarget:self.callSession.callee.cubeId];
    }
}

- (void)onClickHandfreeButton:(UIButton *)sender{
    NSLog(@"click handfree btn");
    if ([[CubeEngine sharedSingleton].mediaService speakerEnableForTarget:self.callSession.callee.cubeId]) {
        [[CubeEngine sharedSingleton].mediaService setSpeakerEnable:NO forTarget:self.callSession.callee.cubeId];
        sender.selected = YES;
    }
    else{
        [[CubeEngine sharedSingleton].mediaService setSpeakerEnable:YES forTarget:self.callSession.callee.cubeId];
        sender.selected = NO;
    }
}

#pragma mark - Public
- (void)showView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    });
}

#pragma mark - CWCallServiceDelegate
-(void)newCall:(CubeCallSession *)callSession from:(CubeUser *)from{
    
}

-(void)callFailed:(CubeCallSession *)callSession error:(CubeError *)error from:(CubeUser *)from{
    
}

-(void)callEnded:(CubeCallSession *)callSession from:(CubeUser *)from{
    if ([callSession.callee.cubeId isEqualToString:self.callSession.callee.cubeId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }
}

-(void)callConnected:(CubeCallSession *)callSession from:(CubeUser *)from andView:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        CDConnectedView *connectedView = [CDConnectedView shareInstance];
        [connectedView.showView addSubview:view];
        connectedView.callSession = callSession;
        [connectedView show];
    });
}

-(void)callRing:(CubeCallSession *)callSession from:(CubeUser *)from{
    
}






@end
