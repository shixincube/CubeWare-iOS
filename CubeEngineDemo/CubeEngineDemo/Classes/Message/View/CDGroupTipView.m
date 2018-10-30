//
//  CDGroupTipView.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/10.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDGroupTipView.h"
@interface CDGroupTipView ()

/**
 标题
 */
@property (nonatomic,strong) UILabel *info;

/**
 图标
 */
@property (nonatomic,strong) UIImageView *icon;

/**
 显示类型
 */
@property (nonatomic,assign) TipShowType type;
/**
 背景View
 */
@property (nonatomic,strong) UIView *backgroupView;
@end
@implementation CDGroupTipView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame andShowType:(TipShowType)showtype
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0xF1, 0xF3, 0xF6, 1);
        self.type = showtype;
        [self addSubview:self.icon];
        [self addSubview:self.info];
        [self addSubview:self.backgroupView];
        [self setUI];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
        [self.backgroupView setUserInteractionEnabled:YES];
        [self.backgroupView addGestureRecognizer:tap];
    }
    return self;
}

- (UIView *)backgroupView
{
    if (nil == _backgroupView)
    {
        _backgroupView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backgroupView.backgroundColor = [UIColor clearColor];
    }
    return _backgroupView;
}
- (UILabel *)info
{
    if (nil == _info) {
        _info = [[UILabel alloc]initWithFrame:CGRectZero];//*人正在***中
        _info.textAlignment = NSTextAlignmentLeft;
        _info.font =  [UIFont systemFontOfSize:14];
        _info.textColor = KBlackColor;
    }
    return _info;
}

- (UIImageView *)icon
{
    if (nil == _icon) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_icon setImage:[UIImage imageNamed:[self getImageName]]];
    }
    return _icon;
}

- (void)setUI
{
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@20);
        make.left.mas_equalTo(@15);
        make.centerY.mas_equalTo(self);
    }];

    [self.info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(5);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(self);
    }];
}

- (NSString *)getShowString
{
    NSString *info;
    switch (self.type) {
        case TipShowWhiteBoard:
            info = @"白板";
            break;
        case TipShowShareDesktop:
            info = @"屏幕分享";
            break;
        case TipShowVoiceConferece:
            info = @"音频会议";
            break;
        case TipShowVideoConference:
            info = @"视频会议";
            break;
    }
    return [NSString stringWithFormat:@"正在%@中",info];
}

- (NSString *)getImageName
{
    switch (self.type) {
        case TipShowWhiteBoard:
            return @"tip_whiteBoard";
        case TipShowShareDesktop:
            return @"tip_shareDesktop";
        case TipShowVoiceConferece:
            return @"tip_voice";
        case TipShowVideoConference:
            return @"tip_video";
    }
}

- (void)setMemberCount:(NSInteger )memberCount
{
    _memberCount = memberCount;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.info.text = [NSString stringWithFormat:@"%ld 人%@",(long)self.memberCount,[self getShowString]];
    });
}

- (void)onTap:(UIGestureRecognizer *)ges
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapTipView)]) {
        [self.delegate onTapTipView];
    }
}
@end
