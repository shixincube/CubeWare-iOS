//
//  CDAccountListCell.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/8/29.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDAccountListCell.h"

@interface CDAccountListCell ()

@property (nonatomic,strong) UIImageView *portraitImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *cubeIdLabel;

@end

@implementation CDAccountListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeAppearance];
    }
    return self;
}


#pragma mark - setter observe
- (void)setModel:(CDLoginAccountModel *)model{
    _model = model;
    self.nameLabel.text = model.displayName;
    self.cubeIdLabel.text = model.cubeId;
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
}


#pragma mark - appearance init
- (void)initializeAppearance{
    self.portraitImageView = [[UIImageView alloc]init];
    [self.portraitImageView setImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
    self.portraitImageView.layer.cornerRadius = 25;
    self.portraitImageView.layer.masksToBounds = YES;
    [self addSubview:self.portraitImageView];
    
    [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    self.nameLabel.textColor = RGBA(33, 33, 33, 1.f);
    [self addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitImageView.mas_right).offset(10);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(200);
    }];
    
    self.cubeIdLabel = [[UILabel alloc]init];
    self.cubeIdLabel.font = [UIFont systemFontOfSize:13];
    self.cubeIdLabel.textColor = RGBA(33, 33, 33, 1.f);
    [self addSubview:self.cubeIdLabel];
    
    [self.cubeIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitImageView.mas_right).offset(10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(200);
    }];
}

@end
