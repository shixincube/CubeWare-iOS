//
//  CWVideoInviteView.m
//  CubeWare
//
//  Created by 美少女 on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWVideoInviteView.h"
#import "CWResourceUtil.h"
#import "CWToastUtil.h"
#import "CWColorUtil.h"
#import "CubeWareHeader.h"
#import "CWWorkerFinder.h"
#import "CWInfoRefreshDelegate.h"

@interface CWVideoInviteView()<CWInfoRefreshDelegate>

/**
 背景图层
 */
@property (nonatomic, strong) UIImageView *backgroundView;

/**
 头像
 */
@property (nonatomic,strong) UIImageView *iconImageView;

/**
 昵称
 */
@property (nonatomic,strong) UILabel *userName;

/**
 状态描述
 */
@property (nonatomic,strong) UILabel *statusLabel;

/**
 免提按钮
 */
@property (nonatomic,strong) UIButton *handfreeButton;

/**
 免提按钮文字描述
 */
@property (nonatomic,strong) UILabel *handfreeLabel;

/**
 取消按钮
 */
@property (nonatomic,strong) UIButton *cancelButton;

/**
 取消按钮文字描述
 */
@property (nonatomic,strong) UILabel *cancelLabel;

/**
 麦克风按钮
 */
@property (nonatomic,strong) UIButton *microButton;

/**
 麦克风按钮文字描述s
 */
@property (nonatomic,strong) UILabel *microLabel;

/**
 拒绝按钮
 */
@property (nonatomic, strong) UIButton *rejectButton;

/**
 拒绝按钮描述文字
 */
@property (nonatomic, strong) UILabel *rejectLabel;

/**
 接听按钮
 */
@property (nonatomic, strong) UIButton *answerButton;

/**
 接听按钮描述文字
 */
@property (nonatomic, strong) UILabel *answerLabel;

/**

 */
@property (nonatomic, strong) NSDate *lastDate;
@end

@implementation CWVideoInviteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self createView];
        [self addViewConstraints];
        [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWInfoRefreshDelegate)]];
    }
    return self;
}

- (void)createView
{
    [self addSubview:self.backgroundView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.userName];
    [self addSubview:self.statusLabel];

    [self addSubview:self.handfreeButton];
    [self addSubview:self.handfreeLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.cancelLabel];
    [self addSubview:self.microButton];
    [self addSubview:self.microLabel];

    [self addSubview:self.rejectButton];
    [self addSubview:self.rejectLabel];
    [self addSubview:self.answerButton];
    [self addSubview:self.answerLabel];

#warning - for test
//    self.userName.text = @"美少女测试";
    self.statusLabel.text = @"正在等待对方接收邀请";
}

- (void)addViewConstraints
{
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(30);
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
        make.bottom.equalTo(self.iconImageView.mas_centerY).offset(-10);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
        make.bottom.equalTo(self.iconImageView.mas_centerY).offset(10);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-100);
    }];
    [self.cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-70);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self);
    }];
    [self.handfreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-100);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.equalTo(@(-(self.bounds.size.width/2 - 65/2)/2-30));
    }];
    [self.handfreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.handfreeButton);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.bottom.equalTo(self).offset(-70);
    }];
    [self.microButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.equalTo(self.handfreeButton);
        make.centerX.equalTo(@((self.bounds.size.width/2 - 65/2)/2+30));
    }];
    [self.microLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-70);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self.microButton);
    }];

    [self.rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.centerX.equalTo(@(-self.bounds.size.width/4));
        make.bottom.equalTo(self).offset(-100);
    }];

    [self.rejectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rejectButton);
        make.top.equalTo(self.rejectButton.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
    }];

    [self.answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.centerX.equalTo(@(self.bounds.size.width/4));
        make.bottom.equalTo(self).offset(-100);
    }];

    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.answerButton);
        make.top.equalTo(self.answerButton.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
    }];
}

