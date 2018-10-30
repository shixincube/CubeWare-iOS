//
//  JGPhotoToolbar.h
//  JGPhotoBrowser
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JGPhoto;

@interface JGPhotoToolbar : UIView

/** 需要显示关闭按钮时，关闭按钮的回调，回调存在则显示关闭按钮，内部回调完成后则置空该回调 */
@property (nonatomic, copy) void (^closeShowAction)(void);

/** 显示保存按钮时，保存按钮的回调，如置空则不显示保存按钮，注意内存循环引用问题 */
@property (nonatomic, copy) void (^saveShowPhotoAction)(NSInteger index);

/** 是否显示保存按钮 */
@property (nonatomic, assign) BOOL showSaveBtn;

/** iOS 11 SafeArea适配，用于iOS 11顶部、底部适配 */
@property (nonatomic, assign) UIEdgeInsets browserSafeAreaInsets;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithPhotosCount:(NSInteger)count index:(NSInteger)curIndex;

/** 更新当前显示序号及是否显示保存按钮 */
- (void)changeCurrentIndex:(NSInteger)toIndex indexsaved:(BOOL)saved;

@end

NS_ASSUME_NONNULL_END
