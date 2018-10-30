//
//  CDConferenceDetailInfoModel.h
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/6.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDConferenceDetailInfoModel : NSObject

/**
 会议主题
 */
@property (nonatomic,strong) NSString *conferenceTheme;

/**
 会议开始日期
 */
@property (nonatomic,strong) NSDate *conferenceBeginDate;

/**
 会议开始日期格式化字符串 eg: 2018年9月20日 星期四 10:00
 */
@property (nonatomic,strong) NSString *conferenceBeginDateFormatString;

/**
 会议时长
 */
@property (nonatomic,assign) NSTimeInterval conferenceDuration;

/**
 会议时长格式化字符串 eg: 15分钟
 */
@property (nonatomic,strong) NSString *conferenceDurationFormatString;

/**
 会议成员
 */
@property (nonatomic,strong) NSArray<CubeUser *> *members;

/**
 会议对象
 */
@property (nonatomic,strong) CubeConference *conference;

@end
