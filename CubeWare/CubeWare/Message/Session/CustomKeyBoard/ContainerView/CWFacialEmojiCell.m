//
//  CWFacialEmojiCell.m
//  CWRebuild
//
//  Created by luchuan on 2018/1/2.
//  Copyright © 2018年 luchuan. All rights reserved.
//

#import "CWFacialEmojiCell.h"
#import "CWColorUtil.h"

#define DefaultFont 12
#define DefaultSpace 10


@interface CWFacialEmojiCell()

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UILabel *titleLab;

@end
@implementation CWFacialEmojiCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat titleH = [UIFont systemFontOfSize:DefaultFont].lineHeight;
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(self);
            make.height.mas_equalTo(@(titleH));
        }];
        
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self);
            make.bottom.mas_equalTo(self.titleLab.mas_top);
        }];
    }
    return self;
}
#pragma mark - getter and setter
-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
         [self addSubview:_imageV];
    }
    return _imageV;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:DefaultFont];
        _titleLab.textColor = [CWColorUtil colorWithRGB:0x8a8a8a andAlpha:1];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}

//-(void)setSimpleEmojiModel:(CWSimpleEmojiModel *)simpleEmojiModel{
//    _simpleEmojiModel = simpleEmojiModel;
//    self.imageV.image = [UIImage imageWithContentsOfFile:simpleEmojiModel.pngfilePath];
//    self.titleLab.text = simpleEmojiModel.chs;
//}


@end
