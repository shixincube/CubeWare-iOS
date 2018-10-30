//
//  CWMessageCell.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWMessageCell.h"
#import "CWResourceUtil.h"
#import "CWColorUtil.h"
#import <Masonry.h>
#import "CubeWareHeader.h"
#define CWMessageMenuItemSELPrefix @"CWMessageMenuItemSEL"

void CWMessageMenuItemSEL(id self, SEL _cmd);

@interface CWMessageCell()

/**气泡背景裁剪层*/
@property (nonatomic, strong) CAShapeLayer *backLayer;
/**名字到气泡的距离*/
@property (nonatomic, strong) NSLayoutConstraint *nameToBubbleDisConstraint;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) UIButton *retryButton;

@end

@implementation CWMessageCell{
    // 消息显示---左边---的约束
    NSLayoutConstraint *avatarShowLeftConstraint;
    NSLayoutConstraint *nameShowLeftConstraint;
    NSLayoutConstraint *bubbleShowLeftConstraint_toName;
    NSLayoutConstraint *bubbleShowLeftConstraint_toContainer;
    
    // 消息显示---右边---的约束
    NSLayoutConstraint *avatarShowRightConstraint;
    NSLayoutConstraint *nameShowRightConstraint;
    NSLayoutConstraint *bubbleShowRightConstraint_toName;
    NSLayoutConstraint *bubbleShowRightConstraint_toContainer;
	
	NSLayoutConstraint *displayNameLabelHeigtConstraint;
	
    NSArray <CWMessageMenuItem *>* cacheItems;
}

#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initBaseVieW];
    }
    return self;
}

- (void)initBaseVieW{
    _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_avatarButton addTarget:self action:@selector(didClickedButtton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_avatarButton];
    
    _avatarButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_avatarButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:BubbleOffset]];
    
    //显示左边的约束
    avatarShowLeftConstraint = [NSLayoutConstraint constraintWithItem:_avatarButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:12];
    
    //显示右边的约束
    avatarShowRightConstraint = [NSLayoutConstraint constraintWithItem:_avatarButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-12];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_avatarButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_avatarButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_avatarButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_avatarButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    _avatarButton.layer.cornerRadius = 20;
	_avatarButton.clipsToBounds = YES;
	
    _displayNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _displayNameLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:_displayNameLabel];
    
    _displayNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_displayNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_avatarButton attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	displayNameLabelHeigtConstraint = [NSLayoutConstraint constraintWithItem:_displayNameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    //左
    nameShowLeftConstraint = [NSLayoutConstraint constraintWithItem:_displayNameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_avatarButton attribute:NSLayoutAttributeRight multiplier:1 constant:7];
	
    //右
    nameShowRightConstraint = [NSLayoutConstraint constraintWithItem:_displayNameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_avatarButton attribute:NSLayoutAttributeLeft multiplier:1 constant:-7];

	[_displayNameLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisVertical];
	
    _bubbleView = [[UIView alloc] initWithFrame:CGRectZero];
    _bubbleView.userInteractionEnabled = YES;
    _bubbleView.layer.cornerRadius = 5;
    _bubbleView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bubbleView];
    
    _bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
    _nameToBubbleDisConstraint = [NSLayoutConstraint constraintWithItem:_bubbleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_displayNameLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.contentView addConstraint:_nameToBubbleDisConstraint];

    //左
    bubbleShowLeftConstraint_toName = [NSLayoutConstraint constraintWithItem:_bubbleView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_displayNameLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    bubbleShowLeftConstraint_toContainer = [NSLayoutConstraint constraintWithItem:_bubbleView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-40];

    //右
    bubbleShowRightConstraint_toName = [NSLayoutConstraint constraintWithItem:_bubbleView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_displayNameLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    bubbleShowRightConstraint_toContainer = [NSLayoutConstraint constraintWithItem:_bubbleView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:40];

    NSLayoutConstraint *bubbleToContentViewButtonConstrain = [NSLayoutConstraint constraintWithItem:_bubbleView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.contentView addConstraint:bubbleToContentViewButtonConstrain];
    
    [_bubbleView setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];
    [_bubbleView setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];
    
    //添加手势相关
    //头像长按手手势
    UILongPressGestureRecognizer *avatarLongpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    [self.avatarButton addGestureRecognizer:avatarLongpress];
    // 气泡长按手手势
    UILongPressGestureRecognizer * bubbleViewLongpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongPress:)];
    [self.bubbleView addGestureRecognizer:bubbleViewLongpress];
    
    //气泡点击事件
    UITapGestureRecognizer *bubbleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.bubbleView addGestureRecognizer:bubbleTap];
    
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.hidesWhenStopped = YES;
    [self.contentView addSubview:_activity];
    [_activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(_bubbleView);
        make.right.equalTo(_bubbleView.mas_left).with.offset(-15);
    }];
    
    self.avatarImage = nil;
	
	_enableDefaultBubbleMask = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse{
    [super prepareForReuse];
}

