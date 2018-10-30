//
//  CWPopView.m
//  CubeWare
//
//  Created by Zeng Changhuan on 2018/8/22.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import "CDPopView.h"
@interface CDPopView ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray  *centerHigh;
@property (nonatomic, strong) NSMutableArray  *centerLow;
@property (nonatomic, strong) NSMutableArray  *centerMenu;
@property (nonatomic, assign) BOOL isHidding ;
@property (nonatomic, strong) UIButton *nevermindButton;

@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIButton *whiteboardButton;
//@property (nonatomic, strong) UIButton *screenSharingButton;
@property (nonatomic,strong) UIView *lineView;
@end;
@implementation CDPopView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KClearColor;
        [self initImageView];
        [self initCenterArrayWithFrame:frame];
        [self setUpView];
    }
    return self;
}

//初始化按钮视图(尺寸+图片,使用不同尺寸适配不同屏幕->)
-(void)initImageView{
    UIImage *image = [UIImage imageNamed:@"button-chat"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);

    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceButton.frame = frame;
    [self.voiceButton setImage:[UIImage imageNamed:@"tab_more_voice_btn"] forState:UIControlStateNormal];
    [self.voiceButton setTitle:@"多人语音" forState:UIControlStateNormal];
    [self.voiceButton setTitleColor:KBlackColor forState:UIControlStateNormal];
    self.voiceButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.voiceButton.titleEdgeInsets = UIEdgeInsetsMake(0, -self.voiceButton.imageView.frame.size.width, -self.voiceButton.imageView.frame.size.height, 0);
    self.voiceButton.imageEdgeInsets = UIEdgeInsetsMake(-self.voiceButton.titleLabel.intrinsicContentSize.height, 0, 0, -self.voiceButton.titleLabel.intrinsicContentSize.width);

    self.whiteboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.whiteboardButton.frame = frame;
    [self.whiteboardButton setImage:[UIImage imageNamed:@"tab_more_whiteborad_btn"] forState:UIControlStateNormal];
    [self.whiteboardButton setTitle:@"白板演示" forState:UIControlStateNormal];
    [self.whiteboardButton setTitleColor:KBlackColor forState:UIControlStateNormal];
    self.whiteboardButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.whiteboardButton.titleEdgeInsets = UIEdgeInsetsMake(0, -self.whiteboardButton.imageView.frame.size.width, -self.whiteboardButton.imageView.frame.size.height, 0);
    self.whiteboardButton.imageEdgeInsets = UIEdgeInsetsMake(-self.whiteboardButton.titleLabel.intrinsicContentSize.height, 0, 0, -self.whiteboardButton.titleLabel.intrinsicContentSize.width);

    self.nevermindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nevermindButton.frame = CGRectMake(0, 0, self.frame.size.width, self.voiceButton.frame.size.height * 0.5);
    [self.nevermindButton setImage:[UIImage imageNamed:@"tab_more_close"] forState:UIControlStateNormal];
    [self.nevermindButton setBackgroundColor:[UIColor clearColor]];
    [self.nevermindButton setTitleColor:KGrayColor forState:UIControlStateNormal];

    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width , 0.5)];
    self.lineView.backgroundColor = KGray2Color;

    self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.backgroundView.backgroundColor = KClearColor;

    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
    view.frame = self.frame;
    [self.backgroundView addSubview:view];

    self.voiceButton.tag = 0;
    self.whiteboardButton.tag = 1;
//    self.screenSharingButton.tag = 2;
}
//尺寸数组
-(void)initCenterArrayWithFrame:(CGRect)frame{

    //每个按钮的边长
    CGFloat widthUnit = frame.size.width * 0.25;
    //屏幕上方
    CGFloat heightHight = frame.origin.y - self.voiceButton.frame.size.height * 0.5;
    //屏幕下方
    CGFloat heightLow = frame.size.height + self.voiceButton.frame.size.height * 0.5;
    //按钮直接间隔距离
    CGFloat gap = self.voiceButton.frame.size.height * 0.5 + 5;

    //上移尺寸
    self.centerHigh = [[NSMutableArray alloc] initWithObjects:[NSValue valueWithCGPoint:CGPointMake(widthUnit, heightHight)], [NSValue valueWithCGPoint:CGPointMake(widthUnit * 2, heightHight)],[NSValue valueWithCGPoint:CGPointMake(widthUnit * 3, heightHight)],nil];

    //下移尺寸
    self.centerLow = [[NSMutableArray alloc] initWithObjects:[NSValue valueWithCGPoint:CGPointMake(widthUnit, heightLow)], [NSValue valueWithCGPoint:CGPointMake(widthUnit * 2, heightLow)],[NSValue valueWithCGPoint:CGPointMake(widthUnit * 3, heightLow)],[NSValue valueWithCGPoint:CGPointMake(widthUnit * 2, frame.size.height + self.nevermindButton.frame.size.height * 0.5)],nil];

    //中间显示尺寸
    self.centerMenu = [[NSMutableArray alloc] initWithObjects:
                   [NSValue valueWithCGPoint:CGPointMake(widthUnit + 30, frame.size.height * 0.5 + gap)],
                   [NSValue valueWithCGPoint:CGPointMake((widthUnit + 30)*2, frame.size.height * 0.5 + gap)],
                   [NSValue valueWithCGPoint:CGPointMake(widthUnit, frame.size.height * 0.5 + gap)],
                   [NSValue valueWithCGPoint:CGPointMake(widthUnit * 2, frame.size.height * 0.5 + gap)],
                   [NSValue valueWithCGPoint:CGPointMake(widthUnit * 2, frame.size.height - self.nevermindButton.frame.size.height * 0.5)],
                   nil];
}
//初始化视图
-(void)setUpView{
    self.hidden = YES;

//    self.backgroundView.backgroundColor = [UIColor colorWithRed:61/255.0 green:77/255.0 blue:100/255.0 alpha:0.9];
    self.backgroundView.backgroundColor = [UIColor clearColor];


    //增加点击事件
    UITapGestureRecognizer *gestur = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.backgroundView setUserInteractionEnabled:YES];
    [self.backgroundView addGestureRecognizer:gestur];

    self.nevermindButton.hidden = YES;
    [self.nevermindButton setUserInteractionEnabled:YES];
