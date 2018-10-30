//
//  CWAudioMessageCell.h
//  CubeWare
//
//  Created by jianchengpan on 2018/1/3.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWMessageCell.h"

@interface CWAudioMessageCell : CWMessageCell

/**语音时长*/
@property (nonatomic, assign) int duration;
/**是否已读*/
@property (nonatomic, assign) BOOL isRead;

/**
 播放音频
 */
- (void)startPlayAudio;
/**
 停止播放
 */
- (void)stopPlayAudio;

@end
