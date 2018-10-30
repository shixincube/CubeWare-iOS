//
//  CDConnectedView.h
//  CubeEngineDemo
//  接通中画面
//  Created by pretty on 2018/9/6.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDConnectedView;

@protocol CDConnectedViewDelegate<NSObject>

/**
 点击选择邀请更多成员按钮

 @param view 通话界面
 */
- (void)onClickAddMoreMembers:(CDConnectedView *)view;

@end


@interface CDConnectedView : UIView

/**
 显示类型
 */
@property (nonatomic,strong) NSString *groupType;

/**
 展示View
 */
@property (nonatomic,strong) UIView *showView;


///**
// 屏幕共享
// */
//@property (nonatomic,strong) CubeShareDesktop *shareDesktop;

/**
 会议
 */
@property (nonatomic,strong) CubeConference *conference;

/**
 白板
 */
@property (nonatomic,strong) CubeWhiteBoard *whiteBoard;


/**
 一对一通话
 */
@property (nonatomic,strong) CubeCallSession *callSession;

/**
 代理
 */
@property (nonatomic,weak) id <CDConnectedViewDelegate> delegate;

/**
 显示接通中画面
 */
- (void)show;


/**
 移除画面(并复位设置的数据源)
 */
- (void)remove;


/**
 通话界面单例获取

 @return 界面单例
 */
+(instancetype)shareInstance;


@end
