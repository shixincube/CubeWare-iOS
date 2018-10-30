//
//  CWMediaService.h
//  CubeWare
//
//  Created by 美少女 on 2018/1/11.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CWMediaServiceDelegate <NSObject>
/**
 录制视频开始

 @param userInfo 用户信息
 */
- (void)onRecordVideoStart:(NSDictionary *)userInfo;

/**
 录制视频结束

 @param userInfo 用户信息
 */
- (void)onRecordVideoStop:(NSDictionary *)userInfo;

/**
 预览

 @param userInfo 用户信息
 */
- (void)onRecordReadyForDisplay:(NSDictionary *)userInfo;

/**
  //录制视频失败回调

 @param userInfo 用户信息
 */
- (void)onRecordVideoFailed:(NSDictionary *)userInfo;
@end

#warning update to Engine 3.0
@interface CWMediaService : NSObject //<CubePlayDelegate,CubeRecordDelegate>

/**
 媒体服务代理
 */
@property (nonatomic,weak) id<CWMediaServiceDelegate> mediaServiceDelegate;
@end
