//
//  CWVideoView.h
//  CubeWare
//  视频通话
//  Created by 美少女 on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWAudioVideoPrerequisites.h"
@protocol CWVideoViewDelegate<NSObject>
@optional
/**
 缩小窗口
 */
- (void)zoomOutWindow;

/**
 切换到语音
 */
- (void)changeToVoice;
@end
@interface CWVideoView : UIView

@property (nonatomic, strong) NSString *peerCubeId;

/**
 CWVideoViewDelegate 代理
 */
@property (nonatomic, weak) id<CWVideoViewDelegate> delegate;

/**
 己方视频画面
 */
@property (nonatomic,strong) UIView *localVideoImageView;

/**
 对方视频画面
 */
@property (nonatomic,strong) UIView *remoteVideoImgView;

/**
 设置连接时间
 */
@property (nonatomic, strong) NSString *connectingTime;

/**
 设置免提是否可用

 @param enable 可用状态
 */
- (void)setHandFreeEnable:(BOOL)enable;

/**
 将要显示视频画面
 */
- (void)willShow;

@end
