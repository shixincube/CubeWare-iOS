//
//  CWParseNode.m
//  SPCubeWareDev
//
//  Created by jianchengpan on 2018/4/8.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import "CWParseNode.h"
#import "CWMessageUtil.h"

@implementation CWParseNode

+(CWParseNode *)nodeWithType:(CWParseNodeType)type andRange:(NSRange)range andOriginalText:(NSString *)originalText{
	CWParseNode *node = [CWParseNode new];
	
	node.type = type;
	node.range = range;
	node.originalText = originalText;
	
	return node;
}

-(void)setValue:(id)value forKey:(NSString *)key{
	if([key isEqualToString:@"range"] && [value isKindOfClass:[NSString class]])
	{
		self.range = NSRangeFromString(value);
	}
	else
	{
		[super setValue:value forKey:key];
	}
}

-(void)prepareUserInfo{
	if(self.type == CWParseNodeTypeAt || self.type == CWParseNodeTypeAtAll)
	{
		self.userInfo = [CWMessageUtil parseAtString:self.originalText];
	}
}

#pragma mark - CubeJsonObject
+ (id)fromDictionary:(NSDictionary *)dic{
	return [CubeJsonUtil generateObjectOfClass:[self class] fromDictionary:dic];
}

-(NSMutableDictionary *)toDictionary{
	return [CubeJsonUtil translateObjectToDictionay:self];
}

-(id)valueForProperty:(NSString *)property{
	if([property isEqualToString:@"range"])
	{
		return NSStringFromRange(self.range);
	}
	return [self valueForKey:property];
}

-(void)setValue:(id)value forProperty:(NSString *)property{
	if([property isEqualToString:@"range"]){
		self.range = NSRangeFromString(value);
		return;
	}
	[self setValue:value forKey:property];
}

@end
