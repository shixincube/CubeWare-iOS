//
//  CWVideoView.m
//  CubeWare
//
//  Created by 美少女 on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWVideoView.h"
#import "CWResourceUtil.h"
#import "CWToastUtil.h"
#import "CWColorUtil.h"
#import "CubeWareHeader.h"
@interface CWVideoView ()
/**
 背景图层
 */
@property (nonatomic, strong) UIImageView *backgroundView;

/**
 缩小窗口
 */
@property (nonatomic,strong) UIButton *zoomOutButton;

/**
 切换到语音
 */
@property (nonatomic,strong) UIButton *changeAudioButton;

/**
 切换语音文字
 */
@property (nonatomic,strong) UILabel *changeAudioLabel;

/**
 切换摄像头
 */
@property (nonatomic,strong) UIButton *changeCameraButton;

/**
 切换摄像头文字
 */
@property (nonatomic,strong) UILabel *changeCameraLabel;

/**
 免提按钮
 */
@property (nonatomic,strong) UIButton *handfreeButton;

/**
 免提按钮文字
 */
@property (nonatomic,strong) UILabel *handfreeLabel;

/**
 挂断按钮
 */
@property (nonatomic,strong) UIButton *cancelButton;

/**
 挂断按钮文字
 */
@property (nonatomic,strong) UILabel *cancelLabel;

/**
 麦克风按钮
 */
@property (nonatomic,strong) UIButton *microButton;

/**
麦克风文字描述
 */
@property (nonatomic,strong) UILabel *microLabel;

/**
 通话时间
 */
@property (nonatomic,strong) UILabel *timeLabel;
/**

 */
@property (nonatomic, strong) NSDate *lastDate;