- (void)setShowStyle:(AVShowViewStyle)style
{
    if (style == CallInStyle)
    {
        self.handfreeLabel.hidden = YES;
        self.handfreeButton.hidden = YES;
        self.cancelLabel.hidden = YES;
        self.cancelButton.hidden = YES;
        self.microLabel.hidden = YES;
        self.microButton.hidden = YES;

        self.rejectLabel.hidden = NO;
        self.rejectButton.hidden = NO;
        self.answerLabel.hidden = NO;
        self.answerButton.hidden = NO;
        self.rejectButton.enabled = YES;
        self.answerButton.enabled = YES;
    }
    else if (style == CallOutStyle)
    {
        self.rejectLabel.hidden = YES;
        self.rejectButton.hidden = YES;
        self.answerLabel.hidden = YES;
        self.answerButton.hidden = YES;

        self.handfreeLabel.hidden = NO;
        self.handfreeButton.hidden = NO;
        self.cancelLabel.hidden = NO;
        self.cancelButton.hidden = NO;
        self.microLabel.hidden = NO;
        self.microButton.hidden = NO;
        self.cancelButton.enabled = YES;
        self.microButton.enabled = YES;
        self.answerButton.enabled = YES;
    }
}
#pragma mark - events
- (void)cancelClick:(UIButton *)button
{
    NSLog(@"click cancelButton");
    dispatch_async(dispatch_get_main_queue(), ^ {
        BOOL ret = [[CubeEngine sharedSingleton].callService terminateCall:self.peerCubeId];
        if (ret) {
            NSLog(@"正在拒绝 ，请稍候……");
        }else {
            NSLog(@"挂断呼叫  失败");
        }
        self.cancelButton.enabled = NO;
    });
}

- (void)microClick:(UIButton *)button
{
//    dispatch_async(dispatch_get_main_queue(), ^ {
//        if([[CubeEngine sharedSingleton] getMediaService].isVoiceEnabled)
//        {
//            button.selected = YES;
//            [[[CubeEngine sharedSingleton] getMediaService] closeVoice];
//        }else {
//            button.selected = NO;
//            [[[CubeEngine sharedSingleton] getMediaService] openVoice];
//        }
//    });
}
- (void)handsFreeClick:(UIButton *)button
{
//    dispatch_async(dispatch_get_main_queue(), ^ {
//        NSDate *date = [[NSDate alloc] init];
//        if (date.timeIntervalSince1970 - _lastDate.timeIntervalSince1970 > .5f) {
//            if ([[CubeEngine sharedSingleton] getMediaService].speakerEnabled) {
//                [[[CubeEngine sharedSingleton] getMediaService] closeSpeaker];
//                button.selected = NO;
//            }else {
//                [[[CubeEngine sharedSingleton] getMediaService] openSpeaker];
//                button.selected = YES;
//            }
//            _lastDate = date;
//        }
//    });
}

- (void)rejectClick:(UIButton *)button
{
    NSLog(@"click rejectButton");
    dispatch_async(dispatch_get_main_queue(), ^ {
        BOOL ret = [[CubeEngine sharedSingleton].callService terminateCall:self.peerCubeId];
        if (ret) {
            NSLog(@"正在拒绝 ，请稍候……");
        } else {
            NSLog(@"挂断呼叫  失败");
        }
        self.answerButton.enabled = NO;
        self.rejectButton.enabled = NO;
    });
}

- (void)answerClick:(UIButton *)button
{
    NSLog(@"click answerButton");
    dispatch_async(dispatch_get_main_queue(), ^ {
        BOOL ret = [[CubeEngine sharedSingleton].callService answerCallWith:self.peerCubeId];
        if (ret) {
            NSLog(@"已应答  呼叫");
        } else {
            NSLog(@"应答  呼叫失败");
        }
        self.answerButton.enabled = NO;
        self.rejectButton.enabled = NO;
        
    });
}

#pragma mark - CWInfoRefreshDelegate
-(void)usersInfoUpdated:(NSArray<CWUserModel *> *)users inSession:(CWSession *)session{
	for (CWUserModel *user in users)
	{
		if([user.cubeId isEqualToString:self.peerCubeId]){
			[self updateUserInfo:user];
			break;
		}
	}
}

#pragma mark - private methods
- (void)updateUserInfo:(CWUserModel *)user{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[CWResourceUtil imageNamed:@"defaultAvatar.png"]];
	self.userName.text = user.appropriateName;
}
#pragma mark - getters
- (UIImageView *)backgroundView
{
    if(nil == _backgroundView)
    {
        _backgroundView = [[UIImageView alloc]initWithImage:[CWResourceUtil imageNamed:@"img_video_noanswer_background.png"]];
    }
    return _backgroundView;
}

