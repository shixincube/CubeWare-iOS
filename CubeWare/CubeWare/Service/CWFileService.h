//
//  CWFileService.h
//  CubeWare
//
//  Created by Ashine on 2018/9/3.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CWFileServiceDelegate <NSObject>



/**
 文件服务错误回调(包含了上传、下载、暂停、取消等操作过程中的错误)

 @param message 文件消息
 @param error 错误对象(包含错误码即错误信息)
 */
- (void)onFileServiceFailed:(CubeFileMessage *)message andError:(CubeError *)error;

#pragma mark - upload delegate

/**
 文件上传成功回调

 @param message 文件消息
 */
- (void)onFileUploadSuccess:(CubeFileMessage *)message;


/**
 文件上传进度回调

 @param message 文件消息
 @param progress 进度回调
 */
- (void)onFileUploadProgress:(CubeFileMessage *)message progress:(NSProgress *)progress;


/**
 文件上传暂停成功回调

 @param message 文件消息
 */
- (void)onFileUploadPauseSuccess:(CubeFileMessage *)message;


/**
 文件上传取消成功回调

 @param message 文件消息
 */
- (void)onFileUploadCancelSuccess:(CubeFileMessage *)message;



#pragma mark - download delegate


/**
 文件下载成功回调

 @param message 文件消息
 */
- (void)onFileDownloadSuccess:(CubeFileMessage *)message;

/**
 文件下载进度回调

 @param message 文件消息
 @param progress 进度回调
 */
- (void)onFileDownloadProgress:(CubeFileMessage *)message progress:(NSProgress *)progress;

@end


@interface CWFileService : NSObject


/**
 CWFileServiceDelegate协议 代理
 */
@property (nonatomic,weak) id<CWFileServiceDelegate> delegate;

#pragma mark - Upload file api

/**
 上传文件消息中的文件

 @param message 文件消息
 */
- (void)startUploadFileWithFileMessage:(CubeFileMessage *)message;


/**
 暂停上传文件

 @param message 文件消息
 */
- (void)pauseUploadFileWithFileMessage:(CubeFileMessage *)message;


/**
 取消上传文件

 @param message 文件消息
 */
- (void)cancelUploadFileWithFileMessage:(CubeFileMessage *)message;

#pragma mark - Download file api


/**
 下载文件消息中的文件

 @param message 文件消息
 */
- (void)startDownloadFileWithFileMessage:(CubeFileMessage *)message andBlock:(void(^)(CubeFileMessage * message))block;


// continue implementation...
//- (void)pauseDownloadFileWithFileMessage:(CubeFileMessage *)message;
//
//- (void)resumeDownloadFileWithFileMessage:(CubeFileMessage *)message;
//
//- (void)cancelDownloadFileWithFileMessage:(CubeFileMessage *)message;






@end