//    [self.nevermindButton setBackgroundColor:[UIColor colorWithRed:61/255.0 green:77/255.0 blue:100/255.0 alpha:1]];
    [self.nevermindButton setTintColor:[UIColor colorWithRed:133/255.0 green:141/255.0 blue:152/255.0 alpha:1]];

    //监听方法->
    [self.nevermindButton addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceButton addTarget:self action:@selector(clickMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteboardButton addTarget:self action:@selector(clickMenu:) forControlEvents:UIControlEventTouchUpInside];
//    [self.screenSharingButton addTarget:self action:@selector(clickMenu:) forControlEvents:UIControlEventTouchUpInside];


    //添加子视图!
    [self addSubview:self.backgroundView];
    [self addSubview:self.voiceButton];
    [self addSubview:self.whiteboardButton];
//    [self addSubview:self.screenSharingButton];
    [self addSubview:self.nevermindButton];
    [self.nevermindButton addSubview:self.lineView];
}

//取消的动画往下移动进而消失
-(void)handleTap{
    [self hideMenuViewWithCancel];
}

//点击方法执行代理
-(void)clickMenu:(UIButton *)button{
    NSInteger selectedIndex = button.tag;
    if (self.popDelegate && [self.popDelegate respondsToSelector:@selector(popView:didSelectedIndex:)]) {
        [self hideMenuViewTop];
        [self.popDelegate popView:self didSelectedIndex:selectedIndex];
    }
}
//向上Pop
-(void)hideMenuViewTop
{
    if (self.isHidding) {
        return;
    }

    self.isHidding = YES;

    /*   self.nevermindButton   */
    self.nevermindButton.center = [ self.centerMenu[4] CGPointValue];
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.nevermindButton.center = [ self.centerLow[3] CGPointValue];

    } completion:^(BOOL finished) {
        self.nevermindButton.hidden = YES;
        self.isHidding = NO;

    }];

    /*   self.whiteboardButton   */

    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.whiteboardButton.center = [ self.centerHigh[1] CGPointValue];

    } completion:^(BOOL finished) {
        self.hidden = YES;

    }];


    /*screenSharing Image   */

    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        self.voiceButton.center =  [self.centerHigh[0] CGPointValue];
//        self.screenSharingButton.center = [self.centerHigh[2] CGPointValue];

    } completion:^(BOOL finished) {

    }];

    /*   Link | Video Image  */
    self.whiteboardButton.center = [ self.centerHigh[1] CGPointValue];
    [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    } completion:^(BOOL finished) {

    }];


}
//向底部Pop
-(void)hideMenuViewWithCancel
{
    if (self.isHidding) {
        return;
    }

    self.isHidding = YES;

    /*   self.nevermindButton   */
    self.nevermindButton.center = [ self.centerMenu[4] CGPointValue];
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.nevermindButton.center = [ self.centerLow[3] CGPointValue];

    } completion:^(BOOL finished) {
        self.nevermindButton.hidden = YES;
        self.isHidding = NO;

    }];

    /*   self.whiteboardButton   */

    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.whiteboardButton.center = [ self.centerLow[1] CGPointValue];

    } completion:^(BOOL finished) {
        self.hidden = YES;

    }];


    /*  voice | Chat | screenSharing Image   */

    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        self.voiceButton.center =  [self.centerLow[0] CGPointValue];
//        self.screenSharingButton.center = [self.centerLow[2] CGPointValue];
        //        self.chatButton.center =  [self.centerLow[1] CGPointValue];

    } completion:^(BOOL finished) {

    }];

    /*   Link | Video Image  */
    self.whiteboardButton.center = [ self.centerHigh[1] CGPointValue];
    [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    } completion:^(BOOL finished) {

    }];

    if (self.popDelegate && [self.popDelegate respondsToSelector:@selector(hidePopView)])
    {
        [self.popDelegate hidePopView];
    }

}
//展示弹出视图
-(void)showPop
{
    self.hidden = NO;

    /*   self.nevermindButton   */
    self.nevermindButton.center = [self.centerLow[3] CGPointValue];
    self.nevermindButton.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.nevermindButton.center = [self.centerMenu [4] CGPointValue];
    } completion:^(BOOL finished) {

    }];

    /*   self.whiteboardButton   */

    self.whiteboardButton.center = [self.centerLow[1] CGPointValue];
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.whiteboardButton.center = [self.centerMenu[1] CGPointValue];
    } completion:^(BOOL finished) {

    }];

    /*  voice | Chat | screenSharing Image   */
    self.voiceButton.center = [self.centerLow[0] CGPointValue];
//    self.screenSharingButton.center = [self.centerLow[2] CGPointValue];
    [UIView animateWithDuration:0.6 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        self.voiceButton.center = [self.centerMenu[0] CGPointValue];
//        self.screenSharingButton.center = [self.centerMenu[2] CGPointValue];
    } completion:^(BOOL finished) {

    }];

    [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{

    } completion:^(BOOL finished) {

    }];
}

@end
