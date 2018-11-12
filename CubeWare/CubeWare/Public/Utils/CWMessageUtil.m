//
//  CWMessageUtil.m
//  CubeWare
//
//  Created by jianchengpan on 2018/1/2.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWMessageUtil.h"
#import "CWSession.h"
#import "CWUserModel.h"
#import "CubeWareHeader.h"
#import "CWParseRegularExpression.h"

#define CustomMessageTypeKey @"type"
@implementation CWMessageUtil

#pragma mark - createMessage

+(CubeCustomMessage *)tipMessageWithContent:(NSString *)content forSession:(CWSession *)session{
#warning waiting design
	CubeUser *receiver = [CubeUser userWithCubeId:session.sessionId andDiaplayName:nil andAvatar:nil];;//[CubeUser userWithCubeId:session.sessionId andDiaplayName:session.baseInfo.remarkName.length ? session.baseInfo.remarkName : session.baseInfo.name andAvatar:session.baseInfo.avatarUrl];
	
	NSDictionary *header = [@{
							  CustomMessageTypeKey:[self customMessageTypeStringFromType:CWCustomMessageTypeTip],
							  } mutableCopy];
	
	CubeCustomMessage *msg = [[CubeCustomMessage alloc] initWithHeader:header expires:0 andSender:[CWUserModel currentUser] receiver:receiver];
	
	msg.body = content;
	
    if(session.sessionType == CWSessionTypeGroup)
    {
        msg.groupName = session.sessionId;
    }
    
    msg.messageDirection = CubeMessageDirectionSent;
	
    return msg;
}

+(CubeVoiceClipMessage *)voiceClipMessageWithFilePath:(NSString *)path andDuration:(long long)durations forSession:(CWSession *)session{
#warning waiting design
	CubeUser *receiver = [CubeUser userWithCubeId:session.sessionId andDiaplayName:nil andAvatar:nil];;//[CubeUser userWithCubeId:session.sessionId andDiaplayName:session.baseInfo.remarkName.length ? session.baseInfo.remarkName : session.baseInfo.name andAvatar:session.baseInfo.avatarUrl];
	
//    Sender * sender = [[Sender alloc] initWithName:[CWUserModel currentUser].userId];
//    sender.displayName = [CWUserModel currentUser].baseInfo.remarkName.length ? [CWUserModel currentUser].baseInfo.remarkName : [CWUserModel currentUser].baseInfo.name;
//    Receiver * receiver = [[Receiver alloc] initWithName:session.sessionId];
//    receiver.displayName = session.baseInfo.remarkName.length ? session.baseInfo.remarkName : session.baseInfo.name;
//    CubeVoiceClipMessage * voiceClipMsg = [[CubeVoiceClipMessage alloc] initWithFilePath:path andDuration:durations andReceiver:receiver andSender:sender];
	CubeVoiceClipMessage *voiceClipMsg = [[CubeVoiceClipMessage alloc] initWithFileName:@"" fileSize:0 duration:0 url:nil md5:nil andSender:[CWUserModel currentUser] receiver:receiver];
    if(session.sessionType == CWSessionTypeGroup)
    {
        voiceClipMsg.groupName = session.sessionId;
    }
    return voiceClipMsg;
}

+(CubeVideoClipMessage *)videoClipMessageWithFilePath:(NSString *)path andThumbPath:(NSString *)thumbPath andName:(NSString *)name andSize:(CGSize)size andDuration:(long long)durations forSession:(CWSession *)session{
#warning waiting design
	CubeUser *receiver = [CubeUser userWithCubeId:session.sessionId andDiaplayName:nil andAvatar:nil];;//[CubeUser userWithCubeId:session.sessionId
	CubeVideoClipMessage *videoClipMessage = [[CubeVideoClipMessage alloc] initWithFileName:name fileSize:0 duration:durations thumbImageSize:size url:nil thumbUrl:thumbPath md5:nil andSender:[CWUserModel currentUser] receiver:receiver];
    videoClipMessage.filePath = path;
    videoClipMessage.status = CubeMessageStatusSending;
    videoClipMessage.sendTime = [CWTimeUtil currentTimestampe];
    videoClipMessage.messageDirection = CubeMessageDirectionSent;
    if(session.sessionType == CWSessionTypeGroup)
    {
        videoClipMessage.groupName = session.sessionId;
    }
    return videoClipMessage;
}

