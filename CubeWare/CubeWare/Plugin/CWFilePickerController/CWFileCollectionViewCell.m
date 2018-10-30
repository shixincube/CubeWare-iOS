//
//  CWFileCollectionViewCell.m
//  CubeWare
//
//  Created by Mario on 17/2/10.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWFileCollectionViewCell.h"
//#import "CWNResourceUtil.h"
#import "UIView+NCubeWare.h"
#import "CubeWareHeader.h"

@interface CWFileCollectionViewCell ()

@end

@implementation CWFileCollectionViewCell

- (UIButton *)selectedButton{
    if (_selectedButton == nil) {
        UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedButton = selectedButton;
    }
    return _selectedButton;
}

- (UIImageView *)assetImageView{
    if (_assetImageView == nil) {
        UIImageView *assetImageView = [[UIImageView alloc] init];
        assetImageView.frame = CGRectMake(0, 0, self.cw_width, self.cw_height);
        assetImageView.contentMode = UIViewContentModeScaleAspectFill;
        assetImageView.clipsToBounds = YES;
        [self.contentView addSubview:assetImageView];
        _assetImageView = assetImageView;
    }
    return _assetImageView;
}

-(UIImageView *)selectedImgView{
    
    if (_selectedImgView == nil) {
        UIImageView *selectedImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.cw_width - 24, 2, 22, 22)];
        _selectedImgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:selectedImgView];
        _selectedImgView = selectedImgView;
    }
    return _selectedImgView;
}

-(UIImageView *)videoImageView{
    if (_videoImageView == nil) {
        UIImageView *videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, self.cw_height - 20, 22, 12)];
        videoImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:videoImageView];
        _videoImageView = videoImageView;
    }
    return _videoImageView;
}

-(UILabel *)timeLabel{
    if (_timeLabel == nil) {
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, self.cw_height - 20, self.cw_width - 26, 12)];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.textColor = UIColorFromRGB(0xffffff);
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:timeLabel];
        _timeLabel = timeLabel;
    }
    return _timeLabel;
}

- (void)refreshData:(PHAsset *)asset{
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        _timeLabel.hidden = NO;;
        _videoImageView.hidden = NO;
    }else if (asset.mediaType == PHAssetMediaTypeImage){
        _timeLabel.hidden = YES;
        _videoImageView.hidden = YES;
    }
}

@end
