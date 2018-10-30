//
//  CWAudioMembersCollectionViewCell.h
//  CubeWare
//
//  Created by Mario on 2017/6/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

//#warning TO:zhangdi
//#import "CWGroupAVModel.h"
//#import "CWUserModel.h"

@interface CWAudioMembersCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UIImageView *isJoinedImageView;

@property (nonatomic, strong) UIImageView *isSpeakingImageView;

@property (nonatomic, strong) UIImageView *shadeImageView;

//@property (nonatomic, strong) CWGroupAVModel * model;
//
//- (void)refresh:(CWGroupAVModel *)model mineUserModel:(CWUserModel *)mineModel;

- (void)setJoined:(BOOL)isJoined;

- (void)setSpeaking:(BOOL)isSpeaking;

@end
