//
//  CDInfoTopView.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/30.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDInfoTopView.h"
#import "UIImageView+WebCache.h"
@interface CDInfoTopView()


/**
 按钮标题
 */
@property (nonatomic,strong) UILabel *buttonTitle;
@end

@implementation CDInfoTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconView];
        [self addSubview:self.title];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(@20);
            make.width.equalTo(@90);
            make.height.equalTo(@90);
        }];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.iconView.mas_bottom).offset(15);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(@24);
        }];
    }
    return self;
}

- (UIImageView *)iconView
{
    if (nil == _iconView)
    {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
        _iconView.layer.cornerRadius = 90/2;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)title
{
    if(nil == _title)
    {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 24)];
        _title.textColor = RGBA(0x26, 0x25, 0x2A, 1);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.text = @"昵称";
        _title.font = [UIFont systemFontOfSize:24];
    }
    return _title;
}

- (void)setIsMySelf:(BOOL)isMySelf
{
    _isMySelf = isMySelf;
    self.chatButton.hidden = isMySelf;
    self.buttonTitle.hidden = isMySelf;
}

#pragma mark - events
- (void)onChatButtonClick:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickChatButton)]) {
        [self.delegate onClickChatButton];
    }
}
@end
