//
//  CWHistoryNoticeView.h
//  CubeWare
//
//  Created by jianchengpan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CubeWareHeader.h"
/**
 历史消息提示视图
 */
@interface CWHistoryNoticeView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *upArrowImageView;

@property (nonatomic, strong) CubeMessageEntity *oldestUnreadMessage;

@property (nonatomic, copy) void (^didClickedHandler)(CubeMessageEntity *oldestUnreadMessage);

/**
 创建视图，并添加约束
 */
-(void)initView;

/**
 显示视图

 @param containerView 容器视图
 @param topOffset 到容器视图顶端的距离
 @param time 动画时间
 */
-(void)showInView:(UIView *)containerView withTopOffset:(CGFloat)topOffset andAnimationTime:(float)time;


/**
 隐藏视图,动画完成后从父视图移除
 
 @param time 动画时间
 */
-(void)dismissWithAnimationTime:(float)time;

@end
