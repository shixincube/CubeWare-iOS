//
//  CWCameraViewController.h
//  CubeWare
//
//  Created by Mario on 17/2/22.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  拍摄类型
 */
typedef NS_ENUM(NSInteger, CWCameraType){
    /**
     *  图片
     */
    CWCameraTypeTakePicture = 0,
    /**
     *  短视频
     */
    CWCameraTypeTakeVideo = 1,
};

@class CWCameraViewController;

@protocol CWCameraPickerDelegate <NSObject>

- (void)cameraPickerControllerWithThumbImagePath:(NSString *)thumbPath andFilePath:(NSString *)filePath andFileName:(NSString *)fileName andVideoDuration:(long long)duration andController:(CWCameraViewController *)controller andCameraType:(CWCameraType)type;

@end

@interface CWCameraViewController : UIViewController

@property (nonatomic, assign) id <CWCameraPickerDelegate> delegate;

@property (nonatomic, assign) CWCameraType type;

/**
 拍摄的短视频是否需要转码，默认YES
 */
@property (nonatomic, assign) BOOL needTransCode;

//设置图片或者视频默认大小，0或者不设置默认无限大
@property(nonatomic, assign) NSInteger totalImageLength;

//当前图片或者视频大小，默认为0
@property(nonatomic, assign) NSInteger currentImageLength;

@end
