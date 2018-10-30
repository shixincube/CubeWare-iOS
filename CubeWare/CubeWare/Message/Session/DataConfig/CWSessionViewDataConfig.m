//
//  CWSessionViewDataController.m
//  CubeWare
//
//  Created by luchuan on 2018/1/2.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWSessionViewDataConfig.h"
#import "CWEmojiResourceUtil.h"
#import "CWUtils.h" 
#import "CWEmojiModel.h"
#import "CubeWareHeader.h"
#import "CWResourceUtil.h"
#import "UIImage+NCubeWare.h"
#import <Photos/Photos.h>
#define emojiCount 23 // 每页表情个数

@implementation CWSessionViewDataConfig

#pragma mark - ToolBar
+(NSArray<CWToolBarItemModel *> *)getP2PBarItem{
    NSMutableArray * itemArr = [NSMutableArray array];
    CWToolBarItemModel * callModel = [CWToolBarItemModel toolBarItemModelWithTitle:@"语音通话" image:@"input_call_normal" selectImage:@"input_call_selected" identifier:CWToolBarItemP2PCall];
    CWToolBarItemModel * videoModel = [CWToolBarItemModel toolBarItemModelWithTitle:@"视频通话" image:@"input_video_normal" selectImage:@"input_video_selected" identifier:CWToolBarItemVideo];
    CWToolBarItemModel * shakeModel = [CWToolBarItemModel toolBarItemModelWithTitle:@"抖TA" image:@"input_shake_normal" selectImage:@"input_shake_selected" identifier:CWToolBarItemShakeAt];
    CWToolBarItemModel * refferalModel = [CWToolBarItemModel toolBarItemModelWithTitle:@"推荐联系人" image:@"input_referral_contact" selectImage:@"input_referral_contact_sel" identifier:CWToolBarItemGroupReferral];
    CWToolBarItemModel * whiteBoardModel = [CWToolBarItemModel toolBarItemModelWithTitle:@"白板演示" image:@"input_whiteboard" selectImage:@"input_whiteboard" identifier:CWToolBarItemP2PWhiteBoard];
    [itemArr addObject:callModel];
    [itemArr addObject:videoModel];
    [itemArr addObject:whiteBoardModel];
    [itemArr addObject:shakeModel];
//    [itemArr addObject:refferalModel];
    return itemArr;
}

+(NSArray<CWToolBarItemModel *> *)getGroupBarItem{
   NSMutableArray * itemArr = [NSMutableArray array];
    CWToolBarItemModel * groupCallModel = [CWToolBarItemModel toolBarItemModelWithTitle:@"语音通话" image:@"input_call_normal" selectImage:@"input_call_normal" identifier:CWToolBarItemGroupCall];
    CWToolBarItemModel * groupTaskModel = [CWToolBarItemModel toolBarItemModelWithTitle:@"群任务" image:@"input_group_task" selectImage:@"input_chat_task" identifier:CWToolBarItemGroupTask];
    CWToolBarItemModel * groupApplicationModel = [CWToolBarItemModel toolBarItemModelWithTitle:@"群应用" image:@"input_group_application" selectImage:@"iinput_group_applicationk" identifier:CWToolBarItemGroupApplication];
    
    CWToolBarItemModel * groupVideoModel = [CWToolBarItemModel toolBarItemModelWithTitle:@"视频通话" image:@"input_video_normal" selectImage:@"input_video_normal" identifier:CWToolBarItemGroupVideo];
    CWToolBarItemModel * groupWhiteBoardModel = [CWToolBarItemModel toolBarItemModelWithTitle:@"白板演示" image:@"input_whiteboard" selectImage:@"input_whiteboard" identifier:CWToolBarItemGroupWhiteBoard];
    
    [itemArr addObject:groupCallModel];
    [itemArr addObject:groupVideoModel];
    [itemArr addObject:groupWhiteBoardModel];
//    [itemArr addObject:groupTaskModel];
//    [itemArr addObject:groupApplicationModel];
    return itemArr;
}

