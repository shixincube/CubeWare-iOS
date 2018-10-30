//
//  CWVideoRootView.h
//  CubeWare
//
//  Created by 美少女 on 2018/1/4.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWVideoView.h"
#import "CWVideoInviteView.h"

@interface CWVideoRootView : UIView

/**
 单例方法

 @return 视频View
 */
+ (CWVideoRootView *)VideoRootView;

/**
 对方的cubeId
 */
@property (nonatomic, strong) NSString *cubeId;

/**
 显示弹窗
 */
- (void)showView;

/**
 关闭弹窗
 */
- (void)close;

/**
 设置显示样式

 @param style 显示样式 （CallInStyle呼入，CallOutStyle呼出，ConnectingStyle连接中）
 */
- (void)setShowStyle:(AVShowViewStyle)style;

/**
 设置免提按钮状态是否可用

 @param enable 可用状态
 */
- (void)setHandFreeEnable:(BOOL)enable;

/**
 发起视频会话
 */
- (BOOL)fireVideoCall;

/**
 设置视频画面

 @param localImageView 我方视频画面
 @param remoteImageView 对方视频画面
 */
- (void)setLocalImageView:(UIView *)localImageView withRemoteImageView:(UIView *)remoteImageView;

/**
 变为音频通话
 */
- (void)changeToAudio;
@end
