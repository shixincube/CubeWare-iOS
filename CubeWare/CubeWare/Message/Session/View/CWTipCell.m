//
//  CWTipCell.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWTipCell.h"
#import "CWMessageUtil.h"
#import "CWSessionUtil.h"
#import "CWColorUtil.h"
#import "CWResourceUtil.h"
#import <Masonry.h>

#import "CWTipModel.h"

@interface CWTipCell()

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UIView *backgroupView;

@end

@implementation CWTipCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{

    _backgroupView = [[UIView alloc]init];
    _backgroupView.backgroundColor = [CWColorUtil colorWithRGB:0x000000 andAlpha:0.14];
    _backgroupView.layer.cornerRadius = 12;
    _backgroupView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backgroupView];

    _tipLabel = [[UILabel alloc] init];
    _tipLabel.font = [UIFont systemFontOfSize:12];
    _tipLabel.numberOfLines = 1;
    _tipLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.layer.cornerRadius = 12;
    _tipLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_tipLabel];

    _iconView = [[UIImageView alloc]initWithImage:[CWResourceUtil imageNamed:@"tip_icon"]];
    _iconView.hidden = YES;
    [self.contentView addSubview:_iconView];

    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self.contentView);
        make.top.equalTo(self.contentView).with.offset(8);
        make.bottom.equalTo(self.contentView).with.offset(-8);
        make.width.lessThanOrEqualTo(@(280));
    }];

    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(self.tipLabel.mas_left).offset(-5);
    }];

    [_backgroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.tipLabel.mas_height);
        make.top.mas_equalTo(self.tipLabel.mas_top);
        make.left.mas_equalTo(self.iconView.mas_left).offset(-10);
        make.right.mas_equalTo(self.tipLabel.mas_right).offset(10);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma - geter and setter
-(void)setTip:(NSString *)tip{
    _tipLabel.text = [NSString stringWithFormat:@"  %@  ",tip];
}


#pragma mark - content protocol

-(void)configUIWithContent:(id)content{
    if([content isKindOfClass:[CubeCustomMessage class]])
    {
        CWCustomMessageType type = [CWMessageUtil customMessageTypeForMessage:content];
        switch (type) {
            case CWCustomMessageTypeTip:
                self.tip = ((CubeCustomMessage *)content).body;
                break;
            case CWNCustomMessageTypeNotity:
            case CWNCustomMessageTypeChat:
                self.tip = [CWSessionUtil sessionTipStringWith:content];
                break;
            default:
                self.tip = @"未知消息类型";
                break;
        }
        self.iconView.hidden = NO;
        self.tipLabel.textColor = [UIColor whiteColor];
        self.backgroupView.hidden = NO;
    }
	else if ([content isKindOfClass:[CWTipModel class]])
	{
		CWTipModel *tip = content;
		switch (tip.type) {
			case CWTipTypeTimeStamp:
				self.tip = [CWSessionUtil messageTimeStringWithTimestamp:tip.timestamp];
				break;
			default:
				self.tip = tip.content;
				break;
		}
        self.iconView.hidden = YES;
        self.tipLabel.textColor = [CWColorUtil colorWithRGB:0xB3B3B3 andAlpha:1];
        self.backgroupView.hidden = YES;
	}
    else
    {
        CubeMessageEntity *msg = (CubeMessageEntity *)content;
        if (msg.recallTime != 0 ) {
            NSString *noteString = [NSString stringWithFormat:@"%@撤回了一条消息",msg.messageDirection == CubeMessageDirectionSent ? @"你" : msg.sender.displayName];
            self.tip = noteString;
            self.iconView.hidden = NO;
            self.tipLabel.textColor = [UIColor whiteColor];
            self.backgroupView.hidden = NO;
        }
        else
        {
            self.tip = @"未知消息类型";
        }
    }
}

#pragma mark - cell

+(CGFloat)cellHeigtForContent:(id)content inSession:(CWSession *)session{
    return 40;
}

@end
