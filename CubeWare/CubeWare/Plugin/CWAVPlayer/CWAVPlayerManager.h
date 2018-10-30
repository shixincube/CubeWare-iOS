//
//  CWAVPlayerManager.h
//  SPCubeWareDev
//
//  Created by 陆川 on 2018/4/2.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CWAVPlayerManagerDelegate<NSObject>

@optional
/**
 已经开始播放

 @param identifier identifier
 */
- (void)playAudioHDidStart:(NSString *)identifier;
/**
 播放结束

 @param identifier identifier
 */
- (void)playAudioDidEnd:(NSString *)identifier;
/**
 播放失败

 @param identerifer identifier
 @param error error
 */
- (void)playAudioFail:(NSString *)identerifer error:(NSError *)error;
@end
@interface CWAVPlayerManager : NSObject


+ (instancetype)shareInstance;

- (BOOL)isPlayingWithIdentifier:(NSString *)identifier;
/**
 播放音频

 @param filePath 文件路径
 @param identifier identifier
 */
- (void)playAudioWithFilePath:(NSString *)filePath identifier:(NSString *)identifier delegate:(id<CWAVPlayerManagerDelegate>) delegate;
/**
 停止播放
 */
- (void)stopPlay;

- (void)setDelegate:(id<CWAVPlayerManagerDelegate>) delegate identifier:(NSString *)identifier;
@end
