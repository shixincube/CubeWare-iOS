//
//  CWFileManagerModel.m
//  CubeWare
//
//  Created by Mario on 17/2/10.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWFileManagerModel.h"
//#import "UIImage+CubeWare.h"
//#import "CWNResourceUtil.h"

@implementation CWFileManagerModel

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithFileType:(CWFileType)fileType {
    self = [super init];
    if (self) {
        self.fileType = fileType;
    }
    return self;
}

- (void)setFileType:(CWFileType)fileType {
    _fileType = fileType;
    
    self.fileImage = [[self class] imageWithFileType:fileType];
}

+ (UIImage *)imageWithFileType:(CWFileType)fileType {
    NSString *imageName = nil;
    switch (fileType) {
        case CWFile_Type_RAR:{
            imageName = @"img_file_rar.png";
            break;
        }
        case CWFile_Type_PDF:{
            imageName = @"img_file_pdf.png";
            break;
        }
        case CWFile_Type_DOC:{
            imageName = @"img_file_doc.png";
            break;
        }
        case CWFile_Type_XLS:{
            imageName = @"img_file_xls.png";
            break;
        }
        case CWFile_Type_PPT:{
            imageName = @"img_file_ppt.png";
            break;
        }
        case CWFile_Type_IMAGE:{
            imageName = @"img_file_picture.png";
            break;
        }
        case CWFile_Type_FLODER:{
            imageName = @"img_file_folder.png";
            break;
        }
        case CWFile_Type_TXT:{
            imageName = @"img_file_txt.png";
            break;
        }
        case CWFile_Type_VIDEO:{
            imageName = @"img_file_video.png";
            break;
        }
        case CWFile_Type_MUSIC:{
            imageName = @"img_file_music.png";
            break;
        }
        case CWFile_Type_UNKNOWN:{
            imageName = @"img_file_unknow.png";
            break;
        }
        case CWFile_Type_IMAGEBROKEN:{
            imageName = @"img_file_brokenpic.png";
            break;
        }
        default: {
            imageName = @"img_file_unknow.png";
            break;
        }
    }
    UIImage *fileImage = [UIImage imageNamed:imageName];
    return fileImage;
}
@end
