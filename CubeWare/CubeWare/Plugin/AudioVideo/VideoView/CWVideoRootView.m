//
//  CWVideoRootView.m
//  CubeWare
//
//  Created by 美少女 on 2018/1/4.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWVideoRootView.h"
#import "CWToastUtil.h"
#import "CWAudioRootView.h"
@interface CWVideoRootView ()<CWVideoInviteViewDelegate, CWVideoViewDelegate>

/**
 小视频窗口
 */
@property (nonatomic,strong) UIView *smallView;

/**
 视频通话窗口
 */
@property (nonatomic,strong) CWVideoView *videoView;

/**
 邀请窗口
 */
@property (nonatomic,strong) CWVideoInviteView *inviteView;

/**
 * 手势拖动悬浮窗
 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

/**
 * 点击悬浮窗
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

/**
 显示样式
 */
@property (nonatomic,assign) AVShowViewStyle showStyle;
@end

@implementation CWVideoRootView

+ (CWVideoRootView *)VideoRootView
{
    static CWVideoRootView *videoView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoView = [[CWVideoRootView alloc]init];
    });
    return videoView;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setSmallViewUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setSmallViewUI
{
    self.smallView.frame = CGRectMake(0, 0, 90, 120);
    self.smallView.hidden = YES;
    [self addSubview:self.smallView];
    self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    //添加手势
    [self addGestureRecognizer:self.panGesture];
    [self addGestureRecognizer:self.tapGesture];
}

#pragma mark - notify
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            [self.videoView setHandFreeEnable:NO];
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            [self.videoView setHandFreeEnable:YES];
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            break;
    }
}
#pragma mark - public methods
- (void)showView
{
    self.inviteView.peerCubeId = self.cubeId;
    self.videoView.peerCubeId = self.cubeId;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.videoView];
    [window addSubview:self.inviteView];

    if (self.showStyle == ConnectingStyle)
    {
        self.videoView.hidden = NO;
        self.inviteView.hidden = YES;
        
    }
    else
    {
        self.videoView.hidden = YES;
        self.inviteView.hidden = NO;
    }
}
- (void)close
{
    [self removeFromSuperview];
    [self.inviteView removeFromSuperview];
    [self.videoView removeFromSuperview];
}

- (void)setShowStyle:(AVShowViewStyle)style
{
    _showStyle = style;
    [self reloadView];
}

- (void)reloadView
{
    if (self.showStyle == ConnectingStyle)
    {
        self.videoView.hidden = NO;
        self.inviteView.hidden = YES;
    }
    else
    {
        [self.inviteView setShowStyle:self.showStyle];
        self.videoView.hidden = YES;
        self.inviteView.hidden = NO;
    }
}
- (void)setHandFreeEnable:(BOOL)enable
{
    [self.videoView setHandFreeEnable:enable];
}

- (BOOL)fireVideoCall
{
    if (self.cubeId)
    {
        BOOL ret = [[CubeEngine sharedSingleton].callService makeCallWithCallee:[CubeUser userWithCubeId:self.cubeId andDiaplayName:nil andAvatar:nil] andEnableVideo:YES];
        if (ret) {
            NSLog(@"正在呼叫%@", self.cubeId);

        }else {
            NSLog(@"呼叫%@失败，请稍候重试", self.cubeId);
            [CWToastUtil showTextMessage:[NSString stringWithFormat:@"呼叫失败,请稍后再试"] andDelay:1.f];
        }
        return ret;
    }
    return NO;
}

- (void)setLocalImageView:(UIView *)localImageView withRemoteImageView:(UIView *)remoteImageView
{//设置视频画面

    [self.videoView.localVideoImageView addSubview:localImageView];
    [self.videoView.remoteVideoImgView addSubview:remoteImageView];
}

- (void)changeToAudio
{
//    [[[CubeEngine sharedSingleton] getMediaService] closeVideoWithConsult:YES];
    [self.videoView removeFromSuperview];
    [CWAudioRootView AudioRootView].cubeId = self.cubeId;
    [[CWAudioRootView AudioRootView] setAudioType:SingleAudioType];
    [[CWAudioRootView AudioRootView] setShowStyle:ConnectingStyle];
    [[CWAudioRootView AudioRootView] showView];
}