+(NSArray<CWToolBarItemModel *> *)getToolBarItem{
    NSMutableArray * itemModelArr = [NSMutableArray array];
    NSArray * titleArr = @[@"语音",@"图片",@"文件",@"更多"];
    NSArray * imageArr = @[@"input_voice_normal",@"input_gallery_normal",@"input_file_normal",@"input_more_normal"];
    NSArray * selectImageArr =@[@"input_voice_selected",@"input_gallery_normal",@"input_file_normal",@"input_more_selected"];
    NSArray * tagArr = @[@(CWToolBarItemVoice),@(CWToolBarItemPicture),@(CWToolBarItemFile),@(CWToolBarItemMore)];
    for (int i = 0; i < titleArr.count; i++) {
        CWToolBarItemModel * model = [CWToolBarItemModel toolBarItemModelWithTitle:titleArr[i] image:imageArr[i] selectImage:selectImageArr[i] identifier:[tagArr[i]integerValue]];
        [itemModelArr addObject:model];
    }
    return itemModelArr;
}

+ (CWToolBarItemModel *)moreToolBarItem{
    return [CWToolBarItemModel toolBarItemModelWithTitle:@"更多" image:@"input_more_normal" selectImage:@"input_more_selected" identifier:CWToolBarItemMore];
}

#pragma mark - Emoji
+(NSArray *)getSystemEmojiPackageModelArr{
    NSMutableArray * emojiPackageModelArr = [NSMutableArray array];
    //内置系统表情
    CWEmojiPackageModel * simpleEmojiPackageModel = [[CWEmojiPackageModel alloc] init];
    simpleEmojiPackageModel.emojiPackageType = CWEmojiPackageTypeSystemEmoji;
    simpleEmojiPackageModel.chatPanelFilePath = [CWEmojiResourceUtil getIconPath];
    simpleEmojiPackageModel.emojiModelArr = [self getSystemEmojiModelArr];
    [emojiPackageModelArr addObject:simpleEmojiPackageModel];
    return emojiPackageModelArr;
}
/**拼装内置内置表情模型数组*/
+(NSArray *)getSystemEmojiModelArr{
    NSArray<NSDictionary *>  *emojiArr = [CWEmojiResourceUtil getEmojiPlistArr];
    
    NSMutableArray * simpleEmojiModelArr = [NSMutableArray array];
    [emojiArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CWEmojiModel *model = [[CWEmojiModel alloc] init];
        model.name = obj[@"chs"];
        model.thumbName = obj[@"png"];
        model.fileName = obj[@"gif"];
        model.thumbPath = [CWEmojiResourceUtil getEmojiPngPathWithName:model.thumbName];
        model.filePath = [CWEmojiResourceUtil getEmojiGifPathWithName:model.fileName];
        model.key = obj[@"key"];
        model.emojiType = CWEmojiModelTypeSystemEmoji;
        
        [simpleEmojiModelArr addObject:model];
    }];
    //拼接表情数组
    NSInteger pageCount = (NSInteger)ceilf((CGFloat)simpleEmojiModelArr.count / emojiCount);
    //判断是否能被emojiCount 整除，如果不能，则用空填充
    NSInteger  residueCount = simpleEmojiModelArr.count % emojiCount;
    for (int i = 0; i < emojiCount - residueCount; i++) {
        CWEmojiModel * nilModel = [[CWEmojiModel alloc] init];
//        nilModel.funcationType = CWSimpleEmojiModelTypeNil;
        nilModel.funcationType = CWEmojiModelFunctionTypeNil;
        nilModel.emojiType = CWEmojiModelTypeSystemEmoji;
        [simpleEmojiModelArr addObject:nilModel];
    }
    // 最后一个添加删除按钮
    CWEmojiModel *deleteModel = [[CWEmojiModel alloc] init];
