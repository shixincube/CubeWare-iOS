//
//  MessageEntity+CWMessage.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/26.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CubeMessageEntity+CWMessage.h"
#import "CWSessionUtil.h"

#import <objc/runtime.h>

static const char *sessionIdKey = "CWMessageSessionIdKey";

static const char *needShowKey = "CWMessageNeedShowKey";

static const char *parsInfoKey = "CWMessageParsInfoKey";

@implementation CubeMessageEntity (CWMessage)

#pragma mark - CubeJsonObject
+(NSArray<NSString *> *)ignoredProperties{
	return @[@"beginSendTime",@"lastestSendTime",@"json",@"parseInfo"];
}

#pragma mark - jsonprotocol
-(NSString *)json{
    NSMutableDictionary *dic = [self toDictionary];

	NSDictionary *parseInfoDic = [self .parseInfo toDictionary];
	if(parseInfoDic)
	{
		[dic setObject:parseInfoDic forKey:@"parseInfo"];
	}

    NSString *string = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    return string ? string : @"";
}

-(void)setJson:(NSString *)json{
    if(json)
    {
        NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
		NSDictionary *parseInfoDic = [jsonDic objectForKey:@"parseInfo"];
		self.parseInfo = [CWParseInfo fromDictionary:parseInfoDic];
    }
}

-(void)setSessionId:(NSString *)sessionId{
    objc_setAssociatedObject(self, sessionIdKey, sessionId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)sessionId{
    NSString *sessionId = objc_getAssociatedObject(self, sessionIdKey);
    if (!sessionId)
        sessionId = [CWSessionUtil sessionIdForMessage:self];
    return sessionId;
}

-(void)setParseInfo:(CWParseInfo *)parseInfo{
	objc_setAssociatedObject(self, parsInfoKey, parseInfo, OBJC_ASSOCIATION_RETAIN);
}

- (CWParseInfo *)parseInfo{
	return objc_getAssociatedObject(self, parsInfoKey);
}

-(void)setNeedShow:(BOOL)needShow{
	objc_setAssociatedObject(self, needShowKey, @(needShow), OBJC_ASSOCIATION_COPY);
}

-(BOOL)needShow{
	return [objc_getAssociatedObject(self, needShowKey) boolValue];
}

+(instancetype)objectWithJson:(NSString *)jsonString{
    CubeMessageEntity *message = nil;
    
    if(jsonString)
    {
        NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        message = [CubeMessageEntity fromDictionary:jsonDic];
    }
    return message;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
	
}

-(id)valueForUndefinedKey:(NSString *)key{
	return nil;
}

@end
