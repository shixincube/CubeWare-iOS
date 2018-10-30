//
//  CDSubTitleTableViewCell.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/30.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDSubTitleTableViewCell.h"
@interface CDSubTitleTableViewCell()
/**
 图标
 */
@property (nonatomic,strong) UIImageView *iconView;

@end
@implementation CDSubTitleTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.title];
        [self addSubview:self.content];
        [self addSubview:self.iconView];
        [self addSubview:self.separatorLine];
    }
    return self;
}

- (UILabel *)title
{
    if(_title == nil)
    {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, self.width, 20)];
        _title.backgroundColor = [UIColor clearColor];
        _title.font = [UIFont systemFontOfSize:12];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.textColor = RGBA(0x99, 0x99, 0x99, 1);
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _title;
}

- (UILabel *)content
{
    if(_content == nil)
    {
        _content = [[UILabel alloc]initWithFrame:CGRectMake(18, 20, self.width, self.height - 20)];
        _content.backgroundColor = [UIColor clearColor];
        _content.font = [UIFont systemFontOfSize:16];
        _content.textAlignment = NSTextAlignmentLeft;
        _content.textColor = KBlackColor;
        _content.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _content;
}

- (UIView *)separatorLine
{
    if (_separatorLine == nil)
    {
        _separatorLine = [[UIView alloc]initWithFrame:CGRectMake(18, self.height - 1, kScreenWidth - 18 * 2, 1)];
        _separatorLine.backgroundColor = RGBA(0xe6, 0xe6, 0xe6, 1);
    }
    return _separatorLine;
}

- (UIImageView *)iconView
{
    if (nil == _iconView)
    {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 40, 0, 16, 16)];
        _iconView.image = [UIImage imageNamed:@"right.png"];
        _iconView.centerY = self.centerY;
        _iconView.hidden = YES;//默认不显示
    }
    return _iconView;
}

- (void)setShowRightArrow:(BOOL)showRightArrow
{
    _showRightArrow = showRightArrow;
    if (_showRightArrow)
    {
        self.iconView.hidden = NO;
    }
    else
    {
        self.iconView.hidden = YES;
    }
}

@end
