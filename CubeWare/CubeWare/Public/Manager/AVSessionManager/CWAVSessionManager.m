//
//  CWAVSessionManager.m
//  SPCubeWareDev
//
//  Created by 陆川 on 2018/4/16.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import "CWAVSessionManager.h"
#import <AVFoundation/AVFoundation.h>
static CWAVSessionManager * avSessionManager = nil;
@interface CWAVSessionManager ()
@property (nonatomic, assign) BOOL handSpeakUsing;// 插入耳机后不可改变输出模式，即： openSpeaker 设置无效
@end
@implementation CWAVSessionManager
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avSessionManager = [[super allocWithZone:nil] init];
        [avSessionManager config];
        [[NSNotificationCenter defaultCenter] addObserver:avSessionManager selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];
    });
    return avSessionManager;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)openSpeaker:(BOOL)open{
    if([self areHeadphonesPluggedIn])return;// 正在使用耳机，不可以切换
    NSError *error = nil;
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:(open ? AVAudioSessionPortOverrideSpeaker : AVAudioSessionPortOverrideNone) error:&error];
    NSLog(@"switch avsession output %@",error);
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

#pragma mark - notif
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
        NSLog(@"interuptionDict:%@",interuptionDict);
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
        {
            _handSpeakUsing = YES;
            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable,耳机插入");
            if(_delegate && [_delegate respondsToSelector:@selector(avSessionManagerHandSpeakInput:)]){
                [_delegate avSessionManagerHandSpeakInput:YES];
            }
            
            
        }
            
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            _handSpeakUsing =NO;
            NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable,耳机拔出");
            if(_delegate && [_delegate respondsToSelector:@selector(avSessionManagerHandSpeakInput:)]){
                [_delegate avSessionManagerHandSpeakInput:NO];
            }
        }
            
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            //            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
        default:
            break;
    }
}

- (void)config{
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    
                    setCategory: AVAudioSessionCategoryPlayAndRecord
                    
                    error: &setCategoryError];
    if (!success) {
    }
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL ret = [audioSession setActive:YES error:&error];
    if (!ret)
    {
        NSLog(@"%s - activate audio session failed with error %@", __func__,[error description]);
        
    }
}
@end
