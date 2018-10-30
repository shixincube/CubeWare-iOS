//
//  CWPhotoPreviewCell.h
//  CubeWare
//
//  Created by Mario on 17/2/9.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWAssetModel;
@interface CWPhotoPreviewCell : UICollectionViewCell
@property (nonatomic, strong) CWAssetModel *model;
@property (nonatomic, copy) void (^singleTapGestureBlock)();
@end
