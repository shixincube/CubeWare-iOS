//
//  CWNewArriveNoticeView.m
//  CubeWare
//
//  Created by jianchengpan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWNewArriveNoticeView.h"
#import "CWResourceUtil.h"

@interface CWNewArriveNoticeView()

@property (nonatomic, strong) UIImageView *backGroudImageView;

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation CWNewArriveNoticeView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame])
    {
        [self initView];
    }
    return self;
}

-(void)initView{
    _backGroudImageView = [[UIImageView alloc] initWithImage: [CWResourceUtil imageNamed:@"unread_newmessage"]];
    
    [self addSubview:_backGroudImageView];
    [_backGroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(36, 36));        
    }];
    
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.font = [UIFont systemFontOfSize:12.0];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.and.right.equalTo(_backGroudImageView);
    }];
    
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    self.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self addGestureRecognizer:tapGesture];
}

-(void)setUnreadCount:(int)unreadCount{
    _unreadCount = unreadCount;
    if(unreadCount > 0)
    {
        self.hidden = NO;
        _countLabel.text = unreadCount < 100 ? [NSString stringWithFormat:@"%d",unreadCount] : @"99+";
    }
    else
    {
        self.hidden = YES;
    }
    
}

#pragma mark - event

-(void)didTap:(UITapGestureRecognizer *)tapGesture{
    if(self.didClickedHandler)
    {
        self.didClickedHandler();
    }
}

@end