+ (CubeImageMessage *)imageMessageWithPath:(NSString *)path andThumbPath:(NSString *)thumbPath andName:(NSString *)name andFileSize:(CGFloat)filesize andSize:(CGSize)size forSession:(CWSession *)session
{
#warning waiting design
	CubeUser *receiver = [CubeUser userWithCubeId:session.sessionId andDiaplayName:nil andAvatar:nil];;//[CubeUser userWithCubeId:session.sessionId
	CubeImageMessage *imageMsg = [[CubeImageMessage alloc] initWithFileName:name fileSize:filesize imageSize:size url:nil thumbUrl:nil md5:nil andSender:[CWUserModel currentUser] receiver:receiver];
    imageMsg.filePath = path;
    imageMsg.thumbPath = thumbPath;
    imageMsg.width = size.width;
    imageMsg.height = size.height;
    imageMsg.status = CubeMessageStatusSending;
    imageMsg.messageDirection = CubeMessageDirectionSent;
    NSData *data = [NSData dataWithContentsOfFile:path];
    imageMsg.md5 = [CubeMessageUtil MD5WithBytes:data.bytes andLength:(int)data.length];
    if(session.sessionType == CWSessionTypeGroup)
    {
        imageMsg.groupName = session.sessionId;
    }
    return imageMsg;
}

+(CubeFileMessage *)fileMessageWithPath:(NSString *)path andName:(NSString *)name forSession:(CWSession *)session
{
#warning waiting design
	CubeUser *receiver = [CubeUser userWithCubeId:session.sessionId andDiaplayName:nil andAvatar:nil];;//[CubeUser userWithCubeId:session.sessionId
	CubeFileMessage *fileMessage = [[CubeFileMessage alloc] initWithFileName:name fileSize:0 url:nil md5:nil andSender:[CWUserModel currentUser] receiver:receiver];
    fileMessage.filePath = path;
    fileMessage.status = CubeMessageStatusSending;
    fileMessage.sendTime = [CWTimeUtil currentTimestampe];
    fileMessage.messageDirection = CubeMessageDirectionSent;
    NSData *data = [NSData dataWithContentsOfFile:path];
    fileMessage.md5 = [CubeMessageUtil MD5WithBytes:data.bytes andLength:(int)data.length];
    if(session.sessionType == CWSessionTypeGroup){
        fileMessage.groupName = session.sessionId;
    }
    return fileMessage;
}


+(CubeCustomMessage *)shakeCustomMessageForSession:(CWSession *)session
{
	CubeUser *receiver = [CubeUser userWithCubeId:session.sessionId andDiaplayName:nil andAvatar:nil];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setObject:kCWCustomMessageOperateShakeFriend forKey:@"operate"];
	[dic setObject:@"chat" forKey:@"type"];
	CubeCustomMessage *customMessage = [[CubeCustomMessage alloc] initWithHeader:dic expires:0 andSender:[CWUserModel currentUser] receiver:receiver];
    return customMessage;
}
#pragma mark - custom message type

+(NSString *)customMessageTypeStringFromType:(CWCustomMessageType)type{
    NSString *typeString = nil;
    switch (type)
    {
        case CWCustomMessageTypeTip:
            typeString = @"CWCustomMessageTypeTip";
            break;
        case CWNCustomMessageTypeNotity:
            typeString = @"notify";
            break;
        case CWNCustomMessageTypeChat:
            typeString = @"chat";
            break;
        default:
            typeString = @"CWCustomMessageTypeUnknown";
            break;
    }
    return typeString;
}

+(CWCustomMessageType)customMessageTypeFromString:(NSString *)typeString{
    CWCustomMessageType type = CWCustomMessageTypeUnknown;
    
    if([typeString isEqualToString:@"CWCustomMessageTypeTip"])
    {
        type = CWCustomMessageTypeTip;
    }
    else if ([typeString isEqualToString:@"notify"]){
        type = CWNCustomMessageTypeNotity;
    }else if ([typeString isEqualToString:@"chat"]){
        type = CWNCustomMessageTypeChat;
    }
    return type;
}

+(CWCustomMessageType)customMessageTypeForMessage:(CubeCustomMessage *)msg{
    NSString *typeString = nil;
    if([msg isKindOfClass:[CubeCustomMessage class]])
    {
        typeString = [msg.header objectForKey:CustomMessageTypeKey];
    }
    return [self customMessageTypeFromString:typeString];
}

