//
//  CWPlayerView.m
//  CubeWare
//
//  Created by Mario on 17/4/14.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWPlayerView.h"
#import "CWProgressView.h"
#import "CWCustomAlertView.h"
//#import "UIView+CubeWare.h"
//#import "UIImage+CubeWare.h"
#import "UIImageView+WebCache.h"
//#import "CWButtonItem.h"
//#import "UIAlertView+CWBlocks.h"
#import "CWWorkerFinder.h"
#import "CubeWareGlobalMacro.h"
#import "CWResourceUtil.h"
#import "UIView+NCubeWare.h"
#import "CWUtils.h"
#import "CWFileRefreshDelegate.h"
#define MAX_VIDEO_DURATION 10

@interface CWPlayerView () <CWFileRefreshDelegate>{
    BOOL isIntoBackground;
    BOOL isShowToolbar;
    NSTimer *_timer;
    AVPlayerItem *_playerItem;
    AVPlayerLayer *_playerLayer;
    id _playTimeObserver; // 播放进度观察者
    BOOL isFull;
}
@property (strong, nonatomic) UIView *playerView;
@property (strong, nonatomic) UIView *downView;
@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIButton *closeBtn;
@property (strong, nonatomic) UIButton *playCenterBtn;
@property (strong, nonatomic) UILabel *currentTimeLabel;
@property (strong, nonatomic) UISlider *playProgress;
@property (strong, nonatomic) UIProgressView *bufferProgress;
@property (strong, nonatomic) UILabel *totalTimeLabel;
@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, strong) UIView *oldView;
@property (nonatomic, strong) UIViewController *SuperVC;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, strong) CubeVideoClipMessage *videoModel;
@property (nonatomic, strong) CWProgressView * progressView;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (strong, nonatomic) UIProgressView *secretProgress;
@property (nonatomic, strong) dispatch_source_t sourceTimer;

@property (nonatomic, copy) NSString *recallMessageSN;
@end

@implementation CWPlayerView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        isShowToolbar = NO;
        [self setUpViewWithFrame:frame];
        [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWFileRefreshDelegate)]];
    }
    return self;
}

- (void)setUpViewWithFrame:(CGRect)frame{
    _playerView = [[UIView alloc] initWithFrame:frame];
    _playerView.backgroundColor = [UIColor blackColor];
    [self addSubview:_playerView];
    
    self.player = [[AVPlayer alloc] init];
    [self addObserverAndNotification];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    [self.playerView.layer addSublayer:_playerLayer];
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    _backgroundImageView.hidden = NO;
    [_playerView addSubview:_backgroundImageView];
    
    _progressView = [[CWProgressView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _progressView.center = CGPointMake(UIScreenWidth/2, UIScreenHeight/2);
    [_playerView addSubview:_progressView];
    
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 44, 44)];
    [_closeBtn setImage:[CWResourceUtil imageNamed:@"img_video_player_close.png"] forState:UIControlStateNormal];
    _closeBtn.backgroundColor = [UIColor clearColor];
    [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.hidden = YES;
    _closeBtn.enabled = YES;
    [_playerView addSubview:_closeBtn];
    
    _playCenterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _playCenterBtn.center = self.center;
    [_playCenterBtn setBackgroundImage:[CWResourceUtil imageNamed:@"img_videoplay_default.png"] forState:UIControlStateNormal];
    _playCenterBtn.backgroundColor = [UIColor clearColor];
    [_playCenterBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    _playCenterBtn.hidden = YES;
    [_playerView addSubview:_playCenterBtn];
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 66, frame.size.width, 44)];
    _downView.backgroundColor = [UIColor clearColor];
    _downView.hidden = YES;
    [_playerView addSubview:_downView];
    
    _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _playBtn.backgroundColor = [UIColor clearColor];
    [_playBtn addTarget:self action:@selector(playORPause:) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:_playBtn];
    
    _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 44, 44)];
    _currentTimeLabel.backgroundColor = [UIColor clearColor];
    _currentTimeLabel.textColor = [UIColor whiteColor];
    _currentTimeLabel.font = [UIFont systemFontOfSize:14.f];
    _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    _currentTimeLabel.text = @"00:00";
    [_downView addSubview:_currentTimeLabel];
    
    _bufferProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(88, 0, frame.size.width - 132, 44)];
    _bufferProgress.backgroundColor = [UIColor clearColor];
    _bufferProgress.tintColor = [UIColor whiteColor];
    _bufferProgress.contentMode = UIViewContentModeScaleToFill;
    [_downView addSubview:_bufferProgress];
    
    _playProgress = [[UISlider alloc] initWithFrame:CGRectMake(88, 0, frame.size.width - 132, 44)];
    _playProgress.minimumTrackTintColor = [UIColor clearColor];
    _playProgress.maximumTrackTintColor = [UIColor clearColor];
    [self.playProgress setThumbImage:[CWResourceUtil imageNamed:@"img_video_player_point"] forState:UIControlStateNormal];
    [_playProgress addTarget:self action:@selector(playerSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [_playProgress addTarget:self action:@selector(playerSliderInside:) forControlEvents:UIControlEventTouchUpInside];
    [_playProgress addTarget:self action:@selector(playerSliderDown:) forControlEvents:UIControlEventTouchDown];
    [_downView addSubview:_playProgress];
    _bufferProgress.cw_centerY = _playProgress.cw_centerY;

    _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 44, 0, 44, 44)];
    _totalTimeLabel.backgroundColor = [UIColor clearColor];
    _totalTimeLabel.textColor = [UIColor whiteColor];
    _totalTimeLabel.font = [UIFont systemFontOfSize:14.f];
    _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_downView addSubview:_totalTimeLabel];
    
    
    _secretProgress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    _secretProgress.trackTintColor = CWRGBColor(248.f, 117.f, 125.f, 1.f);
    _secretProgress.progressTintColor = [UIColor blackColor];
    _secretProgress.hidden = YES;
    _secretProgress.contentMode = UIViewContentModeScaleToFill;
     _secretProgress.frame = CGRectMake(0, 0, UIScreenWidth, 3);
    [_playerView addSubview:_secretProgress];

    _recallMessageSN = [[NSString alloc] init];
}

