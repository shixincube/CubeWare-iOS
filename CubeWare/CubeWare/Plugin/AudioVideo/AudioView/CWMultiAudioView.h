//
//  CWMultiAudioView.h
//  CubeWare
//  多人音频通话view
//  Created by 美少女 on 2017/12/28.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWAudioVideoPrerequisites.h"
#import "CWNetworkUpdateType.h"
#import "CubeWareHeader.h"
@protocol CWMultiAudioViewDelegate<NSObject>
@optional
/**
 缩小窗体
 */
- (void)ZoomOutWindow;


/**
 点击添加成员
 */
- (void)clickAddMember;

@end

@interface CWMultiAudioView : UIView
/**
 设置连接时间
 */
@property (nonatomic, strong) NSString *connectingTime;
/**
 初始化方法
 
 @param frame 窗体大小
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame withAudioShowStyle:(AVShowViewStyle)style;

/**
 设置当前页面展示样式
 
 @param style 样式
 */
- (void)setMultiAudioShowStyle:(AVShowViewStyle)style;

/**
 设置免提按钮是否可用

 @param enable 可用状态
 */
- (void)setHandFreeEnable:(BOOL)enable;

/**
 更新成员列表
 */
- (void)updateCollectView;

/**
 更新网络状态

 @param type 状态码
 */
-(void)updateConferenceNetWork:(CWNetworkUpdateType)type;
/**
 代理
 */
@property (nonatomic, weak) id<CWMultiAudioViewDelegate> delegate;

/**
 * 会议
 */
@property (nonatomic, strong) CubeConference *conference;
@end
