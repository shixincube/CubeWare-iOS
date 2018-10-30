//
//  CWFileService.m
//  CubeWare
//
//  Created by Ashine on 2018/9/3.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CWFileService.h"
#import "CWResourceUtil.h"


@implementation CWFileService


- (instancetype)init{
    if (self == [super init]) {
        
    }
    return self;
}


#pragma mark - pravite
- (BOOL)isFileMessageType:(CubeFileMessage *)message{
    if (message.type == CubeMessageTypeFile ||
        message.type == CubeMessageTypeImage ||
        message.type == CubeMessageTypeVideoClip ||
        message.type == CubeMessageTypeVoiceClip) {
        return YES;
    }
    return NO;
}


- (NSString *)resourcePathWithMessage:(CubeFileMessage *)message{
    NSString *resourcePath;
    if (message.type == CubeMessageTypeFile) {
        resourcePath = [CWResourceUtil folderWithMessageType:MessageFolderFileType];
    }
    else if (message.type == CubeMessageTypeImage){
        resourcePath = [CWResourceUtil folderWithMessageType:MessageFolderImageType];
    }
    else if (message.type == CubeMessageTypeVideoClip){
        resourcePath = [CWResourceUtil folderWithMessageType:MessageFolderVideoType];
    }
    else if (message.type == CubeMessageTypeVoiceClip){
        resourcePath = [CWResourceUtil folderWithMessageType:MessageFolderVoiceType];
    }
    return resourcePath;
}



#pragma mark - Upload api implementation

-(void)startUploadFileWithFileMessage:(CubeFileMessage *)message{
    if ([self isFileMessageType:message]) {
        [[CubeWare sharedSingleton].messageService processMessagesInSameSession:@[message]];
        UploadCubeFile *uploadFile = [UploadCubeFile uploadFileWithIdentify:[NSString stringWithFormat:@"%lld",message.SN] andFilePath:message.filePath andFileName:message.fileName];
        uploadFile.fileId = message.key;
        [[CubeEngine sharedSingleton].fileService startUploadFileWithCubeFile:uploadFile progress:^(NSProgress *progress) {
            message.progress = progress.completedUnitCount;
            
            for (id<CWFileServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWFileServiceDelegate)] )
            {
                if([obj respondsToSelector:@selector(onFileUploadProgress:progress:)])
                {
                    [obj onFileUploadProgress:message progress:progress];
                }
            }
        } success:^(NSDictionary *responseData) {
            NSString *fileUrl = responseData[@"fileInfo"][@"url"];
            message.url = fileUrl;
            message.md5 = responseData[@"fileInfo"][@"md5"];
            message.modified = [NSString stringWithFormat:@"%.0lf",[[NSDate date] timeIntervalSince1970] * 1000];
            message.key = responseData[@"fileInfo"][@"fileId"];
            message.fileSize = [responseData[@"fileInfo"][@"size"] longLongValue];
            
            if(message.type == CubeMessageTypeFile){
                
            }
            else if (message.type == CubeMessageTypeImage){
                int wid = ((CubeImageMessage *)message).width;
                int hei = ((CubeImageMessage *)message).height;
                NSString *thumb = [NSString stringWithFormat:@"imageView2/0/w/%d/h/%d",wid,hei];
                ((CubeImageMessage *)message).thumbUrl = [NSString stringWithFormat:@"%@?%@",fileUrl,thumb];
                
                // NSString *filePath = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject],message.fileName];
                // ((CubeImageMessage *)message).thumbPath = filePath;
            }
            else if (message.type == CubeMessageTypeVideoClip){
                // int wid = ((CubeVideoClipMessage *)message).thumbImageWidth;
                // int hei = ((CubeVideoClipMessage *)message).thumbImageHeight;
                NSString *thumb = [NSString stringWithFormat:@"vFrame/png/offset/1"];
                ((CubeVideoClipMessage *)message).thumbUrl = [NSString stringWithFormat:@"%@?%@",fileUrl,thumb];
            }
            
            
            for (id<CWFileServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWFileServiceDelegate)] )
            {
                if([obj respondsToSelector:@selector(onFileUploadSuccess:)])
                {
                    [obj onFileUploadSuccess:message];
                }
            }
            
        } failure:^(CubeError *error) {
            
            for (id<CWFileServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWFileServiceDelegate)] )
            {
                if([obj respondsToSelector:@selector(onFileServiceFailed:andError:)])
                {
                    [obj onFileServiceFailed:message andError:error];
                }
            }
        }];
    }
}


