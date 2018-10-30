//
//  CWAudioMembersCollectionViewCell.m
//  CubeWare
//
//  Created by Mario on 2017/6/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWAudioMembersCollectionViewCell.h"
#import "UIView+NCubeWare.h"
#import "UIImage+NCubeWare.h"
#import "UIImageView+WebCache.h"
#import "CWResourceUtil.h"



#define SpeakingImageViewWidth 15.f
#define ShadeImageViewWidth 10.f

@implementation CWAudioMembersCollectionViewCell

-(UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        avatarImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:avatarImageView];
        _avatarImageView = avatarImageView;
        
        _shadeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 10, ShadeImageViewWidth, ShadeImageViewWidth)];
        _shadeImageView.backgroundColor = [UIColor clearColor];
        _shadeImageView.image = [CWResourceUtil imageNamed:@"img_groupav_shade.png"];
        [self.contentView addSubview:_shadeImageView];
    }
    return _avatarImageView;
}

-(UIImageView *)isJoinedImageView{
    if (!_isJoinedImageView ) {
        UIImageView *isJoinedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        isJoinedImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:isJoinedImageView];
        _isJoinedImageView = isJoinedImageView;
    }
    return _isJoinedImageView;
}

-(UIImageView *)isSpeakingImageView{
    if (!_isSpeakingImageView) {
        UIImageView *isSpeakingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 25, SpeakingImageViewWidth, SpeakingImageViewWidth)];
        isSpeakingImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:isSpeakingImageView];
        _isSpeakingImageView = isSpeakingImageView;
    }
    return _isSpeakingImageView;
}

/*
- (void)setJoined:(BOOL)isJoined
{
    if (!isJoined) {
        self.isJoinedImageView.image = [CWResourceUtil imageNamed:@"img_groupav_joined_001.png"];
        NSArray *isJoinedAnimateNames = @[@"img_groupav_joined_001.png",@"img_groupav_joined_002.png",@"img_groupav_joined_003.png"];
        
        NSMutableArray * isJoinedAnimationImages = [[NSMutableArray alloc] initWithCapacity:isJoinedAnimateNames.count];
        for (NSString * animateName in isJoinedAnimateNames) {
            UIImage * animateImage = [CWResourceUtil imageNamed:animateName];
            [isJoinedAnimationImages addObject:animateImage];
        }
        self.isJoinedImageView.animationImages = isJoinedAnimationImages;
        self.isJoinedImageView.animationDuration = 1.f;
        [self.isJoinedImageView startAnimating];
    }else{
        [self.isJoinedImageView stopAnimating];
    }
}
*/

- (void)setSpeaking:(BOOL)isSpeaking
{
    if (isSpeaking) {
        self.isSpeakingImageView.image = [CWResourceUtil imageNamed:@"img_groupav_speaking_003.png"];
        NSArray *isSpeakingAnimateNames = @[@"img_groupav_speaking_001.png",@"img_groupav_speaking_002.png",@"img_groupav_speaking_003.png"];
        
        NSMutableArray * isSpeakingAnimationImages = [[NSMutableArray alloc] initWithCapacity:isSpeakingAnimateNames.count];
        for (NSString * animateName in isSpeakingAnimateNames) {
            UIImage * animateImage = [CWResourceUtil imageNamed:animateName];
            [isSpeakingAnimationImages addObject:animateImage];
        }
        self.isSpeakingImageView.animationImages = isSpeakingAnimationImages;
        self.isSpeakingImageView.animationDuration = 1.f;
        
        [self.isSpeakingImageView startAnimating];
    }else{
        [self.isSpeakingImageView stopAnimating];
    }
}

@end
