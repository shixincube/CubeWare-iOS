//
//  CWImageMessageCell.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/28.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWImageMessageCell.h"
#import "CWResourceUtil.h"
#import "CWSessionUtil.h"
#import "CWMessageUtil.h"
#import <Masonry.h>
#import <SDWebImage/UIImage+GIF.h>
#import <UIImageView+WebCache.h>
@interface CWImageMessageCell()

@property (nonatomic, strong) UIImageView *contentImageView;

@property (nonatomic, strong) NSLayoutConstraint *imageWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *imageHeightConstraint;

@end

@implementation CWImageMessageCell

#pragma mark - init
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    _imageSize = CGSizeZero;
    _contentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.bubbleView addSubview:_contentImageView];
    
    [_contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bubbleView);
    }];
    
    _imageWidthConstraint = [NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    _imageHeightConstraint = [NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    _imageHeightConstraint.priority = UILayoutPriorityDefaultHigh;
    _imageWidthConstraint.active = YES;
    _imageHeightConstraint.active = YES;

}

#pragma mark - content protocl

+(CGFloat)bubbleHeightForContent:(id)content inSession:(CWSession *)session{
	CGFloat height = 0;
	if([content isKindOfClass:[CubeImageMessage class]])
	{
		CubeImageMessage *msg = content;
		height = [CWMessageUtil fileDisplaySizeForOriginSize:CGSizeMake(msg.width, msg.height)].height;
	}
	if(!height)
	{
		height = [super bubbleHeightForContent:content inSession:session];
	}
	return height;
}

-(void)configUIWithContent:(id)content{
    [super configUIWithContent:content];
    if([content isKindOfClass:[CubeImageMessage class]])
    {
        CubeImageMessage *msg = content;
        self.imageSize = CGSizeMake(msg.width, msg.height);
        self.bubbleView.backgroundColor = [UIColor clearColor];
        UIImage *thumbImage =[UIImage imageWithContentsOfFile:msg.thumbPath];
        if(thumbImage)//本地有缩略图，优先显示本地缩率图
        {
            self.imageUrl = msg.thumbPath;
        }
        else
        {
            if (msg.thumbUrl) {
                self.imageUrl = msg.thumbUrl;
            }
            else
            {
                self.imageUrl = msg.url;
            }
        }
    }
}

#pragma mark - getter and setter

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImageUrl:(NSString *)imageUrl{
	if(!self.image || ![_imageUrl isEqualToString:imageUrl])
	{
        _imageUrl = imageUrl;
		if(imageUrl.length &&![imageUrl hasPrefix:@"http"])
		{   //本地
			self.image = nil;
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				if([[NSFileManager defaultManager] fileExistsAtPath:imageUrl])
				{
					NSData *data = [NSData dataWithContentsOfFile:imageUrl];
					//超过200K的GIF图暂不显示
					UIImage *image =  data.length > 200 * 1024 ? [UIImage imageWithData:data] : [UIImage sd_animatedGIFWithData:data];
					dispatch_async(dispatch_get_main_queue(), ^{
						self.image = image;
					});
				}
			});
		}
		else
		{  //url
            self.image = nil;
		}
	}
}

-(void)setImage:(UIImage *)image{
    _image = image;
    self.contentImageView.image = image ? image : [CWResourceUtil imageNamed:@"img_invalid"];
    if (!image&&self.imageUrl)
    {
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[CWResourceUtil imageNamed:@"img_invalid"]];
    }
}

-(void)setImageSize:(CGSize)imageSize{
	if(!CGSizeEqualToSize(_imageSize, imageSize))
	{
		CGSize displaySize = [CWMessageUtil fileDisplaySizeForOriginSize:imageSize];
		_imageWidthConstraint.constant = displaySize.width;
		_imageHeightConstraint.constant = displaySize.height;
		_imageSize = imageSize;
	}
}

@end
