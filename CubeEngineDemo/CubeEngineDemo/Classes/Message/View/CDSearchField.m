//
//  CDSearchField.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/27.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDSearchField.h"
@interface CDSearchField()<UITextFieldDelegate>

/**
 输入框
 */
@property (nonatomic,strong) UITextField *textField;

/**
 图标
 */
@property (nonatomic,strong) UIImageView *iconView;

@end

@implementation CDSearchField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.frame.size.height/2;
        self.backgroundColor = RGBA(0xf5, 0xf5, 0xf5, 1);
        [self addSubview:self.iconView];
        [self addSubview:self.textField];

        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.left.mas_equalTo(11);
            make.top.mas_equalTo(4);
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconView.mas_right).offset(5);
            make.top.mas_equalTo(9);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(self.width);
        }];
    }
    return self;
}

- (UIImageView *)iconView
{
    if (nil == _iconView) {
        _iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_mirror"]];
    }
    return _iconView;
}

- (UITextField *)textField
{
    if (nil == _textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectZero];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.clearsOnBeginEditing = YES;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        _textField.placeholder = @"群号码";
    }
    return _textField;
}
#pragma mark -


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchText:)])
    {
        [self.delegate searchText:textField.text];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchText:)])
    {
        [self.delegate searchText:textField.text];
    }
}
@end
