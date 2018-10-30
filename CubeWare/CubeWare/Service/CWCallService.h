//
//  CWCallService.h
//  CubeWare
//  音频呼叫
//  Created by 美少女 on 2017/12/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//
#import <Foundation/Foundation.h>
@protocol CWCallServiceDelegate<NSObject>

/**
 收到新呼叫

 @param callSession 通话
 @param from 通话发起者
 */
- (void)newCall:(CubeCallSession *)callSession from:(CubeUser *)from;

/**
 通话响铃中

 @param callSession 通话
 @param from 通话发起者
 */
- (void)callRing:(CubeCallSession *)callSession from:(CubeUser *)from;

/**
 通话已连接

 @param callSession 通话
 @param from 通话发起者
 */
- (void)callConnected:(CubeCallSession *)callSession from:(CubeUser *)from andView:(UIView *)view;

/**
 通话结束

 @param callSession 通话
 @param from 通话发起者
 */
- (void)callEnded:(CubeCallSession *)callSession from:(CubeUser *)from;

/**
 通话失败

 @param callSession 通话
 @param error 错误对象
 @param from 通话发起者
 */
-(void)callFailed:(CubeCallSession *)callSession error:(CubeError *)error from:(CubeUser *)from;


@end

@interface CWCallService : NSObject<CubeCallServiceDelegate>

@property (nonatomic,weak) id<CWCallServiceDelegate> delegate;

/**
 发起一对一通话

 @param cubeId 通话对端cubeId
 @param enableVideo 视频通话开关
 */
- (void)makeCallWithCallee:(NSString *)cubeId andEnableVideo:(BOOL)enableVideo;

/**
 挂断一对一通话

 @param cubeId 通话对端cubeId
 */
- (void)terminalCall:(NSString *)cubeId;

/**
 接听一对一通话

 @param cubeId 通话对端cubeId
 */
- (void)answerCall:(NSString *)cubeId;

@end
