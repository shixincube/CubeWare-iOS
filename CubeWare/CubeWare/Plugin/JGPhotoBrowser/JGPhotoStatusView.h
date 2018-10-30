//
//  JGPhotoStatusView.h
//  JGPhotoBrowser
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define JGPhotoLoadMinProgress 0.0001

typedef NS_ENUM(NSInteger, JGPhotoStatus) {
    JGPhotoStatusNone = 0,
    JGPhotoStatusLoading = 1,
    JGPhotoStatusLoadFail,
    JGPhotoStatusSaveSuccess,
    JGPhotoStatusSaveFail,
    JGPhotoStatusPrivacy,
    
    JGPhotoStatusDefault = JGPhotoStatusNone,
};

@interface JGPhotoStatusView : UIView

@property (nonatomic, assign) CGFloat progress;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)showWithStatus:(JGPhotoStatus)status;

@end

NS_ASSUME_NONNULL_END
