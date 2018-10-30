//
//  CWMoreItemCell.m
//  CWRebuild
//
//  Created by luchuan on 2017/12/28.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import "CWMoreItemCell.h"
#import "CWResourceUtil.h"
#import "CWColorUtil.h"
#import <Masonry.h>
@interface CWMoreItemCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLab;

@end
@implementation CWMoreItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat font = _expectFont ? _expectFont : 12;
        CGFloat space = _expectSpace ? _expectSpace : 15;
        CGFloat titleH = [UIFont systemFontOfSize:font].lineHeight;
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self).offset(-(space + titleH) / 2);
            make.centerX.mas_equalTo(self);
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageV.mas_bottom).offset(space);
            make.centerX.mas_equalTo(self);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark - getters and setters
-(void)setToolBarItemModel:(CWToolBarItemModel *)toolBarItemModel{
    _toolBarItemModel = toolBarItemModel;
    self.imageV.image = [CWResourceUtil imageNamed:_toolBarItemModel.image];
    self.imageV.highlighted = [CWResourceUtil imageNamed:_toolBarItemModel.selectImage];
    self.titleLab.text = _toolBarItemModel.title;
}

-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        [self addSubview:_imageV];
    }
    return _imageV;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:(_expectFont ? _expectFont : 12)];
        _titleLab.textColor = [CWColorUtil colorWithRGB:0x333333 andAlpha:1];
        
        [self addSubview:_titleLab];
    }
    return _titleLab;
}

@end
