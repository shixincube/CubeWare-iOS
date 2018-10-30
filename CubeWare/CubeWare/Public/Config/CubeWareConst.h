//
//  CubeWareConst.h
//  CubeWare
//
//  Created by zhuguoqiang on 17/2/23.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#ifndef CubeWareConst_h
#define CubeWareConst_h

/**
 * CubeWare中用到的const
 */

// 标准系统状态栏高度
static NSInteger const CWSYSStatusBarHeight = 20;
// 热点栏高度
static NSInteger const CWHotspotStatusBarHeight = 20;
// 导航栏（UINavigationController.UINavigationBar）高度
static NSInteger const CWavigationBarHeight = 44;
// 工具栏（UINavigationController.UIToolbar）高度
static NSInteger const CWToolBarHeight = 44;
// 标签栏（UITabBarController.UITabBar）高度
static NSInteger const CWTabBarHeight = 49;

#pragma mark - CubeWare
static NSString *const kCWKitInfoKey                                    = @"CubeWareKitInfoKey";

#pragma mark - Message && Session
static NSString *const kCWMessageEntity                                 = @"CubeWareMessageEntity";
static NSString *const kCWMessageEntities                               = @"CubeWareMessageEntities";
static NSString *const kCWSessionAndMessageSaveNotification             = @"CubeWareSessionAndMessageSaveNotification";
static NSString *const kCWTouch3DTouchNotification                      = @"CubeWareTouch3DTouchNotification";
static NSString *const kCWTouch3DTouchCreateGroup                       = @"CubeWareTouch3DTouchCreateGroup";
static NSString *const kCWTouch3DTouchAddFriend                         = @"CubeWareTouch3DTouchAddFriend  ";
static NSString *const kCWTouch3DTouchScanQr                            = @"CubeWareTouch3DTouchScanQr ";

#pragma mark - User
static NSString *const kCWUserInfoHasUpdatedNotification                = @"CubeWareUserInfoHasUpdatedNotification";

#pragma mark - Group
static NSString *const kCWGroupInfoHasUpdatedNotification               = @"CubeWareGroupInfoHasUpdatedNotification";
static NSString *const kCWGroupMembersHasUpdatedNotification            = @"CubeWareGroupMembersHasUpdatedNotification";

#pragma mark - Keyboard
static NSString *const kCWKeyboardSendActionNotification                = @"CubeWareKeyboardSendActionNotification";
static NSString *const kCWKeyboardRecordStartNotification               = @"CubeWareKeyboardRecordStartNotification";
static NSString *const kCWKeyboardRecordStopNotification                = @"CubeWareKeyboardRecordStopNotification";
static NSString *const kCWKeyboardRecordReadyForDisplay                 = @"CubeWareKeyboardRecordReadyForDisplay";
static NSString *const kCWKeyboardRecordFailedNotification              = @"CubeWareKeyboardRecordFailedNotification";

#pragma mark - Session
static NSString *const kCWSessionSaveNotification                       = @"CubeWareSessionSaveNotification";
static NSString *const kCWSyncSessionSaveNotification                   = @"CubeWareSyncSessionSaveNotification";
static NSString *const kCWDeleteSessionObjectNotification               = @"CubeWareDeleteSessionObjectNotification";
static NSString *const kCWSessionIsTopNotification                      = @"CubeWareSessionIsTopNotification";
static NSString *const kCWSessionNoReadMessageCountNotification         = @"CubeWareSessionNoReadMessageCountNotification";
static NSString *const kCWDeleteSessionsNotification                    = @"CubeWareDeleteSessionsNotification";
static NSString *const kCWHasDraftSessionsNotification                  = @"CubeWareHasDraftSessionsNotification";
static NSString *const kCWSessionsHaveGroupAVNotification               = @"CubeWareSessionsHaveGroupAVNotification";
static NSString *const kCWSessionsGroupAVHasUpdateNotification          = @"CubeWareSessionsGroupAVHasUpdateNotification";
static NSString *const kCWSessionsGroupAVHideMenuNotification           = @"CubeWareSessionsGroupAVHideMenuNotification";
static NSString *const kCWSessionSingleAVHasUpdateNofication            = @"CubeWareSessionsSingleAVHasUpdateNotification";

