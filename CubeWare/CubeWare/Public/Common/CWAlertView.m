//
//  CWAlertView.m
//  CubeWare
//
//  Created by 美少女 on 2018/1/4.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWAlertView.h"
#import "UITextField+NCubeWare.h"
#import "UILabel+NCubeWare.h"
#import "UIButton+NCubeWare.h"
#import "Masonry.h"
#import "CWButton.h"
#import "UIView+NCubeWare.h"
#import "CWUtils.h"
#import "CubeWareHeader.h"

#define CW_FIRST_TEXTCOLOR  UIColorFromRGB(0x333333)
#define CW_SECOND_TEXTCOLOR UIColorFromRGB(0x666666)
#define CW_THIRD_TEXTCOLOR  UIColorFromRGB(0xaaaaaa)
#define CW_THEME_BLUE       UIColorFromRGB(0x7a8fdf)
#define CW_LINE_COLOR       UIColorFromRGB(0xe0e4e5)
#define CW_BACKGROUND_COLOR       UIColorFromRGB(0xf1f2f7)
#define CW_RETURN_BUTTON_COLOR    UIColorFromRGB(0x8a8fa4)
#define CW_MAIL_TOKEN_BACKGROUND_COLOR UIColorFromRGB(0xe3e5f2)

@interface CWAlertView ()
/**
 代理
 */
@property (nonatomic,weak) id<CWAlertViewDelegate> delegate;

/**
 文字长度限制
 */
@property (nonatomic,assign) NSInteger defaultlimitLength;

/**
 背景图层
 */
@property (nonatomic,strong) UIView *backgroundView;

/**
 背景window
 */
@property (nonatomic, strong) UIWindow *backgroundWindow;

/**
 背景图层
 */
@property (nonatomic, strong) UIView *alertBackgroundView;

/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 内容
 */
@property (nonatomic, strong) UILabel *messageLabel;

/**
 输入框背景
 */
@property (nonatomic, strong) UIView *textFieldBackgroundView;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelButton;

/**
 block
 */
@property (nonatomic, copy) CWAlertViewBlock alertBlock;
@end

@implementation CWAlertView

#pragma mark - init
+ (instancetype)initAlertViewWithTextFieldWithTitle:(NSString *)title
                                            message:(NSString *)message
                                               text:(NSString *)text
                                   placeholderTitle:(NSString *)placeholder
                                           delegate:(id <CWAlertViewDelegate>)delegate
                                       buttonTitles:(NSArray *)buttonTitileAarray{

    return [[self alloc] initAlertViewWithTextFieldWithTitle:title
                                                     message:message
                                                        text:text
                                            placeholderTitle:placeholder
                                                    delegate:delegate
                                                buttonTitles:buttonTitileAarray];
}