- (void)dealloc{
	if(_backLayer)
	{
    	[_bubbleView removeObserver:self forKeyPath:@"bounds"];
	}
}

#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.backLayer.frame = self.bubbleView.bounds;
    [CATransaction commit];
}

#pragma mark - event
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)didClickedButtton:(UIButton *)sender{
    if(self.delegate)
    {
        if(sender == _avatarButton && [self.delegate respondsToSelector:@selector(didClickedAvatarOnCell:)])
        {
            [self.delegate didClickedAvatarOnCell:self];
        }
        else if (sender == _retryButton && [self.delegate respondsToSelector:@selector(didClickedRetryButtonOnCell:)])
        {
            [self.delegate didClickedRetryButtonOnCell:self];
        }
    }
}

- (void)didLongPress:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if(gesture.view == self.avatarButton)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLongPressedAvatarOnCell:)])
            {
                [self.delegate didLongPressedAvatarOnCell:self];
            }
        }
        else
        {
            [self didLongPressedBubble];
        }
    }
}

- (void)didTap:(UITapGestureRecognizer *)gesture{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedBubbleOnCell:)])
    {
        [self.delegate didClickedBubbleOnCell:self];
    }
}

#pragma mark - content protocol

+(CGFloat)cellHeigtForContent:(id)content inSession:(CWSession *)session{
	return [self bubbleHeightForContent:content inSession:session] + (session.showNickName && [(CubeMessageEntity *)content messageDirection] == CubeMessageDirectionReceived ? displayNameHeight : 0) + BubbleOffset;
}

+(CGFloat)bubbleHeightForContent:(id)content inSession:(CWSession *)session{
	return BubbleMinHeight;
}

- (void)configUIWithContent:(id)content{
    
    if([content isKindOfClass:[CubeMessageEntity class]])
    {
        _currentContent = content;
        CubeMessageEntity *message = content;
        self.showLeft = message.messageDirection == CubeMessageDirectionReceived;
        self.messageStatus = message.status;
		self.displayName = message.sender.appropriateName;
        if(message.messageDirection == CubeMessageDirectionReceived)
        {
            for (id<CWMessageServiceDelegate> repotor in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWMessageServiceDelegate)]) {
                if(repotor && [repotor respondsToSelector:@selector(getAvatorUrl:)])
                {
                    NSString *url = [repotor getAvatorUrl:message.sender.cubeId];
                    self.avatarUrl = url;
                }
            }
        }
        else
        {
            self.avatarUrl = [CubeUser currentUser].avatar;
        }
    }
}

#pragma mark - getter and setter

- (UIButton *)retryButton{
    if(!_retryButton)
    {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryButton setImage:[CWResourceUtil imageNamed:@"messageretry_default"] forState:UIControlStateNormal];
        [_retryButton setImage:[CWResourceUtil imageNamed:@"messageretry_selected"] forState:UIControlStateHighlighted];
        [_retryButton addTarget:self action:@selector(didClickedButtton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_retryButton];
        [_retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.center.equalTo(_activity);
        }];
    }
    return _retryButton;
}

- (void)setShowLeft:(BOOL)showLeft{
    _showLeft = showLeft;
	
	
	NSString *bubbleImageName =nil;
	
    if(_showLeft)
    {
        bubbleImageName =@"bubble_left";
        avatarShowRightConstraint.active = !_showLeft;
        nameShowRightConstraint.active = !_showLeft;
        bubbleShowRightConstraint_toName.active = !_showLeft;
        bubbleShowRightConstraint_toContainer.active = !_showLeft;
        
        avatarShowLeftConstraint.active = _showLeft;
        nameShowLeftConstraint.active = _showLeft;
        bubbleShowLeftConstraint_toName.active = _showLeft;
        bubbleShowLeftConstraint_toContainer.active = _showLeft;
        
        _bubbleView.backgroundColor = [CWColorUtil colorWithRGB:0xf0f0f0  andAlpha:1];
    
    }
    else
    {
        bubbleImageName = @"bubble_right";
        avatarShowLeftConstraint.active = _showLeft;
        nameShowLeftConstraint.active = _showLeft;
        bubbleShowLeftConstraint_toName.active = _showLeft;
        bubbleShowLeftConstraint_toContainer.active = _showLeft;

        avatarShowRightConstraint.active = !_showLeft;
        nameShowRightConstraint.active = !_showLeft;
        bubbleShowRightConstraint_toName.active = !_showLeft;
        bubbleShowRightConstraint_toContainer.active = !_showLeft;
        
        _bubbleView.backgroundColor = [CWColorUtil colorWithRGB:0x4393F9   andAlpha:1];
    }
	
	if(self.enableDefaultBubbleMask)
	{
		UIImage *bubbleImage = [CWResourceUtil imageNamed:bubbleImageName];

		if(bubbleImage)
		{
			self.backLayer.contents = (id)bubbleImage.CGImage;
		}
	}
	if(!showLeft)
	{
		self.enableDisplayName = NO;
	}
}

