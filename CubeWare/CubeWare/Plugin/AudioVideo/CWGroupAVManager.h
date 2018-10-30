//
//  CWGroupAVManager.h
//  CubeWare
//
//  Created by Mario on 2017/7/7.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWGroupAVManager : NSObject

/**
 * 单例
 */
+ (CWGroupAVManager *)sharedSingleton;

///**
// * 多人音视频View
// */
//@property (nonatomic, strong) CWGroupAVRootView *groupAVView;
//
///**
// * 多人音视频View
// */
//@property (nonatomic, strong) CWApplyJoinAVView *applyAVView;
//
///**
// * 多人音视频View
// */
//@property (nonatomic, strong) CWInvitedAVView *invitedAVView;

/**
 * 默认是视频呼叫NO，音频呼叫时为YES
 */
@property (nonatomic, assign) BOOL isCallAudio;

/**
 * 通话计时器时长
 */
@property (nonatomic, strong) NSString *talkDurationStr;

/**
 * 视频通话结束的通话时长
 */
@property (nonatomic, strong) NSString *videoCallEndDuration;

/**
 * 语音通话结束的通话时长
 */
@property (nonatomic, strong) NSString *audioCallEndDuration;

/**
 * 被邀请中或者正在通话中的多人音视频
 */
@property (nonatomic, strong) CubeConference *conference;

/**
 * 多人音视频缓存
 */
@property (nonatomic, strong) NSMutableDictionary *conferenceDic;

/**
 * 邀请多人音视频成员缓存
 */
@property (nonatomic, strong) NSMutableDictionary *memberDic;

/**
 当前会话的sessionID
 */
@property (nonatomic, strong) NSString *sessionId;
/**
 *  存取
 */
-(void)pushGroupAVStackKey:(NSString *)groupCube andObject:(CubeConference *)confe;

/**
 *  读取
 */
-(CubeConference *)getGroupAVStack:(NSString *)groupCube;

/**
 *  移除
 */
-(void)remove:(NSString *)groupCube;

/**
 *  清空
 */
-(void)removeAll;

@end