- (instancetype)initAlertViewWithTextFieldWithTitle:(NSString *)title
                                            message:(NSString *)message
                                               text:(NSString *)text
                                   placeholderTitle:(NSString *)placeholder
                                           delegate:(id <CWAlertViewDelegate>)delegate
                                       buttonTitles:(NSArray *)buttonTitileAarray{
    if (self = [super init]) {
        _defaultlimitLength = 20;
        //添加监听键盘的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardHasShown:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];

        _delegate = delegate;

        self.shouldHideViewWhenTapBackground = NO;

        //背景视图
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        backgroundView.userInteractionEnabled = NO;
        backgroundView.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.4];
        [self addSubview:backgroundView];
        _backgroundView = backgroundView;

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(onTapBackgroundView:)];
        [backgroundView addGestureRecognizer:tapGestureRecognizer];

        [self addSubview:self.alertBackgroundView];
        [self.alertBackgroundView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertBackgroundView).offset(17);
            make.centerX.equalTo(self.alertBackgroundView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.alertBackgroundView.frame) - 40, 20));
        }];
        self.titleLabel.text = title;

        [self.alertBackgroundView addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
            make.centerX.equalTo(self.alertBackgroundView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.alertBackgroundView.frame) - 30, 20));
        }];
        self.messageLabel.text = message;

        [self.textFieldBackgroundView addSubview:self.inputTextField];
        self.inputTextField.text = text ? text : @"";
        self.inputTextField.placeholder = placeholder ? placeholder : @"";
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textFieldBackgroundView).offset(20);
            make.right.equalTo(self.textFieldBackgroundView);
            make.top.bottom.equalTo(self.textFieldBackgroundView);
        }];

        [self.alertBackgroundView addSubview:self.textFieldBackgroundView];
        [self.textFieldBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.messageLabel.mas_bottom).offset(10);
            //make.centerX.equalTo(self.alertBackgroundView.mas_centerX);
            //make.size.mas_equalTo(CGSizeMake(230, 40));
            make.left.equalTo(self.alertBackgroundView).offset(20);
            make.right.equalTo(self.alertBackgroundView.mas_right).offset(- 20);
            make.height.equalTo(@40);
        }];

        UIView *horizalLineView = [UIView new];
        horizalLineView.backgroundColor = CW_LINE_COLOR;
        [self.alertBackgroundView addSubview:horizalLineView];
        [horizalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textFieldBackgroundView.mas_bottom).offset(10);
            make.left.right.equalTo(self.alertBackgroundView);
            make.height.equalTo(@0.5);
        }];

        UIView *verticalLineView = [UIView new];
        verticalLineView.backgroundColor = CW_LINE_COLOR;
        [self.alertBackgroundView addSubview:verticalLineView];
        [verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(horizalLineView.mas_bottom);
            make.bottom.equalTo(self.alertBackgroundView.mas_bottom);
            make.centerX.equalTo(self.alertBackgroundView.mas_centerX);
            make.width.equalTo(@0.5);
        }];

        if (buttonTitileAarray.count) {
            [self.alertBackgroundView addSubview:self.cancelButton];
            [self.cancelButton setTitle:buttonTitileAarray[0]];
            [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.alertBackgroundView);
                make.right.equalTo(verticalLineView.mas_left);
                make.top.equalTo(horizalLineView.mas_bottom);
                make.bottom.equalTo(self.alertBackgroundView);
            }];

            [self.alertBackgroundView addSubview:self.confirmButton];
            [self.confirmButton setTitle:buttonTitileAarray[1]];
            [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.alertBackgroundView);
                make.left.equalTo(verticalLineView.mas_right);
                make.top.equalTo(horizalLineView.mas_bottom);
                make.bottom.equalTo(self.alertBackgroundView);
            }];
        }

        if (text && text.length > 0) {
            self.confirmButton.enabled = YES;
        }else{
            self.confirmButton.enabled = NO;
        }

        [self setFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        [self.backgroundWindow addSubview:self];
    }
    return self;
}

+ (instancetype)initAlertViewWithTextFieldWithTitle:(NSString *)title
                                            message:(NSString *)message
                                               text:(NSString *)text
                                   placeholderTitle:(NSString *)placeholder
                                       buttonTitles:(NSArray *)buttonTitileAarray
                                   customAlertBlock:(CWAlertViewBlock)alertBlock{

    return [[self alloc] initAlertViewWithTextFieldWithTitle:title
                                                     message:message
                                                        text:text
                                            placeholderTitle:placeholder
                                                buttonTitles:buttonTitileAarray
                                            customAlertBlock:alertBlock];

}

