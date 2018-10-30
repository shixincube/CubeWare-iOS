//
//  CWWhiteBoardDelegate.h
//  CubeWare
//
//  Created by Ashine on 2018/9/13.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

@protocol CWWhiteBoardServiceDelegate <NSObject>
@optional

/**
 白板创建成功回调

 @param whiteBoard 白板
 @param fromUser 发起者
 */
- (void)whiteBoardCreate:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser andView:(UIView *)view;

/**
 白板退出成功回调

 @param whiteBoard 白板
 @param quitMember 退出者
 */
- (void)whiteBoardQuit:(CubeWhiteBoard *)whiteBoard quitMember:(CubeUser *)quitMember;

/**
 白板销毁成功回调

 @param whiteBoard 白板
 @param fromUser 发起者
 */
- (void)whiteBoardDestroy:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser;

/**
 白板邀请成功回调

 @param whiteBoard 白板
 @param fromUser 发起邀请者
 @param invites 邀请成员列表
 */
- (void)whiteBoardInvite:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser invites:(NSArray<CubeGroupMember *> *)invites;

/**
 白板接受邀请成功回调

 @param whiteBoard 白板
 @param fromUser 邀请发起者
 @param joinedMember 接受加入者
 */
- (void)whiteBoardAcceptInvite:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser joinedMember:(CubeUser *)joinedMember;

/**
 白板拒绝邀请成功回调

 @param whiteBoard 白板
 @param fromUser 邀请发起者
 @param rejectMember 拒绝加入者
 */
- (void)whiteBoardRejectInvite:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser rejectMember:(CubeUser *)rejectMember;

/**
 白板加入成功回调

 @param whiteBoard 白板
 @param joinedMember 加入成功者
 */
- (void)whiteBoardJoin:(CubeWhiteBoard *)whiteBoard joinedMember:(CubeUser *)joinedMember andView:(UIView *)view;

/**
 白板错误回调

 @param whiteBoard 白板
 @param error 错误对象(含错误描述及错误码)
 */
- (void)whiteBoardFailed:(CubeWhiteBoard *)whiteBoard error:(CubeError *)error;



@end
