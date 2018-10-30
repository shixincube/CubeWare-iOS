//
//  CWUtils.h
//  CubeWare

//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWNetworkUpdateType.h"
@interface CWUtils : NSObject

/**
 获取会议错误描述

 @param code 错误码
 @return 错误描述文字
 */
+ (NSString *)conferenceErrorWithCode:(CubeErrorType)code;

/**
 显示loaing加载
 */
+ (void)showLoadingHud;

/**
 隐藏loading加载
 */
+ (void)hideLoadingHud;

/**
 返回高度

 @param width 宽度
 @param font 字体
 @param title 文字
 @return 高度
 */
+ (CGFloat)heigthWithwidth:(CGFloat)width font:(CGFloat)font andTitle:(NSString *)title;

/**
 返回宽度

 @param height 高度
 @param font 字体大小
 @param title 文字
 @return 宽度
 */
+ (CGFloat)widthWithheight:(CGFloat)height font:(CGFloat)font andTitle:(NSString *)title;

///**
// 返回当前网络状态
//
// @param newstate 视频通话状态
// @return 连接状态
// */
//+ (CWNetworkUpdateType)groupAVNetWorkTypeWithCubeMediaQuality:(CubeMediaQuality)newstate;

/**
 * 图片等比缩放尺寸
 * @param imgRect 图片原始尺寸
 * @param ratio 缩放比例  0-1
 * @param bounds 视图bounds
 * @return CGRect 图片缩放之后的尺寸
 */
+ (CGRect)rectWithImageRect:(CGRect)imgRect ratio:(float)ratio inBounds:(CGRect)bounds;

/**
 缩小图片

 @param image 原图
 @param maxResolution 最大尺寸
 @return 图片
 */
+ (UIImage *)scaleAndRotateImage:(UIImage *)image maxResolution:(int)maxResolution;

/**
 计算图片尺寸

 @param originalSize 原图尺寸
 @param limit 限制
 @return 尺寸
 */
+ (CGSize)resizeImageSize:(CGSize)originalSize withLimit:(CGFloat)limit;

/**
 根据当前时间生成图片名称

 @return 名
 */
+ (NSString *)fileNameFromCurrentDate;

/**
 压缩图片质量

 @param image 原图
 @param isOriginal 是否选择了原图
 @return 压缩后
 */
+ (NSData *)compressImageData:(UIImage *)image isOriginal:(BOOL)isOriginal;

/**
 窗体

 @return window
 */
+ (UIWindow *)CWKeyWindow;

/**
 替换编码

 @param originStr 原始string
 @return 转码后
 */
+ (NSString *)replaceUnicode020eCharOfString:(NSString *)originStr;

+ (BOOL)is24HourSystem;

+ (NSString *)showTime:(NSTimeInterval)msglastTime showDetail:(BOOL)showDetail is24HourSystem:(BOOL)is24HourSystem;

+ (NSString *)getPeriodOfTime:(NSInteger)time withMinute:(NSInteger)minute;

/**
 获取文件路径

 @param name 文件夹名称
 @return 完整路径
 */
+ (NSString *)subFolderAtDocumentWithName:(NSString *)name;

/**
文件大小转换为字符串

 @param filesize 大小
 @return 字符串
 */
+ (NSString *)stringForamtWithFileSize:(long long)filesize;



/**
 获取图片的后缀

 @param fileName 文件路径
 @return 后缀
 */
+ (NSString *)fileExtensionFromFileName:(NSString *)fileName;

/**
 转化为时间格式

 @param time  时间
 @return 00:00 OR 00：00:00
 */
+ (NSString *)convertToTime:(long long)time;

/**
 通过文件名获取文件需要显示的图标

 @param fileName 文件名
 @return 需要显示图标名字
 */
+(NSString *)getImageWithFileName:(NSString *)fileName;
@end