- (instancetype)initAlertViewWithTextFieldWithTitle:(NSString *)title
                                            message:(NSString *)message
                                               text:(NSString *)text
                                   placeholderTitle:(NSString *)placeholder
                                       buttonTitles:(NSArray *)buttonTitileAarray
                                   customAlertBlock:(CWAlertViewBlock)alertBlock{
    if (self = [super init]) {
        _delegate = nil;
        _alertBlock = alertBlock;

        _defaultlimitLength = 20;
        //添加监听键盘的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardHasShown:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];

        //背景视图
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        backgroundView.userInteractionEnabled = NO;
        backgroundView.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.4];
        [self addSubview:backgroundView];
        _backgroundView = backgroundView;

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(onTapBackgroundView:)];
        [backgroundView addGestureRecognizer:tapGestureRecognizer];

        [self addSubview:self.alertBackgroundView];
        [self.alertBackgroundView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertBackgroundView).offset(17);
            make.centerX.equalTo(self.alertBackgroundView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.alertBackgroundView.frame) - 40, 20));
        }];
        self.titleLabel.text = title;

        [self.alertBackgroundView addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
            make.centerX.equalTo(self.alertBackgroundView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.alertBackgroundView.frame) - 30, 20));
        }];
        self.messageLabel.text = message;

        [self.textFieldBackgroundView addSubview:self.inputTextField];
        self.inputTextField.text = text ? text : @"";
        self.inputTextField.placeholder = placeholder ? placeholder : @"";
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textFieldBackgroundView).offset(20);
            make.right.equalTo(self.textFieldBackgroundView);
            make.top.bottom.equalTo(self.textFieldBackgroundView);
        }];

        [self.alertBackgroundView addSubview:self.textFieldBackgroundView];
        [self.textFieldBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.messageLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.alertBackgroundView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(230, 40));
            make.left.equalTo(self.alertBackgroundView).offset(20);
            make.right.equalTo(self.alertBackgroundView.mas_right).offset(- 20);
        }];

        UIView *horizalLineView = [UIView new];
        horizalLineView.backgroundColor = CW_LINE_COLOR;
        [self.alertBackgroundView addSubview:horizalLineView];
        [horizalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textFieldBackgroundView.mas_bottom).offset(10);
            make.left.right.equalTo(self.alertBackgroundView);
            make.height.equalTo(@0.5);
        }];

        UIView *verticalLineView = [UIView new];
        verticalLineView.backgroundColor = CW_LINE_COLOR;
        [self.alertBackgroundView addSubview:verticalLineView];
        [verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(horizalLineView.mas_bottom);
            make.bottom.equalTo(self.alertBackgroundView.mas_bottom);
            make.centerX.equalTo(self.alertBackgroundView.mas_centerX);
            make.width.equalTo(@0.5);
        }];

        if (buttonTitileAarray.count) {
            [self.alertBackgroundView addSubview:self.cancelButton];
            [self.cancelButton setTitle:buttonTitileAarray[0]];
            [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.alertBackgroundView);
                make.right.equalTo(verticalLineView.mas_left);
                make.top.equalTo(horizalLineView.mas_bottom);
                make.bottom.equalTo(self.alertBackgroundView);
            }];

            [self.alertBackgroundView addSubview:self.confirmButton];
            [self.confirmButton setTitle:buttonTitileAarray[1]];
            [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.alertBackgroundView);
                make.left.equalTo(verticalLineView.mas_right);
                make.top.equalTo(horizalLineView.mas_bottom);
                make.bottom.equalTo(self.alertBackgroundView);
            }];
        }

        if (text && text.length > 0) {
            self.confirmButton.enabled = YES;
        }else{
            self.confirmButton.enabled = NO;
        }

        [self setFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        [self.backgroundWindow addSubview:self];


    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard Monitor
- (void)keyboardHasShown:(NSNotification*)aNotification{

    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat keyboardY = screenHeight - keyBoardFrame.size.height;
    CGFloat padding;
    if (CGRectGetMaxY(self.alertBackgroundView.frame) > keyboardY) {//弹窗被遮挡
        padding = 80;
    }else{
        padding = 0;
    }

    self.backgroundWindow.hidden = NO;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        _backgroundView.alpha = 0.5f;
        _backgroundView.userInteractionEnabled = YES;
        CGRect frame = _alertBackgroundView.frame;
        frame.origin.y -= padding;
        [_alertBackgroundView setFrame:frame];

    } completion:nil];

}

#pragma mark - Action
- (void)onTapBackgroundView:(UIGestureRecognizer *)gestureRecognizer{
    if (_shouldHideViewWhenTapBackground) {
        [self p_onTapBackgroundView];

    }
}

- (void)textFieldDidChange:(UITextField *)textField{

    [textField textInputLimitWithLength:_defaultlimitLength];

    if (textField.text.length > 0) {
        self.confirmButton.enabled = YES;
    }else{
        self.confirmButton.enabled = NO;
    }

}

- (void)onClickCancelButton:(UIButton *)sender{
    [self p_onTapBackgroundView];
    if (_delegate && [_delegate respondsToSelector:@selector(customAlertView:textField:clickedButtonAtIndex:)]) {
        [_delegate customAlertView:self textField:self.inputTextField clickedButtonAtIndex:sender.tag];
    }
    if (!_delegate) {
        if (_alertBlock) {
            _alertBlock(self, self.inputTextField, sender.tag);
        }
    }
}

