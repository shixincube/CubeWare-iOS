//
//  CWVWWaterView.m
//  CubeWare
//
//  Created by Mario on 17/2/13.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWVWWaterView.h"
#import "CubeWareHeader.h"

@interface CWVWWaterView ()
{
    float _a;
    float _b;
    float _c;
    BOOL jia;
}

@property (nonatomic, strong) NSTimer *animationTimer;

@end

@implementation CWVWWaterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _a = 1.5;
        _b = 0;
        _c = 0;
        jia = NO;
        _currentWaterColor = [UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1];
        _currentLinePointY = (UIScreenHeight-64)/2;//波浪线距离View上边界的距离
//        [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        self.animationTimer = [NSTimer timerWithTimeInterval:0.03 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
         [self.animationTimer setFireDate:[NSDate distantFuture]];
        [[NSRunLoop mainRunLoop] addTimer:self.animationTimer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andLineColor:(UIColor *)color andA:(float)a andB:(float)b {
    if ([super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        _a = a;
        _b = b;
        _c = 0;
        jia = NO;
        _currentWaterColor = color;
        _currentLinePointY = (UIScreenHeight-64)/2;//波浪线距离View上边界的距离Height/1.647
//        [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        self.animationTimer = [NSTimer timerWithTimeInterval:0.03 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        [self.animationTimer setFireDate:[NSDate distantFuture]];
        [[NSRunLoop mainRunLoop] addTimer:self.animationTimer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

-(void)animateWave
{
    if (jia) {
        _a += 0.01;
    }else{
        _a -= 0.01;
    }
    if (_a<=1) {
        jia = YES;
    }
    if (_a>=3) {
        jia = NO;
    }
    _b+=0.1;
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIColor *color = _currentWaterColor;
    [color set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]);
    float y=_currentLinePointY;
    CGPathMoveToPoint(path, NULL, 0, y);
    for(float x=_c;x<=UIScreenWidth;x++){
        y= _a * sin( x/180*M_PI + 4*_b/M_PI ) * 5 + _currentLinePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGPathAddLineToPoint(path, nil, rect.size.width , rect.size.height);//
    CGPathAddLineToPoint(path, nil, -1, rect.size.height);
    CGPathAddLineToPoint(path, nil, -1, _currentLinePointY);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}

-(void)startAnimation{
    [self.animationTimer setFireDate:[NSDate distantPast]];
    [self.animationTimer fire];
}

-(void)stopAnimation{
    [self.animationTimer setFireDate:[NSDate distantFuture]];
    [self.animationTimer fire];
}

@end
