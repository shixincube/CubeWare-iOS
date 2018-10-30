//
//  JGPhotoBrowserImpl.h
//  JGPhotoBrowser
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@class JGPhoto;

@protocol JGPhotoBrowseDelegate<NSObject>

/**
 将图片发送给朋友

 @param photo 将要发送的图片
 */
- (void)photoBrowserDidSendFriend:(JGPhoto *)photo;

@end


@interface JGPhotoBrowser : UIViewController

@property (nonatomic, weak) id<JGPhotoBrowseDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (instancetype)initWithPhotos:(NSArray<JGPhoto *> *)photos index:(NSInteger)curIndex;
- (instancetype)initWithPhotos:(NSArray<JGPhoto *> *)photos index:(NSInteger)curIndex showSave:(BOOL)showSaveBtn;

// 显示
- (void)show;
- (void)showFromView:(UIView *)view;
/**
 隐藏
 */
- (void)closePhotoShow;


@end

NS_ASSUME_NONNULL_END
