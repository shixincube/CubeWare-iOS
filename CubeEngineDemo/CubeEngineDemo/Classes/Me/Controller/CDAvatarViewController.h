//
//  CDAvatarViewController.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/27.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDAvatarViewController : UIViewController

/**
 当前登录的用户信息
 */
@property (nonatomic,strong) CDLoginAccountModel *loginUser;

/**
 头像
 */
@property (nonatomic,strong) UIImageView *avatarView;

/**
 群组信息
 */
@property (nonatomic,strong) CubeGroup *group;
@end

NS_ASSUME_NONNULL_END
