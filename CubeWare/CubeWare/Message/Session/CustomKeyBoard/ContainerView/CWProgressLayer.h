//
//  CWProgressLayer.h
//  SPCubeWareDev
//
//  Created by 陆川 on 2018/4/14.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CWProgressLayer : CALayer
@property (nonatomic, assign) CGFloat progress;
/**
 圆环宽度
 */
@property (nonatomic, assign) CGFloat circleWidth;

/**
 开始动画

 @param time 动画时间
 */
- (void)starAnimation:(CGFloat)time;
/**
 停止动画
 */
- (void)stopAnimation;
/**
 暂停动画
 */
- (void)pauseAnimation;
/**
 恢复动画
 */
- (void)resumeAnimation;
@end
