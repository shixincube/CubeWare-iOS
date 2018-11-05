//
//  CWMessageUtil.h
//  CubeWare
//
//  Created by jianchengpan on 2018/1/2.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWTimeUtil.h"
#import "CWCustomMessageType.h"
#import "CubeWareHeader.h"

#import "CWParseInfo.h"

@class CWSession;
@interface CWMessageUtil : NSObject

#pragma mark - createMessage


+(CubeCustomMessage *)tipMessageWithContent:(NSString *)content forSession:(CWSession *)session;
/**
 创建音频消息

 @param path
 @param durations 音频路径
 @param session 所属回话
 @return 音频消息
 */
+(CubeVoiceClipMessage *)voiceClipMessageWithFilePath:(NSString *)path andDuration:(long long)durations forSession:(CWSession *)session;


/**
  创建视频消息

 @param path 视频路径
 @param thumbPath 视频缩略图
 @param name 视频名称
 @param size 视频尺寸
 @param durations 时长
 @param session 所属回话
 @return 视频消息
 */
+(CubeVideoClipMessage *)videoClipMessageWithFilePath:(NSString *)path andThumbPath:(NSString *)thumbPath andName:(NSString *)name andSize:(CGSize)size andDuration:(long long)durations forSession:(CWSession *)session;

/**
 构造图片消息

 @param path 原图路径
 @param thumbPath 缩略图路径
 @param name 图片名称
 @param filesize 图片大小
 @param size 图片尺寸
 @param session 消息会话
 @return 图片消息
 */
+ (CubeImageMessage *)imageMessageWithPath:(NSString *)path andThumbPath:(NSString *)thumbPath andName:(NSString *)name andFileSize:(CGFloat)filesize andSize:(CGSize)size forSession:(CWSession *)session;
/**
 构造文件消息e

 @param path 文件路径
 @param name 文件名称
 @param session 消息会话
 @return 文件消息
 */
+(CubeFileMessage *)fileMessageWithPath:(NSString *)path andName:(NSString *)name forSession:(CWSession *)session;

/**
 构造抖动消息自定义消息

 @param session 消息会话
 @return 抖动消息（自定义消息）
 */
+(CubeCustomMessage *)shakeCustomMessageForSession:(CWSession *)session;

///**
// 音视频处理相关的消息
//
// @param session 消息会话
// @param body 消息内容
// @param customMsgType 消息类型，
// @return 音视频处理相关的消息（自定义消息）
// */
//+(CubeCustomMessage *)avMsgCustomMessageForSession:(CubeSession *)session body:(NSString *)body type:(CWCustomMessageType)customMsgType;

/**
 构造音视频通话通知类消息

 @param session 消息会话
 @param text 消息内容
 @return 消息
 */
+ (CubeCustomMessage *)customAVMessageWithSession:(CubeCallSession *)session andText:(NSString *)text andIsVideo:(BOOL)isVideo;

/**
  构造白板通话通知类消息

 @param whiteboard 白板
 @param user 用户
 @param content 内容
 @return 消息
 */
+(CubeCustomMessage *)customMessageWithWhiteBoard:(CubeWhiteBoard *)whiteboard fromUser:(CubeUser *)user andContent:(NSString *)content;
#pragma mark - custom message type

+(NSString *)customMessageTypeStringFromType:(CWCustomMessageType)type;

+(CWCustomMessageType)customMessageTypeFromString:(NSString *)typeString;

+(CWCustomMessageType)customMessageTypeForMessage:(CubeCustomMessage *)msg;

#pragma mark - image

/**
 更具提供的尺寸，获取文件的显示尺寸
 
 @param originSize 待计算的尺寸
 @return 显示尺寸
 */
+(CGSize)fileDisplaySizeForOriginSize:(CGSize)originSize;

/**
 压缩图片

 @param imageData 带压缩的数据
 @param maxWidthOrHeight 压缩过后最大的宽和高
 @return 压缩后的数据
 */
+(NSData *)getThumbImageDataWithImageData:(NSData *)imageData andMaxWidthOrHeight:(CGFloat)maxWidthOrHeight;

/**
 获取文件大小字符串

 @param fileSize 文件大小(Byte)
 @return 文件大小字符串
 */
+(NSString *)fileSizeStringWithFileSize:(long long )fileSize;

#pragma mark - message parse

/**
 获取消息的解析内容

 @param msg 待解析的消息
 @return 解析消息，无法解析则为空
 */
+(CWParseInfo *)parseInfoWithMessage:(CubeMessageEntity *)msg;

/**
 解析@字符串
 
 @param atString @字符串
 @return 解析后的字典
 */
+(NSMutableDictionary *)parseAtString:(NSString *)atString;


/**
 下载文件是否存在

 @param fileMessage 文件消息
 @param addtion 文件夹  File 、Image 、Video 、Voice
 @return 存在YES 不存在NO
 */
+ (BOOL)isExistFile:(CubeFileMessage *)fileMessage andAddition:(NSString *)addtion;

/**
 存储已下载文件

 @param fileMessage 文件消息
 @param addtion 文件夹  File 、Image 、Video 、Voice
 @return 存储成功返回存储路径，失败则返回nil
 */
+ (NSString *)saveFilePath:(CubeFileMessage *)fileMessage andAddition:(NSString *)addtion;

/**
 获取已下载文件

 @param fileMessage 文件消息
 @param addtion  文件夹  File 、Image 、Video 、Voice
 @return 文件路径
 */
+ (NSString *)getFilePath:(CubeFileMessage *)fileMessage andAddition:(NSString *)addtion;
@end
