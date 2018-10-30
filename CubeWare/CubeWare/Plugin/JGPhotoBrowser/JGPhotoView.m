//
//  JGPhotoView.m
//  JGPhotoBrowser
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import "JGPhotoView.h"
#import "JGPhoto.h"
#import "JGPhotoStatusView.h"
#import "FLAnimatedImageView+WebCache.h"
#import "JGSourceBase.h"
#define JGPhotoBrowserDeviceScale [UIScreen mainScreen].scale

@interface JGPhotoView () <UIScrollViewDelegate> {
    
    BOOL _zoomByDoubleTap;
    FLAnimatedImageView *imgViewWithGIF;
    JGPhotoStatusView *photoStatusView;
}

@end

@implementation JGPhotoView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        // 图片
        imgViewWithGIF = [[FLAnimatedImageView alloc] init];
        imgViewWithGIF.backgroundColor = [UIColor blackColor];
        imgViewWithGIF.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imgViewWithGIF];
        
        // 进度条
        photoStatusView = [[JGPhotoStatusView alloc] init];
        
        // 属性
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

- (void)dealloc {
    
    //JGLog(@"<%@: %p>", NSStringFromClass([self class]), self);
    
    // 取消请求
    [imgViewWithGIF sd_setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
}

#pragma mark - View
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    [self adjustFrame];
//}

#pragma mark - 显示图片
- (void)setPhoto:(JGPhoto *)photo {
    
    _photo = photo;
    
    [self startLoadPhotoImage];
    [self adjustFrame];
}

- (void)adjustFrame {
    
    if (imgViewWithGIF.image == nil) {
        return;
    }
    
    // 基本尺寸参数
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    CGFloat imageWidth = imgViewWithGIF.image.size.width;
    CGFloat imageHeight = imgViewWithGIF.image.size.height;
    
    // 设置伸缩比例
    CGFloat imageScale = boundsWidth / imageWidth;
    CGFloat minScale = MIN(0.8, imageScale);
    
    CGFloat maxScale = 3.0;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, MAX(0, (boundsHeight- imageHeight*imageScale) * 0.5), boundsWidth, imageHeight *imageScale);
    
    self.contentSize = CGSizeMake(CGRectGetWidth(imageFrame), CGRectGetHeight(imageFrame));
    imgViewWithGIF.frame = imageFrame;
}

#pragma mark - Load
- (void)startLoadPhotoImage {
    
    if (_photo.GIFImage) {
        
        [photoStatusView removeFromSuperview];
        imgViewWithGIF.animatedImage = _photo.GIFImage;
        self.scrollEnabled = YES;
    }
    else if (_photo.image) {
        
        [photoStatusView removeFromSuperview];
        imgViewWithGIF.image = _photo.image;
        self.scrollEnabled = YES;
    }
    else {
        
        imgViewWithGIF.image = _photo.placeholder;
        self.scrollEnabled = NO;
        //如果url为本地存储路径
        if(![_photo.url.absoluteString hasPrefix:@"http"]){
            imgViewWithGIF.image = [UIImage imageWithContentsOfFile:_photo.url.absoluteString];
            [self photoImageDidFinishLoad];
            return;
        }
        // 直接显示进度条
        [photoStatusView showWithStatus:JGPhotoStatusLoading];
        [self addSubview:photoStatusView];
        
        JGWeak(self);
        JGWeak(photoStatusView);
        
        [imgViewWithGIF sd_setImageWithURL:_photo.url placeholderImage:_photo.image ?: _photo.placeholder options:(SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageHandleCookies | SDWebImageTransformAnimatedImage) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
            if (receivedSize > JGPhotoLoadMinProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    JGStrong(photoStatusView);
                    photoStatusView.progress = (CGFloat)receivedSize / expectedSize;
                });
            }
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                JGStrong(self);
                [self photoImageDidFinishLoad];
            });
        }];
    }
}

- (void)photoImageDidFinishLoad {
    
    if (imgViewWithGIF.image) {
        
        self.scrollEnabled = YES;
        _photo.GIFImage = imgViewWithGIF.animatedImage;
        _photo.image = imgViewWithGIF.image;
        [photoStatusView removeFromSuperview];
        
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
            [self.photoViewDelegate photoViewImageFinishLoad:self];
        }
    }
    else {
        
        [self addSubview:photoStatusView];
        [photoStatusView showWithStatus:JGPhotoStatusLoadFail];
    }
    
    // 设置缩放比例
    [self adjustFrame];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    if (_zoomByDoubleTap) {
        
        CGFloat insetY = (CGRectGetHeight(self.bounds) - CGRectGetHeight(imgViewWithGIF.frame)) * 0.5;
        insetY = MAX(insetY, 0.0);
        if (ABS(imgViewWithGIF.frame.origin.y - insetY) > (1.f / JGPhotoBrowserDeviceScale)) {
            
            CGRect imageViewFrame = imgViewWithGIF.frame;
            imageViewFrame = CGRectMake(imageViewFrame.origin.x, insetY, imageViewFrame.size.width, imageViewFrame.size.height);
            imgViewWithGIF.frame = imageViewFrame;
        }
    }
    
    return imgViewWithGIF;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    _zoomByDoubleTap = NO;
    CGFloat insetY = (CGRectGetHeight(self.bounds) - CGRectGetHeight(imgViewWithGIF.frame)) * 0.5;
    insetY = MAX(insetY, 0.0);
    if (ABS(imgViewWithGIF.frame.origin.y - insetY) > (1.f / JGPhotoBrowserDeviceScale)) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect imageViewFrame = imgViewWithGIF.frame;
            imageViewFrame = CGRectMake(imageViewFrame.origin.x, insetY, imageViewFrame.size.width, imageViewFrame.size.height);
            imgViewWithGIF.frame = imageViewFrame;
        }];
    }
}

#pragma mark - Gesture
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    
    // 移除提示
    [UIView animateWithDuration:0.2 animations:^{
        photoStatusView.alpha = 0;
    } completion:^(BOOL finished) {
        [photoStatusView removeFromSuperview];
    }];
    
    // 通知代理
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
        [self.photoViewDelegate photoViewSingleTap:self];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    
    //双击放大
    _zoomByDoubleTap = YES;
    if (self.zoomScale == self.maximumZoomScale) {
        
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
    else {
        
        CGPoint touchPoint = [tap locationInView:self];
        CGFloat scale = self.maximumZoomScale / self.zoomScale;
        CGRect rectTozoom = CGRectMake(touchPoint.x * scale, touchPoint.y * scale, 1, 1);
        [self zoomToRect:rectTozoom animated:YES];
    }
}

#pragma mark - End

@end
