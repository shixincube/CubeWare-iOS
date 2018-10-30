//
//  CWAssetCell.h
//  CubeWare
//
//  Created by Mario on 17/2/9.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    CWAssetCellTypePhoto = 0,
    CWAssetCellTypeLivePhoto,
    CWAssetCellTypeVideo,
    CWAssetCellTypeAudio,
} CWAssetCellType;

@class CWAssetModel;

@interface CWAssetCell : UICollectionViewCell

@property (weak, nonatomic) UIButton *selectPhotoButton;

@property (nonatomic, strong) CWAssetModel *model;

@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);

@property (nonatomic, assign) CWAssetCellType type;

@property (nonatomic, copy) NSString *representedAssetIdentifier;

@property (nonatomic, assign) PHImageRequestID imageRequestID;

@property(nonatomic, assign) CGSize imageSize;

@property(nonatomic, assign) NSInteger imageLength;

@property(nonatomic, assign) NSInteger totalImageLength;

@end


@class CWAlbumModel;

@interface CWAlbumCell : UITableViewCell

@property (nonatomic, strong) CWAlbumModel *model;

@property (weak, nonatomic) UIButton *selectedCountButton;

@end


@interface CWAssetCameraCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end
