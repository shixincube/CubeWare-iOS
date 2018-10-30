//
//  CDInviteView.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/6.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDInviteView : UIView

/**
 远程桌面
 */
@property (nonatomic,strong) CubeShareDesktop *shareDesktop;

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
 邀请人
 */
@property (nonatomic,strong) CubeUser *from;

/**
 被邀请人列表
 */
@property (nonatomic,strong) NSArray *invites;

- (void)showView;
@end
