//
//  CWBezierView.m
//  CubeWare
//
//  Created by Mario on 2017/7/7.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWBezierView.h"
#import "CubeWareHeader.h"

@interface CWBezierView()

@property(nonatomic,strong)UIBezierPath            *processPath;

@property(nonatomic,strong)CAShapeLayer            *progerssLayer;

@end

@implementation CWBezierView

- (void)drawRect:(CGRect)rect
{
    
    UIBezierPath *pacmanOpenPath;
    
    CGFloat radius = 20;
    CGPoint arcCenter = CGPointMake(20, 20);
    
    //定制一段圆弧
    pacmanOpenPath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                    radius:radius
                                                startAngle: 0
                                                  endAngle: 3 * M_PI / 2
                                                 clockwise: YES];
    
    //生成color数组
    NSMutableArray *colors = nil;
    if (colors == nil) {
        colors = [[NSMutableArray alloc] initWithCapacity:3];
        UIColor *color = nil;
        color = UIColorFromRGB(0x7a8fdf);
        [colors addObject:(id)[color CGColor]];
        color = [UIColor whiteColor];
        [colors addObject:(id)[color CGColor]];
    }
    
    //CAGradientLayer 渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [gradientLayer setColors:colors];
    gradientLayer.frame = CGRectMake(0, 0, 60, 60);
    [self.layer addSublayer:gradientLayer];
    
    //CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.fillMode = kCAFillRuleEvenOdd;
    shapeLayer.path = pacmanOpenPath.CGPath;
    shapeLayer.strokeColor = [UIColor yellowColor].CGColor;
    shapeLayer.lineWidth = 3;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.frame = CGRectMake(10, 10, 40, 40);
    
    //遮罩，将shapelayer 遮罩到渐变layer
    gradientLayer.mask = shapeLayer;
    
    //旋转动画
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    spinAnimation.fromValue = [NSNumber numberWithInt:0];
    spinAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    spinAnimation.duration = 2.0;
    spinAnimation.repeatCount = HUGE_VALF;
    [shapeLayer addAnimation:spinAnimation forKey:@"shapeRotateAnimation"];
    
    //渐变layer 一样旋转，造成渐变效果
    [gradientLayer addAnimation:spinAnimation forKey:@"GradientRotateAniamtion"];
}


@end
