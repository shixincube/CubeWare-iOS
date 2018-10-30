//
//  CWToolBarItemCell.m
//  CWRebuild
//
//  Created by luchuan on 2017/12/28.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import "CWToolBarItemCell.h"
#import "CWResourceUtil.h"
#import <Masonry.h>
@interface CWToolBarItemCell ()
@property (nonatomic, strong) UIImageView *imageV;
@end
@implementation CWToolBarItemCell
-(void)layoutSubviews{
    [super layoutSubviews];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.imageV.highlighted = selected;
}
-(void)setTooBarItemModel:(CWToolBarItemModel *)tooBarItemModel{
    _tooBarItemModel = tooBarItemModel;
    self.imageV.image = [CWResourceUtil imageNamed:tooBarItemModel.image];
    self.imageV.highlightedImage = [CWResourceUtil imageNamed:tooBarItemModel.selectImage];
}
-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageV];
    }
    return _imageV;
}



@end
