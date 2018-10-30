//
//  CDConferenceManager.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/10.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDConferenceManager : NSObject

+ (CDConferenceManager *)shareInstance;

/**
 会议列表  包含 音频会议、视频会议、屏幕分享、等
 */
@property (nonatomic,strong) NSMutableArray *conferenceList;

/**
  查询会议

 @param groupIds 群组ID
 @param completion 成功回调
 @param failure 失败回调
 */
-(void)queryConferencesWithGroupIds:(NSArray *)groupIds
                         completion:(void(^)(NSArray *conferences))completion
                            failure:(void(^)(CubeError *error))failure;


/**
 查询白板
 */
//- (void)queryWhiteBoard...

@end