/**
 * 点击手势控制视频界面显示隐藏相关按钮控件
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapShowOrHideBtn;
@end


@implementation CWVideoView
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self createView];
        [self addViewConstraints];
    }
    return self;
}

- (void)createView
{
    [self addSubview:self.backgroundView];
    [self addSubview:self.remoteVideoImgView];
    [self addSubview:self.localVideoImageView];

    [self addSubview:self.zoomOutButton];
    [self addSubview:self.changeCameraButton];
    [self addSubview:self.changeCameraLabel];
    [self addSubview:self.cancelLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.cancelLabel];
    [self addSubview:self.microButton];
    [self addSubview:self.microLabel];
    [self addSubview:self.handfreeButton];
    [self addSubview:self.handfreeLabel];
    [self addSubview:self.changeAudioButton];
    [self addSubview:self.changeAudioLabel];
    [self addSubview:self.timeLabel];

    self.tapShowOrHideBtn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowOrHideBtnClick:)];
    [self addGestureRecognizer:self.tapShowOrHideBtn];
}

- (void)addViewConstraints
{
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.localVideoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.remoteVideoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.zoomOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40,40));
        make.top.equalTo(self.mas_top).offset(20);
        make.left.equalTo(self).offset(11);
    }];

    [self.handfreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-100);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.equalTo(@(-(self.bounds.size.width/2 - 65/2)/2-30));
    }];

    [self.handfreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.handfreeButton);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.bottom.equalTo(self).offset(-70);
    }];

    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.handfreeButton);
    }];
    [self.cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-70);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self);
    }];
    [self.microButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.equalTo(self.handfreeButton);
        make.centerX.equalTo(@((self.bounds.size.width/2 - 65/2)/2+30));
    }];
    [self.microLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-70);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self.microButton);
    }];

    [self.changeAudioButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(65, 65));
        make.centerX.equalTo(self.handfreeButton);
        make.bottom.equalTo(self.handfreeButton.mas_top).offset(-40);
    }];

    [self.changeAudioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self.changeAudioButton);
        make.top.equalTo(self.changeAudioButton.mas_bottom);
    }];

    [self.changeCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.centerX.equalTo(self.microButton);
        make.bottom.equalTo(self.changeAudioButton);
    }];

    [self.changeCameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self.changeCameraButton);
        make.centerY.equalTo(self.changeAudioLabel);
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.cancelButton.mas_top).offset(-10);
    }];
}
#pragma mark - events
- (void)tapShowOrHideBtnClick:(UIGestureRecognizer *)tap
{
    NSLog(@"tapShowOrHideBtnClick !!!");
    [self setVideoTapShowOrHidden];
}

- (void)zoomOutClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(zoomOutWindow)])
    {
        [_delegate zoomOutWindow];
    }
}

- (void)cancelClick:(UIButton *)button
{
    NSLog(@"videoCall click cancelButton");
    dispatch_async(dispatch_get_main_queue(), ^ {
        BOOL ret = [[CubeEngine sharedSingleton].callService terminateCall:self.peerCubeId];
        if (ret) {
            NSLog(@"正在挂断 ，请稍候……");
        } else {
            NSLog(@"挂断呼叫  失败");
        }
        self.cancelButton.enabled = NO;
    });
}

-(void)microClick:(UIButton *)button
{
    NSLog(@"videoCall click microButton");
    UIButton *btn = button;
    if ([[CubeEngine sharedSingleton].mediaService enableMediaType:CubeMediaTypeAudio forTarget:self.peerCubeId]) {
        btn.selected = YES;
        [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeAudio enable:NO forTarget:self.peerCubeId];
    }
    else{
        btn.selected = NO;
        [[CubeEngine sharedSingleton].mediaService setMediaType:CubeMediaTypeAudio enable:YES forTarget:self.peerCubeId];
    }
}

- (void)changeCameraClick:(UIButton *)button
{
    [[CubeEngine sharedSingleton].mediaService switchCamera];
}
- (void)handfreeClick:(UIButton *)button
{
    NSLog(@"videoCall click handsFreeButton");
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

- (void)changeAudioClick:(UIButton *)button
{
    NSLog(@"videoCall click changeAudioButton");
    if(_delegate && [_delegate respondsToSelector:@selector(changeToVoice)])
    {
        [_delegate changeToVoice];
    }
}


#pragma mark - public methods
- (void)setHandFreeEnable:(BOOL)enable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.handfreeButton.enabled = enable;
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    });
}


#pragma mark - getters
-(void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if(!hidden){
        //这里处理页面初始化的逻辑
        self.cancelButton.enabled = YES;
    }
}
- (UIImageView *)backgroundView
{
    if(nil == _backgroundView)
    {
        _backgroundView = [[UIImageView alloc]initWithImage:[CWResourceUtil imageNamed:@"img_video_noanswer_background.png"]];
    }
    return _backgroundView;
}

- (UIButton *)zoomOutButton
{
    if (nil == _zoomOutButton)
    {
        _zoomOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zoomOutButton setBackgroundImage:[CWResourceUtil imageNamed:@"narrow_groupav_btn_normal.png"] forState:UIControlStateNormal];
        [_zoomOutButton setBackgroundImage:[CWResourceUtil imageNamed:@"narrow_groupav_btn_normal.png"] forState:UIControlStateHighlighted];
        [_zoomOutButton addTarget:self action:@selector(zoomOutClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zoomOutButton;
}

- (UIView *)localVideoImageView
{
    if (nil == _localVideoImageView)
    {
        _localVideoImageView = [[UIView alloc]init];
        [_localVideoImageView setBackgroundColor:[UIColor clearColor]];
    }
    return _localVideoImageView;
}

- (UIView *)remoteVideoImgView
{
    if (nil == _remoteVideoImgView)
    {
        _remoteVideoImgView = [[UIView alloc]init];
        [_remoteVideoImgView setBackgroundColor:[UIColor clearColor]];
    }
    return _remoteVideoImgView;
}

- (UIButton *)changeAudioButton
{
    if (nil == _changeAudioButton)
    {
        _changeAudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeAudioButton setImage:[CWResourceUtil imageNamed:@"btn_video_change_voice_default.png"] forState:UIControlStateNormal];
        [_changeAudioButton setImage:[CWResourceUtil imageNamed:@"btn_video_change_voice_default.png"] forState:UIControlStateSelected];
        [_changeAudioButton addTarget:self action:@selector(changeAudioClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeAudioButton;
}

- (UILabel *)changeAudioLabel
{
    if (nil == _changeAudioLabel)
    {
        _changeAudioLabel = [[UILabel alloc]init];
        _changeAudioLabel.text = @"切换到语音";
        _changeAudioLabel.textColor = [UIColor whiteColor];
        _changeAudioLabel.font = [UIFont systemFontOfSize:14];
        _changeAudioLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _changeAudioLabel;
}
- (UIButton *)changeCameraButton
{
    if (nil == _changeCameraButton)
    {
        _changeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeCameraButton setImage:[CWResourceUtil imageNamed:@"btn_cyclegrayvideo_default.png"] forState:UIControlStateNormal];
        [_changeCameraButton setImage:[CWResourceUtil imageNamed:@"btn_cyclegrayvideo_default.png"] forState:UIControlStateSelected];
        [_changeCameraButton addTarget:self action:@selector(changeCameraClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeCameraButton;
}
- (UILabel *)changeCameraLabel
{
    if (nil == _changeCameraLabel)
    {
        _changeCameraLabel = [[UILabel alloc]init];
        _changeCameraLabel.text = @"切换摄像头";
        _changeCameraLabel.textColor = [UIColor whiteColor];
        _changeCameraLabel.font = [UIFont systemFontOfSize:14];
        _changeCameraLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _changeCameraLabel;
}

- (UIButton *)handfreeButton
{
    if (nil == _handfreeButton)
    {
        _handfreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handfreeButton setImage:[CWResourceUtil imageNamed:@"btn_video_handfree_selected.png"] forState:UIControlStateNormal];
        [_handfreeButton setImage:[CWResourceUtil imageNamed:@"btn_video_handfree_default.png"] forState:UIControlStateSelected];
        [_handfreeButton addTarget:self action:@selector(handfreeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _handfreeButton;
}
- (UILabel *)handfreeLabel
{
    if (nil == _handfreeLabel)
    {
        _handfreeLabel = [[UILabel alloc]init];
        _handfreeLabel.text = @"免提";
        _handfreeLabel.textColor = [UIColor whiteColor];
        _handfreeLabel.font = [UIFont systemFontOfSize:14];
        _handfreeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _handfreeLabel;
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
    if(nil == _cancelLabel)
    {
        _cancelLabel = [[UILabel alloc]init];
        _cancelLabel.text = @"挂断";
        _cancelLabel.textColor = [UIColor whiteColor];
        _cancelLabel.font = [UIFont systemFontOfSize:14];
        _cancelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cancelLabel;
}
- (UIButton *)microButton
{
    if (nil == _microButton)
    {
        _microButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_microButton setImage:[CWResourceUtil imageNamed:@"btn_video_mute_default.png"] forState:UIControlStateNormal];
        [_microButton setImage:[CWResourceUtil imageNamed:@"btn_video_mute_select.png"] forState:UIControlStateSelected];
        [_microButton addTarget:self action:@selector(microClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _microButton;
}
- (UILabel *)microLabel
{
    if (nil == _microLabel)
    {
        _microLabel = [[UILabel alloc]init];
        _microLabel.text = @"麦克风";
        _microLabel.textColor = [UIColor whiteColor];
        _microLabel.font = [UIFont systemFontOfSize:14];
        _microLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _microLabel;
}

- (UILabel *)timeLabel
{
    if (nil == _timeLabel)
    {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

#pragma mark - privite methods
- (void)setVideoTapShowOrHidden
{
    self.localVideoImageView.hidden = NO;
    self.remoteVideoImgView.hidden = NO;

    self.changeAudioButton.hidden = !self.changeAudioButton.hidden;
    self.changeAudioLabel.hidden = !self.changeAudioLabel.hidden;
    self.microButton.hidden = !self.microButton.hidden;
    self.microLabel.hidden = !self.microLabel.hidden;
    self.cancelButton.hidden = !self.cancelButton.hidden;
    self.cancelLabel.hidden = !self.cancelLabel.hidden;
    self.handfreeButton.hidden = !self.handfreeButton.hidden;
    self.handfreeLabel.hidden = !self.handfreeLabel.hidden;
    self.changeCameraButton.hidden = !self.changeCameraButton.hidden;
    self.changeCameraLabel.hidden = !self.changeCameraLabel.hidden;
    self.timeLabel.hidden = !self.timeLabel.hidden;
    self.zoomOutButton.hidden = !self.zoomOutButton.hidden;
}

- (void)setConnectingTime:(NSString *)connectingTime{
    _connectingTime = connectingTime;
    self.timeLabel.text = connectingTime;
}
@end
