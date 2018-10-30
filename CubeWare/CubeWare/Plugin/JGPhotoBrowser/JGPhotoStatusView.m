//
//  JGPhotoStatusView.m
//  JGPhotoBrowser
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import "JGPhotoStatusView.h"
#import "JGSourceBase.h"
#import "JGPhotoProgressView.h"

@interface JGPhotoStatusView () {
    
    UILabel *_statusLabel;
    JGPhotoProgressView *_progressView;
}

@end

@implementation JGPhotoStatusView

#pragma mark - init
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - init
- (void)dealloc {
    
    //JGLog(@"<%@: %p>", NSStringFromClass([self class]), self);
}

#pragma mark - View
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat borderWidth = 76.f / 320.f * MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    CGFloat maxWidth = MIN(CGRectGetWidth(self.frame) - 18 * 2, CGRectGetHeight(self.frame) - 18 * 2);
    
    // status
    [_statusLabel sizeToFit];
    CGRect labelFrame = _statusLabel.frame;
    labelFrame.size.width = MIN(maxWidth, MAX(borderWidth, CGRectGetWidth(labelFrame) + 18 * 2));
    labelFrame.size.height = MIN(maxWidth, MAX(borderWidth, CGRectGetHeight(labelFrame) + 18 * 2));
    if (CGRectGetWidth(labelFrame) / CGRectGetHeight(labelFrame) > 16 / 9.f) {
        labelFrame.size.height = CGRectGetWidth(labelFrame) / (16 / 9.f);
    }
    else if (CGRectGetHeight(labelFrame) / CGRectGetWidth(labelFrame) > 16 / 9.f) {
        labelFrame.size.width = CGRectGetHeight(labelFrame) / (16 / 9.f);
    }
    labelFrame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(labelFrame)) * 0.5;
    labelFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(labelFrame)) * 0.5;
    _statusLabel.frame = labelFrame;
    
    // loading
    _progressView.frame = CGRectMake((CGRectGetWidth(self.frame) - borderWidth) * 0.5, (CGRectGetHeight(self.frame) - borderWidth) * 0.5, borderWidth, borderWidth);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    if (newSuperview) {
        self.frame = newSuperview.bounds;
        [self setNeedsLayout];
    }
}

#pragma mark - Show
- (void)showWithStatus:(JGPhotoStatus)status {
    
    switch (status) {
        case JGPhotoStatusLoading:
            [self setProgress:0];
            break;
            
        case JGPhotoStatusLoadFail:
            [self showWithStatusString:@"网络不给力\n图片下载失败"];
            break;
            
        case JGPhotoStatusSaveFail:
            [self showWithStatusString:@"保存失败"];
            break;
            
        case JGPhotoStatusSaveSuccess:
            [self showWithStatusString:@"已成功保存到相册"];
            break;
            
        case JGPhotoStatusPrivacy: {
            NSString *execute = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
            [self showWithStatusString:[NSString stringWithFormat:@"请在设置中开启\"%@\"的相册访问权限", execute]];
        }
            break;
            
        case JGPhotoStatusNone:
            break;
    }
}

- (void)showWithStatusString:(NSString *)string {
    
    [_progressView removeFromSuperview];
    if (!_statusLabel) {
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont boldSystemFontOfSize:16];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.numberOfLines = 0;
        _statusLabel.layer.cornerRadius = 4.f;
        _statusLabel.layer.masksToBounds = YES;
    }
    if (!_statusLabel.superview && string.length > 0) {
        [self addSubview:_statusLabel];
    }
    
    // 显示行距问题
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineHeightMultiple = 1.2;
    style.alignment = NSTextAlignmentCenter;
    _statusLabel.attributedText = [[NSAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName : style}];
    [self setNeedsLayout];
}

- (void)showLoadingWithProgress:(CGFloat)progress {
    
    [_statusLabel removeFromSuperview];
    if (!_progressView) {
        
        _progressView = [[JGPhotoProgressView alloc] init];
    }
    if (!_progressView.superview && progress < 1.0) {
        [self addSubview:_progressView];
    }
    _progressView.progress = MAX(JGPhotoLoadMinProgress, progress);
    [self setNeedsLayout];
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    [self showLoadingWithProgress:_progress];
}

#pragma mark - End

@end
