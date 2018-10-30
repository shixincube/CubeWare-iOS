//
//  CWRecordView.m
//  CWRebuild
//
//  Created by luchuan on 2018/1/8.
//  Copyright © 2018年 luchuan. All rights reserved.
//

#import "CWRecordView.h"
#import "CWSpectrumView.h"
#import "CWColorUtil.h"
#import "UIView+NCubeWare.h"
#import "CWResourceUtil.h"
#import "CWAuthorizeManager.h"
#import "NSString+NCubeWare.h"
#import "CWToastUtil.h"
#import "CubeWareHeader.h"
#import "CWProgressLayer.h"
#import "CWAlertView.h"
typedef NS_ENUM(NSInteger,CWRecordState){
    CWRecordStateWillBegin,
    CWRecordStateRecording,
    CWRecordStateWillFinsh,
    CWRecordStateDidFinsh,
    CWRecordStateRecrordTooShort,
    CWRecordStateWillSend,
    CWRecordStateDidSend,
    CWRecordStateWillDelete,
    CWRecordStateDidDelete,
    CWRecordStateWillReplay,
    CWRecordStateReplaying,
    
};

@interface CWRecordView()<CubeRecordServiceDelegate,CubeMediaPlayServiceDelegate>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) CWSpectrumView *spectrumView;
@property (nonatomic, strong) UIImageView *centerImageV;
@property (nonatomic, strong) UIImageView *playBackImageV;
@property (nonatomic, strong) UIImageView *deleteImageV;
@property (nonatomic, strong) UIButton *replayBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) NSString *filePath; // 录制的文件路径

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeIndex;
@property (nonatomic, assign) NSInteger totalTime; // 语音总时长
@property (nonatomic, assign) BOOL showLine;
@property (nonatomic, assign) CWRecordState recordState;
@property (nonatomic, assign) BOOL onLongGesterIng;
@property (nonatomic, strong) CWProgressLayer *progressLayer;
@end


@implementation CWRecordView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
       
    }
    return self;
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.centerX.equalTo(self);
    }];
    [self.centerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.playBackImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).offset(-40);
        make.left.mas_equalTo(self).offset(20);
    }];
    [self.deleteImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playBackImageV);
        make.right.mas_equalTo(self).offset(-20);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.cancelBtn.mas_right).offset(-1);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(self.cancelBtn.mas_width);
    }];
    [self.replayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.centerImageV);
    }];
    [self.spectrumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLab);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(200);
        make.centerX.mas_equalTo(self);
    }];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (!_showLine) return;
    UIColor *color = [CWColorUtil colorWithRGB:0xf1f2f7 andAlpha:1];
    [color set]; //设置线条颜色
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 1.0;
    aPath.lineCapStyle = kCGLineCapButt; //线条拐角
    aPath.lineJoinStyle = kCGLineJoinMiter; //终点处理
    CGPoint starPoint = CGPointMake(_centerImageV.cw_left, _centerImageV.cw_top + _centerImageV.cw_height * 0.6);
    CGPoint endPoint = CGPointMake(_playBackImageV.cw_right, _playBackImageV.cw_top + _playBackImageV.cw_height * 0.6);
    CGPoint controlPoint = CGPointMake((starPoint.x + endPoint.x)/2, (starPoint.y + endPoint.y)/2 + 20);
    [aPath moveToPoint:starPoint];
    [aPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    [aPath stroke];
    
    CGPoint starPoint2 = CGPointMake(_centerImageV.cw_right, _centerImageV.cw_top + _centerImageV.cw_height * 0.6);
    CGPoint endPoint2 = CGPointMake(_deleteImageV.cw_left, _deleteImageV.cw_top + _deleteImageV.cw_height * 0.6);
    CGPoint controlPoint2 = CGPointMake((starPoint2.x + endPoint2.x)/2, (starPoint2.y + endPoint2.y)/2 + 20);
    [aPath moveToPoint:starPoint2];
    [aPath addQuadCurveToPoint:endPoint2 controlPoint:controlPoint2];
    [aPath stroke];
}

#pragma mark - CubeRecordDelegate

-(void)didStartRecordAudioToFile:(NSString *)filePath{
	[self showSomeViewsWhenRecord:YES];
	[self startChangeSpectrumView];
	 _totalTime = 0;
}

