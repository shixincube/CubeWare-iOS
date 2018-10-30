//
//  CWAudioRootView.m
//  CubeWare
//
//  Created by 美少女 on 2017/12/28.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWAudioRootView.h"
#import "CWResourceUtil.h"
#import "CWToastUtil.h"
#import "CWColorUtil.h"
#import "CWUtils.h"
@interface CWAudioRootView ()<CWSingleAudioViewDelegate,CWMultiAudioViewDelegate,CWApplyJoinViewDelegate>

/**
 小窗口背景
 */
@property (nonatomic, strong) UIImageView *smallBackGroundView;

/**
 通话时间
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 * 手势拖动悬浮窗
 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

/**
 * 点击悬浮窗
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

/**
 通话类型 单人、多人
 */
@property (nonatomic, assign) AudioType audioType;
@end

static CWAudioRootView *instance = nil;
@implementation CWAudioRootView

+ (instancetype)AudioRootView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CWAudioRootView alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setSmallView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - notify
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
//    NSLog(@"interuptionDict:%@",interuptionDict);
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
//            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable,耳机插入");
            [self.singleAudioView setHandFreeEnable:NO];
            [self.multiAudioView setHandFreeEnable:NO];
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            //NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable,耳机拔出");
            [self.singleAudioView setHandFreeEnable:YES];
            [self.multiAudioView setHandFreeEnable:YES];
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
//            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
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

- (void)click:(UITapGestureRecognizer *)tap
{   //放大窗体
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    self.smallBackGroundView.hidden = YES;
    self.singleAudioView.hidden = NO;
    self.multiAudioView.hidden = NO;
    [self removeFromSuperview];
}

#pragma mark - public methods
- (BOOL)fireAudioCall
{
    [self resetView];
    if (self.audioType == SingleAudioType) // 单人语音
    {
        if (self.cubeId) {
            BOOL ret = [[CubeEngine sharedSingleton].callService makeCallWithCallee:[CubeUser userWithCubeId:self.cubeId andDiaplayName:nil andAvatar:nil] andEnableVideo:NO];
            if (ret) {
                NSLog(@"正在呼叫%@", self.cubeId);
                
            }else {
                NSLog(@"呼叫%@失败，请稍候重试", self.cubeId);
                [CWToastUtil showTextMessage:[NSString stringWithFormat:@"呼叫失败,请稍后再试"] andDelay:1.f];
            }
            return ret;
        } else {
            NSLog(@"cubeId is nil");
        }
    }
   else
   {
//        if (self.groupId) {
//            if(self.selectMemberArray && self.selectMemberArray.count > 0)
//            {
//                BOOL ret = [[[CubeEngine sharedSingleton] getConferenceService] applyConferenceWithGroupid:self.groupId andCubeIds:@[@"201589"] andConferenceType:ConferenTypeVoiceCall andMaxMember:9 andMergeScreen:NO andExpiredTime:0 andForceCreate:YES];
//                if (ret) {
//                    
//                }
//                else {
//                    
//                }
//            }
//        }
//        else
//        {
//            NSLog(@"groupId is nil");
//        }
   }
    return NO;
}

- (void)close
{
    [self resetView];
    if (self.audioType == SingleAudioType)
    {
        [self.singleAudioView removeFromSuperview];
    }
    else if(self.audioType == GroupAudioType)
    {
        [self.multiAudioView removeFromSuperview];
    }
    else if (self.audioType == ApplyAudioType)
    {
        [self.joinView removeFromSuperview];
    }
    [self removeFromSuperview];
}

- (void)setConnectingTime:(long long)time
{
    //转换时间格式
     NSString *timeStr = @"";
    if(time < 3600){
        timeStr =  [NSString stringWithFormat:@"%02lld:%02lld",time/60,time%60];
    }else{
        timeStr = [NSString stringWithFormat:@"%02lld:%02lld:%02lld",time/3600,(time%3600)/60,(time%3600)%60];
    }
    self.timeLabel.text = timeStr;
    self.singleAudioView.connectingTime = timeStr;
    self.multiAudioView.connectingTime = timeStr;
}

- (void)setAudioType:(AudioType)type
{
    _audioType = type;
}

