//
//  CWSessionListCell.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWSessionListCell.h"
#import "CWColorUtil.h"
#import "CWSessionUtil.h"
#import "CWResourceUtil.h"
#import "CWSession.h"
#import "CubeWareHeader.h"
@interface CWSessionListCell()

@property (nonatomic, strong) UIImageView *toppedImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *conferenceView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *summaryLabel;
@property (nonatomic, strong) UILabel *unreadCoutLabel;
@property (nonatomic,strong) UIImage *defaultImage;
@end

@implementation CWSessionListCell

#pragma mark - init
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

-(void)initView{
	
	_toppedImageView = [[UIImageView alloc] initWithImage:[CWResourceUtil imageNamed:@"img_message_top"]];
	[self.contentView addSubview:_toppedImageView];
	[_toppedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(10, 10));
		make.top.and.left.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 5, 0, 0));
	}];
	
	
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _avatarImageView.layer.cornerRadius = 25;
    
    [self.contentView addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.equalTo(self.contentView).with.offset(18);
        make.centerY.equalTo(self.contentView);
    }];
	
	_avatarImageView.layer.cornerRadius = 25;
	_avatarImageView.clipsToBounds = YES;

    _conferenceView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _conferenceView.layer.cornerRadius = 25;
    _conferenceView.clipsToBounds = YES;
    [self.contentView addSubview:_conferenceView];
    [_conferenceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.equalTo(self.contentView).with.offset(18);
        make.centerY.equalTo(self.contentView);
    }];

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.textColor = [CWColorUtil colorWithRGB:0x26242A andAlpha:1];
    
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).with.offset(10);
        make.top.equalTo(_avatarImageView).with.offset(4);
    }];
    
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [CWColorUtil colorWithRGB:0x8A8FA4 andAlpha:1];
    [_timeLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    [_timeLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel);
        make.right.equalTo(self.contentView).with.offset(-13);
        make.left.greaterThanOrEqualTo(_nameLabel.mas_right).with.offset(8);
    }];
    
    
    _summaryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _summaryLabel.font = [UIFont systemFontOfSize:13];
    _summaryLabel.textColor = [CWColorUtil colorWithRGB:0x666666 andAlpha:1];
    
    [self.contentView addSubview:_summaryLabel];
    [_summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).with.offset(10);
        make.bottom.equalTo(_avatarImageView).with.offset(-4);
        make.right.equalTo(_timeLabel.mas_left).with.offset(-8);
    }];
    
    
    _unreadCoutLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _unreadCoutLabel.font = [UIFont systemFontOfSize:10];
    _unreadCoutLabel.textColor = [UIColor whiteColor];
    _unreadCoutLabel.textAlignment = NSTextAlignmentCenter;
    _unreadCoutLabel.backgroundColor = [UIColor redColor];
    _unreadCoutLabel.layer.cornerRadius = 9;
    _unreadCoutLabel.clipsToBounds = YES;
    
    [self.contentView addSubview:_unreadCoutLabel];
    [_unreadCoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18);
        make.width.mas_greaterThanOrEqualTo(18);
        make.right.equalTo(self.contentView).with.offset(-13);
        make.centerY.equalTo(_summaryLabel);
    }];

    _defaultImage = [[UIImage alloc]init];
}

#pragma mark - contentCell protcol

+(NSString *)reuseIdentifier{
    return NSStringFromClass([self class]);
}

+(CGFloat)cellHeigtForContent:(id)content inSession:(CWSession *)session{
	return 70;
}

-(void)configUIWithContent:(id)content{
    
    CWSession *session = content;
    if (session.sessionType == CWSessionTypeP2P) {
        self.defaultImage = [UIImage imageNamed:@"img_square_avatar_male_default"];
    }
    else
    {
        self.defaultImage = [UIImage imageNamed:@"group"];
    }
    self.avatarImage = self.defaultImage;
//    self.avatarUrl = [[CubeWare sharedSingleton].infoManager userInfoForCubeId:session.sessionId inSession:nil].avatar;
	self.sessionName = session.appropriateName;
    self.summary = session.summary;
    self.timeString = [CWSessionUtil sessionTimeStringWithTimestamp:session.lastesTimestamp];
    self.unreadCount = session.unReadCount;
	self.isTop = session.topped;
    self.conferenceType = session.conferenceType;
    if (session.sessionType == CWSessionTypeP2P) {
        for (id<CWMessageServiceDelegate> repotor in [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWMessageServiceDelegate)]) {
            if(repotor && [repotor respondsToSelector:@selector(getAvatorUrl:)])
            {
                NSString *url = [repotor getAvatorUrl:session.sessionId];
                self.avatarUrl = url;
            }
        }
    }
    else
    {}
}
#pragma mark - getter and setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAvatarUrl:(NSString *)avatarUrl{
    if(avatarUrl.length){
        //加载图片
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:self.defaultImage];
    }else{
        //设置默认图片
        self.avatarImage = nil;
    }
}

-(void)setAvatarImage:(UIImage *)avatarImage{
    _avatarUrl = nil;

    _avatarImage=avatarImage ? avatarImage : self.defaultImage;
    _avatarImageView.image = _avatarImage;
    
}
-(void)setSessionName:(NSString *)sessionName{
    _sessionName = sessionName;
    self.nameLabel.text = sessionName;
}

-(void)setSummary:(NSString *)summary{
    self.summaryLabel.text = summary;
}

-(void)setTimeString:(NSString *)timeString{
    self.timeLabel.text = timeString;
}

-(void)setUnreadCount:(NSInteger)unreadCount{
    if(unreadCount <= 0)
    {
        self.unreadCoutLabel.hidden = YES;
    }
    else
    {
        self.unreadCoutLabel.hidden = NO;
        self.unreadCoutLabel.text = unreadCount < 99 ? [NSString stringWithFormat:@"%ld",unreadCount] : @"99+";
    }
}

-(void)setIsTop:(BOOL)isTop{
	self.toppedImageView.hidden = !isTop;
}

- (void)setConferenceType:(CubeGroupType)conferenceType
{
    if (conferenceType && (conferenceType == CubeGroupType_Voice_Conference || conferenceType == CubeGroupType_Voice_Call)) {
        self.conferenceView.hidden = NO;
        [self.conferenceView setImage:[UIImage imageNamed:@"isVoice"]];
    }
    else if (conferenceType && (conferenceType == CubeGroupType_Video_Conference || conferenceType == CubeGroupType_Video_Call) )
    {
        self.conferenceView.hidden = NO;
        [self.conferenceView setImage:[UIImage imageNamed:@"isVideo"]];
    }
    else if (conferenceType && conferenceType == CubeGroupType_Share_Desktop_Conference)
    {
        self.conferenceView.hidden = NO;
        [self.conferenceView setImage:[UIImage imageNamed:@"isShareDesktop"]];
    }
    else if (conferenceType && conferenceType == CubeGroupType_Share_WB)
    {
        self.conferenceView.hidden = NO;
        [self.conferenceView setImage:[UIImage imageNamed:@"isWhiteboard"]];
    }
    else
    {
          self.conferenceView.hidden = YES;
    }
}
@end
