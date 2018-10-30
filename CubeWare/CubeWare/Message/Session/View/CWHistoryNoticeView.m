//
//  CWHistoryNoticeView.m
//  CubeWare
//
//  Created by jianchengpan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWHistoryNoticeView.h"

#import <Masonry.h>
@interface CWHistoryNoticeView()


@end

@implementation CWHistoryNoticeView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame])
    {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = UIColorFromRGBA(0xEBF1FA, 1);
    self.layer.cornerRadius =  18;
    self.layer.masksToBounds = YES;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);

    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.layer.cornerRadius = 15;
    _iconImageView.clipsToBounds = YES;
    
    [self addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(6);
    }];

    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = UIColorFromRGBA(0x4393F9, 1);
    _contentLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(7);
    }];

    _upArrowImageView = [[UIImageView alloc] init];
    
    [self addSubview:_upArrowImageView];
    [_upArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentLabel);
        make.left.equalTo(self.contentLabel.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(9, 10));
        make.right.equalTo(self.mas_right).with.offset(-22);
    }];

    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self addGestureRecognizer:tapGesture];
}

-(void)showInView:(UIView *)containerView withTopOffset:(CGFloat)topOffset andAnimationTime:(float)time{
    
    [self removeFromSuperview];
    [containerView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).with.offset(topOffset);
        make.right.equalTo(containerView).offset(18);
        make.height.mas_equalTo(36);
    }];
    
    self.hidden = NO;
    [containerView layoutIfNeeded];
    if(time > 0)
    {
        self.transform = CGAffineTransformTranslate(self.transform, self.bounds.size.width, 0);
        [UIView animateWithDuration:time animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }
}

-(void)dismissWithAnimationTime:(float)time{
    if(time > 0)
    {
        [UIView animateWithDuration:time animations:^{
            self.transform = CGAffineTransformTranslate(self.transform, self.bounds.size.width, 0);
        } completion:^(BOOL finished) {
            self.hidden = YES;
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - event

-(void)didTap:(UITapGestureRecognizer *)tapGesture{
    if(self.didClickedHandler)
    {
        self.didClickedHandler(self.oldestUnreadMessage);
    }
}

@end
