//
//  CWCallService.m
//  CubeWare
//
//  Created by 美少女 on 2017/12/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWCallService.h"
#import "CWAudioRootView.h"
#import "CWVideoRootView.h"
#import "CWMessageRinging.h"
#import "CWToastUtil.h"
#import "CWUtils.h"
#import "CWMessageUtil.h"
@interface CWCallService () 
/**
 通话时长定时器
 */
@property (nonatomic , strong) NSTimer *callTimer;

/**
 通话时间
 */
@property (nonatomic , assign) long long timeCount;
@end

@implementation CWCallService

- (id)init
{
    self = [super init];
    if (self)
    {
        [[CWMessageRinging sharedSingleton] configCallPlayer];
        [[CWMessageRinging sharedSingleton] configRingBackPlayer];
        [[CWMessageRinging sharedSingleton] configNetConnectedPlayer];
    }
    return self;
}

#pragma mark - public
-(void)makeCallWithCallee:(NSString *)cubeId andEnableVideo:(BOOL)enableVideo{
    [[CubeEngine sharedSingleton].callService makeCallWithCallee:[CubeUser userWithCubeId:cubeId andDiaplayName:@"" andAvatar:@""] andEnableVideo:enableVideo];
}

-(void)terminalCall:(NSString *)cubeId{
    [[CubeEngine sharedSingleton].callService terminateCall:cubeId];
}

-(void)answerCall:(NSString *)cubeId{
    [[CubeEngine sharedSingleton].callService answerCallWith:cubeId];
}


#pragma mark - CubeCallServiceDelegate

-(void)onNewCall:(CubeCallSession *)session from:(CubeUser *)from{
    
    for (id<CWCallServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWCallServiceDelegate)]) {
        if([obj respondsToSelector:@selector(newCall:from:)])
        {
            [obj newCall:session from:from];
        }
    }
    
    return;
}


-(void)onCallConnected:(CubeCallSession *)session from:(CubeUser *)from{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self beginTimer];
        UIView *view ;
        if (session.videoEnabled) {
             view = [[CubeEngine sharedSingleton].mediaService getRemoteViewForTarget:session.callee.cubeId];
        }
        else{
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth * 9/16)];
            UILabel *showLable = [[UILabel alloc] init];
            showLable.text = @"正在进行语音通话...";
            showLable.textColor = [UIColor whiteColor];
            [view addSubview:showLable];
            showLable.textAlignment = NSTextAlignmentCenter;
            [showLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(view);
                make.size.mas_equalTo(CGSizeMake(UIScreenWidth, 30));
            }];
        }
        CGRect frame = CGRectMake(0, 0, UIScreenWidth, UIScreenWidth * 9/16);
        view.frame = frame;
        
        for (id<CWCallServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWCallServiceDelegate)]) {
            if([obj respondsToSelector:@selector(callConnected:from:andView:)])
            {
                [obj callConnected:session from:from andView:view];
            }
        }
    });
    
    return;
}

-(void)onCallEnded:(CubeCallSession *)session from:(CubeUser *)from{
     [self stopTimer];
    for (id<CWCallServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWCallServiceDelegate)]) {
        if([obj respondsToSelector:@selector(callEnded:from:)])
        {
            [obj callEnded:session from:from];
        }
    }
//    NSLog(@"onCallEnded");
    [self sendCustomMsgWithSessionInCallEnd:session andError:nil];
    return;
}

-(void)onCallFailed:(CubeCallSession *)session error:(CubeError *)error from:(CubeUser *)from{
    [self stopTimer];
    for (id<CWCallServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWCallServiceDelegate)]) {
        if([obj respondsToSelector:@selector(callFailed:error:from:)])
        {
            [obj callFailed:session error:error from:from];
        }
    }
//     NSLog(@"onCallFailed");
    [self sendCustomMsgWithSessionInCallEnd:session andError:error];
    return;
}

- (void)onCallRinging:(CubeCallSession *)session from:(CubeUser *)from{
    for (id<CWCallServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWCallServiceDelegate)]) {
        if([obj respondsToSelector:@selector(callRing:from:)])
        {
            [obj callRing:session from:from];
        }
    }
    return;
}