//    deleteModel.funcationType = CWSimpleEmojiModelTypeDelete;
    deleteModel.funcationType = CWEmojiModelFunctionTypeDelete;
    deleteModel.emojiType = CWEmojiModelTypeSystemEmoji;
    deleteModel.thumbPath = [CWEmojiResourceUtil getDeleteImagePath];
    NSMutableArray *splitSimpleEmojiModelArr = [NSMutableArray array];
    for (int i = 0; i < pageCount; i++) {
        NSArray * pageArr = [simpleEmojiModelArr subarrayWithRange:NSMakeRange(i*emojiCount, emojiCount)];
        
        [splitSimpleEmojiModelArr addObjectsFromArray:pageArr];
        [splitSimpleEmojiModelArr addObject:deleteModel];
    }
    return splitSimpleEmojiModelArr;
}
+(void)sendImageN:(NSArray *)assets  andIsOriginal:(BOOL)isOriginal andBlock:(void (^)(NSData *imageData  ,NSData *thumbImageData , NSString *name ,CGSize thumbSize,bool isFile))block{
    int imageCout = assets.count;
    __block NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:imageCout];
    for (int i = 0 ; i< imageCout; i++) {
        [imageArr addObject:@""];
    }
    
    PHCachingImageManager *imageManager = (PHCachingImageManager *)[PHCachingImageManager defaultManager];
    PHImageRequestOptions* itemOptions = [[PHImageRequestOptions alloc]init];
    if (isOriginal) {
        itemOptions.deliveryMode =  PHImageRequestOptionsDeliveryModeHighQualityFormat;
    }else{
        itemOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    }
    itemOptions.networkAccessAllowed = YES;
    // 异步请求图片并获取压缩图
    
    [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //需要判断ios11以上系统是否是heif格式图片
        __block BOOL isHEIF = NO;
        NSArray *resourceList = [PHAssetResource assetResourcesForAsset:obj];
        [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAssetResource *resource = obj;
            NSString *UTI = resource.uniformTypeIdentifier;
            if ([UTI isEqualToString:@"public.heif"] || [UTI isEqualToString:@"public.heic"]) {
                isHEIF = YES;
                *stop = YES;
            }
        }];
        
        [imageManager requestImageDataForAsset:obj options:itemOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                __block NSInteger currentidx = idx;
                __block NSData *originImageDate = imageData;
                if(!imageData)return ;//图片不存在
                NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[info objectForKey:@"PHImageFileURLKey"]]];
                NSString *imageContentType = isHEIF ?  @"jpeg" : [imageUrl pathExtension];//图片类型
                bool isFile = NO;
                __block NSData *thumbImageData;
                CGSize thumbSize ;
                NSString *imageName = [NSString stringWithFormat:@"image-%@-%lu.%@", [CWUtils fileNameFromCurrentDate],(unsigned long)currentidx,imageContentType];
                if([[imageContentType lowercaseString] isEqualToString:@"gif"]){
                    //gif图暂时不处理
                    thumbImageData =imageData;
                    UIImage  *thumbImage = [UIImage imageWithData:imageData];
                    thumbSize = thumbImage.size;
                }else{
                    originImageDate = [self getThumbImageDataWithImageData:imageData andMaxWidthOrHeight:1000];
                    thumbImageData = [self getThumbImageDataWithImageData:imageData andMaxWidthOrHeight:300];
                    UIImage *thumbImage = [UIImage imageWithData:thumbImageData];
                    thumbSize = thumbImage.size;
                }
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionary];
                [imageDic setObject:originImageDate forKey:@"imageData"];
                [imageDic setObject:thumbImageData forKey:@"thumbImageData"];
                [imageDic setObject:imageName forKey:@"imageName"];
                [imageDic setObject:[NSValue valueWithCGSize:thumbSize] forKey:@"thumbSize"];
                [imageDic setObject:[NSNumber numberWithBool:isFile] forKey:@"isFile"];
                
                [imageArr replaceObjectAtIndex:currentidx withObject:imageDic];
                NSLog(@"第%ld已处理完成,%@",currentidx ,[NSThread currentThread]);
                
                @synchronized(imageArr){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if(![obj isKindOfClass:[NSDictionary class]]){
                                *stop = YES;
                            }else{
                                NSMutableDictionary *imageDic = obj;
                                if(!obj) *stop =YES;
                                NSNumber *hadSend = [imageDic objectForKey:@"hadSend"];
                                if(!hadSend.boolValue){
                                    NSValue * thumbSize = imageDic[@"thumbSize"];
                                    NSNumber *isFile = imageDic[@"isFile"];
                                    if(block){
                                        block([imageDic objectForKey:@"imageData"],imageDic[@"thumbImageData"],imageDic[@"imageName"],thumbSize.CGSizeValue,isFile.boolValue);
                                        NSMutableDictionary * hadSendDic = [NSMutableDictionary dictionary];
                                        [hadSendDic setObject:@(true) forKey:@"hadSend"];
                                        [imageArr replaceObjectAtIndex:idx withObject:hadSendDic];
                                        NSLog(@"第%ld已发送完成",idx);
                                    }
                                }
                            }
                            
                        }];
                    });
                    
                }
            });
        }];
    }];
}