#pragma mark - image
+(CGSize)fileDisplaySizeForOriginSize:(CGSize)originSize{
    
    CGSize displaySize = CGSizeZero;
    if(originSize.width > 1 && originSize.height > 1)
    {
        CGFloat originMaxSideValue = 0;
        BOOL userWidth = NO;
        if(originSize.width > originSize.height)
        {
            originMaxSideValue = originSize.width;
            userWidth = YES;
        }
        else
        {
            originMaxSideValue = originSize.height;
        }
        
        CGFloat displayMaxSideValue = 0;
        
        CGFloat MaxWidthOrHeight = [UIScreen mainScreen].bounds.size.width / 2;
        CGFloat MinWidthOrHeight = [UIScreen mainScreen].bounds.size.width / 4;
        
        if(originMaxSideValue < MinWidthOrHeight)
        {
            displayMaxSideValue = MinWidthOrHeight;
        }
        else if(originMaxSideValue < MaxWidthOrHeight)
        {
            displayMaxSideValue = originSize.width;
        }
        else
        {
            displayMaxSideValue = MaxWidthOrHeight;
        }
        
        CGFloat anotherSideValue = (displayMaxSideValue / originMaxSideValue) * (userWidth ? originSize.height : originSize.width);
        
        displaySize.width = userWidth ? displayMaxSideValue : anotherSideValue;
        displaySize.height = !userWidth ? displayMaxSideValue : anotherSideValue;
    }
    
    return displaySize;
}

+ (NSData *)getThumbImageDataWithImageData:(NSData *)imageData andMaxWidthOrHeight:(CGFloat)maxWidthOrHeight{
	NSMutableData *thumbImageData = nil;
	
	if(imageData)
	{
		CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((CFDataRef)imageData, nil);
		
		NSDictionary *thumbImageOptions = @{
											(__bridge NSString *)kCGImageSourceCreateThumbnailFromImageAlways:@YES,
											(__bridge NSString *)kCGImageSourceThumbnailMaxPixelSize:@(maxWidthOrHeight),
											(__bridge NSString *)kCGImageSourceCreateThumbnailWithTransform:@YES,
											};
		
		if(imageSourceRef && CGImageSourceGetCount(imageSourceRef))
		{
			
			size_t imageCount = CGImageSourceGetCount(imageSourceRef);
			
			thumbImageData = [NSMutableData data];
			
			CGImageDestinationRef thumbImageDestination = CGImageDestinationCreateWithData((CFMutableDataRef)thumbImageData, CGImageSourceGetType(imageSourceRef), imageCount, NULL);
			
			for (size_t i = 0; i < imageCount; i++) {
				CGImageRef thubmImage = CGImageSourceCreateImageAtIndex(imageSourceRef, i, (CFDictionaryRef)thumbImageOptions);
				NSDictionary *properties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(imageSourceRef, i, NULL));
				
				NSDictionary *GIFDic = nil;
				
				if(imageCount > 1){
					NSNumber *GIFDelayTime  = [[properties objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary] objectForKey:(__bridge NSString *)kCGImagePropertyGIFUnclampedDelayTime];
					GIFDic = @{
							   (__bridge NSString *)kCGImagePropertyGIFDictionary:@{
									   (__bridge NSString *)kCGImagePropertyGIFDelayTime:GIFDelayTime ? GIFDelayTime : @(0.1),
									   },
							   };
				}
				CGImageDestinationAddImage(thumbImageDestination, thubmImage, (CFDictionaryRef)GIFDic);
				CGImageRelease(thubmImage);
			}
			
			CGImageDestinationFinalize(thumbImageDestination);
			CFRelease(thumbImageDestination);
			
			CFRelease(imageSourceRef);
		}
	}
	
	return thumbImageData;
}

+(NSString *)fileSizeStringWithFileSize:(long long)fileSize{
	NSArray *sizeDes = @[@"B",@"KB",@"M",@"G"];
	int i = 1;
	for (; i < sizeDes.count; i ++)
	{
		if(fileSize < (1 << (i * 10)))
		{
			break;
		}
	}
	return [NSString stringWithFormat:@"%.0lf%@",(fileSize * 1.0) / (1 << (i - 1) * 10 ),sizeDes[i - 1]];
}

#pragma mark - message parse

+(NSArray<CWParseRegularExpression *> *)parseRegularExpressions{
	static NSMutableArray *PREs = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		PREs = [NSMutableArray arrayWithObjects:[CWParseRegularExpression parseRegularExpressionWithParseType:CWParseNodeTypeEmoji andRegularExpression:@"\\[([\u4e00-\u9fa5|OK|NO]+)\\]"],
				[CWParseRegularExpression parseRegularExpressionWithParseType:CWParseNodeTypeAt andRegularExpression:@"@\\{cube:[^,]*,name:[^\\}]*\\}"],
				[CWParseRegularExpression parseRegularExpressionWithParseType:CWParseNodeTypeAtAll andRegularExpression:@"@\\{group:[^,]*,name:[^\\}]*\\}"],
				[CWParseRegularExpression parseRegularExpressionWithParseType:CWParseNodeTypeLink andRegularExpression:@"(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]"],
				nil];
	});
	return PREs;
}