- (void)pauseUploadFileWithFileMessage:(CubeFileMessage *)message{
    if ([self isFileMessageType:message]) {
        UploadCubeFile *uploadFile = [UploadCubeFile uploadFileWithIdentify:[NSString stringWithFormat:@"%lld",message.SN] andFilePath:nil andFileName:nil];
        uploadFile.fileId  = message.key;
        [[CubeEngine sharedSingleton].fileService pauseUploadFileWithCubeFile:uploadFile success:^(NSDictionary *responseData) {
            for (id<CWFileServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWFileServiceDelegate)] )
            {
                if([obj respondsToSelector:@selector(onFileUploadPauseSuccess:)])
                {
                    [obj onFileUploadPauseSuccess:message];
                }
            }
        } failure:^(CubeError *error) {
            for (id<CWFileServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWFileServiceDelegate)] )
            {
                if([obj respondsToSelector:@selector(onFileServiceFailed:andError:)])
                {
                    [obj onFileServiceFailed:message andError:error];
                }
            }
        }];
    }
}

- (void)cancelUploadFileWithFileMessage:(CubeFileMessage *)message{
    if ([self isFileMessageType:message]) {
        UploadCubeFile *uploadFile = [UploadCubeFile uploadFileWithIdentify:[NSString stringWithFormat:@"%lld",message.SN] andFilePath:nil andFileName:nil];
        uploadFile.fileId  = message.key;
        
        [[CubeEngine sharedSingleton].fileService cancelUploadFileWithCubeFile:uploadFile success:^(NSDictionary *responseData) {
            for (id<CWFileServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWFileServiceDelegate)] )
            {
                if([obj respondsToSelector:@selector(onFileUploadCancelSuccess:)])
                {
                    [obj onFileUploadCancelSuccess:message];
                }
            }
        } failure:^(CubeError *error) {
            for (id<CWFileServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWFileServiceDelegate)] )
            {
                if([obj respondsToSelector:@selector(onFileServiceFailed:andError:)])
                {
                    [obj onFileServiceFailed:message andError:error];
                }
            }
        }];
    }
}


#pragma mark - Download api implementation

- (void)startDownloadFileWithFileMessage:(CubeFileMessage *)message andBlock:(void(^)(CubeFileMessage * message))block{
    if ([self isFileMessageType:message]) {
        // crate local folder...by application
        NSString *filePath = [self resourcePathWithMessage:message];
        NSString *fileName = message.fileName;
        message.filePath = [NSString stringWithFormat:@"%@/%@", filePath,fileName];
        
        DownloadCubeFile *downloadFile = [DownloadCubeFile downloadFileWithIdentify:[NSString stringWithFormat:@"%lld",message.SN] andDownloadUrl:message.url andLocalFolder:message.filePath];
        [[CubeEngine sharedSingleton].fileService startDownloadFileWithDownloadCubeFile:downloadFile progress:^(NSProgress *progress) {
            for (id<CWFileServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWFileServiceDelegate)])
            {
                if([obj respondsToSelector:@selector(onFileDownloadProgress:progress:)])
                {
                    [obj onFileDownloadProgress:message progress:progress];
                }
            }
        } success:^(id response) {
            for (id<CWFileServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWFileServiceDelegate)])
            {
                if([obj respondsToSelector:@selector(onFileDownloadSuccess:)])
                {
                    [obj onFileDownloadSuccess:message];
                }
            }
            if (block) {
                block(message);
            }
        } failure:^(CubeError *error) {
            for (id<CWFileServiceDelegate> obj in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWFileServiceDelegate)])
            {
                if([obj respondsToSelector:@selector(onFileServiceFailed:andError:)])
                {
                    [obj onFileServiceFailed:message andError:error];
                }
            }
        }];
    }
}





@end
