//
//  JGPhotoProgressView.m
//  JGPhotoBrowser
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import "JGPhotoProgressView.h"
#import "JGSourceBase.h"

#define kDegreeToRadian(x) (M_PI/180.0 * (x))

@implementation JGPhotoProgressView

#pragma mark - init
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = self.trackTintColor;
        self.layer.cornerRadius = 4.f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - init
- (void)dealloc {
    
    //JGLog(@"<%@: %p>", NSStringFromClass([self class]), self);
}

#pragma mark - Draw
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat pathWidth = 8;
    CGPoint centerPoint = CGPointMake(rect.size.height * 0.5, rect.size.width * 0.5);
    CGFloat radius = MIN(rect.size.height, rect.size.width) * 0.5 - pathWidth * 0.5;
    
    CGFloat radians = kDegreeToRadian((_progress * 359.9) - 90);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, pathWidth);
    
    // 绘制半透明圆轨迹
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, kDegreeToRadian(270), kDegreeToRadian(-90), YES);
    CGContextAddPath(context, trackPath);
    CGContextSetStrokeColorWithColor(context, [self.trackTintColor colorWithAlphaComponent:0.6].CGColor);
    CGContextStrokePath(context);
    CGPathRelease(trackPath);
    
    // 绘制圆弧
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGMutablePathRef progressPath = CGPathCreateMutable();
    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, kDegreeToRadian(270), radians, NO);
    CGContextAddPath(context, progressPath);
    CGContextSetStrokeColorWithColor(context, self.progressTintColor.CGColor);
    CGContextStrokePath(context);
    CGPathRelease(progressPath);
    
    // 绘制圆弧内透明扇形
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGFloat innerRadius = radius - pathWidth * 0.5;
    CGMutablePathRef clearPath = CGPathCreateMutable();
    CGPathMoveToPoint(clearPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(clearPath, NULL, centerPoint.x, centerPoint.y, innerRadius, kDegreeToRadian(270), radians, NO);
    CGPathCloseSubpath(clearPath);
    CGContextAddPath(context, clearPath);
    CGContextFillPath(context);
    CGPathRelease(clearPath);
}

#pragma mark - Property Methods
- (UIColor *)trackTintColor {
    
    _trackTintColor = _trackTintColor ?: [UIColor colorWithWhite:0 alpha:0.7f];
    
    return _trackTintColor;
}

- (UIColor *)progressTintColor {
    
    _progressTintColor = _progressTintColor ?: [UIColor whiteColor];
    
    return _progressTintColor;
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    [self setNeedsDisplay];
}

#pragma mark - End

@end
