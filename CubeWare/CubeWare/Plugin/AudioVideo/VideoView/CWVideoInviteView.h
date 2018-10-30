//
//  CWVideoInviteView.h
//  CubeWare
//  视频邀请view
//  Created by 美少女 on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWAudioVideoPrerequisites.h"
@protocol CWVideoInviteViewDelegate<NSObject>
@optional
/**
 缩小窗口
 */
- (void)zoomOutWindow;
@end


@interface CWVideoInviteView : UIView

@property (nonatomic, strong) NSString *peerCubeId;

/**
 CWVideoInviteViewDelegate 代理
 */
@property (nonatomic, weak) id<CWVideoInviteViewDelegate> delegate;
/**
 设置显示样式

 @param style 显示样式
 */
- (void)setShowStyle:(AVShowViewStyle)style;


@end
