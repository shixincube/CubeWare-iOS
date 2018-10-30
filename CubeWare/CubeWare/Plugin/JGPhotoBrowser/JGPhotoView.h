//
//  JGPhotoView.h
//  JGPhotoBrowser
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JGPhoto;
@class JGPhotoView;

@protocol JGPhotoViewDelegate <NSObject>

@required
- (void)photoViewImageFinishLoad:(JGPhotoView *)photoView;
- (void)photoViewSingleTap:(JGPhotoView *)photoView;

@end

@interface JGPhotoView : UIScrollView

// 图片
@property (nonatomic, strong) JGPhoto *photo;

// 代理
@property (nonatomic, weak) id<JGPhotoViewDelegate> photoViewDelegate;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
