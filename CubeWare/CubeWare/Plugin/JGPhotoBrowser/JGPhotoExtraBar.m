//
//  JGPhotoExtraBar.m
//  JGPhotoBrowser
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import "JGPhotoExtraBar.h"
#import "JGSourceBase.h"

@interface JGPhotoExtraBar ()

@property (nonatomic, strong) UIView *colorBgView;
@property (nonatomic, strong) UITextView *extraTextView;

@end

@implementation JGPhotoExtraBar

#pragma mark - init
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self initViewElements];
    }
    return self;
}

- (void)initViewElements {
    
    // bg
    _colorBgView = [[UIView alloc] init];
    _colorBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.28];
    [self addSubview:_colorBgView];
    
    // text
    _extraTextView = [[UITextView alloc] init];
    _extraTextView.contentInset = UIEdgeInsetsMake(4, 8, 4, 8);
    _extraTextView.backgroundColor = [UIColor clearColor];
    _extraTextView.editable = NO;
    _extraTextView.textColor = [UIColor whiteColor];
    _extraTextView.showsVerticalScrollIndicator = NO;
    _extraTextView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_extraTextView];
}

- (void)dealloc {
    
    //JGLog(@"<%@: %p>", NSStringFromClass([self class]), self);
}

#pragma mark - View
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.backgroundColor && ![self.backgroundColor isEqual:[UIColor clearColor]]) {
        _colorBgView.backgroundColor = self.backgroundColor;
        self.backgroundColor = nil;
    }
    
    // bg
    CGRect bgFrame = self.bounds;
    bgFrame.origin.y -= _browserSafeAreaInsets.top;
    bgFrame.size.height += (_browserSafeAreaInsets.top + _browserSafeAreaInsets.bottom);
    _colorBgView.frame = bgFrame;
    
    // text
    _extraTextView.frame = bgFrame;
    _extraTextView.contentInset = UIEdgeInsetsMake(4 + _browserSafeAreaInsets.top, 8 + _browserSafeAreaInsets.left, 4 + _browserSafeAreaInsets.bottom, 8 + _browserSafeAreaInsets.right);
}

- (void)setBrowserSafeAreaInsets:(UIEdgeInsets)browserSafeAreaInsets {
    _browserSafeAreaInsets = browserSafeAreaInsets;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text {
    
    _text = text;
    _extraTextView.contentOffset = CGPointZero;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 显示行距问题
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineHeightMultiple = 1.2;
    style.alignment = NSTextAlignmentLeft;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    _extraTextView.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:14]}];
}

#pragma mark - End

@end
