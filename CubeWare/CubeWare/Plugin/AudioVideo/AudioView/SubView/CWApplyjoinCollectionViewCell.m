//
//  CWApplyjoinCollectionViewCell.m
//  CubeWare
//
//  Created by Mario on 2017/6/19.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWApplyjoinCollectionViewCell.h"

@implementation CWApplyjoinCollectionViewCell
-(UIImageView *)imageView{
    
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.layer.cornerRadius = self.frame.size.height / 2;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}
@end