- (void)showInSuperView:(UIView*)SuperView andSuperVC:(UIViewController *)SuperVC
{
    [SuperView addSubview:self];
    _oldView=SuperView;
    _SuperVC=SuperVC;
}

// 后台
- (void)resignActiveNotification{
    isIntoBackground = YES;
    [self pause];
}

// 前台
- (void)enterForegroundNotification
{
    isIntoBackground = NO;
    [self play];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _playerLayer.frame = self.bounds;
}

- (void)updatePlayerWith:(NSURL *)url{
    _playerItem = [AVPlayerItem playerItemWithURL:url];
    [_player replaceCurrentItemWithPlayerItem:_playerItem];
    [self monitoringPlayback:_player.currentItem];// 监听播放状态
    
}

- (void)updatePlayerBackgroundViewMessageModel:(CubeVideoClipMessage *)model rect:(CGRect)viewRect{
    _oldFrame = viewRect;
    isShowToolbar = NO;
    _backgroundImageView.hidden = NO;
    _videoModel = model;
    if (model.thumbUrl) {
        NSString *urlStr = [model.thumbUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlStr];
        CGRect imgViewFrame = CGRectMake(0, 0, model.thumbImageWidth, model.thumbImageHeight);
        CGRect changeFrame = [CWUtils rectWithImageRect:imgViewFrame ratio:1.0 inBounds:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.backgroundImageView sd_setImageWithURL:url placeholderImage:nil];
        [self.backgroundImageView setFrame:changeFrame];
    }
}

- (void)updatePlayerProgress:(float)progress andMessageModel:(CubeVideoClipMessage *)model{
    if (progress >= 1.f && model) {
        _videoModel = model;
        if (model.filePath && ![_recallMessageSN isEqualToString:[NSString stringWithFormat:@"%lld",model.SN]]) {
            _backgroundImageView.hidden = YES;
            _progressView.hidden = YES;
            [self updatePlayerWith:[NSURL fileURLWithPath:model.filePath]];
        }
    }else if (progress < 1.f){
        [_progressView setProgress:progress];
        _backgroundImageView.hidden = NO;
    }
}

