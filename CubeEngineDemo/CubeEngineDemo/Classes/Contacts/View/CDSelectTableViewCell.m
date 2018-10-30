//
//  CDSelectTableViewCell.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/31.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDSelectTableViewCell.h"
@interface CDSelectTableViewCell()
/**
 选择状态图标
 */
@property (nonatomic,strong) UIImageView *selectedView;
@end

@implementation CDSelectTableViewCell

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
        [self addSubview:self.selectedView];
        [self addSubview:self.iconView];
        [self addSubview:self.title];
        [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(25);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(18);
        }];

        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.width.height.mas_equalTo(40);
             make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.selectedView.mas_right).offset(12);
        }];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.iconView.mas_right).offset(15);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(self.width);
        }];
    }
    return self;
}

- (UIImageView *)selectedView
{
    if (nil == _selectedView)
    {
        _selectedView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diselected.png"]];
    }
    return _selectedView;
}

- (UILabel *)title
{
    if (nil == _title) {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, self.width, self.height)];
        _title.backgroundColor = [UIColor clearColor];
        _title.font = [UIFont systemFontOfSize:16];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _title;
}

- (UIImageView *)iconView
{
    if (nil == _iconView) {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 40, 40)];
        _iconView.backgroundColor = [UIColor clearColor];
        _iconView.centerY = self.centerY;
        _iconView.layer.cornerRadius = 20;
        _iconView.layer.masksToBounds = YES;
        _iconView.image = [UIImage imageNamed:@"img_square_avatar_male_default"];
    }
    return _iconView;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected)
    {
        self.selectedView.image = [UIImage imageNamed:@"selected.png"];
    }
    else
    {
        self.selectedView.image = [UIImage imageNamed:@"diselected.png"];
    }
    if (_unableChoose) {
        self.selectedView.image = [UIImage imageNamed:@"img_choose_disabled"];
    }
    [self setNeedsDisplay];
}

- (void)setUnableChoose:(BOOL)unableChoose
{
    _unableChoose = unableChoose;
}
@end
