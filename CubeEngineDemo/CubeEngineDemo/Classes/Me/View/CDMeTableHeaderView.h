//
//  CDMeTableHeaderView.h
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/3.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CDMeTableHeaderDelegate<NSObject>
@optional

/**
 点击头像
 */
- (void)onClickAvatarBtn;
@end

@interface CDMeTableHeaderView : UIView

/**
 头像
 */
@property (nonatomic,strong) UIImageView *portraitImageView;

/**
 昵称
 */
@property (nonatomic,strong) UILabel *nameLabel;

/**
 代理
 */
@property (nonatomic,weak) id<CDMeTableHeaderDelegate> delegate;
@end