- (void)onClickConfirmButton:(UIButton *)sender{
    [self p_onTapBackgroundView];
    if (_delegate && [_delegate respondsToSelector:@selector(customAlertView:textField:clickedButtonAtIndex:)]) {
        [_delegate customAlertView:self textField:self.inputTextField clickedButtonAtIndex:sender.tag];
    }

    if (!_delegate) {
        if (_alertBlock) {
            _alertBlock(self, self.inputTextField, sender.tag);
        }
    }
}
#pragma mark - Getters
- (UIWindow *)backgroundWindow{
    if (!_backgroundWindow) {
        _backgroundWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundWindow.windowLevel = UIWindowLevelStatusBar;
        _backgroundWindow.backgroundColor = [UIColor clearColor];
        _backgroundWindow.hidden = NO;
    }
    return _backgroundWindow;
}

- (UIView *)alertBackgroundView{
    if (!_alertBackgroundView) {
        _alertBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(50.f/375 * UIScreenWidth, 0, UIScreenWidth - 100.f/375 * UIScreenWidth, 180)];
        _alertBackgroundView.backgroundColor = [UIColor whiteColor];
        _alertBackgroundView.layer.cornerRadius = 3.f;
        _alertBackgroundView.clipsToBounds = YES;
    }
    return _alertBackgroundView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFrame:CGRectZero
                              backgroundColor:[UIColor clearColor]
                                         font:[UIFont systemFontOfSize:15]
                                textAlignment:NSTextAlignmentCenter
                                    textColor:UIColorFromRGB(0x333333)
                         highlightedTextColor:UIColorFromRGB(0x333333)];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [UILabel labelWithFrame:CGRectZero
                                backgroundColor:[UIColor clearColor]
                                           font:[UIFont systemFontOfSize:13]
                                  textAlignment:NSTextAlignmentCenter
                                      textColor:UIColorFromRGB(0x333333)
                           highlightedTextColor:UIColorFromRGB(0x333333)];
    }
    return _messageLabel;
}

- (UIView *)textFieldBackgroundView{
    if (!_textFieldBackgroundView) {
        _textFieldBackgroundView = [[UIView alloc] init];
        _textFieldBackgroundView.backgroundColor = [UIColor clearColor];
        _textFieldBackgroundView.layer.cornerRadius = 4.f;
        _textFieldBackgroundView.layer.borderWidth = 0.5;
        _textFieldBackgroundView.layer.borderColor = CW_LINE_COLOR.CGColor;
        _textFieldBackgroundView.clipsToBounds = YES;
    }
    return _textFieldBackgroundView;
}

- (UITextField *)inputTextField{
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc]init];
        _inputTextField.borderStyle = UITextBorderStyleNone;
        _inputTextField.textColor = UIColorFromRGB(0x333333);
        _inputTextField.font = [UIFont systemFontOfSize:13];
        [_inputTextField addTarget:self
                            action:@selector(textFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    }
    return _inputTextField;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitleColor:CW_THEME_BLUE];
        _cancelButton.backgroundColor = [UIColor clearColor];
        [_cancelButton setTitleFont:[UIFont systemFontOfSize:17]];
        _cancelButton.tag = 0;
        [_cancelButton addTarget:self action:@selector(onClickCancelButton:)];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitleColor:CW_THEME_BLUE];
        [_confirmButton setTitleColor:CW_LINE_COLOR forState:UIControlStateDisabled];
        _confirmButton.backgroundColor = [UIColor clearColor];
        [_confirmButton setTitleFont:[UIFont systemFontOfSize:17]];
        _confirmButton.tag = 1;
        [_confirmButton addTarget:self action:@selector(onClickConfirmButton:)];
    }
    return _confirmButton;
}
- (NSInteger)textLimitLength{
    return _defaultlimitLength;
}

#pragma mark - Public Method
- (void)show{
    self.backgroundWindow.hidden = NO;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        _backgroundView.alpha = 0.5f;
        _backgroundView.userInteractionEnabled = YES;
        CGRect frame = _alertBackgroundView.frame;
        frame.origin.y += self.center.y - _alertBackgroundView.frame.size.height/2 - 80;
        [_alertBackgroundView setFrame:frame];

    } completion:nil];
}

