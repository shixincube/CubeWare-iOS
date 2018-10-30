//
//  CWConferenceDelegate.h
//  CubeWare
//
//  Created by pretty on 2018/9/7.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//


@protocol CWConferenceServiceDelegate <NSObject>
@optional
#pragma mark - 以下回调为远程桌面流程使用
/**
 创建会议
 
 @param conference 会议
 @param user 创建会议发起者
 */
- (void)createConference:(CubeConference *)conference byUser:(CubeUser *)user;

/**
 已连接会议

 @param conference 会议
 @param view 展示View
 */
- (void)connectedConference:(CubeConference *)conference andView:(UIView *)view;

/**
 邀请加入

 @param conference 会议
 @param from 邀请者
 @param invites 邀请列表
 */
- (void)inviteConference:(CubeConference *)conference andFrom:(CubeUser *)from andInvites:(NSArray *)invites;

/**
 加入会议

 @param conference 会议
 @param joiner 加入者
 */
- (void)joinConference:(CubeConference *)conference andJoin:(CubeUser *)joiner;


/**
 拒绝邀请

 @param conference 会议
 @param inviterUser 邀请者
 @param rejectUser 拒绝者
 */
- (void)rejectInviteConference:(CubeConference *)conference fromUser:(CubeUser *)inviterUser byUser:(CubeUser *)rejectUser;

/**
 接受邀请

 @param conference 会议
 @param inviterUser 邀请者
 @param accpetUser 接受者
 */
- (void)acceptInviteConference:(CubeConference *)conference fromUser:(CubeUser *)inviterUser byUser:(CubeUser *)accpetUser;

/**
 更新会议

 @param conference 会议
 */
- (void)updateConference:(CubeConference *)conference;
/**
 退出

 @param conference 会议
 */
- (void)quitConference:(CubeConference *)conference andQuitMember:(CubeUser *)quiter;

/**
 销毁

 @param conference 会议
 */
- (void)destroyConference:(CubeConference *)conference byUser:(CubeUser *)user;

/**
 会议错误

 @param error 错误信息
 */
- (void)conferenceFail:(CubeConference *)conference andError:(CubeError *)error;


@end
