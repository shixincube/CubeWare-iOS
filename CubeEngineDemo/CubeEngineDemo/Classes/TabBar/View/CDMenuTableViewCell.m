//
//  CWMenuTableViewCell.m
//  CubeWare
//
//  Created by pretty on 2018/8/25.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import "CDMenuTableViewCell.h"
@interface CDMenuTableViewCell ()

/**
 图标
 */
@property (nonatomic,strong) UIImageView *iconView;

@end
@implementation CDMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView= [[UIView alloc]initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];//无选择颜色
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.title];
        [self addSubview:self.iconView];
        [self addSubview:self.separatorLine];
    }
    return self;
}

- (void)setIconImage:(UIImage *)iconImage
{
    if (iconImage) {
        _iconImage = iconImage;
        self.iconView.image = _iconImage;
        [self.title setX:40 + 10];
    }
}

- (UIImageView *)iconView
{
    if (_iconView == nil)
    {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
        _iconView.backgroundColor = [UIColor clearColor];
        _iconView.centerY = self.centerY;
    }
    return _iconView;
}

- (UILabel *)title
{
    if(_title == nil)
    {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.width, self.height)];
        _title.backgroundColor = [UIColor clearColor];
        _title.font = [UIFont systemFontOfSize:12];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _title;
}

- (UIView *)separatorLine
{
    if (_separatorLine == nil)
    {
        _separatorLine = [[UIView alloc]initWithFrame:CGRectMake(10, self.height - 1, self.width - 20 , 1)];
        _separatorLine.backgroundColor = RGBA(0xe6, 0xe6, 0xe6, 1);
    }
    return _separatorLine;
}

@end