+(void)sendVideo:(NSArray *)assets   andBlock:(void (^)(NSString *filePath  ,NSString *thumbPath ,long long duration ,NSString *fileFame ,CGSize thumbSize))block{
    if(!assets.count)return;
    [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj isKindOfClass:[PHAsset class]])return ;
        PHAsset *videoAsset = (PHAsset *)obj;
        if(videoAsset.mediaType != PHAssetMediaTypeVideo)return;
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:videoAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                
                NSURL *url = urlAsset.URL;
                NSString *dateStr = [CWUtils fileNameFromCurrentDate];
                NSString *fileName = [NSString stringWithFormat:@"video-%@-%lu.mp4", dateStr, (unsigned long)idx];
                
                // 压缩 并发送
                [self compressVideoWithVideoURL:url savedName:fileName completion:^(NSString *savedPath) {
                    if (savedPath) {
                        NSString *dateStr = [CWUtils fileNameFromCurrentDate];
                        NSString *thumbName = [NSString stringWithFormat:@"image-%@-%lu.JPG", dateStr, (unsigned long)idx];
                        NSString *fileFolder = [CWUtils subFolderAtDocumentWithName:@"CubeEngine/Message/File"];
                        NSString *thumbPath = [fileFolder stringByAppendingPathComponent:thumbName];

                        UIImage *thumImage = [self getThumbnailImage:savedPath];
                        NSData  *imageData = UIImagePNGRepresentation(thumImage);
                        //写入沙盒
                        [imageData writeToFile:thumbPath atomically:YES];
                        CMTime time =  urlAsset.duration;
                        long long duration = CMTimeGetSeconds(time);
                        if(block){
                            block(savedPath,thumbPath,duration,fileName,thumImage.size);
                        }
                    } else {
                        NSLog(@"savedFilePath is nil !!!");
                    }
                }];
            });
        }];
    }];
    
}
/*
+(void)sendImage:(NSArray *)assets photos:(NSArray<UIImage *> *)photos andIsOriginal:(BOOL)isOriginal andBlock:(void (^)(NSData *imageData  ,NSData *thumbImageData , NSString *name ,CGSize size))block
{
    PHCachingImageManager *imageManager = (PHCachingImageManager *)[PHCachingImageManager defaultManager];
    PHImageRequestOptions* itemOptions = [[PHImageRequestOptions alloc]init];
    if (isOriginal) {
        itemOptions.deliveryMode =  PHImageRequestOptionsDeliveryModeHighQualityFormat;
    }else{
        itemOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    }
    
    itemOptions.networkAccessAllowed = YES;
    
    __weak typeof(self)weakself = self;
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue2 = dispatch_queue_create("dealPic", DISPATCH_QUEUE_SERIAL);
    [assets enumerateObjectsUsingBlock:^(PHAsset * asset, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            [imageManager requestImageDataForAsset:asset options:itemOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                if (!imageData)return ;
                __block UIImage *thumbImage = photos[idx];
                __block NSData * thumbImageData = UIImageJPEGRepresentation(thumbImage,1.0);
                
                dispatch_async(queue2, ^{
                    NSString * imageContentTypeStr = [CWUtils contentTypeForImageData:imageData];
                    NSString *dateStr = [CWUtils fileNameFromCurrentDate];
                    NSString * imageName ;
                    UIImage * oringImage = [UIImage imageWithData:imageData];
                    NSData *rotateImageImageData;
                    if([imageContentTypeStr isEqualToString:@"gif"]){
                        imageName = [NSString stringWithFormat:@"image-%@-%lu.gif", dateStr,(unsigned long)idx];
                        rotateImageImageData = imageData;
                        thumbImageData = imageData;
                    }
                    else{
                        imageName = [NSString stringWithFormat:@"image-%@-%lu.%@", dateStr,(unsigned long)idx,imageContentTypeStr];
                        oringImage = [CWUtils scaleAndRotateImage:oringImage maxResolution:MAX(oringImage.size.width, oringImage.size.height)];
                        rotateImageImageData = UIImageJPEGRepresentation(oringImage, 1.0);
                    }
                    if(block){
                        block(rotateImageImageData,thumbImageData,imageName,thumbImage.size);
                    }
                });
            }];
            dispatch_semaphore_signal(semaphore);
        });
    }];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    return;
  /*
    //遍历PHAsset数组
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [assets enumerateObjectsUsingBlock:^(PHAsset * asset, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            //取出imageData
            PHCachingImageManager *imageManager = (PHCachingImageManager *)[PHCachingImageManager defaultManager];
            PHImageRequestOptions* itemOptions = [[PHImageRequestOptions alloc]init];
            if (isOriginal) {
                itemOptions.deliveryMode =  PHImageRequestOptionsDeliveryModeHighQualityFormat;
            }else{
                itemOptions.deliveryMode =  PHImageRequestOptionsDeliveryModeOpportunistic;
            }
            itemOptions.networkAccessAllowed = YES;
            [imageManager requestImageDataForAsset:asset options:itemOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {

                CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
                size_t count = CGImageSourceGetCount(source);
                UIImage *animatedImage;
                UIImage *originalImage = [UIImage imageWithData:imageData];
                NSData *compactImageData = UIImageJPEGRepresentation(originalImage, 1.0);
                originalImage = [UIImage imageWithData:compactImageData];
                CGSize imageSize = CGSizeZero;

                NSMutableArray *images = [NSMutableArray array];
                NSTimeInterval duration = 0.0f;
                for (size_t i = 0; i < count; i++) {
                    CGImageRef imageref = CGImageSourceCreateImageAtIndex(source, i, NULL);
                    CGSize originalImageSize = CGSizeZero;
                    originalImageSize = CGSizeMake(originalImage.size.width, originalImage.size.height);
                    imageSize = originalImageSize;
                    CGSize size = [CWUtils resizeImageSize:originalImageSize withLimit:4032];
                    UIImage *image = [UIImage imageWithCGImage:imageref scale:size.width / originalImageSize.width orientation:orientation];
                    CGImageRelease(imageref);

                    if (!image) {
                        continue;
                    }
                    if(count > 1){
                        [images addObject:image];

                        CGFloat frameDuration = 0.1;
                        CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, i, nil);
                        NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
                        NSDictionary *gifProperties = frameProperties[[NSString stringWithFormat:@"%@",kCGImagePropertyGIFDictionary]];

                        NSNumber *delayTimeUnclampedProp = gifProperties[[NSString stringWithFormat:@"%@",kCGImagePropertyGIFUnclampedDelayTime]];
                        if (delayTimeUnclampedProp) {
                            frameDuration = [delayTimeUnclampedProp floatValue];
                        }
                        else {
                            NSNumber *delayTimeProp = gifProperties[[NSString stringWithFormat:@"%@",kCGImagePropertyGIFDelayTime]];
                            if (delayTimeProp) {
                                frameDuration = [delayTimeProp floatValue];
                            }
                        }
                        if (frameDuration < 0.011f) {
                            frameDuration = 0.100f;
                        }
                        duration += frameDuration;
                    }else{
                        animatedImage = image;
                    }
                }
                if (images.count) {
                    animatedImage = [UIImage animatedImageWithImages:images duration:duration];
                }
                CFRelease(source);
                NSString *dateStr = [CWUtils fileNameFromCurrentDate];
                NSString *nameString;//图片名称
                NSData *scalImageData = imageData;
                NSData *thumbImageData = imageData;
                if (count > 1)
                {//gif
                    nameString = [NSString stringWithFormat:@"image-%@-%lu.gif", dateStr,(unsigned long)idx];
                    scalImageData = imageData;
                }
                else
                {
                    NSData * jpgImageData = UIImageJPEGRepresentation(animatedImage, 1);
                    if (jpgImageData)
                    {
                        nameString = [NSString stringWithFormat:@"image-%@-%lu.JPG", dateStr,(unsigned long)idx];
                    }
                    else
                    {
                        nameString = [NSString stringWithFormat:@"image-%@-%lu.PNG", dateStr,(unsigned long)idx];
                    }
                    scalImageData = [CWUtils compressImageData:animatedImage isOriginal:isOriginal];
                }
                if(block)
                {
                    block(scalImageData,thumbImageData,nameString,imageSize);
                }
            }];
            dispatch_semaphore_signal(semaphore);
        });
    }];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
   */
