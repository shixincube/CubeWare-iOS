//
//  CWShareDesktopDelegate.h
//  CubeWare
//
//  Created by pretty on 2018/9/6.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

@protocol CWShareDesktopServiceDelegate <NSObject>

/**
 加入远程桌面

 @param shareDesktop 远程桌面
 @param view 显示View
 */
- (void)joinShareDesktop:(CubeShareDesktop *)shareDesktop andView:(UIView *)view;

/**
  邀请加入远程桌面

 @param shareDesktop 远程桌面
 @param from 邀请人
 @param invites 被邀请人列表
 */
- (void)inviteShareDesktop:(CubeShareDesktop *)shareDesktop andFrom:(CubeUser *)from andInvites:(NSArray *)invites;

/**
 拒绝邀请

 @param shareDesktop 远程桌面
 */
- (void)rejectInviteShareDesktop:(CubeShareDesktop *)shareDesktop;

/**
 退出远程桌面

 @param shareDesktop 远程桌面
 */
- (void)quitShareDesktop:(CubeShareDesktop *)shareDesktop;
/**
 远程桌面错误

 @param error 错误消息
 */
- (void)shareDesktopFail:(CubeError *)error;
@end
