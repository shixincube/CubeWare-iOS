//
//  CWEmojiResourceUtil.h
//  CWRebuild
//
//  Created by luchuan on 2018/1/3.
//  Copyright © 2018年 luchuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWEmojiModel.h"

#import <FLAnimatedImage/FLAnimatedImage.h>

@interface CWEmojiResourceUtil : NSObject

/**
 删除按钮图片

 @return 路径
 */
+(NSString *)getDeleteImagePath;
/**
 删除按钮高亮图片

 @return 路径
 */
+(NSString *)getDeletHighLightImagePath;
/**
 获取png图片

 @param name png图片名
 @return 路径
 */
+(NSString *)getEmojiPngPathWithName:(NSString *)name;
/**
 获取gif动图

 @param name git图片名
 @return 路径
 */
+(NSString *)getEmojiGifPathWithName:(NSString *)name;
/**
 获取plist 文件

 @return 路径
 */
+(NSString *)getEmojiPlistPath;
/**
 获取plist文件的数组

 @return plist 解析数组
 */
+(NSArray *)getEmojiPlistArr;
/**
 获取icon图标

 @return 路径
 */
+(NSString *)getIconPath;

+(BOOL)isSystemEmoji:(NSString *)imageName;

/**
 通过表情名获取表情

 @param emojiName 表情名
 @return 表情模型
 */
+ (CWEmojiModel *)getEmojiByEmojiName:(NSString *)emojiName;
/**
 通过表情KE月获取表情

 @param emojiKey emojkey
 @return 表情模型
 */
+ (CWEmojiModel *)getEmojiByEmojiKey:(NSString *)emojiKey;

#pragma mark - GIF Image

/**
 获取GIF图片

 @param emojiName 表情名  "[emojiName]"
 @return 表情图片
 */
+(FLAnimatedImage *)gifEmojiWithName:(NSString *)emojiName;

@end