#pragma mark - SecretSession
static NSString *const kCWSecretSessionSaveNotification                       = @"CubeWareSecretSessionSaveNotification";
static NSString *const kCWSyncSecretSessionSaveNotification                   = @"CubeWareSyncSecretSessionSaveNotification";
static NSString *const kCWDeleteSecretSessionObjectNotification               = @"CubeWareDeleteSecretSessionObjectNotification";
static NSString *const kCWSecretSessionIsTopNotification                      = @"CubeWareSecretSessionIsTopNotification";
static NSString *const kCWSecretSessionNoReadMessageCountNotification         = @"CubeWareSecretSessionNoReadMessageCountNotification";
static NSString *const kCWDeleteSecretSessionsNotification                    = @"CubeWareDeleteSecretSessionsNotification";
static NSString *const kCWSecretMessageTimeOutNotification                    = @"kCWSecretMessageTimeOutNotification";


#pragma mark - Message
static NSString *const kCWMessageDraftUserDefaults                      = @"kCWMessageDraftUserDefaults";
static NSString *const kCWMessageInsertOrUpdateNotification             = @"kCWMessageInsertOrUpdateNotification";
static NSString *const kCWSyncMessageInsertNotification                 = @"kCWSyncMessageInsertNotification";
static NSString *const kCWRevokedMessageNotification                    = @"kCWRevokedMessageNotification";
static NSString *const kCWDeleteMessageNotification                     = @"kCWDeleteMessageNotification";
static NSString *const kCubeWareEventNameTapContent                     = @"CubeWareEventNameTapContent";
static NSString *const kCWMessageHasReadUpdateNotification              = @"kCWMessageHasReadUpdateNotification";
static NSString *const kCWMessageHasPlayedUpdateNotification            = @"kCWMessageHasPlayedUpdateNotification";
static NSString *const kCWDeleteMessageObjectNotification               = @"kCWDeleteMessageObjectNotification";
static NSString *const kCWMessageUpdateRemarkMessageNotification        = @"kCWMessageUpdateRemarkMessageNotification";
static NSString *const kCWMessageUpdateMessageStatusFailedNotification  = @"kCWMessageUpdateMessageStatusFailedNotification";
static NSString *const kCWMessageTableViewScroll                        = @"kCWMessageTableViewScroll";
static NSString *const kCWCustomMessageOperateAddFriendNotification     = @"kCWCustomMessageOperateAddFriendNotification";
static NSString *const kCWSecretMessageHasReadUpdateNotification        = @"kCWSecretMessageHasReadUpdateNotification";
static NSString *const kCWSecretMessageHasReceiptedNotification         = @"kCWSecretMessageHasReceiptedNotification";
static NSString *const kCWewGroupQueryConferenceNotification           = @"kCWewGroupQueryConferenceNotification";

static NSString *const kCWWriteStateMessageNotification                 = @"kCWWriteStateMessageNotification";
static NSString *const kCWShakeFriendMessageNotification                = @"kCWShakeFriendMessageNotification";
#pragma mark - Registration
static NSString *const kCWRegistrationProgressNotification              = @"CubeWareRegistrationProgressNotification";
static NSString *const kCWRegistrationOKNotification                    = @"CubeWareRegistrationOKNotification";
static NSString *const kCWRegistrationClearNotification                 = @"CubeWareRegistrationClearNotification";
static NSString *const kCWRegistrationFailedNotification                = @"CubeWareRegistrationFailedNotification";
static NSString *const kCWRegistrationOnlineDevicesChanged              = @"CubeWareRegistrationOnlineDevicesChanged";
static NSString *const kCWRegistrationOnlineDevicesDidChanged           = @"CubeWareRegistrationOnlineDevicesDidChanged";//收到这个通知主动查询在线设备

static NSString *const kCWAtAllUserDefaults                             = @"kCWAtAllUserDefaults";

