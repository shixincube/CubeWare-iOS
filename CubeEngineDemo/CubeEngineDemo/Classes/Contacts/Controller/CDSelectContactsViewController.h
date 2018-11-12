//
//  CWSelectContactsViewController.h
//  CubeWare
//
//  Created by pretty on 2018/8/25.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDSelectContactsDelegate <NSObject>
@optional
/**
 跳转到会话详情页面

 @param group 群组信息
 */
- (void)gotoSessionViewController:(CubeGroup *)group;

/**
 完成邀请
 */
- (void)compeleteInvite;

/**
 取消选择
 */
- (void)cancel;
@end
/**
 选择联系人
 */
@interface CDSelectContactsViewController : UIViewController

/**
 选择列表
 */
@property (nonatomic,strong) NSArray *dataArray;

/**
 代理
 */
@property (nonatomic,weak) id <CDSelectContactsDelegate> delegate;

/**
 群组类型
 */
@property (nonatomic,assign) CubeGroupType groupType;

@property (nonatomic,strong) CubeGroup *group;

@property (nonatomic,strong) CubeConference *conference;

@property (nonatomic,strong) CubeWhiteBoard *whiteBoard;
@end