- (void)addObserverAndNotification{
    [_player addObserver:self forKeyPath:@"currentItem.status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [_player addObserver:self forKeyPath:@"currentItem.loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听缓冲进度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
    [self addNotification];
}

-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 后台&前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignActiveNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)playbackFinished:(NSNotification *)notification{
    _playerItem = [notification object];
    [_playerItem seekToTime:kCMTimeZero];
    [self pause];
}

-(void)updateRevokedMessage:(NSString *)messageSN{
//    __block typeof(self)weakself = self;
//    if ([[NSString stringWithFormat:@"%lld",_videoModel.SN] isEqualToString:messageSN]) {
//        _recallMessageSN = messageSN;
//        [self pause];
//        NSString *message = nil;
//        if (_videoModel.progress == _videoModel.fileSize && _videoModel.fileMessageState == CubeFileMessageStateSucceed) {
//            message = NSLocalizedString(@"消息已被撤回", nil);
//        }else{
//            message = NSLocalizedString(@"下载失败,消息已被撤回", nil);
//        }
//        NSString *determineTitle = NSLocalizedString(@"确定", nil);
//        [CWCustomAlertView showNormalAlertWithTitle:nil message:message leftTitle:nil rightTitle:determineTitle hanle:^(NSString *buttonTitle) {
//            [weakself close:_closeBtn];
//        }];
//    }
}

#pragma mark - KVO - status
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *item = nil;
    if ([object isKindOfClass:[AVPlayer class]]) {
        AVPlayer *avPlayer = (AVPlayer *)object;
        item = avPlayer.currentItem;
    
    if ([keyPath isEqualToString:@"currentItem.status"]) {
        if (isIntoBackground) {
            return;
        }else{
            if ([item status] == AVPlayerStatusReadyToPlay) {
                NSLog(@"AVPlayerStatusReadyToPlay");
                CMTime duration = item.duration;// 获取视频总长度
                float time = CMTimeGetSeconds(duration);
                NSLog(@"%f", time);
                [self setMaxDuratuin:time];
                [self play];
            }else if([item status] == AVPlayerStatusFailed) {
                NSLog(@"AVPlayerStatusFailed");
            }else{
                NSLog(@"AVPlayerStatusUnknown");
            }
        }
    }else if ([keyPath isEqualToString:@"currentItem.loadedTimeRanges"]) {
    }else if (item == _playerItem && [keyPath isEqualToString:@"currentItem.playbackBufferEmpty"])
    {
        if (_playerItem.playbackBufferEmpty) {
            //Your code here
            NSLog(@"bufer Empty---");
        }
    }
    
    else if (item == _playerItem && [keyPath isEqualToString:@"currentItem.playbackLikelyToKeepUp"])
    {
        if (_playerItem.playbackLikelyToKeepUp)
        {
            //Your code here
            NSLog(@"keep   up");
            
        }
    }
    } else {
        NSLog(@"observer class name = %@", object);
    }
}

- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            
            //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            [self pause];
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:

            break;
    }
}

- (NSTimeInterval)availableDurationRanges {
    NSArray *loadedTimeRanges = [_playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - 移除通知&KVO
- (void)removeObserverAndNotification{
    [_player removeObserver:self forKeyPath:@"currentItem.status"];
    [_player removeObserver:self forKeyPath:@"currentItem.loadedTimeRanges"];
    [_player replaceCurrentItemWithPlayerItem:nil];
    [_player removeTimeObserver:_playTimeObserver];
    _playTimeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setMaxDuratuin:(float)total{
    self.playProgress.maximumValue = total;
    self.totalTimeLabel.text = [self convertTime:self.playProgress.maximumValue];
}

#pragma mark - _playTimeObserver
- (void)monitoringPlayback:(AVPlayerItem *)item {
    __weak typeof(self) weakself = self;
    //这里设置每秒执行30次
    _playTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // 计算当前在第几秒
        float currentPlayTime = (double)item.currentTime.value/item.currentTime.timescale;
        [weakself updateVideoSlider:currentPlayTime];
    }];
}

- (void)updateVideoSlider:(float)currentTime{
    self.playProgress.value = currentTime;
    if (currentTime < 1) {
        self.currentTimeLabel.text = @"00:00";
    }else{
        self.currentTimeLabel.text = [self convertTime:currentTime];
    }
}

- (void)close:(id)sender{
    CGAffineTransform transform = CGAffineTransformMakeRotation(0);
    _closeBtn.enabled = NO;
    //CGRect rect = _oldFrame;
    self.backgroundColor = [UIColor clearColor];
    _sourceTimer = nil;
    
    [self removeObserverAndNotification];
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = transform;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        if ([self.delegate respondsToSelector:@selector(closeVideoPlayer)]) {
            [self.delegate closeVideoPlayer];
        }
    }];
}

