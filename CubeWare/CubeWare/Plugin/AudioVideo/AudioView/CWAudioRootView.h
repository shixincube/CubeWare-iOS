//
//  CWAudioRootView.h
//  CubeWare
//  音频通话基类View
//  Created by 美少女 on 2017/12/28.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWMultiAudioView.h"
#import "CWSingleAudioView.h"
#import "CWApplyJoinView.h"
@protocol CWAudioRootViewDelegate<NSObject>
@end

@interface CWAudioRootView : UIView

/**
 单例方法

 @return view
 */
+ (instancetype)AudioRootView;

/**
 多人音频View
 */
@property (nonatomic, strong) CWMultiAudioView *multiAudioView;

/**
 单人音频View
 */
@property (nonatomic, strong) CWSingleAudioView *singleAudioView;

/**
 申请加入View
 */
@property (nonatomic,strong) CWApplyJoinView *joinView;

/**
 对方的cubeId
 */
@property (nonatomic, strong) NSString *cubeId;

/**
 当前群组cubeID
 */
@property (nonatomic, strong) NSString *groupId;

/**
 已选成员列表
 */
@property (nonatomic, strong) NSMutableArray *selectMemberArray;

/**
 * 会议
 */
@property (nonatomic, strong) CubeConference *conference;
/**
 发起音频会话

 @return YES 发起成功NO 发起失败
 */
- (BOOL)fireAudioCall;

/**
 显示View页面
 */
- (void)showView;

/**
 结束会话，关闭窗口，
 */
- (void)close;

/**
 设置通话时长
 @param time 时间
 */
- (void)setConnectingTime:(long long)time;

/**
 设置通话类型

 @param type 通话类型 单人SingleAudioType 多人GroupAudioType
 */
- (void)setAudioType:(AudioType)type;
/**
 设置当前页面展示样式
 
 @param style 样式
 */
- (void)setShowStyle:(AVShowViewStyle)style;

/**
 设置免提按钮状态是否可用

 @param enable 可用状态
 */
- (void)setHandFreeEnable:(BOOL)enable;

/**
 更新会议

 @param conference 会议
 @param failureList 加入失败的列表
 */
- (void)updateConference:(CubeConference *)conference andfailureList:(NSArray *)failureList;

/**
 加入会议
 */
- (void)joinInConference;
/**
 更新网络状态

 @param type 状态码
 */
-(void)updateConferenceNetWork:(CWNetworkUpdateType)type;
@end
