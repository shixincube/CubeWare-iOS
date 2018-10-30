//
//  CWParseInfo.m
//  SPCubeWareDev
//
//  Created by jianchengpan on 2018/4/8.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import "CWParseInfo.h"
#import "CWEmojiResourceUtil.h"

@implementation CWParseInfo

-(void)prepairAttibuteLabel{
	if(!self.nodes || (self.nodes.count == 1 && self.nodes.firstObject.type == CWParseNodeTypeText))
	{
		self.attributeLabel = nil;
		self.attibuteLabeSize = CGSizeZero;
	}
	else
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			self.attributeLabel = [[M80AttributedLabel alloc] init];
			self.attributeLabel.tag = ParseInfoAttibuteLabelTag;
			self.attributeLabel.backgroundColor = [UIColor clearColor];
			self.attributeLabel.font = [UIFont systemFontOfSize:TextFontSize];
			self.attributeLabel.linkColor = ParseInfoURLColor;
		});		
		
		for (CWParseNode *node in self.nodes) {
			switch (node.type) {
				case CWParseNodeTypeAt:
				case CWParseNodeTypeAtAll:
				{
					dispatch_async(dispatch_get_main_queue(), ^{
						[self.attributeLabel appendText:[NSString stringWithFormat:@"@%@",node.userInfo[@"name"]]];
					});
					break;
				}
				case CWParseNodeTypeEmoji:
				{
					FLAnimatedImage *emoji = [CWEmojiResourceUtil gifEmojiWithName:node.originalText];
					if(emoji)
					{
						dispatch_async(dispatch_get_main_queue(), ^{
							FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, EmojiSize, EmojiSize)];
							imageView.runLoopMode = NSDefaultRunLoopMode;
							imageView.animatedImage = emoji;
							[self.attributeLabel appendView:imageView margin:UIEdgeInsetsZero alignment:M80ImageAlignmentCenter];
						});
						break;
					}
				}
				default:
				{
					dispatch_async(dispatch_get_main_queue(), ^{
						[self.attributeLabel appendText:node.originalText];
					});
					break;
				}
			}
		}
		dispatch_async(dispatch_get_main_queue(), ^{
			CGFloat width = [self.attributeLabel.attributedText boundingRectWithSize:CGSizeMake(bubbleMaxWidth - 24, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
			CGFloat hegit = [self.attributeLabel sizeThatFits:CGSizeMake(bubbleMaxWidth - 24, CGFLOAT_MAX)].height;
			_attibuteLabeSize = CGSizeMake(ceil(width), hegit);
		});
	}
}

#pragma mark - cubeJsonObject
+(NSArray<NSString *> *)ignoredProperties{
	return @[@"attributeLabel",@"attibuteLabeSize"];
}

+(id)fromDictionary:(NSDictionary *)dic{
	return [CubeJsonUtil generateObjectOfClass:[self class] fromDictionary:dic];
}

-(NSMutableDictionary *)toDictionary{
	return [CubeJsonUtil translateObjectToDictionay:self];
}

-(id)valueForProperty:(NSString *)property{
	if([property isEqualToString:@"nodes"])
	{
		NSMutableArray *array = [NSMutableArray array];
		for (CWParseNode *node in self.nodes) {
			NSDictionary *dic = [node toDictionary];
			if(dic)
			{
				[array addObject:dic];
			}
		}
		return array;
	}
	else{
		return [self valueForKey:property];
	}
}

-(void)setValue:(id)value forProperty:(NSString *)property{
	id newValue = value;
	if([property isEqualToString:@"nodes"])
	{
		if([(NSArray *)value count])
		{
			newValue = [NSMutableArray array];
			for (NSDictionary *dic in value) {
				CWParseNode *node = [CWParseNode fromDictionary:dic];
				if(node)
				{
					[newValue addObject:node];
				}
			}
		}
	}
	[self setValue:newValue forKey:property];
}

@end
