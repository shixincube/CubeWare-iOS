//
//  CWPhotoPickerController.h
//  CubeWare
//
//  Created by Mario on 17/2/9.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWAlbumModel;

@interface CWPhotoPickerController : UIViewController

@property (nonatomic, strong) CWAlbumModel *model;

@property (nonatomic, copy) void (^backButtonClickHandle)(CWAlbumModel *model);

@end
