//
//  JGPhotoToolbar.m
//  JGPhotoBrowser
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import "JGPhotoToolbar.h"
#import "JGPhoto.h"


@interface JGPhotoToolClose : UIButton

@end

@interface JGPhotoToolbar()

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) UIView *colorBgView;
@property (nonatomic, strong) JGPhotoToolClose *closeBtn;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIButton *saveImageBtn;

@end

@implementation JGPhotoToolbar

#pragma mark - init
- (instancetype)initWithPhotosCount:(NSInteger)count index:(NSInteger)curIndex {
    
    self = [super init];
    if (self) {
        
        _totalCount = count;
        _currentIndex = curIndex;
        
        [self setupViewElements];
    }
    
    return self;
}

- (void)dealloc {
    
    //JGLog(@"<%@: %p>", NSStringFromClass([self class]), self);
}

#pragma mark - View
- (void)setupViewElements {
    
    // bg
    _colorBgView = [[UIView alloc] init];
//    _colorBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.28];
    _colorBgView.backgroundColor = [UIColor blackColor];
    [self addSubview:_colorBgView];
    
    // 关闭
    _closeBtn = [JGPhotoToolClose buttonWithType:UIButtonTypeCustom];
    [_closeBtn addTarget:self action:@selector(closeShow:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];
    _closeBtn.hidden = YES;
    
    // 页码
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.backgroundColor = [UIColor clearColor];
    _indexLabel.font = [UIFont systemFontOfSize:18];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_indexLabel];
    _indexLabel.hidden = _totalCount <= 1;
    
    // 保存图片按钮
//    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn =nil;// 不需要这个按钮
    _saveImageBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_saveImageBtn setTitleColor:_indexLabel.textColor forState:UIControlStateNormal];
    [_saveImageBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveImageBtn addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];
    _saveImageBtn.hidden = YES;
}

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
    
    // btn
    [_saveImageBtn sizeToFit];
    CGRect btnFrame = _saveImageBtn.frame;
    btnFrame.size.width = CGRectGetWidth(btnFrame) + 8 * 2;
    btnFrame.size.height = CGRectGetHeight(btnFrame) + 4 * 2;
    btnFrame.origin.x = CGRectGetWidth(self.bounds) - 20 - CGRectGetWidth(btnFrame);
    btnFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(btnFrame)) * 0.5;
    _saveImageBtn.frame = btnFrame;
    
    // index
    [_indexLabel sizeToFit];
    CGRect indexFrame = _indexLabel.frame;
    CGFloat btnMinX = CGRectGetMinX(btnFrame);
    indexFrame.size.width = MIN(CGRectGetWidth(_indexLabel.frame), btnMinX - (CGRectGetWidth(self.bounds) - btnMinX));
    indexFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(indexFrame)) * 0.5;
    indexFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(indexFrame)) * 0.5;
    _indexLabel.frame = indexFrame;
    
    // clsoe
    _closeBtn.frame = CGRectMake(20, (CGRectGetHeight(self.bounds) - CGRectGetHeight(btnFrame)) * 0.5, CGRectGetHeight(btnFrame), CGRectGetHeight(btnFrame));
}

- (void)setBrowserSafeAreaInsets:(UIEdgeInsets)browserSafeAreaInsets {
    _browserSafeAreaInsets = browserSafeAreaInsets;
    [self setNeedsLayout];
}

#pragma mark - Index
- (void)changeCurrentIndex:(NSInteger)toIndex indexsaved:(BOOL)saved {
    
    // 更新页码
    _currentIndex = toIndex;
    _indexLabel.text = [NSString stringWithFormat:@"%zd/%zd", _currentIndex + 1, _totalCount];
    
    // 按钮
    [self setShowSaveBtn:!saved];
    [self setNeedsLayout];
}

- (void)setCloseShowAction:(void (^)(void))closeShowAction {
    
    _closeShowAction = closeShowAction;
    _closeBtn.hidden = !_closeShowAction;
}

- (void)setSaveShowPhotoAction:(void (^)(NSInteger))saveShowPhotoAction {
    
    _saveShowPhotoAction = saveShowPhotoAction;
    _saveImageBtn.hidden = (!_showSaveBtn || !_saveShowPhotoAction);
}

- (void)setShowSaveBtn:(BOOL)showSaveBtn {
    
    _showSaveBtn = showSaveBtn;
    _saveImageBtn.hidden = (!_showSaveBtn || !_saveShowPhotoAction);
}

#pragma mark - Action
- (void)closeShow:(JGPhotoToolClose *)sender {
    
    if (_closeShowAction) {
        _closeShowAction();
        _closeShowAction = nil;
    }
}

- (void)saveImage:(UIButton *)sender {
    
    if (_saveShowPhotoAction) {
        _saveShowPhotoAction(_currentIndex);
    }
}

#pragma mark - End

@end

@implementation JGPhotoToolClose

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat centerX = CGRectGetWidth(self.frame) * 0.5, circleY = CGRectGetHeight(self.frame) * 0.5, strokeWidth = 1.5;
    CGFloat radius = CGRectGetWidth(self.frame) * 0.5, closeDis = radius * 0.5 * sin(M_PI_4);
    CGFloat closeMinX = centerX - closeDis, closeMaxX = centerX + closeDis;
    CGFloat closeMinY = circleY - closeDis, closeMaxY = circleY + closeDis;
    
    // 绘制参数
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, strokeWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetShouldAntialias(ctx, true);
    
    // 绘制圆，半径处理，否则边界被切
    //CGContextAddArc(ctx, centerX, circleY, radius - strokeWidth * 0.5, 0, M_PI * 2, true);
    
    // 绘制圆中心叉
    CGContextMoveToPoint(ctx, closeMinX, closeMinY);
    CGContextAddLineToPoint(ctx, closeMaxX, closeMaxY);
    CGContextMoveToPoint(ctx, closeMinX, closeMaxY);
    CGContextAddLineToPoint(ctx, closeMaxX, closeMinY);
    
    CGContextStrokePath(ctx);
}

@end