- (void)setMessageStatus:(CubeMessageStatus)messageStatus{
    _messageStatus = messageStatus;
    switch (messageStatus) {
        case CubeMessageStatusSending:
            [self showActivity:YES];
            break;
        case CubeMessageStatusSucceed:
            [self showActivity:NO];
            [self showRetry:NO];
            break;
		case CubeMessageStatusReceiving:
			[self showActivity:self.currentContent.messageDirection == CubeMessageDirectionReceived];
			[self showRetry:NO];
			break;
        default:
            [self showRetry:YES];
            break;
    }
}

- (void)setAvatarUrl:(NSString *)avatarUrl{
    _avatarUrl = avatarUrl;
    if(avatarUrl.length){
        //加载图片
		[self.avatarButton sd_setImageWithURL:[NSURL URLWithString:avatarUrl] forState:UIControlStateNormal placeholderImage:[CWResourceUtil imageNamed:@"defaultAvatar"]];
    }else{
        //设置默认图片
        self.avatarImage = nil;
    }
}
- (void)setAvatarImage:(UIImage *)avatarImage{
    _avatarUrl = nil;
    _avatarImage = avatarImage ? avatarImage : [CWResourceUtil imageNamed:@"defaultAvatar"];
    [_avatarButton setImage:_avatarImage forState:UIControlStateNormal];
    
}

- (void)setEnableDisplayName:(BOOL)enableDisplayName{
	
	displayNameLabelHeigtConstraint.active = !enableDisplayName;
    _enableDisplayName = enableDisplayName;
    _nameToBubbleDisConstraint.constant = enableDisplayName ? 4 : 0;
    [self.contentView needsUpdateConstraints];
}

- (void)setDisplayName:(NSString *)displayName{
    self.displayNameLabel.text = displayName;
}

- (CAShapeLayer *)backLayer{
    if(!_backLayer)
    {
        _backLayer = [CAShapeLayer layer];
        _backLayer.frame = CGRectMake(0, 0, 1, 1);
        _backLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
        _backLayer.contentsScale = [UIScreen mainScreen].scale;
        _backLayer.shadowColor = [UIColor lightGrayColor].CGColor;
        _bubbleView.layer.mask = _backLayer;
        [_bubbleView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _backLayer;
}

-(void)setEnableDefaultBubbleMask:(BOOL)enableDefaultBubbleMask{
	if(_enableDefaultBubbleMask > enableDefaultBubbleMask)
	{
		if(_backLayer)
		{
			[_bubbleView removeObserver:self forKeyPath:@"bounds"];
			[_backLayer removeFromSuperlayer];
			_backLayer = nil;
		}
	}
	_enableDefaultBubbleMask = enableDefaultBubbleMask;
}



#pragma mark - control UI
- (void)showActivity:(BOOL)showActivity{
    if(!self.showLeft)
    {
        showActivity ? ([self.activity startAnimating], [self showRetry:NO]) : [self.activity stopAnimating];
    }
    else
    {
        [_activity stopAnimating];
        _retryButton.hidden = YES;
    }
}

- (void)showRetry:(BOOL)showRetry{
    if(!self.showLeft)
    {
        if(showRetry)
        {
            self.retryButton.hidden = NO;
            [self showActivity:NO];
        }
        else
        {
            _retryButton.hidden = YES;
        }
    }
    else
    {
        [_activity stopAnimating];
        _retryButton.hidden = YES;
    }
}

#pragma mark - cell menu

- (void)didLongPressedBubble{
    if(self.delegate && [self.delegate respondsToSelector:@selector(menuItemsForCell:)])
    {
        NSArray<CWMessageMenuItem *> *items = [self.delegate menuItemsForCell:self];
        if(items.count)
        {
            [self becomeFirstResponder];
            
            NSMutableArray *itemsArray = [NSMutableArray array];
            for (int i = 0; i < items.count; i++) {
                UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:items[i].title action:NSSelectorFromString([NSString stringWithFormat:@"%@%d",CWMessageMenuItemSELPrefix,i])];
                [itemsArray addObject:item];
            }
            [UIMenuController sharedMenuController].menuItems = itemsArray;
            [[UIMenuController sharedMenuController] setTargetRect:self.bubbleView.bounds inView:self.bubbleView];
            [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
            
            cacheItems = items;
        }
    }
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return [NSStringFromSelector(action) hasPrefix:CWMessageMenuItemSELPrefix];
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *signature = nil;
    if([NSStringFromSelector(aSelector) hasPrefix:CWMessageMenuItemSELPrefix])
    {
        signature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return signature;
}

-(void)forwardInvocation:(NSInvocation *)anInvocation{
    NSString *selString = NSStringFromSelector(anInvocation.selector);
    if([NSStringFromSelector(anInvocation.selector) hasPrefix:CWMessageMenuItemSELPrefix])
    {
        NSInteger index = [[[selString componentsSeparatedByString:CWMessageMenuItemSELPrefix] lastObject] integerValue];
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectedMenuItem:onCell:)])
        {
            [self.delegate didSelectedMenuItem:cacheItems[index] onCell:self];
        }
    }
}
@end
