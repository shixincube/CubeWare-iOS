//
//  CDGroupInfoTableView.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/29.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CDGroupInfoDelegate <NSObject>
@optional
/**
  群组信息页跳转到会话页

 @param group 群信息
 */
- (void)groupViewPushToSessionViewController:(CubeGroup *)group;

/**
 编辑群聊名称

 @param group 群信息
 */
- (void)editGroupName:(CubeGroup *)group;

/**
 添加群成员

 @param group 群信息
 */
- (void)addGroupMember:(CubeGroup *)group;

/**
 显示群头像

 @param group 群信息
 */
- (void)showAvator:(CubeGroup *)group;
@end

@interface CDGroupInfoTableView : UITableView

/**
 代理
 */
@property (nonatomic,weak) id <CDGroupInfoDelegate> infoDelegate;

/**
 群信息
 */
@property (nonatomic,strong) CubeGroup *group;
@end