- (void)playORPause:(id)sender {
    if (_isPlaying) {
        [self pause];
    }else{
        [self play];
    }
    [self chickToolBar];
}

- (void)playerSliderChanged:(UISlider *)sender {
    [self pause];
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(self.playProgress.value, 1);
    [_playerItem seekToTime:dragedCMTime];
    [self chickToolBar];
}

- (void)playerSliderInside:(UISlider *)sender {
    NSLog(@"释放播放");
    [self play];
}

- (void)playerSliderDown:(UISlider *)sender {
    NSLog(@"按动暂停");
    [self pause];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchBegan");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchEnd");
    if (_backgroundImageView.isHidden) {
        if (self.isLandscape) {
            if (isShowToolbar) {
                [self landscapeHide];
            }else{
                [self landscapeShow];
            }
        }else{
            if (isShowToolbar) {
                [self portraitHide];
            }else{
                [self portraitShow];
            }
        }
    }else{
        [self close:self.closeBtn];
    }
}

- (void)portraitShow{
    isShowToolbar = YES;
    self.downView.hidden = NO;
    self.closeBtn.hidden = NO;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:5]; //fireDate
    [_timer invalidate];
    _timer = nil;
    _timer = [[NSTimer alloc] initWithFireDate:date interval: 1 target:self selector:@selector(portraitHide) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)chickToolBar{
    if (self.isLandscape) {
        [self landscapeShow];
    }else{
        [self portraitShow];
    }
}

- (void)portraitHide{
    isShowToolbar = NO;
    self.downView.hidden = YES;
    self.closeBtn.hidden = YES;
}

- (void)landscapeShow{
    isShowToolbar = YES;
    self.downView.hidden = NO;
    self.closeBtn.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:5]; //fireDate
    [_timer invalidate];
    _timer = nil;
    _timer = [[NSTimer alloc] initWithFireDate:date interval: 1 target:self selector:@selector(landscapeHide) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)landscapeHide{
    isShowToolbar = NO;
    self.downView.hidden = YES;
    self.closeBtn.hidden = YES;
    if (self.isLandscape) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
}

- (void)play{
    _isPlaying = YES;
    [_player play];
    _playCenterBtn.hidden = YES;
    [self.playBtn  setImage:[CWResourceUtil imageNamed:@"img_video_player_pause.png"] forState:UIControlStateNormal];
}

- (void)pause{
    _isPlaying = NO;
    [_player pause];
    _playCenterBtn.hidden = NO;
    [self.playBtn  setImage:[CWResourceUtil imageNamed:@"img_video_player_play.png"] forState:UIControlStateNormal];
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}
//
//- (NSString *)secretMessageTime{
//    return [NSString stringWithFormat:@"%d", (int)(_videoModel.secretReadTime - ([CWUtils getCurrentTimestamp] - _videoModel.secretTimestamp)/1000)];
//}


#pragma mark - CWFileRefreshDelegate
- (void)fileMessageDownloading:(CubeMessageEntity *)message withProcessed:(long long)processed withTotal:(long long)total{
    if(message.SN != self.videoModel.SN)return;
    
    CGFloat progress = processed / total;
    NSLog(@"video file process %f",progress);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updatePlayerProgress:processed andMessageModel:nil];
    });
    
    
}


- (void)fileMessageDownLoadComplete:(CubeMessageEntity *)message{
    if(message.SN != self.videoModel.SN)return;
    if(![message isKindOfClass:[CubeVideoClipMessage class]])return;
    CubeVideoClipMessage * videoMsg = (CubeVideoClipMessage *)message;
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoMsg.filePath]) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [self updatePlayerProgress:1.f andMessageModel:videoMsg];
        });
       
    }
}
@end
