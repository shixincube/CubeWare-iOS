//
//  CWResourceUtil.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/28.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWResourceUtil.h"

@implementation CWResourceUtil

+(NSBundle *)resourceBundle{
    static NSBundle *bundle = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"CubeWareBundle" ofType:@"bundle"]];
    });
    
    return bundle;
}

+(UIImage *)imageNamed:(NSString *)imageName{
    return [UIImage imageNamed:imageName inBundle:[self resourceBundle] compatibleWithTraitCollection:nil];
}

+(NSURL *)audioResourceUrl:(NSString *)name andType:(NSString *)type
{
    NSString *audio_path = [[self resourceBundle] pathForResource:name ofType:type];
	NSURL *url = [NSURL fileURLWithPath:audio_path ? audio_path : @""];
    return url;
}

+(NSString *)engineFolder{
    CubeConfig * cubeConfig = [CubeEngine sharedSingleton].config;
    NSString *engineFolder = (cubeConfig && cubeConfig.resourceDir.length >0) ? cubeConfig.resourceDir : [[CWResourceUtil documentFolder] stringByAppendingPathComponent:@"CubeEngine"];
    [CWResourceUtil createFolder:engineFolder];
    return engineFolder;
}

+ (void)createFolder:(NSString *)folder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:folder]) {
        BOOL finish = [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
        if (finish) {
            NSLog(@"createFolder 创建成功");
        }else{
            NSLog(@"createFolder 失败");
        }
    }
}

// default folder
+ (NSString *)documentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = paths.firstObject;
    return docPath;
}


+ (NSString *)messageFolderWithParentDiretory:(NSString *)parentDir{
    NSString *parentFolderPath = [[CWResourceUtil engineFolder] stringByAppendingPathComponent:parentDir];
    NSString *msgFolderPath = [parentFolderPath stringByAppendingPathComponent:@"Message"];
    [CWResourceUtil createFolder:msgFolderPath];
    return msgFolderPath;
}

+ (NSString *)messageFolder
{
    NSString *msgFolderPath = [[CWResourceUtil engineFolder] stringByAppendingPathComponent:@"Message"];
    [CWResourceUtil createFolder:msgFolderPath];
    return msgFolderPath;
}

// get current register path..
+ (NSString *)currentRegisterMessageFolder{
    NSString *currentRegister = [CubeEngine sharedSingleton].userService.currentUser.cubeId;
    NSString *messageFolder = nil;
    if (currentRegister) {
        messageFolder = [CWResourceUtil messageFolderWithParentDiretory:currentRegister];
    } else {
        messageFolder = [CWResourceUtil messageFolder];
    }
    return messageFolder;
}


+ (NSString *)folderWithMessageType:(MessageFolderType)type{
    NSString *folder = [CWResourceUtil currentRegisterMessageFolder];
    NSString *folderPath ;
    if (type == MessageFolderFileType) {
        folderPath = [folder stringByAppendingPathComponent:@"File"];
    }
    else if (type == MessageFolderImageType){
        folderPath = [folder stringByAppendingPathComponent:@"Image"];
    }
    else if (type == MessageFolderVideoType){
        folderPath = [folder stringByAppendingPathComponent:@"Video"];
    }
    else if (type == MessageFolderVoiceType){
        folderPath = [folder stringByAppendingPathComponent:@"Voice"];
    }
    [CWResourceUtil createFolder:folderPath];
    return folderPath;
}


@end
