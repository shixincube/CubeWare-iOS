//
//  CWProgressLineView.m
//  SPCubeWareDev
//
//  Created by 陆川 on 2018/4/20.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import "CWProgressLineView.h"
#import "CWColorUtil.h"

@implementation CWProgressLineView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [CWColorUtil colorWithRGB:0xd3d3d3 andAlpha:1];
    }
    return self;
}
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef content = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0,rect.size.width * _progress, rect.size.height)];
    [[CWColorUtil colorWithRGB:0x4393f9 andAlpha:1] setFill];
    CGContextAddPath(content, path.CGPath);
    CGContextFillPath(content);
}


@end
