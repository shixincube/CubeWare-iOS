//
//  CWPlayerView.h
//  CubeWare
//
//  Created by Mario on 17/4/14.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@protocol CWVideoPlayerCloseProtocal <NSObject>

- (void)closeVideoPlayer;

@end

@interface CWPlayerView : UIView

/**
 *  初始化
 */
//-(instancetype)initWithFrame:(CGRect)frame rect:(CGRect)viewRect messageModel:(CWVideoContentModel *)model;

@property (nonatomic, weak) id <CWVideoPlayerCloseProtocal> delegate;

/**
 *  AVPlayer播放器
 */
@property (nonatomic, strong) AVPlayer *player;

/**
 *  播放状态，YES为正在播放，NO为暂停
 */
@property (nonatomic, assign) BOOL isPlaying;

/**
 *  是否横屏，默认NO -> 竖屏
 */
@property (nonatomic, assign) BOOL isLandscape;

/**
 *  传入视频地址
 *
 *   string 视频url
 */
//- (void)updatePlayerWith:(NSURL *)url;

/**
 *  传入背景图(缩略图)
 *
 *   thumbPath 缩略图地址
 */
- (void)updatePlayerBackgroundViewMessageModel:(CubeVideoClipMessage *)model rect:(CGRect)viewRect;

/**
 *  传入视频信息
 *
 *   string 视频url
 */
- (void)updatePlayerProgress:(float)progress andMessageModel:(CubeVideoClipMessage *)model;

/**
 *  移除通知&KVO
 */
- (void)removeObserverAndNotification;

/**
 *  播放
 */
- (void)play;

/**
 *  暂停
 */
- (void)pause;

/**
 *在父视图显示
 */
-(void)showInSuperView:(UIView*)SuperView andSuperVC:(UIViewController*)SuperVC;

-(void)updateRevokedMessage:(NSString *)messageSN;

@end