- (void)showView
{
    [self.singleAudioView removeFromSuperview];
    [self.multiAudioView removeFromSuperview];
    [self.joinView removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.audioType == SingleAudioType)
    {
        self.singleAudioView.peerCubeId = self.cubeId;
        [window addSubview:self.singleAudioView];
    }
    else if(self.audioType == GroupAudioType)
    {
        self.multiAudioView.conference = self.conference;
        [window addSubview:self.multiAudioView];
    }
    else if(self.audioType == ApplyAudioType)
    {
        [window addSubview:self.joinView];
    }
}

- (void)setShowStyle:(AVShowViewStyle)style
{
     if (self.audioType == SingleAudioType)
    {
        [self.singleAudioView setSingleAudioShowStyle:style];
    }
    else if(self.audioType == GroupAudioType)
    {
        [self.multiAudioView setMultiAudioShowStyle:style];
    }
}

- (void)setHandFreeEnable:(BOOL)enable
{
    [self.singleAudioView setHandFreeEnable:enable];
    [self.multiAudioView setHandFreeEnable:enable];
}

//- (void)setConference:(Conference *)conference
//{
//    _conference = conference;
//    self.multiAudioView.conference = conference;
//    self.joinView.conference = conference;
//}
//
//- (void)updateConference:(Conference *)conference andfailureList:(NSArray *)failureList
//{
//    self.conference = conference;;
//    [self.multiAudioView updateCollectView];
//    [self.joinView updateCollectView];
//}

- (void)joinInConference
{
    [self joinInAudio];
}

-(void)updateConferenceNetWork:(CWNetworkUpdateType)type
{
    [self.multiAudioView updateConferenceNetWork:type];
}

#pragma mark -
- (void)setSmallView
{
    self.smallBackGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    self.smallBackGroundView.image = [CWResourceUtil imageNamed:@"img_groupav_bubble_calling.png"];
    [self addSubview:self.smallBackGroundView];
    self.smallBackGroundView.hidden = YES;
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,40, 65, 14)];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [CWColorUtil colorWithRGB:0xffffff andAlpha:1];
    [self.smallBackGroundView addSubview:self.timeLabel];
    //添加手势
    [self addGestureRecognizer:self.panGesture];
    [self addGestureRecognizer:self.tapGesture];
}

- (void)resetView
{
    self.smallBackGroundView.hidden = YES;
    self.singleAudioView.hidden = NO;
    self.multiAudioView.hidden = NO;
}


#pragma mark - CWMultiAudioViewDelegate
-(void)ZoomOutWindow
{
    self.frame = CGRectMake(UIScreenWidth-80, 20, 80, 80);
    self.smallBackGroundView.hidden = NO;
    self.singleAudioView.hidden = YES;
    self.multiAudioView.hidden = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
#pragma mark - CWApplyJoinViewDelegate
- (void)joinInAudio
{
    //申请加入
#warning ZD for test 201489
//    CWUserModel *mineUserModel = [[CWUserModelManager defaultManager] userIsSelf];
//    if (_conference.memberSize >= 9) {
//        [CWToastUtil showTextMessage:@"人数已达9人上限，请稍后加入" andDelay:1.f];
//    }else{
//        BOOL result = NO;
//        BOOL videoEnable = _conference.type == ConferenTypeVideoCall;
//        if([_conference.members objectForKey:@"201489"])
//        {
//            result = [[[CubeEngine sharedSingleton] getConferenceService] joinConference:_conference.conferenceId withVideoEnable:videoEnable];
//        }
//        else
//        {
//            result = [[[CubeEngine sharedSingleton] getConferenceService] applyJoinConference:_conference.conferenceId withVideoEnable:videoEnable];
//        };
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (result) {
//                [CWUtils showLoadingHud];
//            }
//            else
//            {
//                [CWToastUtil showTextMessage:@"申请加入通话失败" andDelay:1.f];
//            }
//        });
//    }

}
- (void)back
{
    [self.joinView removeFromSuperview];
}
#pragma mark - getters
- (CWSingleAudioView *)singleAudioView
{
    if(!_singleAudioView)
    {
        _singleAudioView = [[CWSingleAudioView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        _singleAudioView.delegate = self;
    }
    return _singleAudioView;
}

- (CWMultiAudioView *)multiAudioView
{
    if(!_multiAudioView)
    {
        _multiAudioView = [[CWMultiAudioView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight) withAudioShowStyle:CallInStyle];
        _multiAudioView.delegate = self;
    }
    return _multiAudioView;
}

- (CWApplyJoinView *)joinView
{
    if (!_joinView)
    {
        _joinView = [[CWApplyJoinView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        _joinView.delegate = self;
    }
    return _joinView;
}
@end