-(void)didFinishedRecordAudioToFile:(NSString *)filePath withError:(CubeError *)error{
	if(error)
	{
		if (error.errorCode == 1102) { // 语音录制时间太短
			[CWToastUtil showTextMessage:error.errorInfo andDelay:1];
		}
		self.filePath = NULL;
		[self showSomeViewsWhenRecord:NO];
		 _totalTime = _timeIndex;
	}
	else
	{
		NSLog(@"lc::%s",__func__);
		[self recordFinshed];
		self.filePath = filePath;
		if (self.recordState == CWRecordStateWillReplay) {
			[self playBackAction];
		}
		else if (self.recordState == CWRecordStateWillDelete)
		{
			if(filePath)
			{
				[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
			}
		}
        else
        {
            [self sendRecord];
        }
         _totalTime = _timeIndex;
	}
}

#pragma mark - CubePlayServiceDelegate
-(void)didStartedPlay:(NSString *)file duration:(CMTime)duration viewLayer:(AVPlayerLayer *)layer{
	    NSLog(@"lc::%s",__func__);
	    [self startChangeSpectrumView];
	    self.replayBtn.selected = YES;
	    [self.progressLayer starAnimation:CMTimeGetSeconds(duration)];
}

-(void)didCompletedPlay:(NSString *)file withError:(CubeError *)error{
	if(error)
	{
		NSLog(@"play file:%@ error:%@",file,error.errorInfo);
	}
	self.replayBtn.selected = NO;
	[self stopChangeSpectRumView];
}

#pragma mark - Action
- (void)longGestureAction:(UIGestureRecognizer *)gesture{
    CGPoint position = [gesture locationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [CubeEngine sharedSingleton].mediaService.recordServiceDelegate = self;
        [self longGestureBegin];
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        [self longPositionHadChange:position];
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        self.titleLab.text = @"按住说话";
        [self showSomeViewsWhenRecord:NO];
        [self longGestureEnd:position];
    }
}

- (void)playBackAction{
    [self showSomeViewWhenPlayBack:YES];
}

/**取消发送*/
- (void)cancelPlayBack{
	[[CubeEngine sharedSingleton].mediaService stopCurrentPlay];
    [self showSomeViewWhenPlayBack:NO];
	if(self.filePath)
	{
		[[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil];
	}
}


- (void)sendRecord{
    [[CubeEngine sharedSingleton].mediaService stopCurrentPlay];
     [self showSomeViewWhenPlayBack:NO];
    if (_delegate && [_delegate respondsToSelector:@selector(recordView:finshRecord:)]) {
        [_delegate recordView:self finshRecord:self.filePath];
    }
}


- (void)replayBtnAction:(UIButton *)replayBtn{
    if (replayBtn.selected)
	{
        //暂停
		[[CubeEngine sharedSingleton].mediaService stopCurrentPlay];
        [self.progressLayer stopAnimation];
    }else{
        //播放
        if (self.filePath)
		{
			[CubeEngine sharedSingleton].mediaService.mediaPlayServiceDelegate = self;
			[[CubeEngine sharedSingleton].mediaService play:self.filePath repeatTimes:0];
        }
    }
}

- (void)updateSpecturmView{
    self.spectrumView.text = [NSString stringWithTimeInterval:_timeIndex++];
    if (_timeIndex == 59) {//大约有1s左右的误差
        self.recordState = CWRecordStateWillSend;
        [[CubeEngine sharedSingleton].mediaService stopRecordAudio];
    }
}

#pragma mark - Notification
-(void)sensorStateChange:(NSNotificationCenter *)notification{
    if ([[UIDevice currentDevice] proximityState] == YES) {
        NSLog(@"Device is close to user");
         [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else{
        NSLog(@"Device is not close to user");
          [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

#pragma mark - privtate Methods


-(void)showSomeViewsWhenRecord:(BOOL)isShow{
    self.centerImageV.highlighted = isShow;
    self.playBackImageV.hidden = !isShow;
    self.deleteImageV.hidden = !isShow;
    self.spectrumView.hidden = !isShow;
    self.showLine = isShow;
    self.titleLab.hidden = isShow;
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

- (void)showSomeViewWhenPlayBack:(BOOL)isShow{
    self.centerImageV.hidden = isShow;
    self.titleLab.hidden = isShow;
    self.spectrumView.hidden = !isShow;
    self.replayBtn.hidden = !isShow;
    self.cancelBtn.hidden = !isShow;
    self.sendBtn.hidden = !isShow;
    [[UIDevice currentDevice] setProximityMonitoringEnabled:isShow];
}

- (void)showTitle:(NSString *)title{
    if (title.length > 0) {
        self.titleLab.hidden = NO;
        self.spectrumView.hidden = YES;
        self.titleLab.text = title;
    }else{
        self.titleLab.hidden = YES;
        self.spectrumView.hidden = NO;
        self.titleLab.text = @"按住说话";
    }
}

- (void)recordFinshed{
    [self stopChangeSpectRumView];
    self.playBackImageV.highlighted = NO;
    self.deleteImageV.highlighted = NO;
    self.playBackImageV.transform = CGAffineTransformIdentity;
    self.deleteImageV.transform = CGAffineTransformIdentity;
}

- (void)longGestureBegin{
    self.titleLab.text = @"准备中";
    self.filePath = NULL;
    self.onLongGesterIng = YES;
    [CWAuthorizeManager authorizeForType:CWAuthorizeTypeMIC completed:^(BOOL isAllow, NSError *error) {
        if (!isAllow) {
            NSLog(@"无权限");
            self.titleLab.text = @"没有麦克风权限";
            [CWAlertView showNormalAlertWithTitle:nil message:@"没有麦克风权限" leftTitle:nil rightTitle:@"确定" hanle:^(NSString *buttonTitle) {
                
            }];
            return ;
        }
        if(!self.onLongGesterIng)return;
        if ([CubeEngine sharedSingleton].mediaService.isCalling) {
            [CWToastUtil showTextMessage:@"正在通话中，无法录制短语音" andDelay:1];
            return;
        }
        self.recordState = CWRecordStateWillBegin;
		[[CubeEngine sharedSingleton].mediaService startRecordAudioWithDuration:60];
    }];
}

/** 长按的位置改变，YES:在当前视图中，NO，已经超出了当前视图*/
-(BOOL)longPositionHadChange:(CGPoint)position{
    if (CGRectContainsPoint(self.centerImageV.frame, position)){
        self.playBackImageV.transform = CGAffineTransformIdentity;
        self.deleteImageV.transform = CGAffineTransformIdentity;
        [self setNeedsDisplay];
        [self layoutIfNeeded];
         return YES;//在中央按钮时直接返回
    }
    if (position.x < 0 || position.y < 0 ) return NO;//超出当前View
    CGFloat distanceH = position.x - self.centerImageV.center.x;
    CGFloat scale = 1 + ABS(distanceH / (self.centerImageV.center.x - self.playBackImageV.center.x) * 0.7) ;
    if (distanceH < 0) { // 在左边
        self.playBackImageV.transform = CGAffineTransformMakeScale(scale, scale);
        if (CGRectContainsPoint(self.playBackImageV.frame, position)) {
            self.playBackImageV.highlighted = YES;
            [self showTitle:@"松手试听"];
        }else{
            self.playBackImageV.highlighted = NO;
            [self showTitle:@""];
        }
    }else{ //
        self.deleteImageV.transform = CGAffineTransformMakeScale(scale, scale);
        if (CGRectContainsPoint(self.deleteImageV.frame, position)) {
            self.deleteImageV.highlighted = YES;
            [self showTitle:@"松手取消发送"];
        }else{
            self.deleteImageV.highlighted = NO;
            [self showTitle:@""];
        }
    }
    [self setNeedsDisplay];
    [self layoutIfNeeded];
    return YES;
}

/**长按手势结束*/
- (void)longGestureEnd:(CGPoint)position{
    self.onLongGesterIng = NO;
    if (CGRectContainsPoint(self.playBackImageV.frame, position)) { // 回放
        self.recordState = CWRecordStateWillReplay;
		[[CubeEngine sharedSingleton].mediaService stopRecordAudio];
    }else if (CGRectContainsPoint(self.deleteImageV.frame, position)){ //删除
        self.recordState = CWRecordStateWillDelete;
        [[CubeEngine sharedSingleton].mediaService stopRecordAudio];
    }else{ //发送
        if(_timeIndex > 1)
        {
            self.recordState = CWRecordStateWillSend;
            [[CubeEngine sharedSingleton].mediaService stopRecordAudio];
        }
        else
        {
            self.recordState = CWRecordStateWillDelete;
            [[CubeEngine sharedSingleton].mediaService stopRecordAudio];
            [CWToastUtil showTextMessage:@"录制时长太短" andDelay:1];
        }
    }
	
}

- (void)startChangeSpectrumView{
    self.timeIndex = 0;
    [self.spectrumView startUpdateMeter];
    self.timer.fireDate = [NSDate date];
}

- (void)stopChangeSpectRumView{
    [self.spectrumView stopUpdateMeter];
    self.timer.fireDate = [NSDate distantFuture];
}

#pragma mark - getters and setters
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"按住说话";
        _titleLab.textColor = [CWColorUtil colorWithRGB:0x333333 andAlpha:1];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}

- (UIImageView *)centerImageV{
    if (!_centerImageV) {
        _centerImageV = [[UIImageView alloc] init];
        _centerImageV.image =[CWResourceUtil imageNamed:@"record_voice"];
        _centerImageV.highlightedImage = [CWResourceUtil imageNamed:@"record_voice_sel"];
        _centerImageV.userInteractionEnabled = YES;
        UILongPressGestureRecognizer * longGestur = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureAction:)];
        [_centerImageV addGestureRecognizer:longGestur];
        [self addSubview:_centerImageV];
        
    }
    return _centerImageV;
}


- (UIImageView *)playBackImageV{
    if (!_playBackImageV) {
        _playBackImageV = [[UIImageView alloc] init];
        _playBackImageV.image = [CWResourceUtil imageNamed:@"record_replay"];
        _playBackImageV.highlightedImage = [CWResourceUtil imageNamed:@"record_replay_sel"];
        _playBackImageV.hidden = YES;
        [self addSubview:_playBackImageV];
    }
    return _playBackImageV;
}

- (UIImageView *)deleteImageV{
    if (!_deleteImageV) {
        _deleteImageV = [[UIImageView alloc] init];
        _deleteImageV.image = [CWResourceUtil imageNamed:@"record_delete"];
        _deleteImageV.highlightedImage = [CWResourceUtil imageNamed:@"record_delete_sel"];
        _deleteImageV.hidden = YES;
        [self addSubview:_deleteImageV];
    }
    return _deleteImageV;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[CWColorUtil colorWithRGB:0x7a8fdf andAlpha:1] forState:UIControlStateNormal];
        _cancelBtn.hidden = YES;
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = [CWColorUtil colorWithRGB:0xf1f2f7 andAlpha:1].CGColor;
        [_cancelBtn addTarget:self action:@selector(cancelPlayBack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[CWColorUtil colorWithRGB:0x7a8fdf andAlpha:1] forState:UIControlStateNormal];
        _sendBtn.hidden = YES;
        _sendBtn.layer.borderWidth = 1;
        _sendBtn.layer.borderColor = [CWColorUtil colorWithRGB:0xf1f2f7 andAlpha:1].CGColor;
        [_sendBtn addTarget:self action:@selector(sendRecord) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendBtn];
    }
    return _sendBtn;
}

-(UIButton *)replayBtn{
    if (!_replayBtn) {
        _replayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replayBtn setImage:[CWResourceUtil imageNamed:@"record_start_replay"] forState:UIControlStateNormal];
        [_replayBtn setImage:[CWResourceUtil imageNamed:@"record_start_replay_sel"] forState:UIControlStateHighlighted];
        [_replayBtn setImage:[CWResourceUtil imageNamed:@"record_playing"] forState:UIControlStateSelected];
        _replayBtn.hidden = YES;
        [_replayBtn addTarget:self action:@selector(replayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_replayBtn];
    }
    return _replayBtn;
}

-(CWSpectrumView *)spectrumView{
    if (!_spectrumView) {
        _spectrumView = [[CWSpectrumView alloc] init];
        _spectrumView.itemColor = [CWColorUtil colorWithRGB:0x7a8fdf andAlpha:1];
        _spectrumView.text = @"00:00:00";
        _spectrumView.hidden = YES;
        [self addSubview:_spectrumView];
        __weak CWSpectrumView * weakSpectrum = _spectrumView;
        __weak typeof(self) weakSelf = self;
        _spectrumView.itemLevelCallback = ^{
//            AVAudioRecorder *audioRecorder = weakSelf.mediaService.audioRecoder;
//            float power = 0;
//            BOOL isRecording = NO;
//            if (audioRecorder && audioRecorder.isRecording) {
//                isRecording = YES;
//                [audioRecorder updateMeters];
//                //取得第一个通道的音频，音频强度范围时-160到0
//                power= [audioRecorder averagePowerForChannel:0];
//            }
//
//            BOOL isPlaying = NO;
//            AVAudioPlayer *audioPalyer = weakSelf.mediaService.audioPlayer;
//            if (audioPalyer && audioPalyer.isPlaying) {
//                isPlaying = YES;
//                [audioPalyer updateMeters];
//                power= [audioRecorder averagePowerForChannel:0];
//            }
//            if (isPlaying || isRecording) {
//                 weakSpectrum.level = power;
//            }
			weakSpectrum.level = -120;

        };
    }
    return _spectrumView;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSpecturmView) userInfo:nil repeats:YES];
        _timer.fireDate = [NSDate distantFuture];
    }
    return _timer;
}
- (CWProgressLayer *)progressLayer{
    if(!_progressLayer){
        _progressLayer = [[CWProgressLayer alloc] init];
        _progressLayer.frame = CGRectMake(0, 0, self.replayBtn.frame.size.width, self.replayBtn.frame.size.height);
        [self.replayBtn.layer addSublayer:_progressLayer];
    }
    return _progressLayer;
}
@end