+(CWParseInfo *)parseInfoWithMessage:(CubeMessageEntity *)msg{
	CWParseInfo *parse = nil;
	if(msg.type == CubeMessageTypeText)
	{
		CubeTextMessage *message = (id)msg;
		parse = [CWParseInfo new];
		
		parse.nodes = [self nodesWithRegularExpressions:[self parseRegularExpressions] andCurrentIndex:0 forTextNode:[CWParseNode nodeWithType:CWParseNodeTypeText andRange:NSMakeRange(0, message.content.length) andOriginalText:message.content]];
	}
	return parse;
}

+(NSMutableArray<CWParseNode *> *)nodesWithRegularExpressions:(NSArray<CWParseRegularExpression *> *)RegularExpressions andCurrentIndex:(int)currentIndex forTextNode:(CWParseNode *)textNode{
	if(textNode.type == CWParseNodeTypeText && currentIndex < RegularExpressions.count)
	{
		NSArray *results = [[NSRegularExpression regularExpressionWithPattern:RegularExpressions[currentIndex].regularExpression options:NSRegularExpressionCaseInsensitive error:nil] matchesInString:textNode.originalText options:NSMatchingReportCompletion range:NSMakeRange(0, textNode.originalText.length)];
		if(results.count)
		{
			NSMutableArray *nodes = [NSMutableArray array];
			int locate = 0;
			for (NSTextCheckingResult *result in results) {
				if(result.range.location > locate)
				{
					NSRange range = NSMakeRange(locate, result.range.location - locate);
					CWParseNode *temptextNode = [CWParseNode nodeWithType:CWParseNodeTypeText andRange:range andOriginalText:[textNode.originalText substringWithRange:range]];
					NSMutableArray *subNodes = [self nodesWithRegularExpressions:RegularExpressions andCurrentIndex:currentIndex + 1 forTextNode:temptextNode];
					[nodes addObjectsFromArray:subNodes];
				}
				CWParseNode *node = [CWParseNode nodeWithType:RegularExpressions[currentIndex].parseType andRange:result.range andOriginalText:[textNode.originalText substringWithRange:result.range]];
				[node prepareUserInfo];
				[nodes addObject:node];
				locate = result.range.location + result.range.length;
			}
			if(textNode.originalText.length - 1 > locate)
			{
				NSRange range = NSMakeRange(locate, textNode.range.length - locate);
				CWParseNode *temptextNode = [CWParseNode nodeWithType:CWParseNodeTypeText andRange:range andOriginalText:[textNode.originalText substringWithRange:NSMakeRange(locate, textNode.originalText.length - locate)]];
				NSMutableArray *subNodes = [self nodesWithRegularExpressions:RegularExpressions andCurrentIndex:currentIndex + 1 forTextNode:temptextNode];
				[nodes addObjectsFromArray:subNodes];
			}
			return nodes;
		}
		else
		{
			return [self nodesWithRegularExpressions:RegularExpressions andCurrentIndex:currentIndex + 1 forTextNode:textNode];
		}
	}
	else
	{
		return [NSMutableArray arrayWithObjects:textNode, nil];
	}
}

+(NSMutableDictionary *)parseAtString:(NSString *)atString{
	NSMutableDictionary *dic = nil;
	NSArray<NSString *> *compents = [atString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{},:"]];
	if(compents.count == 6)
	{
		dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:compents[2], compents[1], compents[4], compents[3], nil];
	}
	return dic;
}