//}


+ (NSData *)getThumbImageDataWithImageData:(NSData *)imageData andMaxWidthOrHeight:(CGFloat)maxWidthOrHeight{
    NSMutableData *thumbImageData = nil;
    
    if(imageData)
    {
        CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((CFDataRef)imageData, nil);
        
        NSDictionary *thumbImageOptions = @{
                                            (__bridge NSString *)kCGImageSourceCreateThumbnailFromImageAlways:@YES,
                                            (__bridge NSString *)kCGImageSourceThumbnailMaxPixelSize:@(maxWidthOrHeight),
                                            (__bridge NSString *)kCGImageSourceCreateThumbnailWithTransform:@YES,
                                            };
        
        if(imageSourceRef && CGImageSourceGetCount(imageSourceRef))
        {
            
            size_t imageCount = CGImageSourceGetCount(imageSourceRef);
            
            thumbImageData = [NSMutableData data];
            
            CGImageDestinationRef thumbImageDestination = CGImageDestinationCreateWithData((CFMutableDataRef)thumbImageData, CGImageSourceGetType(imageSourceRef), imageCount, NULL);
            
            for (size_t i = 0; i < imageCount; i++) {
                CGImageRef thubmImage = CGImageSourceCreateThumbnailAtIndex(imageSourceRef, i, (CFDictionaryRef)thumbImageOptions);

                NSDictionary *properties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(imageSourceRef, i, NULL));
                
                NSDictionary *GIFDic = nil;
                
                if(imageCount > 1){
                    NSNumber *GIFDelayTime  = [[properties objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary] objectForKey:(__bridge NSString *)kCGImagePropertyGIFUnclampedDelayTime];
                    GIFDic = @{
                               (__bridge NSString *)kCGImagePropertyGIFDictionary:@{
                                       (__bridge NSString *)kCGImagePropertyGIFDelayTime:GIFDelayTime ? GIFDelayTime : @(0.1),
                                       },
                               };
                }
                CGImageDestinationAddImage(thumbImageDestination, thubmImage, (CFDictionaryRef)GIFDic);
                CGImageRelease(thubmImage);
            }
            
            CGImageDestinationFinalize(thumbImageDestination);
            CFRelease(thumbImageDestination);
            
            CFRelease(imageSourceRef);
        }
    }
    
    return thumbImageData;
}

