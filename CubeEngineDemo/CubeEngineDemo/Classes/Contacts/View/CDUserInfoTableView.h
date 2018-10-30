//
//  CDUserInfoTableView.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/30.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDLoginAccountModel.h"

@protocol CDUserInfoDelegate <NSObject>
@optional
/**
 用户信息页跳转到会话页面
 */
- (void)userViewPushToSessionViewController:(CDLoginAccountModel *)user;

/**
 选择

 @param indexPath 行
 */
- (void)didselectedIndexPath:(NSIndexPath *)indexPath;

@end

@interface CDUserInfoTableView : UITableView

/**
 个人信息
 */
@property (nonatomic,strong) CDLoginAccountModel *user;
/**
 代理
 */
@property (nonatomic,weak) id <CDUserInfoDelegate> infoDelegate;
@end
