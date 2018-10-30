//
//  CWActionSheet.m
//  CubeWare
//
//  Created by Mario on 17/2/8.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWActionSheet.h"
#import "CubeWareGlobalMacro.h"
// 按钮高度
#define BUTTON_H 55.0f

@interface CWActionSheet () {
    
    /** 所有按钮 */
    NSArray *_buttonTitles;
    
    /** 暗黑色的view */
    UIView *_darkView;
    
    /** 所有按钮的底部view */
    UIView *_bottomView;
    
    /** 代理 */
    id<CWActionSheetDelegate> _delegate;
}

@property (nonatomic, strong) UIWindow *backWindow;
@property (nonatomic, strong) UIButton *normalButton;
@property (nonatomic, strong) UILabel *normalLabel;

@end


@implementation CWActionSheet

+ (instancetype)sheetWithTitle:(NSString *)title buttonTitles:(NSArray *)titles redButtonIndex:(NSInteger)buttonIndex delegate:(id<CWActionSheetDelegate>)delegate {
    return [[self alloc] initWithTitle:title buttonTitles:titles redButtonIndex:buttonIndex delegate:delegate];
}

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)titles
               redButtonIndex:(NSInteger)buttonIndex
                     delegate:(id<CWActionSheetDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        // 暗黑色的view
        UIView *darkView = [[UIView alloc] init];
        [darkView setAlpha:0];
        [darkView setUserInteractionEnabled:NO];
        [darkView setFrame:(CGRect){0, 0, UISCREENSIZE}];
        [darkView setBackgroundColor:[UIColorFromRGB(0x000000) colorWithAlphaComponent:0.4]];
        [self addSubview:darkView];
        _darkView = darkView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [darkView addGestureRecognizer:tap];
        
        // 所有按钮的底部view
        UIView *bottomView = [[UIView alloc] init];
        [bottomView setBackgroundColor:UIColorFromRGB(0xf1f2f7)];
        [self addSubview:bottomView];
        _bottomView = bottomView;
        if (title) {
            // 标题
            UILabel *label = [[UILabel alloc] init];
            [label setText:title];
            [label setTextColor:CWRGBColor(111, 111, 111, 1.f)];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:[UIFont systemFontOfSize:13.0f]];
            [label setBackgroundColor:[UIColor whiteColor]];
            [label setFrame:CGRectMake(0, 0, UISCREENSIZE.width, BUTTON_H)];
            [bottomView addSubview:label];
        }
        if (titles.count) {
            _buttonTitles = titles;
            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"LCActionSheet" ofType:@"bundle"];
            for (int i = 0; i < titles.count; i++) {
                // 所有按钮
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:i];
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitle:titles[i] forState:UIControlStateNormal];
                [[btn titleLabel] setFont:[UIFont systemFontOfSize:16]];
                UIColor *titleColor = nil;
                if (i == buttonIndex) {
                    titleColor = UIColorFromRGB(0xFA7479);
                } else {
                    titleColor = UIColorFromRGB(0x333333);
                }
                [btn setTitleColor:titleColor forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                CGFloat btnY = BUTTON_H * (i + (title ? 1 : 0));
                [btn setFrame:CGRectMake(0, btnY, UISCREENSIZE.width, BUTTON_H)];
                //[btn setBackgroundImage:[UIImage imageNamed:@"rectangle-63"] forState:UIControlStateHighlighted];
                [bottomView addSubview:btn];
            }
            for (int i = 0; i < titles.count; i++) {
                NSString *linePath = [bundlePath stringByAppendingPathComponent:@"cellLine@2x.png"];
                UIImage *lineImage = [UIImage imageWithContentsOfFile:linePath];
                // 所有线条
                UIImageView *line = [[UIImageView alloc] init];
                line.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                [line setImage:lineImage];
                [line setContentMode:UIViewContentModeCenter];
                CGFloat lineY = (i + (title ? 1 : 0)) * BUTTON_H;
                [line setFrame:CGRectMake(0, lineY, UISCREENSIZE.width, 1.0f)];
                [bottomView addSubview:line];
            }
        }
        // 取消按钮
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTag:titles.count];
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [[cancelBtn titleLabel] setFont:[UIFont systemFontOfSize:16]];
        [cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"rectangle-63"] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        CGFloat btnY = BUTTON_H * (titles.count + (title ? 1 : 0)) + 10.0f;
        [cancelBtn setFrame:CGRectMake(0, btnY, UISCREENSIZE.width, BUTTON_H)];
        [bottomView addSubview:cancelBtn];
        CGFloat bottomH = (title ? BUTTON_H : 0) + BUTTON_H * titles.count + BUTTON_H + 10.0f;
        [bottomView setFrame:CGRectMake(0, UISCREENSIZE.height, UISCREENSIZE.width, bottomH)];
        //bottomView.layer.masksToBounds = YES;
        //bottomView.layer.cornerRadius = 6.0;
        [self setFrame:(CGRect){0, 0, UISCREENSIZE}];
        [self.backWindow addSubview:self];
    }
    return self;
}

- (UIWindow *)backWindow {
    if (_backWindow == nil) {
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel       = UIWindowLevelStatusBar;
        _backWindow.backgroundColor   = [UIColor clearColor];
        _backWindow.hidden = NO;
    }
    return _backWindow;
}


- (void)didClickBtn:(UIButton *)btn {
    [self dismiss:nil];
    if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
        [_delegate actionSheet:self didClickedButtonAtIndex:btn.tag];
    }
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_darkView setAlpha:0];
                         [_darkView setUserInteractionEnabled:NO];
                         
                         CGRect frame = _bottomView.frame;
                         frame.origin.y += frame.size.height;
                         [_bottomView setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                         _backWindow.hidden = YES;
                         [self removeFromSuperview];
                         [self normalButton:self.normalButton andSelected:NO andNormalLabel:self.normalLabel andHighlighted:NO];
                     }];
}

- (void)didClickCancelBtn {
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_darkView setAlpha:0];
                         [_darkView setUserInteractionEnabled:NO];
                         CGRect frame = _bottomView.frame;
                         frame.origin.y += frame.size.height;
                         [_bottomView setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                         _backWindow.hidden = YES;
                         [self removeFromSuperview];
                         if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
                             [_delegate actionSheet:self didClickedButtonAtIndex:_buttonTitles.count];
                         }
                     }];
}

- (void)show {
    _backWindow.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_darkView setAlpha:0.4f];
                         [_darkView setUserInteractionEnabled:YES];
                         CGRect frame = _bottomView.frame;
                         frame.origin.y -= frame.size.height;
                         [_bottomView setFrame:frame];
                     }
                     completion:nil];
}

-(void)normalButton:(UIButton *)btn andSelected:(BOOL)selected andNormalLabel:(UILabel *)lbl andHighlighted:(BOOL)hilighted{
    self.normalButton = btn;
    self.normalButton.selected = selected;
    self.normalLabel =lbl;
    self.normalLabel.highlighted = hilighted;
}

@end
