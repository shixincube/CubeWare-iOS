//
//  CWAudioMessageCell.m
//  CubeWare
//
//  Created by jianchengpan on 2018/1/3.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWAudioMessageCell.h"
#import "CWColorUtil.h"
#import "CWResourceUtil.h"
#import "CWAVPlayerManager.h"
#import "CWMessageUtil.h"
#define ImageMaxIndex 3
#define ImageMinIndex 1

#define voiceDuration_min 1
#define voiceDuration_max 60

#define bubbleMinWidth 75.0
#define bubbleMaxWidth 180.0

@interface CWAudioMessageCell() <CWAVPlayerManagerDelegate>

@property (nonatomic, strong) UIImageView *playImageView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *readStatusImageView;

@property (nonatomic, strong) NSMutableArray *leftAnimationImages;
@property (nonatomic, strong) NSMutableArray *rightAnimationImages;

/**show left*/
@property (nonatomic, strong) MASConstraint *playImageViewShowLeftConstraint;
@property (nonatomic, strong) MASConstraint *timeLabelShowLeftConstraint;

/**show right*/
@property (nonatomic, strong) MASConstraint *playImageViewShowRightConstraint;
@property (nonatomic, strong) MASConstraint *timeLabelShowRightConstraint;

@end

@implementation CWAudioMessageCell{
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initView];
    }
    return self;
}

-(void)initView{
    _playImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _playImageView.animationDuration = 1.5;
    
    [self.bubbleView addSubview:_playImageView];
    [_playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 20));
        make.centerY.equalTo(self.bubbleView);
    }];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    
    [self.bubbleView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bubbleView);
    }];
    
    
    _readStatusImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _readStatusImageView.image = [CWResourceUtil imageNamed:@"voice_noread"];
    
    [self.contentView addSubview:_readStatusImageView];
    [_readStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(9, 9));
        make.top.equalTo(self.bubbleView);
        make.left.equalTo(self.bubbleView.mas_right).with.offset(4);
    }];
}

#pragma mark - publicd Methods
- (void)startAudioAnimation{
    if (self.playImageView.animating){
        [self.playImageView stopAnimating];
    }else{
        [self.playImageView startAnimating];
    }
   
}

- (void)stopAudioAnimation{
    if(self.playImageView.animating){
        [self.playImageView stopAnimating];
    }
    
}

- (void)startPlayAudio{
    if(![self.currentContent isKindOfClass:[CubeVoiceClipMessage class]])return;
    CubeVoiceClipMessage *msg = (CubeVoiceClipMessage *)self.currentContent;
    NSString * filePath = msg.filePath;
    NSString *path = [CWMessageUtil getFilePath:msg andAddition:@"Voice"];
    [[CWAVPlayerManager shareInstance] playAudioWithFilePath:filePath identifier:[NSString stringWithFormat:@"%lld",msg.SN] delegate:self];
}
- (void)stopPlayAudio{
    [[CWAVPlayerManager shareInstance] stopPlay];
}

#pragma mark - CWAVPlayerManagerDelegate
- (void)playAudioHDidStart:(NSString *)identifier{
    [self startAudioAnimation];
}

- (void)playAudioDidEnd:(NSString *)identifier{
    [self stopAudioAnimation];
}

- (void)playAudioFail:(NSString *)identerifer error:(NSError *)error{
    [self stopAudioAnimation];
}

#pragma mark - content Protocol

-(void)configUIWithContent:(id)content{
    [super configUIWithContent:content];
    CubeVoiceClipMessage *msg = content;
    self.duration = msg.duration;
	self.isRead = msg.receiptTimestamp ? YES : NO;
    NSString * identifier = [NSString stringWithFormat:@"%lld",msg.SN];
    [[CWAVPlayerManager shareInstance] setDelegate:self identifier:identifier];
    if([[CWAVPlayerManager shareInstance] isPlayingWithIdentifier:identifier]){
        [self startAudioAnimation];
    }
}

