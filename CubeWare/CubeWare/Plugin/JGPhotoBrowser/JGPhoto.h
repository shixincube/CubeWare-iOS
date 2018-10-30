//
//  JGPhoto.h
//  JGPhotoBrowser
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FLAnimatedImage;

@interface JGPhoto : NSObject

@property (nonatomic, assign) NSInteger index; // 索引
@property (nonatomic, copy) NSURL *url; // 图片链接
@property (nonatomic, copy) NSString *extraText; // 图片文字介绍
@property (nonatomic, strong) UIImage *image; // 完整的图片
@property (nonatomic, strong, nullable) FLAnimatedImage *GIFImage; // 完整的GIF图片

@property (nonatomic, strong) UIImageView *srcImageView; // 来源view
@property (nonatomic, strong) UIImage *placeholder; // 默认为srcImageView图片，可单独设置
@property (nonatomic, strong, readonly) UIImage *capture; // 截图
@property (nonatomic, strong) NSString *identifier;//图片标识

// 是否已经保存到相册，仅当次有效
@property (nonatomic, assign) BOOL saved;

@end

NS_ASSUME_NONNULL_END
