//
//  CWEmojiTabBarCell.m
//  CubeWare
//
//  Created by luchuan on 2018/1/3.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWEmojiTabBarCell.h"
#import <Masonry.h>
@interface CWEmojiTabBarCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLab;
@end

@implementation CWEmojiTabBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(6, 6, 6, 6));
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

-(void)setEmojiPackageModel:(CWEmojiPackageModel *)emojiPackageModel{
    _emojiPackageModel = emojiPackageModel;
    self.imageV.image = [UIImage imageWithContentsOfFile:emojiPackageModel.chatPanelFilePath];
}

-(void)setSelected:(BOOL)selected{
    if (selected) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
