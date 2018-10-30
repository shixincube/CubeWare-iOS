//
//  CWSessionUtil.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWSessionUtil.h"
#import "CWTextMessageCell.h"
#import "CWImageMessageCell.h"
#import "CWTipCell.h"
#import "CWVideoMessageCell.h"
#import "CWAudioMessageCell.h"
#import "CWFileMessageCell.h"
#import "CWAVMessageCell.h"

#import "CWTipModel.h"

@implementation CWSessionUtil

#pragma mark - message cell

+(Class)cellClassForContent:(id)content{
    Class cls;
    
    if([content isKindOfClass:[CubeMessageEntity class]])
    {
         CubeMessageEntity *msg = (CubeMessageEntity *)content;
        if(msg.recallTime > 0){
            return [CWTipCell class];
        }
        CubeMessageType type = [((CubeMessageEntity *)content) type];
        switch (type) {
            case CubeMessageTypeFile:
                cls = [CWFileMessageCell class];
                break;
            case CubeMessageTypeImage:
                cls = [CWImageMessageCell class];
                break;
            case CubeMessageTypeVideoClip:
                cls = [CWVideoMessageCell class];
                break;
            case CubeMessageTypeVoiceClip:
                cls = [CWAudioMessageCell class];
                break;
            case CubeMessageTypeCustom:
                cls = [self cellClassForCustomMessage:content];
                break;
            default:
                cls = [CWTextMessageCell class];
                break;
        }

    }
    else if([content isKindOfClass:[NSString class]])
    {
        cls = [CWTipCell class];
    }
    else if([content isKindOfClass:[CWTipModel class]])
    {
//		CWTipType type = [(CWTipModel *)content type];
		cls = [CWTipCell class];
//		switch (type) {
//			case default:
//				cls = [CWTipCell class];
//				break;
//		}
    }
    else
    {
        cls = [CWTipCell class];
    }
    
    return cls;
}

+(Class)cellClassForCustomMessage:(CubeCustomMessage *)msg
{
    CWCustomMessageType type = [CWMessageUtil customMessageTypeForMessage:msg];
    Class cls;
    switch (type)
    {
        case CWCustomMessageTypeTip:
            cls = [CWTipCell class];
            break;
        case CWNCustomMessageTypeNotity:
            cls = [CWTipCell class];
            break;
        case CWNCustomMessageTypeChat:
            cls = [CWAVMessageCell class];
            break;
        default:
            cls = [CWTipCell class];
            break;
    }
    return cls;
}

#pragma mark - session
+(NSString *)sessionIdForMessage:(CubeMessageEntity *)msg{
    return  msg.groupName.length ? msg.groupName : msg.messageDirection == CubeMessageDirectionSent ? msg.receiver.cubeId : msg.sender.cubeId;
}

+(CWSessionType)sessionTypeForMessage:(CubeMessageEntity *)msg{
    return msg.groupName.length ? CWSessionTypeGroup : CWSessionTypeP2P;
}

+(CWSession *)sessionWithMessage:(CubeMessageEntity *)msg{
    CWSession *session = [[CWSession alloc] initWithSessionId:[self sessionIdForMessage:msg] andType:[self sessionTypeForMessage:msg]];
    
    return session;
}

+(NSString *)sessionSummaryWithMessage:(CubeMessageEntity *)msg{
	NSString *summary = nil;
	switch (msg.type) {
		case CubeMessageTypeText:
			summary = [(CubeTextMessage *)msg content];
			break;
		case CubeMessageTypeFile:
			summary = @"[文件]";
			break;
		case CubeMessageTypeImage:
			summary = @"[图片]";
			break;
		case CubeMessageTypeReply:
			summary = [self sessionSummaryWithMessage:[(CubeReplyMessage *)msg reply]];
			break;
		case CubeMessageTypeVideoClip:
			summary = @"[视频]";
			break;
		case CubeMessageTypeVoiceClip:
			summary = @"[语音]";
			break;
		case CubeMessageTypeLocation:
			summary = @"[位置]";
			break;
		case CubeMessageTypeUnknown:
			summary = @"未知消息类型";
			break;
		default:
			summary = @"[新消息]";
			break;
	}
	return summary;
}

#pragma mark - sort

+(NSMutableArray *)sortSessions:(NSMutableArray *)sessions{
#warning todo sort
    return sessions;
}

+(NSMutableArray *)revertMessages:(NSMutableArray *)messages withTimeIndicateInterval:(int)interval onBasisOf:(CubeMessageEntity *)basis{
    NSMutableArray *proccedMessages = [NSMutableArray array];
    CubeMessageEntity *previousMessage = basis;
    
    int intervalMill = interval * 1000;
    for (NSInteger i = messages.count - 1; i >= 0; i --) {
        CubeMessageEntity *temp = [messages objectAtIndex:i];
        if(previousMessage && (temp.timestamp - previousMessage.timestamp > intervalMill))
		{
			CWTipModel *timeTip = [CWTipModel tipWithType:CWTipTypeTimeStamp andContent:nil andUserInfo:nil];
			timeTip.timestamp = previousMessage.timestamp;
            [proccedMessages addObject:timeTip];
		}
        previousMessage = temp;
        [proccedMessages addObject:temp];
    }
    
    return proccedMessages;
}

