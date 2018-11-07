//
//  CDMessageHelper.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/10/23.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDMessageHelper.h"
#import "CWSession.h"
#import "CDContactsManager.h"
static CDMessageHelper *helper = nil;

@implementation CDMessageHelper
+(CDMessageHelper *)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[CDMessageHelper alloc] init];
        [CubeWare sharedSingleton].messageService.delegate = helper;
    });
    return helper;
}

#pragma mark - CWMessageServiceDelegate
-(BOOL)needShowMessage:(CubeMessageEntity *)msg
{
    if (msg.type == CubeMessageTypeReceipt)
    {
        return NO;
    }
    else
    {
        if (msg.type == CubeMessageTypeCustom)
        {
            NSString *operate = [((CubeCustomMessage *)msg).header objectForKey:@"operate"];
            if ([operate isEqualToString:@"writing"]) {
                return NO;
            }
        }
        else
        {
           
        }
    }
    return YES;
}

- (BOOL)shouldUpdateSessionWithMessage:(CubeMessageEntity *)message session:(CWSession *)session
{
    if (message.type == CubeMessageTypeCustom) {
        CubeCustomMessage *customMsg = (CubeCustomMessage *)message;
        NSString *operate = [customMsg.header objectForKey:@"operate"];
        if ([operate isEqualToString:@"writing"]) {
            return NO;
        }
    }
    else if(message.type == CubeMessageTypeReceipt)
    {
        return NO;//回执消息
    }
    return YES;
}

-(NSString *)summaryOfMesssage:(CubeMessageEntity *)msg forSession:(CWSession *)session
{
    if(msg.recallTime != 0)
    {
        return  [NSString stringWithFormat:@"%@撤回了一条消息",msg.messageDirection == CubeMessageDirectionSent ? @"你" : msg.sender.displayName];;
    }
    else
    {
        if(msg.type == CubeMessageTypeText)
        {
            if (session.sessionType == CWSessionTypeGroup && msg.messageDirection == CubeMessageDirectionReceived)
            {
                return [NSString stringWithFormat:@"%@:%@",msg.sender.displayName,((CubeTextMessage *)msg).content];
            }
            else
            {
                return ((CubeTextMessage *)msg).content;
            }
        }
        else if(msg.type == CubeMessageTypeImage)
        {
            if (session.sessionType == CWSessionTypeGroup && msg.messageDirection == CubeMessageDirectionReceived)
            {
                return [NSString stringWithFormat:@"%@:[图片]",msg.sender.displayName];
            }
        }
        else if(msg.type == CubeMessageTypeFile)
        {
            if (session.sessionType == CWSessionTypeGroup && msg.messageDirection == CubeMessageDirectionReceived)
            {
                return [NSString stringWithFormat:@"%@:[文件]",msg.sender.displayName];
            }
        }
        else if (msg.type == CubeMessageTypeReply)
        {}
        else if (msg.type == CubeMessageTypeVideoClip)
        {
            if (session.sessionType == CWSessionTypeGroup && msg.messageDirection == CubeMessageDirectionReceived)
            {
                return [NSString stringWithFormat:@"%@:[视频]",msg.sender.displayName];
            }
        }
        else if (msg.type == CubeMessageTypeVoiceClip)
        {
            if (session.sessionType == CWSessionTypeGroup && msg.messageDirection == CubeMessageDirectionReceived)
            {
                return [NSString stringWithFormat:@"%@:[音频]",msg.sender.displayName];
            }
        }
        else if(msg.type == CubeMessageTypeCustom)
        {
            return [self getNotifyMessage:msg];
        }
    }

    return nil;
}

-(NSString *)getSessionNameforSession:(CWSession *)session
{
    if (session.sessionType == CWSessionTypeGroup) {
        CubeGroup *model = [[CDContactsManager shareInstance] getGroupInfo:session.sessionId];
        if(model)
        {
            return model.displayName;
        }
    }
    else
    {
        CDLoginAccountModel *model = [[CDContactsManager shareInstance] getFriendInfo:session.sessionId];
        if (model) {
            return model.displayName;
        }
    }
    return nil;
}


#pragma mark - privte methods
- (NSString *)getNotifyMessage:(CubeMessageEntity *)msg
{
    CubeCustomMessage *customMessage = (CubeCustomMessage *)msg;
    NSDictionary *header = customMessage.header;
    NSString *operate =  [header objectForKey:@"operate"];
    if ([operate isEqualToString:@"close_conference"]) {
        NSString *conferenceType = [header objectForKey:@"conferenceType"];
        if ([conferenceType isEqualToString:CubeGroupType_Voice_Conference_String] || [conferenceType isEqualToString:CubeGroupType_Voice_Call_String])
        {
            return @"多人音频会议结束";
        }
        else if ([conferenceType isEqualToString:CubeGroupType_Video_Conference_String] || [conferenceType isEqualToString:CubeGroupType_Video_Call_String])
        {
            return @"多人视频会议结束";
        }
        else if ([conferenceType isEqualToString:CubeGroupType_Share_Desktop_Conference_String])
        {
            return @"桌面分享结束";
        }
        else if ([conferenceType isEqualToString:CubeGroupType_Share_WB_String])
        {
            return @"白板演示结束";
        }
        return @"多人会议结束";
    }
    else if ([operate isEqualToString:@"apply_conference"])
    {
        NSString *conferenceType = [header objectForKey:@"conferenceType"];
        NSString *cubeID = [header objectForKey:@"userCube"];
        if ([conferenceType isEqualToString:CubeGroupType_Voice_Conference_String]|| [conferenceType isEqualToString:CubeGroupType_Voice_Call_String])
        {
            return [NSString stringWithFormat:@"%@发起了多人音频会议",cubeID];
        }
        else if ([conferenceType isEqualToString:CubeGroupType_Video_Conference_String]|| [conferenceType isEqualToString:CubeGroupType_Video_Call_String])
        {
            return [NSString stringWithFormat:@"%@发起了多人视频会议",cubeID];
        }
        else if ([conferenceType isEqualToString:CubeGroupType_Share_Desktop_Conference_String])
        {
            return [NSString stringWithFormat:@"%@发起了桌面分享",cubeID];
        }
        else if ([conferenceType isEqualToString:CubeGroupType_Share_WB_String])
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
    else if ([operate isEqualToString:@"share_wb"])
    {
        return [NSString stringWithFormat:@"白板演示"];
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
    else if ([operate isEqualToString:@"videoCall"]||[operate isEqualToString:@"voiceCall"])
    {
        return customMessage.body;
    }
    else if ([operate isEqualToString:@"shake"])
    {
        if(msg.messageDirection == CubeMessageDirectionReceived)
        {
            return @"抖了你一下";
        }
        else
        {
            return @"抖了一下";
        }
    }
    return @"通知消息";
}

@end
