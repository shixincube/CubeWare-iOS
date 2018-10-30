//
//  CWResourceUtil.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/28.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Masonry.h>


typedef enum : NSUInteger {
    MessageFolderFileType,
    MessageFolderImageType,
    MessageFolderVideoType,
    MessageFolderVoiceType,
} MessageFolderType;

@interface CWResourceUtil : NSObject

/**
 获取资源bundle
 
 @return 资源bundle
 */
+(NSBundle *)resourceBundle;

/**
 获取资源bundle里面的图片资源

 @param imageName 图片名
 @return 图片
 */
+(UIImage *)imageNamed:(NSString *)imageName;

/**
 
 获取音频类资源路径
 @param name 文件名
 @param type 文件类型
 @return 路径
 */
+(NSURL *)audioResourceUrl:(NSString *)name andType:(NSString *)type;


+ (NSString *)engineFolder;

+ (NSString *)folderWithMessageType:(MessageFolderType)type;
@end
