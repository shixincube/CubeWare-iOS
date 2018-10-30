//
//  CDContactsTableViewCell.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/28.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDContactsTableViewCell.h"
@interface CDContactsTableViewCell()

@end
@implementation CDContactsTableViewCell

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
        [self addSubview:self.title];
        [self addSubview:self.iconView];
        [self addSubview:self.separatorLine];
    }
    return self;
}

- (UIImageView *)iconView
{
    if (_iconView == nil)
    {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 40, 40)];
        _iconView.backgroundColor = [UIColor clearColor];
        _iconView.centerY = self.centerY;
        _iconView.image = [UIImage imageNamed:@"group.png"];
        _iconView.layer.cornerRadius = 20;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)title
{
    if(_title == nil)
    {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, self.width, self.height)];
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
        _separatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
        _separatorLine.backgroundColor = KGray2Color;
        _separatorLine.hidden = YES;
    }
    return _separatorLine;
}


@end
