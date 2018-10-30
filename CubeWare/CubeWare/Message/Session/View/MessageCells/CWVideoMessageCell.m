//
//  CWVideoMessageCell.m
//  CubeWare
//
//  Created by jianchengpan on 2018/1/3.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWVideoMessageCell.h"
#import "CWResourceUtil.h"
#import "CWMessageUtil.h"
#import <Masonry.h>
@interface CWVideoMessageCell()

@property (nonatomic ,strong) UIButton *playButton;

@end;

@implementation CWVideoMessageCell

-(void)initView{
    [super initView];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[CWResourceUtil imageNamed:@"session_video_play"] forState:UIControlStateNormal];
    _playButton.userInteractionEnabled = NO;
    
    [self.bubbleView addSubview:_playButton];
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bubbleView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

#pragma mark - content protocol

+(CGFloat)bubbleHeightForContent:(id)content inSession:(CWSession *)session{
	CGFloat height = 0;
	if([content isKindOfClass:[CubeVideoClipMessage class]])
	{
		CubeVideoClipMessage *msg = (CubeVideoClipMessage *)content;
		height = [CWMessageUtil fileDisplaySizeForOriginSize:CGSizeMake(msg.thumbImageWidth, msg.thumbImageHeight)].height;
	}
	if(!height)
	{
		return [super bubbleHeightForContent:content inSession:session];
	}
	return height;
}

-(void)configUIWithContent:(id)content{
    [super configUIWithContent:content];
    if([content isKindOfClass:[CubeVideoClipMessage class]])
    {
        CubeVideoClipMessage *msg = content;
        self.imageSize = CGSizeMake(msg.thumbImageWidth, msg.thumbImageHeight);
        if(msg.thumbPath)//本地有缩略图，优先显示本地缩率图
        {
            self.imageUrl = msg.thumbPath;
        }
        else
        {
            self.imageUrl = msg.thumbUrl;
        }
    }
}

@end
