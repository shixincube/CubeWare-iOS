//
//  CDSearchTableViewCell.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/10/24.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDSearchTableViewCell.h"

@interface CDSearchTableViewCell()

/**
 状态
 */
@property (nonatomic,strong) UILabel *status;

/**
 群组头像
 */
@property (nonatomic,strong) UIImageView *iconView;

/**
 群组名称
 */
@property (nonatomic,strong) UILabel *groupName;
@end
@implementation CDSearchTableViewCell

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
        [self addSubview:self.iconView];
        [self addSubview:self.groupName];
        [self addSubview:self.status];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(18);
        }];
        [self.groupName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(200);
            make.left.equalTo(self.iconView.mas_right).offset(12);
        }];
        [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
    }
    return self;
}


- (void)setIsJoined:(BOOL)isJoined
{
    self.status.hidden = !isJoined;
}

- (void)setGroup:(CubeGroup *)group
{
    _group = group;
    self.groupName.text = group.displayName;
    [self.iconView  sd_setImageWithURL:[NSURL URLWithString:group.avatar] placeholderImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
}

- (UILabel *)status
{
    if (nil == _status) {
        _status = [[UILabel alloc]initWithFrame:CGRectZero];
        _status.backgroundColor = [UIColor clearColor];
        _status.font = [UIFont systemFontOfSize:14];
        _status.text = @"已加入";
        _status.textColor = RGBA(0x99, 0x99, 0x99, 1);
        _status.textAlignment = NSTextAlignmentCenter;
    }
    return _status;
}

- (UILabel *)groupName
{
    if (nil == _groupName) {
        _groupName = [[UILabel alloc]initWithFrame:CGRectZero];
        _groupName.backgroundColor = [UIColor clearColor];
        _groupName.font = [UIFont systemFontOfSize:16];
    }
    return _groupName;
}

- (UIImageView *)iconView
{
    if (nil == _iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.layer.cornerRadius = 20;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}
@end
