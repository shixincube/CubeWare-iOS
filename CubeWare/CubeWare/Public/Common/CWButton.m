//
//  CWButton.m
//  CubeWare
//
//  Created by Mario on 2017/9/5.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWButton.h"
#import "CubeWareHeader.h"
@implementation CWButton

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                   titleColor:(UIColor *)titlecolor
                    titleFont:(CGFloat)fontsize
                 cornerRadius:(CGFloat)radius
              backgroundColor:(UIColor *)backcolor
              backgroundImage:(UIImage *)backgroundimage
                        image:(UIImage *)image
{
    if (self == [super init]) {
        self.frame = frame;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:titlecolor forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:fontsize]];
        self.layer.cornerRadius = radius;
        self.clipsToBounds = YES;
        self.backgroundColor = backcolor;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self setBackgroundImage:backgroundimage forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        [self addTarget:self action:@selector(clicAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)setClickedAction:(UIButtonTouchAction)clickedAction{
    if (clickedAction) {
        _clickedAction = clickedAction;
    }
}

- (void)clicAction:(UIButton*)sender
{
    if (self.clickedAction) {
        self.clickedAction(sender);
    }
}
#pragma mark - Public

//展示左右上下线
- (void)showRightLine:(CGFloat)height
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-1, 1, 0.8, self.frame.size.height-2)];
    line.backgroundColor = UIColorFromRGB(0xe0e4e5);
    [self addSubview:line];
    if (height) {
        CGRect frame = line.frame;
        frame.size.height = height;
        line.frame = frame;
        
        line.center = CGPointMake(line.center.x, self.frame.size.height/2);
    }
}

@end
