//
//  CWMessageRinging.m
//  CubeWare
//
//  Created by Mario on 17/3/21.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CWMessageRinging.h"
#import "CWResourceUtil.h"
#import "CubeWareHeader.h"
@interface CWMessageRinging () <AVAudioPlayerDelegate> {
    AVAudioPlayer *_callPlayer;
    AVAudioPlayer *_ringBackPlayer;
    AVAudioPlayer *_messageReceivedPlayer;
    AVAudioPlayer *_netConnectedPlayer;
}
@end

@implementation CWMessageRinging

static CWMessageRinging *instance = nil;

+(CWMessageRinging *)sharedSingleton{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CWMessageRinging alloc] init];
    });
    return instance;
}

- (void)stopCallSound{
    if (_callPlayer){
        if ([_callPlayer isPlaying])
        {
            [_callPlayer stop];
            _callPlayer.currentTime = 0;
        }
    }
}

-(void)playCallSound{
    if (![_callPlayer isPlaying])
    {
        [_callPlayer play];
    }
}

- (void)configCallPlayer{
    NSError* err;
  
    NSURL *url = [CWResourceUtil audioResourceUrl:@"ring_tone" andType:@"wav"];
    _callPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    _callPlayer.numberOfLoops = -1;
    _callPlayer.volume = 1.0;
    _callPlayer.delegate = self;
}

- (void)stopRingBackSound{
    if (_ringBackPlayer){
        if ([_ringBackPlayer isPlaying])
        {
            [_ringBackPlayer stop];
            _ringBackPlayer.currentTime = 0;
        }
    }
}

-(void)playRingBackSound{
    if (![_ringBackPlayer isPlaying])
    {
        [_ringBackPlayer play];
    }
}

- (void)configRingBackPlayer{
    NSError *error;
 
    NSURL *url = [CWResourceUtil audioResourceUrl:@"ringbakc_tone" andType:@"wav"];
    _ringBackPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _ringBackPlayer.numberOfLoops = -1;
    _ringBackPlayer.volume = 1;
    _ringBackPlayer.delegate = self;
}

-(void)configMessageReceivedPlayer
{
    NSError* err;

    NSURL *url =  [CWResourceUtil audioResourceUrl:@"receivemessage" andType:@"wav"];;
    _messageReceivedPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    _messageReceivedPlayer.numberOfLoops = -1;
    _messageReceivedPlayer.volume = 1.0;
    _messageReceivedPlayer.delegate = self;
}

-(void)configNetConnectedPlayer{
    NSError* err;

    NSURL *url =  [CWResourceUtil audioResourceUrl:@"net_connected_ringing" andType:@"mp3"];
    _netConnectedPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    _netConnectedPlayer.numberOfLoops = 0;
    _netConnectedPlayer.volume = 0.5;
    _netConnectedPlayer.delegate = self;
}

-(void)playMessageSound
{
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
//    if ([[CubeEngine sharedSingleton].mediaService isCalling]){
//        NSLog(@"通话中，不播放消息提示音");
//    }else{
//        [self stopMessageSound];
//        [_messageReceivedPlayer play];
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//
//        NSURL *url =  [CWResourceUtil audioResourceUrl:@"message_tone"andType:@"wav"];;
//        SystemSoundID soundID;
//        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&soundID);
//        AudioServicesPlaySystemSound(soundID);
//    }
}

- (void)playNetConnectedSound{
    [_netConnectedPlayer play];
}

- (void)stopMessageSound
{
    if (!_messageReceivedPlayer)
        return;
    
    if ([_messageReceivedPlayer isPlaying])
    {
        [_messageReceivedPlayer stop];
        _messageReceivedPlayer.currentTime = 0;
    }
}

- (void)stopConnectedSound{
    if (_netConnectedPlayer){
        if ([_netConnectedPlayer isPlaying])
        {
            [_netConnectedPlayer stop];
            _netConnectedPlayer.currentTime = 0;
        }
    }
}

- (void)shake{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"播放完成");
    //[self stopMessageSound];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    NSLog(@"%@",error);
}

@end
