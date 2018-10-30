//
//  CWAudioView.h
//  CubeWare
//  一对一音频通话View
//  Created by 美少女 on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWAudioVideoPrerequisites.h"


@protocol CWSingleAudioViewDelegate<NSObject>
@optional

/**
 缩小窗体
 */
- (void)ZoomOutWindow;

@end

@interface CWSingleAudioView : UIView

/**
 对方的cubeID
 */
@property (nonatomic, strong) NSString *peerCubeId;

/**
 设置连接时间
 */
@property (nonatomic, strong) NSString *connectingTime;
/**
 初始化方法
 
 @param frame 窗体大小
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 代理
 */
@property (nonatomic, weak) id<CWSingleAudioViewDelegate> delegate;

/**
 设置当前页面展示样式

 @param style 样式
 */
- (void)setSingleAudioShowStyle:(AVShowViewStyle)style;

/**
 设置免提按钮是否可用

 @param enable 可用状态
 */
- (void)setHandFreeEnable:(BOOL)enable;
@end
