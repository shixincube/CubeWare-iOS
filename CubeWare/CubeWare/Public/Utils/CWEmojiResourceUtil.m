//
//  CWEmojiResourceUtil.m
//  CWRebuild
//
//  Created by luchuan on 2018/1/3.
//  Copyright © 2018年 luchuan. All rights reserved.
//

#import "CWEmojiResourceUtil.h"
#import "CWEmojiModel.h"
@implementation CWEmojiResourceUtil

static NSMutableDictionary *GIFEmojiCache = nil;

+(void)load{
	[super load];
	[self cacheGifImage];
}

#pragma mark - GIF Image

+(void)cacheGifImage{
	NSArray *emojiArr = [self getEmojiPlistArr];
	GIFEmojiCache = [NSMutableDictionary dictionary];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		for (NSDictionary *dic in emojiArr) {
			NSString *key = [dic objectForKey:@"chs"];
			NSString *filePath = [CWEmojiResourceUtil getEmojiGifPathWithName:dic[@"gif"]];
			[GIFEmojiCache setValue:[FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:filePath]] forKey:key];
		}
	});
}

+(FLAnimatedImage *)gifEmojiWithName:(NSString *)emojiName{
	return [GIFEmojiCache objectForKey:emojiName];
}

#pragma mark - 加载本地表情
+(NSString *)emojiBundlePath{
    static NSString * budlePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        budlePath = [[NSBundle mainBundle] pathForResource:@"CubeWareEmoticon" ofType:@"bundle"];
    });
    return budlePath;
}
+(NSString *)emojiResourcePath{
    static NSString * emojiPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emojiPath = [[self emojiBundlePath] stringByAppendingPathComponent:@"Emoji"];
    });
    return emojiPath;
}

+(NSString *)cw_emojiPath{
    static NSString *cw_emijPth = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cw_emijPth = [[self emojiResourcePath] stringByAppendingPathComponent:@"cw_emoji"];
    });
    return cw_emijPth;
}
+(NSString *)getDeleteImagePath{
    return [[self emojiBundlePath] stringByAppendingPathComponent:@"emotion_delete"];
}
+(NSString *)getDeletHighLightImagePath{
    return [[self emojiBundlePath] stringByAppendingPathComponent:@"emotion_delete_highlighted"];
}
+(NSString *)getEmojiPngPathWithName:(NSString *)name{
    return [[self cw_emojiPath] stringByAppendingPathComponent:name];
}

+(NSString *)getEmojiGifPathWithName:(NSString *)name{
    return [[self cw_emojiPath]  stringByAppendingPathComponent:name];
}

+(NSString *)getEmojiPlistPath{
    return [[self cw_emojiPath] stringByAppendingPathComponent:@"emotion.plist"];
}
+(NSArray *)getEmojiPlistArr{
    return [NSArray arrayWithContentsOfFile:[self getEmojiPlistPath]];
}

+(NSString *)getIconPath{
    return [[[self cw_emojiPath] stringByAppendingPathComponent:@"icon"] stringByAppendingPathComponent:@"cube_ware_emoji_normal"];
}

/**
 判断是否是系统表情

 @param emojiName 中文描述 ps : [微信]
 @return yes为系统表情
 */
+(BOOL)isSystemEmoji:(NSString *)emojiName{
    NSArray * arr = [self getEmojiPlistArr];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chs = %@",emojiName];
    NSArray * resultArr =[arr filteredArrayUsingPredicate:predicate];
    if(resultArr.count > 0){
        return YES;
    }
    return NO;
}

+ (CWEmojiModel *)getEmojiByEmojiName:(NSString *)emojiName{
    NSArray *emojiArr = [self getEmojiPlistArr];
    __block CWEmojiModel * emojiModel = nil;
    [emojiArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj[@"chs"] isEqualToString:emojiName]){
            CWEmojiModel *model = [[CWEmojiModel alloc] init];
            model.name = obj[@"chs"];
            model.thumbName = obj[@"png"];
            model.fileName = obj[@"gif"];
            model.thumbPath = [CWEmojiResourceUtil getEmojiPngPathWithName:model.thumbName];
            model.filePath = [CWEmojiResourceUtil getEmojiGifPathWithName:model.fileName];
            model.key = obj[@"key"];
            model.emojiType = CWEmojiModelTypeSystemEmoji;
            emojiModel = model;
            *stop = YES;
        }
    }];
    return emojiModel;
}

+ (CWEmojiModel *)getEmojiByEmojiKey:(NSString *)emojiKey{
    NSArray *emojiArr = [self getEmojiPlistArr];
    __block CWEmojiModel * emojiModel = nil;
    [emojiArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj[@"key"] isEqualToString:emojiKey]){
            CWEmojiModel *model = [[CWEmojiModel alloc] init];
            model.name = obj[@"chs"];
            model.thumbName = obj[@"png"];
            model.fileName = obj[@"gif"];
            model.thumbPath = [CWEmojiResourceUtil getEmojiPngPathWithName:model.thumbName];
            model.filePath = [CWEmojiResourceUtil getEmojiGifPathWithName:model.fileName];
            model.key = obj[@"key"];
            model.emojiType = CWEmojiModelTypeSystemEmoji;
            emojiModel = model;
            *stop = YES;
        }
    }];
    return emojiModel;
}

@end
