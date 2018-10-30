//
//  CDConferenceDetailInfoModel.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/6.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDConferenceDetailInfoModel.h"
#import "CDDateUtil.h"

@implementation CDConferenceDetailInfoModel

#pragma mark - Getter
-(NSString *)conferenceBeginDateFormatString{
    if (!_conferenceBeginDateFormatString.length) {
        return [CDDateUtil convertToFormatDateString:self.conferenceBeginDate];
    }
    return _conferenceBeginDateFormatString;
}

- (NSString *)conferenceDurationFormatString{
    if (!_conferenceDurationFormatString.length) {
        return [CDDateUtil convertToMinutesFormatString:self.conferenceDuration];
    }
    return _conferenceDurationFormatString;
}


@end
