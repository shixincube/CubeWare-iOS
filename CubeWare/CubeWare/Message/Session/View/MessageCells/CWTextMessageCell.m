//
//  CWTextMessageCell.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWTextMessageCell.h"
#import <Masonry.h>
#import "CWEmojiResourceUtil.h"
#import "CWColorUtil.h"

#import <M80AttributedLabel/M80AttributedLabel.h>
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface CWTextMessageCell()

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) MASConstraint *labelSizeConstaint;

@property (nonatomic, weak) M80AttributedLabel *attributeLabel;

@end

@implementation CWTextMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initView];
    }
    return self;
}

-(void)initView{
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.font = [UIFont systemFontOfSize:TextFontSize];
    _contentLabel.numberOfLines = 0;
    [self.bubbleView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bubbleView).with.insets(UIEdgeInsetsMake(12, 12, 12, 12));
    }];
	[_contentLabel setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
	_contentLabel.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - getter and setter

-(void)setContent:(NSString *)content{
    _contentLabel.text = content;
}

-(void)setShowLeft:(BOOL)showLeft{
    [super setShowLeft:showLeft];
    self.contentLabel.textColor = showLeft ?[CWColorUtil colorWithRGB:0x26252a andAlpha:1] : [UIColor whiteColor];
}

#pragma mark - content protocol

+(CGFloat)bubbleHeightForContent:(id)content inSession:(CWSession *)session{
	CubeMessageEntity *message = content;
	NSAttributedString *att = nil;
	CGFloat height = 0;
	if(message.parseInfo.attributeLabel)
	{
		height += message.parseInfo.attibuteLabeSize.height;
	}
	else
	{
		NSString *string = message.type == CubeMessageTypeText ? ((CubeTextMessage *)message).content : @"不支持的消息类型";
		CGRect bounds = [string boundingRectWithSize:CGSizeMake(bubbleMaxWidth - 24, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics attributes:@{
																																																NSFontAttributeName:[UIFont systemFontOfSize:TextFontSize]
																																																} context:nil];
		height += bounds.size.height;
	}
	height += 24 ;//24为上下间距
	height = height > BubbleMinHeight ? height : BubbleMinHeight;
	return ceil(height);
}

-(void)configUIWithContent:(id)content{
    [super configUIWithContent:content];

	[[self.bubbleView viewWithTag:ParseInfoAttibuteLabelTag] removeFromSuperview];

	if([self.currentContent isKindOfClass:[CubeMessageEntity class]] && self.currentContent.parseInfo.attributeLabel)
	{
		self.content = nil;
		self.attributeLabel = self.currentContent.parseInfo.attributeLabel;
		dispatch_async(dispatch_get_main_queue(), ^{
			//提交延后加载
			[self.bubbleView addSubview:self.attributeLabel];
			CGSize size = self.currentContent.parseInfo.attibuteLabeSize;
			[self.attributeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
				make.edges.equalTo(self.bubbleView).with.insets(UIEdgeInsetsMake(12, 12, 12, 12));
				make.width.mas_equalTo(size.width);
			}];
		});
	}
	else
	{
		self.attributeLabel = nil;
		NSString *string = self.currentContent.type == CubeMessageTypeText ? ((CubeTextMessage *)self.currentContent).content : @"不支持的消息类型";
		self.content = string;
	}
}

@end