- (UIImageView *)iconImageView
{
    if (nil == _iconImageView)
    {
        _iconImageView = [[UIImageView alloc]initWithImage:[CWResourceUtil imageNamed:@"defaultAvatar.png"]];//默认头像
        _iconImageView.layer.cornerRadius = 40.f;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)userName
{
    if (nil == _userName)
    {
        _userName = [[UILabel alloc]init];
        _userName.textColor = [UIColor whiteColor];
    }
    return _userName;
}

- (UILabel *)statusLabel
{
    if (nil == _statusLabel)
    {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.textColor = [UIColor whiteColor];
    }
    return _statusLabel;
}

- (UIButton *)handfreeButton
{
    if(nil == _handfreeButton)
    {
        _handfreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handfreeButton setImage:[CWResourceUtil imageNamed:@"btn_video_handfree_selected.png"] forState:UIControlStateNormal];
        [_handfreeButton setImage:[CWResourceUtil imageNamed:@"btn_video_handfree_default.png"] forState:UIControlStateSelected];
        [_handfreeButton addTarget:self action:@selector(handsFreeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _handfreeButton;
}

- (UILabel *)handfreeLabel
{
    if (nil == _handfreeLabel)
    {
        _handfreeLabel = [[UILabel alloc]init];
        _handfreeLabel.textAlignment = NSTextAlignmentCenter;
        _handfreeLabel.textColor = [CWColorUtil colorWithRGB:0x737373 andAlpha:1.0];
        _handfreeLabel.font = [UIFont systemFontOfSize:14];
        _handfreeLabel.text = @"免提";
    }
    return _handfreeLabel;
}

- (UIButton *)cancelButton
{
    if (nil == _cancelButton)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[CWResourceUtil imageNamed:@"btn_video_hangup_default.png"] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[CWResourceUtil imageNamed:@"btn_video_hangup_highlight.png"] forState:UIControlStateSelected];
        [_cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UILabel *)cancelLabel
{
    if (nil == _cancelLabel) {
        _cancelLabel = [[UILabel alloc]init];
        _cancelLabel.text = @"取消";
        _cancelLabel.textAlignment = NSTextAlignmentCenter;
        _cancelLabel.textColor = [CWColorUtil colorWithRGB:0x737373 andAlpha:1.0];
        _cancelLabel.font = [UIFont systemFontOfSize:14];
    }
    return _cancelLabel;
}
- (UIButton *)microButton
{
    if (nil == _microButton) {
        _microButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_microButton setImage:[CWResourceUtil imageNamed:@"btn_video_mute_default.png"] forState:UIControlStateNormal];
        [_microButton setImage:[CWResourceUtil imageNamed:@"btn_video_mute_select.png"] forState:UIControlStateSelected];
        [_microButton addTarget:self action:@selector(microClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _microButton;
}

- (UILabel *)microLabel
{
    if (nil == _microLabel) {
        _microLabel = [[UILabel alloc]init];
        _microLabel.textAlignment = NSTextAlignmentCenter;
        _microLabel.textColor = [CWColorUtil colorWithRGB:0x737373 andAlpha:1.0];
        _microLabel.font = [UIFont systemFontOfSize:14];
        _microLabel.text = @"麦克风";
    }
    return _microLabel;
}

- (UIButton *)rejectButton
{
    if (nil == _rejectButton) {
        _rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rejectButton setImage:[CWResourceUtil imageNamed:@"btn_video_hangup_default.png"] forState:UIControlStateNormal];
        [_rejectButton setImage:[CWResourceUtil imageNamed:@"btn_video_hangup_highlight.png"] forState:UIControlStateSelected];
        [_rejectButton addTarget:self action:@selector(rejectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rejectButton;
}

- (UILabel *)rejectLabel
{
    if (nil == _rejectLabel)
    {
        _rejectLabel = [[UILabel alloc]init];
        _rejectLabel.textColor = [CWColorUtil colorWithRGB:0xC2C2C2 andAlpha:1.0];;
        _rejectLabel.font = [UIFont systemFontOfSize:14];
        _rejectLabel.textAlignment = NSTextAlignmentCenter;
        _rejectLabel.text = @"拒绝";
    }
    return _rejectLabel;
}

- (UIButton *)answerButton
{
    if (nil == _answerButton) {
        _answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_answerButton setImage:[CWResourceUtil imageNamed:@"btn_anwser_default.png"] forState:UIControlStateNormal];
        [_answerButton setImage:[CWResourceUtil imageNamed:@"btn_anwser_highlight.png"] forState:UIControlStateSelected];
        [_answerButton addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answerButton;
}

- (UILabel *)answerLabel
{
    if (nil == _answerLabel) {
        _answerLabel = [[UILabel alloc]init];
        _answerLabel.textColor = [CWColorUtil colorWithRGB:0xC2C2C2 andAlpha:1.0];
        _answerLabel.font = [UIFont systemFontOfSize:14];
        _answerLabel.textAlignment = NSTextAlignmentCenter;
        _answerLabel.text = @"接听";
    }
    return _answerLabel;
}

-(void)setPeerCubeId:(NSString *)peerCubeId{
    _peerCubeId = peerCubeId;
	CWUserModel *user = [[CubeWare sharedSingleton].infoManager userInfoForCubeId:peerCubeId inSession:nil];
    if(user){
        [self updateUserInfo:user];
    }else{
         [[CubeWare sharedSingleton].infoManager.delegate needUsersInfoFor:@[peerCubeId] inSession:nil];
    }
   
}
@end

