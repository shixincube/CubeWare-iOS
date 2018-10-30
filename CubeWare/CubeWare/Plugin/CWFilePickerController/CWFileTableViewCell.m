//
//  CWFileTableViewCell.m
//  CubeWare
//
//  Created by Mario on 17/2/10.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWFileTableViewCell.h"
//#import "CWNResourceUtil.h"
#import "CubeWareHeader.h"

@implementation CWFileTableViewCell

#define IconWidth 50
#define BadgeWidth 17
#define STXihei_FONT15 [UIFont fontWithName:@"STXihei" size:15.f]
#define STXihei_FONT13 [UIFont fontWithName:@"STXihei" size:13.f]
#define STXihei_FONT10 [UIFont fontWithName:@"STXihei" size:10.f]
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _selectedImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        _selectedImgView.backgroundColor = [UIColor clearColor];
        _selectedImgView.image = [UIImage imageNamed:@"img_nochoose_other.png"];
        [self.contentView addSubview:_selectedImgView];
        
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, IconWidth, IconWidth)];
        _avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font            = [UIFont systemFontOfSize:15.f];;
        _nameLabel.textColor       = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font            = [UIFont systemFontOfSize:12.f];;
        _timeLabel.textColor       = [UIColor darkGrayColor];
        [self.contentView addSubview:_timeLabel];
        
        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BadgeWidth, BadgeWidth)];
        _sizeLabel.backgroundColor     = [UIColor clearColor];
        _sizeLabel.font                = [UIFont systemFontOfSize:10.f];
        _sizeLabel.textColor           = [UIColor grayColor];
        [self.contentView addSubview:_sizeLabel];
    }
    return self;
}

#define NameLabelMaxWidth    UIScreenWidth - 200.f
- (void)refresh{
    self.nameLabel.cw_width = self.nameLabel.cw_width > NameLabelMaxWidth ? NameLabelMaxWidth : self.nameLabel.cw_width;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //Message List
    NSInteger fileListSelectedCenterX = 25;
    NSInteger fileListIconLeft= 50;
    NSInteger fileListNameTop= 20;
    NSInteger fileListNameLeftToIcon= 19;
    //    NSInteger fileListTimeBottom         = 10;
    NSInteger fileListTimeTopToName = 16;
    NSInteger fileListSizeRight = 20;
    //    NSInteger fileListSizeBottom         = 10;
//    NSInteger fileListSizeTopToName  = 10;
    _selectedImgView.cw_centerX  = fileListSelectedCenterX;
    _selectedImgView.cw_centerY  = self.cw_height * .5f;
    _avatarImageView.cw_left    = fileListIconLeft;
    _avatarImageView.cw_centerY = self.cw_height * .5f;
    _nameLabel.cw_top = fileListNameTop;
    _nameLabel.cw_left = _avatarImageView.cw_right + fileListNameLeftToIcon;
    _timeLabel.cw_left = _avatarImageView.cw_right + fileListNameLeftToIcon;
//    _timeLabel.cw_bottom = self.cw_height - fileListTimeBottom;
    _timeLabel.cw_top = self.nameLabel.cw_bottom + fileListTimeTopToName;
    _sizeLabel.cw_right = self.cw_width - fileListSizeRight;
//    _sizeLabel.cw_bottom = self.cw_height - fileListSizeBottom;
    _sizeLabel.cw_top = self.timeLabel.cw_top;
    
    _selectedImgView.image = _selectedButton.isSelected ? [UIImage imageNamed:@"img_choose.png"] : [UIImage imageNamed:@"img_nochoose_other.png"];
}

@end