#pragma mark - getter and setter

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setShowLeft:(BOOL)showLeft{
    [super setShowLeft:showLeft];
    if(showLeft)
    {
         _timeLabel.textColor = [CWColorUtil colorWithRGB:0x26252a andAlpha:1];
        [_playImageViewShowRightConstraint uninstall];
        [self.playImageViewShowLeftConstraint install];
        
        [_timeLabelShowRightConstraint uninstall];
        [self.timeLabelShowLeftConstraint install];
        
        _playImageView.animationImages = self.leftAnimationImages;
        _playImageView.image = [self.leftAnimationImages lastObject];
    }
    else
    {
        _readStatusImageView.hidden = YES;
        _timeLabel.textColor = [CWColorUtil colorWithRGB:0xffffff andAlpha:1];
        [_playImageViewShowLeftConstraint uninstall];
        [self.playImageViewShowRightConstraint install];
        
        [_timeLabelShowLeftConstraint uninstall];
        [self.timeLabelShowRightConstraint install];
        
        _playImageView.animationImages = self.rightAnimationImages;
        _playImageView.image = [self.rightAnimationImages lastObject];
    }
}

-(void)setDuration:(int)duration{
    self.timeLabel.text = [NSString stringWithFormat:@"%d\"",duration];
    [self.bubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([self bubbleWidthForDuration:duration]);
    }];
    
}

-(void)setIsRead:(BOOL)isRead{
    self.readStatusImageView.hidden = isRead || !self.showLeft;
}

-(NSMutableArray *)leftAnimationImages{
    if(!_leftAnimationImages)
    {
        _leftAnimationImages = [NSMutableArray array];
        for (int i = 1; i <= ImageMaxIndex; i++) {
            UIImage *image = [CWResourceUtil imageNamed:[NSString stringWithFormat:@"voice_volume_%d_%@",i,@"left"]];
            if(image)
                [_leftAnimationImages addObject:image];
        }
    }
    return _leftAnimationImages;
}

-(NSMutableArray *)rightAnimationImages{
    if(!_rightAnimationImages)
    {
        _rightAnimationImages = [NSMutableArray array];
        for (int i = 1; i <= ImageMaxIndex; i++) {
            UIImage *image = [CWResourceUtil imageNamed:[NSString stringWithFormat:@"voice_volume_%d_%@",i,@"right"]];
            if(image)
                [_rightAnimationImages addObject:image];
        }
    }
    return _rightAnimationImages;
}

-(MASConstraint *)playImageViewShowLeftConstraint{
    if(!_playImageViewShowLeftConstraint)
    {
        MASConstraintMaker *constraintMaker = [[MASConstraintMaker alloc] initWithView:_playImageView];
        _playImageViewShowLeftConstraint = constraintMaker.left.equalTo(self.bubbleView).with.offset(13);
    }
    return _playImageViewShowLeftConstraint;
}

-(MASConstraint *)timeLabelShowLeftConstraint{
    if(!_timeLabelShowLeftConstraint)
    {
        MASConstraintMaker *constraintMaker = [[MASConstraintMaker alloc] initWithView:_timeLabel];
        _timeLabelShowLeftConstraint = constraintMaker.right.equalTo(self.bubbleView).with.offset(-10);
    }
    return _timeLabelShowLeftConstraint;
}

-(MASConstraint *)playImageViewShowRightConstraint{
    if(!_playImageViewShowRightConstraint)
    {
        MASConstraintMaker *constraintMaker = [[MASConstraintMaker alloc] initWithView:_playImageView];
        _playImageViewShowRightConstraint = constraintMaker.right.equalTo(self.bubbleView).with.offset(-13);
    }
    return _playImageViewShowRightConstraint;
}

-(MASConstraint *)timeLabelShowRightConstraint{
    if(!_timeLabelShowRightConstraint)
    {
        MASConstraintMaker *constraintMaker = [[MASConstraintMaker alloc] initWithView:_timeLabel];
        _timeLabelShowRightConstraint = constraintMaker.left.equalTo(self.bubbleView.mas_left).with.offset(10);
    }
    return _timeLabelShowRightConstraint;
}

#pragma mark - tool
-(int)bubbleWidthForDuration:(int)duration{
    int width = 0;
    if(duration >= voiceDuration_max)
        width = bubbleMaxWidth;
    else if (duration <= voiceDuration_min)
        width = bubbleMinWidth;
    else{
        width = bubbleMinWidth + (bubbleMaxWidth - bubbleMinWidth) * (duration - voiceDuration_min) / voiceDuration_max;
    }
    return width;
}


@end
