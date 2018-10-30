//
//  CWProgressView.m
//  CubeWare
//
//  Created by Mario on 17/3/3.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWProgressView.h"
#import "CubeWareGlobalMacro.h"

#define CircleRadius 21.f

@interface CWProgressView ()

@property (nonatomic, assign) CGFloat progress;

@end

@implementation CWProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)tapGes:(UIGestureRecognizer *)ges
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapProgressView)]) {
        [_delegate tapProgressView];
    }
}

// 清除指示器
- (void)dismiss
{
    self.progress = 1.0;
    [self removeFromSuperview];
}

+ (id)progressView
{
    return [[self alloc] init];
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;

    // 背景圆环
    CGRect bigRect = CGRectMake(xCenter - CircleRadius, yCenter - CircleRadius, CircleRadius * 2, CircleRadius * 2);
    CGContextSetLineWidth(ctx, 1.f);
    CGContextAddEllipseInRect(ctx, bigRect);
    [UIColorFromRGBA(0xffffff, .7f) set];
    CGContextStrokePath(ctx);
    
    // 背景圆
    [UIColorFromRGBA(0xffffff, .7f) set];
    CGFloat w = (CircleRadius - 1) * 2;
    CGFloat h = w;
    CGFloat x = (rect.size.width - w) * 0.5;
    CGFloat y = (rect.size.height - h) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
    CGContextFillPath(ctx);
    // 进程圆
    [UIColorFromRGBA(0x000000, .5f) set];
    CGContextMoveToPoint(ctx, xCenter, yCenter);
    CGContextAddLineToPoint(ctx, xCenter, 0);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
    CGContextAddArc(ctx, xCenter, yCenter, CircleRadius - 1, - M_PI * 0.5, to, 1);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

@end