#pragma mark - CustomMessage
static NSString *const kCWCustomMessageOperateAddFriend                 = @"add_friend";
static NSString *const kCWCustomMessageOperateApplyFriend               = @"apply_friend";
static NSString *const kCWCustomMessageOperateRefuseFriend              = @"refuse_friend";
static NSString *const kCWCustomMessageOperateDeleteFriend              = @"del_friend";
static NSString *const kCWCustomMessageOperateDismissGroup              = @"dismiss_group";
static NSString *const kCWCustomMessageOperateAddGroupManager           =  @"add_group_manager";
static NSString *const kCWCustomMessageOperateDeleteGroupManager        =  @"del_group_manager";
static NSString *const kCWCustomMessageOperateTransferGroupMaster       = @"transfer_group_master";
static NSString *const kCWCustomMessageOperateAddGroupMember            = @"add_group_member";
static NSString *const kCWCustomMessageOperateDeleteGroupMember         = @"del_group_member";
static NSString *const kCWCustomMessageOperateGroupMemberQuit           = @"group_member_quit";
static NSString *const kCWCustomMessageOperateUpdateGroupName           = @"update_group_name";
static NSString *const kCWCustomMessageOperateNewGroup                  = @"new_group";
static NSString *const kCWCustomMessageOperateUpdateGroupNotice         = @"update_group_notice";
static NSString *const kCWCustomMessageOperateUpdateGroupMemberRemark   = @"update_group_member_remark";
static NSString *const kCWCustomMessageOperateGroupShareQr              = @"group_share_qr";
static NSString *const kCWCustomMessageOperateUserShareQr               = @"user_share_qr";
static NSString *const kCWCustomMessageOperateNetConnectionFailed       = @"net_connection_failed";
static NSString *const kCWCustomMessageOperateApplyConference           = @"apply_conference";
static NSString *const kCWCustomMessageOperateCloseConference           = @"close_conference";
static NSString *const kCWCustomMessageOperateShakeFriend               = @"shake";
static NSString *const kCWCustomMessageOperate                          = @"custom";
;
static NSString *const kCustomMessageInviteGroupNotice                  = @"invite_to_group";
static NSString *const kCustomMessageRefuseInviteGroupNotice            = @"refuse_invite_to_group";
static NSString *const kCustomMessageApplyGroupNotice                   = @"apply_or_agree_to_group";
static NSString *const kCustomMessageUpdateUserPwd                      = @"update_user_pwd";
#pragma mark - NewCall
static NSString *const kCWMediaServiceAuthFailedNotification            = @"CWMediaServiceAuthFailedNotification";
static NSString *const kCWMediaServiceNewCallHideMenuController         = @"CWMediaServiceNewCallHideMenuController";

#pragma mark - Conference
static NSString *const kCWAllConferences                                = @"kCWAllConferences";
static NSString *const kCWLogInQueryConferences                         = @"kCWLogInQueryConferences";
static NSString *const kCWLogInAccountFailed                            = @"kCWLogInAccountFailed";
static NSString *const kCWConnectedToConferenceNotification             = @"kCWConnectedToConferenceNotification";

#pragma mark - Pravicy Description
static NSString *const kCWAudioAccessFailDescription                    = @"请在iPhone的”设置-隐私-麦克风“选项中，允许坐标访问你的手机麦克风";
static NSString *const kCWVideoAccessFailDescription                    = @"请在iPhone的”设置-隐私-相机“选项中，允许坐标访问你的手机相机";
static NSString *const kCWPhotoLibraryAccessFailDescription             = @"请在iPhone的”设置-隐私-相册“选项中，允许坐标访问你的手机相册";
static NSString *const kCWVideoAndAudioAccessFailDescription            = @"请在iPhone的”设置-隐私“选项中，允许坐标访问你的摄像头和麦克风";
static NSString *const kCWVideoAudioAndPhotoAccessFailDescription       = @"请在iPhone的”设置-隐私“选项中，允许坐标访问你的摄像头、麦克风和照片";
static NSString *const kCWSessionMessageNote                            = @"以下为新消息";




#pragma mark - NCubeWare 在新cubeWare使用到的
static NSString *const kCWSendCustomAVMsgCancel                            = @"AVMsgCancel"; //自己取消音视频通话
static NSString *const kCWSendCustomAVMsgCancelByPeer                      = @"AVMsgCancel"; // 对方取消音视频通话
static NSString *const kCWSendCustomAVMsgConnectionEnd                     = @"ConnectionEnd"; // 通话结束
static NSString *const kCWSendCustomAVMsgAudioNoAnswer                     = @"AudioNoAnswer"; // 语音未接听
static NSString *const kCWSendCustomAVMsgVideoNoAnswer                     = @"deoNoAnswer"; // 视频未接听
#endif /* CubeWareConst_h */