#pragma mark - events
//拖动改变位置
-(void)locationChange:(UIPanGestureRecognizer*)pan
{
    CGPoint panPoint = [pan locationInView:[[UIApplication sharedApplication] keyWindow]];
    if(pan.state == UIGestureRecognizerStateChanged)
    {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(pan.state == UIGestureRecognizerStateEnded)
    {
        if(panPoint.x <= UIScreenWidth/2)
        {
            if(panPoint.y <= 40+self.frame.size.height/2 && panPoint.x >= 20+self.frame.size.width/2)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, self.frame.size.height/2);
                }];
            }
            else if(panPoint.y >= UIScreenHeight-self.frame.size.height/2-40 && panPoint.x >= 20+self.frame.size.width/2)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, UIScreenHeight-self.frame.size.height/2);
                }];
            }
            else if (panPoint.x < self.frame.size.width/2+15 && panPoint.y > UIScreenHeight-self.frame.size.height/2)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(self.frame.size.width/2, UIScreenHeight-self.frame.size.height/2);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y < self.frame.size.height/2 ? self.frame.size.height/2 :panPoint.y;
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(self.frame.size.width/2, pointy);
                }];
            }
        }
        else if(panPoint.x > UIScreenWidth/2)
        {
            if(panPoint.y <= 40+self.frame.size.height/2 && panPoint.x < UIScreenWidth-self.frame.size.width/2-20 )
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, self.frame.size.height/2);
                }];
            }
            else if(panPoint.y >= UIScreenHeight-40-self.frame.size.height/2 && panPoint.x < UIScreenWidth-self.frame.size.width/2-20)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, UIScreenHeight-self.frame.size.height/2);
                }];
            }
            else if (panPoint.x > UIScreenWidth-self.frame.size.width/2-15 && panPoint.y < self.frame.size.height/2)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(UIScreenWidth-self.frame.size.width/2, self.frame.size.height/2);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y > UIScreenHeight-self.frame.size.height/2 ? UIScreenHeight-self.frame.size.height/2 :panPoint.y;
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(UIScreenWidth-self.frame.size.width/2, pointy);
                }];
            }
        }
    }
}

- (void)click:(UIButton *)button
{
    //重新进入大视频窗口
    self.smallView.hidden = YES;
    self.videoView.hidden = NO;

//    for (UIView *smallRemoteView in [self.smallView subviews]) {
//        CubeRemoteVideoView *smallVideoView = (CubeRemoteVideoView *)smallRemoteView;
//        [self.videoView.remoteVideoImgView addSubview:smallVideoView];
//        [UIView animateWithDuration:0.4f
//                         animations:^{
//                             CGRect remoteFrame = self.videoView.remoteVideoImgView.bounds;
//
//                             [smallVideoView changeFrame:remoteFrame];
//                             [smallVideoView setBackgroundColor:[UIColor blackColor]];
//                         } completion:^(BOOL finished) {
//
//                         }];
//    }
}


#pragma mark - CWVideoViewDelegate
- (void)zoomOutWindow
{
    self.smallView.hidden = NO;
    self.videoView.hidden = YES;
    self.frame =  CGRectMake(UIScreenWidth - 90, 20, 90, 120);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
//    for (UIView * subview in [self.videoView.remoteVideoImgView subviews]) {
//        CubeRemoteVideoView *smallRemoteVideoView = (CubeRemoteVideoView *)subview;
//        [self.smallView addSubview:smallRemoteVideoView];
//        [UIView animateWithDuration:0.1f
//                         animations:^{
//                             CGRect smallRemoteFrame = self.smallView.bounds;
//
//                             [smallRemoteVideoView changeFrame:smallRemoteFrame];
//                             [smallRemoteVideoView setBackgroundColor:[UIColor blackColor]];
//                         } completion:^(BOOL finished) {
//
//                         }];
//    }
}

- (void)changeToVoice
{
    [self changeToAudio];
}

#pragma mark - getters
- (UIView *)smallView
{
    if (nil == _smallView)
    {
        _smallView = [[UIView alloc]init];
    }
    return _smallView;
}

- (CWVideoInviteView *)inviteView
{
    if (nil == _inviteView)
    {
        _inviteView = [[CWVideoInviteView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        _inviteView.delegate = self;
    }
    return _inviteView;
}

- (CWVideoView *)videoView
{
    if (nil == _videoView)
    {
        _videoView = [[CWVideoView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        _videoView.delegate = self;
    }
    return _videoView;
}

#pragma mark - privite methods

@end
