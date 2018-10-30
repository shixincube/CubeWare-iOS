//
//  CWMediaService.m
//  CubeWare
//
//  Created by 美少女 on 2018/1/11.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWMediaService.h"
@implementation CWMediaService
-(instancetype)init{
    if(self = [super init])
    {
#warning update to Engine 3.0
//        [CubeEngine sharedSingleton].mediaService.playDelegate = self;
//        [CubeEngine sharedSingleton].mediaService.recordDelegate = self;
    }
    return self;
}

-(void)setMediaServiceDelegate:(id<CWMediaServiceDelegate>)mediaServiceDelegate{
    _mediaServiceDelegate = mediaServiceDelegate;
#warning update to Engine 3.0
//    [CubeEngine sharedSingleton].mediaService.playDelegate = self;
//    [CubeEngine sharedSingleton].mediaService.recordDelegate = self;
}

#warning update to Engine 3.0
#pragma mark - CubePlayDelegate
//语音播放开始
//- (void)onPlayStarted:(CubeRecordType)type{
////    _isPlaying = YES;
//}
////语音播放完成
//- (void)onPlayStoped:(CubeRecordType)type{
//    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
////    _isPlaying = NO;
//}
//
//#pragma mark - CubeRecordDelegate
//- (void)onRecordStarted:(CubeRecordType)type
//{
//    if (type == VideoRecord) {
//        NSDictionary *userInfo = @{@"type" : [NSNumber numberWithInteger:type]};
//        if(self.mediaServiceDelegate && [self.mediaServiceDelegate respondsToSelector:@selector(onRecordVideoStart:)])
//        {
//            [self.mediaServiceDelegate onRecordVideoStart:userInfo];
//        }
//    }
//    else
//    {
//
//    }
//}
//
//- (void)onRecordStoped:(CubeRecordType)type
//{
//    if (type == VideoRecord) {
//        NSDictionary *userInfo = @{@"type" : [NSNumber numberWithInteger:type]};
//        if (self.mediaServiceDelegate && [self.mediaServiceDelegate respondsToSelector:@selector(onRecordVideoStop:)])
//        {
//            [self.mediaServiceDelegate onRecordVideoStop:userInfo];
//        }
//    }
//    else
//    {
//
//    }
//}
//- (void)onReadyForDisplay:(CubeRecordType)type
//{
//
//    if (type == VideoRecord)
//    {
//        NSDictionary *userInfo = @{@"type" : [NSNumber numberWithInteger:type]};
//        if (self.mediaServiceDelegate && [self.mediaServiceDelegate respondsToSelector:@selector(onRecordReadyForDisplay:)])
//        {
//            [self.mediaServiceDelegate onRecordReadyForDisplay:userInfo];
//        }
//    }
//    else
//    {
//
//    }
//}
//
//- (void)onRecordFailed:(CubeRecordType)type error:(CubeErrorInfo *)error
//{
//    if (type == VideoRecord) {
//        NSDictionary *userInfo = @{@"type" : [NSNumber numberWithInteger:type],
//                                   @"state" : [NSNumber numberWithInteger:error.code],
//                                   @"descString" : error.description };
//        if (self.mediaServiceDelegate && [self.mediaServiceDelegate respondsToSelector:@selector(onRecordVideoFailed:)])
//        {
//            [self.mediaServiceDelegate onRecordVideoFailed:userInfo];
//        }
//    }
//    else
//    {
//
//    }
//}
@end
