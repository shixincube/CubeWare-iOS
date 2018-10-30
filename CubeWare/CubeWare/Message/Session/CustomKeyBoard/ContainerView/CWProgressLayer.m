//
//  CWProgressLayer.m
//  SPCubeWareDev
//
//  Created by 陆川 on 2018/4/14.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import "CWProgressLayer.h"
#import "CWColorUtil.h"
#import <objc/runtime.h>
@implementation CWProgressLayer
static const char *circleWidthKey = "circleWidthKey";
+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

-(id)initWithLayer:(id)layer {
    if( ( self = [super initWithLayer:layer] ) ) {
        if ([layer isKindOfClass:[CWProgressLayer class]]) {
            self.circleWidth = ((CWProgressLayer*)layer).circleWidth;
        }
    }
    return self;
}

- (void)starAnimation:(CGFloat)time{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = time;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.repeatCount = 1;
    [self addAnimation:animation forKey:@"progressing"];
}
- (void)stopAnimation{
    [self removeAnimationForKey:@"progressing"];
}
- (void)pauseAnimation {
    //（0-5）
    //开始时间：0
    //    myView.layer.beginTime
    //1.取出当前时间，转成动画暂停的时间
    CFTimeInterval pauseTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    
    //2.设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
    self.timeOffset = pauseTime;
    
    //3.将动画的运行速度设置为0， 默认的运行速度是1.0
    self.speed = 0;
    
}
//恢复动画
- (void)resumeAnimation {
    //1.将动画的时间偏移量作为暂停的时间点
    CFTimeInterval pauseTime = self.timeOffset;
    //2.计算出开始时间
    CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
    [self setTimeOffset:0];
    [self setBeginTime:begin];
    self.speed = 1;
}

- (void)setCircleWidth:(CGFloat)circleWidth{
    _circleWidth = circleWidth;
}
-(void)drawInContext:(CGContextRef)ctx{
    CGFloat radius = self.bounds.size.width / 2;
    CGFloat lineWidth = _circleWidth ?  _circleWidth : 5;
    CGFloat startAngle  = -M_PI_2;
    CGFloat EndAngle = startAngle + self.progress * M_PI * 2;
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius - lineWidth / 2 startAngle:startAngle endAngle:EndAngle clockwise:YES];
    CGContextSetStrokeColorWithColor(ctx, [CWColorUtil colorWithRGB:0x4393f9 andAlpha:1].CGColor);
    CGContextSetLineWidth(ctx, lineWidth);//线条宽度
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);
}
@end
