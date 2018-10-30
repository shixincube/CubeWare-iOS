//
//  CDMeTableHeaderView.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/3.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDMeTableHeaderView.h"
@interface CDMeTableHeaderView()

/**
 按钮
 */
@property (nonatomic,strong) UIButton *button;
@end
@implementation CDMeTableHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance{
    self.portraitImageView = [[UIImageView alloc]init];
    self.portraitImageView.layer.cornerRadius = 45;
    self.portraitImageView.layer.masksToBounds = YES;
    self.portraitImageView.backgroundColor = KGray2Color;
    [self addSubview:self.portraitImageView];
    
    [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:24];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.portraitImageView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(self.width, 30));
    }];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.portraitImageView.mas_top);
        make.left.mas_equalTo(self.portraitImageView.mas_left);
        make.right.mas_equalTo(self.portraitImageView.mas_right);
        make.bottom.mas_equalTo(self.portraitImageView.mas_bottom);
    }];

}

-(void)onClick:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickAvatarBtn)]) {
        [self.delegate onClickAvatarBtn];
    }
}

@end
