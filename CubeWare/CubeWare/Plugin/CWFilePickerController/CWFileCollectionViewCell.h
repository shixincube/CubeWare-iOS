//
//  CWFileCollectionViewCell.h
//  CubeWare
//
//  Created by Mario on 17/2/10.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface CWFileCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *selectedImgView;

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UIImageView *assetImageView;

@property (nonatomic, strong) UIImageView *videoImageView;

@property (nonatomic, strong) UILabel *timeLabel;

- (void)refreshData:(PHAsset *)asset;

@end
