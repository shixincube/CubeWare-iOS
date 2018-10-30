//
//  CWFileManagerModel.h
//  CubeWare
//
//  Created by Mario on 17/2/10.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum _CWFileType {
    CWFile_Type_RAR = 1,          //!< 压缩包类型。
    CWFile_Type_PDF = 2,          //PDF
    CWFile_Type_DOC = 3,          //doc、docx
    CWFile_Type_XLS = 4,          //xls、xlsx
    CWFile_Type_PPT = 5,          //ppt、pptx
    CWFile_Type_IMAGE = 6,        //!< 图片类型。
    CWFile_Type_FLODER = 7,           //!< 文件夹类型。
    CWFile_Type_TXT = 8,          //!< 文本文档类型。
    CWFile_Type_VIDEO = 9,        //!< 视频类型。
    CWFile_Type_MUSIC = 10,       //!< 音频类型。
    CWFile_Type_IMAGEBROKEN = 11, //!< 破坏图片类型。
    CWFile_Type_UNKNOWN = 0       //!< 未知类型。
} CWFileType;

@interface CWFileManagerModel : NSObject

/**
 *  文件名称
 */
@property (nonatomic, copy) NSString *nameString;

/**
 *  时间
 */
@property (nonatomic, copy) NSString *timeString;

/**
 *  文件大小
 */
@property (nonatomic, copy) NSString *sizeString;

/**
 *  文件路径
 */
@property (nonatomic, copy) NSString *filePath;

/**
 *  文件头像
 */
@property (nonatomic, strong) UIImage *fileImage;

/**
 *  文件类型
 */
@property (nonatomic, assign) CWFileType fileType;

- (id)initWithFileType:(CWFileType)fileType;

+(UIImage *)imageWithFileType:(CWFileType)fileType;

@end
