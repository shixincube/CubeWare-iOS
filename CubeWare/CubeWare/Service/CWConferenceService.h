//
//  CWConferenceService.h
//  CubeWare
//  会议
//  Created by 美少女 on 2018/1/4.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWConferenceDelegate.h"

@interface CWConferenceService : NSObject<CubeConferenceServiceDelegate>

#pragma mark - 远程桌面流程使用

/**
 邀请进入

 @param conference 会议
 @param invites 邀请列表
 */
- (void)inviteConference:(CubeConference *)conference  andInvites:(NSArray *)invites;
/**
 退出会议

 @param conference 会议
 */
- (void)quitConferenceService:(CubeConference *)conference;

/**
  拒绝邀请

 @param conference 会议
 @param user 发起邀请者
 */
- (void)rejectConferenceService:(CubeConference *)conference andFrom:(CubeUser *)user;

/**
接受邀请

 @param conference 会议
 @param user 发起邀请者
 */
- (void)acceptConferenceService:(CubeConference *)conference andFrom:(CubeUser *)user;

/**
 加入会议

 @param conference 会议
 */
-(void)joinConference:(CubeConference *)conference;

/**
 查询会议

 @param conferenceTypes 会议类型
 @param groupIds 群组IDs
 @param completion 成功回调
 @param failure 失败回调
 */
-(void)queryConferenceWithConferenceType:(NSArray *)conferenceTypes
                                groupIds:(NSArray *)groupIds
                              completion:(void(^)(NSArray *conferences))completion
                                 failure:(void(^)(CubeError *error))failure;

@end
