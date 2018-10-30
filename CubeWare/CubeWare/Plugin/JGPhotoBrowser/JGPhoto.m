//
//  JGPhoto.m
//  JGPhotoBrowser
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import "JGPhoto.h"
#import "JGSourceBase.h"

@implementation JGPhoto

#pragma mark - init
- (void)dealloc {
    
    //JGLog(@"<%@: %p>", NSStringFromClass([self class]), self);
}

#pragma mark 截图
- (UIImage *)capture:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)setSrcImageView:(UIImageView *)srcImageView {
    
    _srcImageView = srcImageView;
    _placeholder = self.placeholder ?: srcImageView.image;
    if (srcImageView.clipsToBounds) {
        
        _capture = [self capture:srcImageView];
    }
}

#pragma mark - End

@end
