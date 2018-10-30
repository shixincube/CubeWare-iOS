//
//  CDMeTableView.h
//  CubeEngineDemo
//
//  Created by Ashine on 2018/8/31.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDMeTableViewDelegate <NSObject>
@optional
/**
 点击昵称
 */
- (void)onClickNickNameRow;

/**
 点击头像
 */
- (void)onClickAvtatorRow;
@end


@interface CDMeTableView : UITableView

/**
 代理
 */
@property (nonatomic,weak) id<CDMeTableViewDelegate> MeDelegate;

/**
 更新用户信息
 */
- (void)updateUserInfo;
@end