#pragma mark - privite methods
- (void)sendCustomMsgWithSessionInCallEnd:(CubeCallSession *)session andError:(CubeError *)error{
    NSString *action = session.CallAction;
    BOOL isVideo = session.videoEnabled;
    NSString *content;
    NSString *duration = [CWUtils convertToTime:self.timeCount];
    if(error)
    {
        if (error.errorCode == CubeErrorTypeCallCalleeIsCalling) {
            content = @"对方正在忙，请稍后再试";
        }
        else if (error.errorCode == CubeErrorTypeCallIngOnOtherDevice)
        {
            content = @"正在其他终端通话中 不能发起通话";
        }
    }
    else
    {
        if (session.callDirection == CubeCallDirectionOutgoing)
        {
            //呼出
            if ([action isEqualToString:CubeCallAction_CANCEL])
            {
                content = @"对方已取消";
            }
            else if ([action isEqualToString:CubeCallAction_CANCEL_ACK])
            {
                content = @"已取消";
            }
            else if ([action isEqualToString:CubeCallAction_BYE]||[action isEqualToString:CubeCallAction_BYE_ACK])
            {
                content = [NSString stringWithFormat:@"通话已结束%@", duration];
            }
            else{
                content = isVideo ? @"视频通话" : @"语音通话";
            }
        }
        else if (session.callDirection == CubeCallDirectionIncoming)
        {
            if ([action isEqualToString:CubeCallAction_CANCEL])
            {
                content = isVideo ? @"视频通话未接听，点击回拨" : @"语音通话未接听，点击回拨";
            }
            else if ([action isEqualToString:CubeCallAction_CANCEL_ACK])
            {
                content = @"已取消";
            }
            else if ([action isEqualToString:CubeCallAction_BYE]||[action isEqualToString:CubeCallAction_BYE_ACK])
            {
                content = [NSString stringWithFormat:@"通话已结束%@",duration];
            }
            else if ([action isEqualToString:CubeCallAction_ANSWER_BY_OTHER])
            {
                content = @"已在其他终端接听";
            }
            else
            {
                content = isVideo ? @"视频通话" : @"语音通话";
            }
        }
    }
    //发送
    CubeCustomMessage *customMessage = [CWMessageUtil customAVMessageWithSession:session andText:content andIsVideo:isVideo];
    customMessage.status = CubeMessageStatusSucceed;
    [[CubeWare sharedSingleton].messageService processMessagesInSameSession:@[customMessage]];
}

- (BOOL)areHeadphonesPluggedIn {
    NSArray *availableOutputs = [[AVAudioSession sharedInstance] currentRoute].outputs;
    for (AVAudioSessionPortDescription *portDescription in availableOutputs) {
        if ([portDescription.portType isEqualToString:AVAudioSessionPortHeadphones]) {
            return YES;
        }
    }
    return NO;
}

- (void)configureAVAudioSession
{
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    BOOL headphoneEnable = [self areHeadphonesPluggedIn];
    if (headphoneEnable) {
        [[CWVideoRootView VideoRootView]setHandFreeEnable:NO];
        [[CWAudioRootView AudioRootView] setHandFreeEnable:NO];
    } else {
        [[CWVideoRootView VideoRootView]setHandFreeEnable:YES];
        [[CWAudioRootView AudioRootView] setHandFreeEnable:YES];
    }

    NSString* category = [AVAudioSession sharedInstance].category;
    AVAudioSessionCategoryOptions options = [AVAudioSession sharedInstance].categoryOptions;
    // Respect old category options if category is
    // AVAudioSessionCategoryPlayAndRecord. Otherwise reset it since old options
    // might not be valid for this category.
    if ([category isEqualToString:AVAudioSessionCategoryPlayAndRecord]) {
        if (!headphoneEnable) {
            options |= AVAudioSessionCategoryOptionDefaultToSpeaker;
        } else {
            options &= ~AVAudioSessionCategoryOptionDefaultToSpeaker;
        }
    } else {
        options = AVAudioSessionCategoryOptionDefaultToSpeaker;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}

- (void)beginTimer
{
    //开启一个通话计时器
    if (self.callTimer) {
        [self.callTimer invalidate];
        self.callTimer = nil;
    }
    self.callTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(openCallingTimer:) userInfo:nil repeats:YES];
    self.timeCount = 0;
}

//通话中计时器
- (void)openCallingTimer:(NSTimer *)timer{
    self.timeCount ++;
//    if(self.talkDuration < 3600){
//        [CWVideoAndAudioManager sharedSingleton].talkDurationStr = [NSString stringWithFormat:@"%02lld:%02lld",self.talkDuration/60,self.talkDuration%60];
//    }else{
//        [CWVideoAndAudioManager sharedSingleton].talkDurationStr = [NSString stringWithFormat:@"%02lld:%02lld:%02lld",self.talkDuration/3600,(self.talkDuration%3600)/60,(self.talkDuration%3600)%60];
//    }
//    [CWVideoAndAudioManager sharedSingleton].voiceVideoWindow.videoView.timerLabel.text = [CWVideoAndAudioManager sharedSingleton].talkDurationStr;
//    [CWVideoAndAudioManager sharedSingleton].voiceVideoWindow.audioView.timerLabel.text = [CWVideoAndAudioManager sharedSingleton].talkDurationStr;
//    [CWVideoAndAudioManager sharedSingleton].voiceVideoWindow.voiceTimeLabel.text = [CWVideoAndAudioManager sharedSingleton].talkDurationStr;
}

- (void)stopTimer
{
    //释放计时器
    if (self.callTimer) {
        [self.callTimer invalidate];
        self.callTimer = nil;
    }
}
@end