+ (void)showNormalAlertWithTitle:(NSString *)title message:(NSString *)message leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle hanle:(void (^)(NSString *))hanle{


    CWButton *  grayBackView = [[CWButton alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                         title:nil
                                                    titleColor:nil
                                                     titleFont:0
                                                  cornerRadius:0
                                               backgroundColor:[UIColorFromRGB(0x000000) colorWithAlphaComponent:0.4]
                                               backgroundImage:nil
                                                         image:nil];
    __weak typeof(grayBackView) weakGrayBackView = grayBackView;

    double  bili = 160 / 540.0;

    UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth - UIScreenWidth * bili, 180)];
    whiteView.layer.cornerRadius = 5;
    whiteView.clipsToBounds = YES;
    whiteView.backgroundColor = [UIColor whiteColor];

    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, whiteView.cw_width, 17)];
    lable.textColor = UIColorFromRGB(0x333333);
    lable.font  = [UIFont systemFontOfSize:18.f];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = title;
    lable.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.f];
    [whiteView addSubview:lable];

    UILabel * vertifyLable = [[UILabel alloc] initWithFrame:CGRectMake(15, lable.cw_bottom+15, whiteView.cw_width - 30 , 14) ];
    vertifyLable.textColor = UIColorFromRGB(0x333333);
    vertifyLable.font  = [UIFont systemFontOfSize:14.f];
    vertifyLable.textAlignment = NSTextAlignmentLeft;
    vertifyLable.numberOfLines = 0;
    vertifyLable.text = message;
    [vertifyLable sizeToFit];
    vertifyLable.cw_centerX = whiteView.cw_width/2;
    vertifyLable.cw_top = lable.cw_bottom+15;
    [whiteView addSubview:vertifyLable];

    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, vertifyLable.cw_bottom + 20, whiteView.cw_width, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xe0e4e5);
    [whiteView addSubview:lineView];

    CWButton *cancelButton = [[CWButton alloc] initWithFrame:CGRectMake(0, lineView.cw_bottom, whiteView.cw_width/2, 40) title:leftTitle titleColor:UIColorFromRGB(0x7a8fdf) titleFont:15.f cornerRadius:0 backgroundColor:nil backgroundImage:nil image:nil];
    [cancelButton setClickedAction:^(UIButton *sender) {

        if (hanle) {
            hanle(leftTitle);
        }
        [UIView animateWithDuration:0.2 animations:^{
            weakGrayBackView.alpha = 0.1;
        }completion:^(BOOL finished) {
            [weakGrayBackView removeFromSuperview];
        }];
    }];
    [cancelButton showRightLine:40];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    if (leftTitle.length > 0) {
        [whiteView addSubview:cancelButton];
    }

    CWButton *confimButton = [[CWButton alloc] initWithFrame:CGRectMake(cancelButton.cw_right, lineView.cw_bottom, whiteView.cw_width/2, 40) title:rightTitle titleColor:UIColorFromRGB(0x7a8fdf) titleFont:15.f cornerRadius:0 backgroundColor:nil backgroundImage:nil image:nil];

    [confimButton setClickedAction:^(UIButton *sender) {

        if (hanle) {
            hanle(rightTitle);
        }
        [UIView animateWithDuration:0.2 animations:^{
            weakGrayBackView.alpha = 0.1;
        }completion:^(BOOL finished) {
            [weakGrayBackView removeFromSuperview];
        }];
    }];
    confimButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    // self.confimButton.userInteractionEnabled = NO;
    [confimButton setTitleColor:UIColorFromRGB(0x7a8fdf) forState:UIControlStateNormal] ;
    confimButton.userInteractionEnabled = YES;
    [whiteView addSubview:confimButton];
    if (leftTitle.length < 1) {
        confimButton.cw_width = 2* confimButton.cw_width;
        confimButton.cw_left = 0;
    }

    whiteView.cw_height = cancelButton.cw_bottom;
    whiteView.cw_centerX = UIScreenWidth/2;

    if (title.length < 1) {
        vertifyLable.cw_centerY = (whiteView.cw_height - confimButton.cw_height)/2;
    }
    [grayBackView addSubview:whiteView];

    [[CWUtils CWKeyWindow] addSubview:grayBackView];
    whiteView.cw_centerY = UIScreenHeight / 2;
    whiteView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        whiteView.alpha = 1;
    }completion:^(BOOL finished) {

    }];
}


#pragma mark - Private
- (void)p_onTapBackgroundView{

    [self.inputTextField resignFirstResponder];
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        _backgroundView.alpha = 0.0f;
        _backgroundView.userInteractionEnabled = NO;
        CGRect frame = _alertBackgroundView.frame;
        frame.origin.y = UIScreenHeight;
        [_alertBackgroundView setFrame:frame];

    } completion:^(BOOL finished) {
        self.backgroundWindow.hidden = YES;
        [self removeFromSuperview];
    }];
}
@end