//压缩视频
+ (void)compressVideoWithVideoURL:(NSURL *)videoURL
                        savedName:(NSString *)savedName
                       completion:(void (^)(NSString *savedPath))completion {
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];

    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];

    if ([presets containsObject:AVAssetExportPreset640x480]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset  presetName:AVAssetExportPreset640x480];
        NSString *folder = [CWUtils subFolderAtDocumentWithName:@"CubeEngine/Message/File"];
    
        BOOL isDir = NO;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir];
        if (!isExist || (isExist && !isDir)) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:folder
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error == nil) {
                NSLog(@"目录创建成功");
            } else {
                NSLog(@"目录创建失败");
            }
        }
        NSString *outPutPath = [folder stringByAppendingPathComponent:savedName];
        session.outputURL = [NSURL fileURLWithPath:outPutPath];
        session.shouldOptimizeForNetworkUse = true;
        
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            NSLog(@"No supported file types");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil);
                }
            });
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        [session exportAsynchronouslyWithCompletionHandler:^{
            if ([session status] == AVAssetExportSessionStatusCompleted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion([session.outputURL path]);
                    }
                });
            } else {
                if ([session status] == AVAssetExportSessionStatusFailed) {
                    NSLog(@"Export failed: %@", [session error]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(nil);
                        }
                    });
                }
            }
        }];
    }
}


+(UIImage *)getThumbnailImage:(NSString *)videoPath {
    if (videoPath) {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath: videoPath] options:nil];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        // 设定缩略图的方向
        // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
        gen.appliesPreferredTrackTransform = YES;
        // 设置图片的最大size(分辨率)
        gen.maximumSize = CGSizeMake(1080, 1920);
        CMTime time = CMTimeMakeWithSeconds(5.0, 600); //取第5秒，一秒钟600帧
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        if (error) {
            UIImage *placeHoldImg = [CWResourceUtil imageNamed:@"img_videoplay_default.png"];
            return placeHoldImg;
        }
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        return thumb;
    } else {
        UIImage *placeHoldImg = [CWResourceUtil imageNamed:@"img_videoplay_default.png"];
        return placeHoldImg;
    }
}


@end
