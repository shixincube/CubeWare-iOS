//
//  CWFileContentModel.h
//  CubeWare
//
//  Created by Mario on 17/1/13.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

//#import "CWBaseSessionContentModel.h"
#import <UIKit/UIKit.h>
typedef enum _CWFileModelType {
    CWFileModel_Type_RAR = 1,          //!< 压缩包类型。
    CWFileModel_Type_PDF = 2,          //PDF
    CWFileModel_Type_DOC = 3,          //doc、docx
    CWFileModel_Type_XLS = 4,          //xls、xlsx
    CWFileModel_Type_PPT = 5,          //ppt、pptx
    CWFileModel_Type_IMAGE = 6,        //!< 图片类型。
    CWFileModel_Type_FLODER = 7,       //!< 文件夹类型。
    CWFileModel_Type_TXT = 8,          //!< 文本文档类型。
    CWFileModel_Type_VIDEO = 9,        //!< 视频类型。
    CWFileModel_Type_MUSIC = 10,       //!< 音频类型。
    CWFileModel_Type_IMAGEBROKEN = 11, //!< 破坏图片类型。
    CWFileModel_Type_UNKNOWN = 0       //!< 未知类型。
} CWFileModelType;

@interface CWFileContentModel : UIViewController

/**
 *  fileUrl
 */
@property (nonatomic, copy) NSString *url;

/**
 *  filePath
 */
@property (nonatomic, copy) NSString *filePath;

/**
 *  当前大小
 */
@property (nonatomic, assign) long long progress;

/**
 *  总大小
 */
@property (nonatomic, assign) long long total;

/**
 *  文件大小
 */
//@property (nonatomic, assign) CGFloat size;

/**
 *  文件类型
 */
@property (nonatomic, assign) CWFileModelType fileType;

@end