#pragma mark - time
+(NSString *)messageTimeStringWithTimestamp:(long long)timestamp{
    
    NSTimeInterval seconds = timestamp / 1000.0;
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:seconds];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents * nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents * myCmps = [calendar components:unit fromDate:myDate];
    NSDateFormatter * dateFmt = [[NSDateFormatter alloc]init];
	if(nowCmps.year == myCmps.year && nowCmps.month == myCmps.month)
	{
		if (nowCmps.day == myCmps.day) { //今天
			if ([CWTimeUtil getTimeSystemHR] == CWTimeSystem12HR) {
				dateFmt.AMSymbol = @"上午";
				dateFmt.PMSymbol = @"下午";
				dateFmt.dateFormat = @"aaa hh:mm";
			}
			else
			{
				dateFmt.dateFormat = @"hh:mm";
			}
			
		}
		else if (nowCmps.day - myCmps.day == 1)
		{ //昨天
			dateFmt.dateFormat=@"昨天";
		}
	}
	
    if(!dateFmt.dateFormat.length)
	{
        dateFmt.dateFormat = @"yyyy/MM/dd";        
    }

    return [dateFmt stringFromDate:myDate];
    
    return [NSString stringWithFormat:@"%lld",timestamp];
}

+(NSString *)sessionTimeStringWithTimestamp:(long long)timestamp{
    return [self messageTimeStringWithTimestamp:timestamp];
}

+ (NSString *)sessionTipStringWith:(CubeMessageEntity *)msg
{
    CubeCustomMessage *customMessage = (CubeCustomMessage *)msg;
    NSDictionary *header = customMessage.header;
    NSString *operate =  [header objectForKey:@"operate"];
    if ([operate isEqualToString:@"close_conference"]) {
        NSString *conferenceType = [header objectForKey:@"conferenceType"];
        if ([conferenceType isEqualToString:CubeGroupType_Voice_Conference] || [conferenceType isEqualToString:CubeGroupType_Voice_Call])
        {
            return @"多人音频会议结束";
        }
        else if ([conferenceType isEqualToString:CubeGroupType_Video_Conference] || [conferenceType isEqualToString:CubeGroupType_Video_Call])
        {
            return @"多人视频会议结束";
        }
        else if ([conferenceType isEqualToString:CubeGroupType_Share_Desktop_Conference])
        {
            return @"桌面分享结束";
        }
        else if ([conferenceType isEqualToString:CubeGroupType_Share_WB])
        {
            return @"白板演示结束";
        }
        return @"多人会议结束";
    }
    else if ([operate isEqualToString:@"apply_conference"])
    {
        NSString *conferenceType = [header objectForKey:@"conferenceType"];
        NSString *cubeID = [header objectForKey:@"userCube"];
        if ([conferenceType isEqualToString:CubeGroupType_Voice_Conference]|| [conferenceType isEqualToString:CubeGroupType_Voice_Call])
        {
            return [NSString stringWithFormat:@"%@发起了多人音频会议",cubeID];
        }
        else if ([conferenceType isEqualToString:CubeGroupType_Video_Conference]|| [conferenceType isEqualToString:CubeGroupType_Video_Call])
        {
            return [NSString stringWithFormat:@"%@发起了多人视频会议",cubeID];
        }
        else if ([conferenceType isEqualToString:CubeGroupType_Share_Desktop_Conference])
        {
            return [NSString stringWithFormat:@"%@发起了桌面分享",cubeID];
        }
        else if ([conferenceType isEqualToString:CubeGroupType_Share_WB])
        {
            return [NSString stringWithFormat:@"%@发起了白板演示",cubeID];
        }
        return [NSString stringWithFormat:@"%@发起了多人会议",cubeID];
    }
    else if ([operate isEqualToString:@"create_wb"]){
        NSString *cubeID = [header objectForKey:@"userCube"];
        return [NSString stringWithFormat:@"%@发起了白板演示",cubeID];
    }
    else if ([operate isEqualToString:@"destory_wb"]){
        return [NSString stringWithFormat:@"白板演示结束"];
    }
    else if([operate isEqualToString:@"update_group_name"])
    {
        return @"变更群名称";
    }
    else if ([operate isEqualToString:@"new_group"])
    {
        return @"创建群成功";
    }
    else if ([operate isEqualToString:@"add_friend"])
    {
        return @"添加好友成功";
    }
    return @"通知消息";
}
@end