+ (CubeCustomMessage *)customAVMessageWithSession:(CubeCallSession *)session andText:(NSString *)text andIsVideo:(BOOL)isVideo
{
    CubeUser *receiver = [[CubeUser alloc] init];
    CubeUser *sender = [[CubeUser alloc] init];
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setValue:@"chat" forKey:@"type"];
    [header setValue:isVideo?@"videoCall":@"voiceCall" forKey:@"operate"];
    [header setValue:text forKey:@"body"];

    CubeCustomMessage *customAVMsg = [[CubeCustomMessage alloc]initWithHeader:header expires:-1 andSender:sender receiver:receiver];
    customAVMsg.SN = [NSDate date].timeIntervalSince1970;
    customAVMsg.status = CubeMessageStatusSending;
    customAVMsg.body = text;
    if (session.callDirection == CubeCallDirectionOutgoing)
    {
        receiver.cubeId = session.callee.cubeId;
        receiver.displayName = session.callee.displayName;
        sender.cubeId = session.caller.cubeId;
        sender.displayName = session.caller.displayName;
        customAVMsg.messageDirection = CubeMessageDirectionSent;
    }else if (session.callDirection == CubeCallDirectionIncoming)
    {
        receiver.cubeId = session.caller.cubeId;
        receiver.displayName = session.caller.displayName;
        sender.cubeId = session.callee.cubeId;
        sender.displayName = session.callee.displayName;
        customAVMsg.messageDirection = CubeMessageDirectionReceived;
    }
    customAVMsg.sender = sender;
    customAVMsg.receiver = receiver;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval inter = [dat timeIntervalSince1970]*1000;
    customAVMsg.sendTime = inter;
    customAVMsg.receiptTimestamp = inter;
    return customAVMsg;
}

+(CubeCustomMessage *)customMessageWithWhiteBoard:(CubeWhiteBoard *)whiteboard fromUser:(CubeUser *)user andContent:(NSString *)content
{
    if (whiteboard.maxNumber == 2)//一对一
    {
        NSMutableDictionary *header = [NSMutableDictionary dictionary];
        [header setValue:@"notify" forKey:@"type"];
        [header setValue:content forKey:@"operate"];
        [header setValue:whiteboard.founder forKey:@"userCube"];
        CubeUser *sender = [[CubeUser alloc]init];
        CubeUser *reciever = [[CubeUser alloc]init];

        if (user) {
            sender.cubeId = user.cubeId;
            sender.displayName = user.displayName;
        }
        else
        {
            sender.cubeId = whiteboard.founder;
        }

        CubeGroupMember *member = whiteboard.members.firstObject;
        if(!member)
        {
            member = whiteboard.invites.firstObject;
        }
        reciever.cubeId = member.cubeId;
        reciever.displayName = member.displayName;

        CubeCustomMessage *customMessage = [[CubeCustomMessage alloc]initWithHeader:header expires:-1 andSender:sender receiver:reciever];
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval inter = [dat timeIntervalSince1970]*1000;
        customMessage.SN = [NSDate date].timeIntervalSince1970;
        customMessage.status = CubeMessageStatusSending;
        customMessage.body = @"白板请求";
        customMessage.sendTime = inter;
        customMessage.receiptTimestamp = inter;
        customMessage.sender = sender;
        customMessage.receiver = reciever;
        if ([sender.cubeId isEqualToString:[CWUserModel currentUser].cubeId]) {
            customMessage.messageDirection = CubeMessageDirectionSent;
        }
        else
        {
            customMessage.messageDirection = CubeMessageDirectionReceived;
        }
        return customMessage;
    }
    return nil;
}

+ (BOOL)isExistFile:(CubeFileMessage *)fileMessage andAddition:(NSString *)addtion
{
    NSString *path = [CubeFileUtil filePathForUrl:fileMessage.url withAddtionalPath:[NSString stringWithFormat:@"%@/%@",[CubeUser currentUser].cubeId,addtion]];
    if (path && path.length >0) {
        return YES;
    }
    return NO;
}

+ (NSString *)saveFilePath:(CubeFileMessage *)fileMessage andAddition:(NSString *)addtion
{
    NSString *identified = [CubeFileUtil fileIdentifierFor:[NSData dataWithContentsOfFile:fileMessage.filePath]];
    NSString *path = [CubeFileUtil saveFile:[NSData dataWithContentsOfFile:fileMessage.filePath] withAddtionalPath:[NSString stringWithFormat:@"%@/%@",[CubeUser currentUser].cubeId,addtion]];
    BOOL ret = [CubeFileUtil createlinkTo:identified for:fileMessage.url withAddtionalPath:[NSString stringWithFormat:@"%@/%@",[CubeUser currentUser].cubeId,addtion]];
    if (ret) {
        return path;
    }
    return nil;
}

+ (NSString *)getFilePath:(CubeFileMessage *)fileMessage andAddition:(NSString *)addtion
{
    NSString *path = [CubeFileUtil filePathForUrl:fileMessage.url withAddtionalPath:[NSString stringWithFormat:@"%@/%@",[CubeUser currentUser].cubeId,addtion]];
    return path;
}
@end
