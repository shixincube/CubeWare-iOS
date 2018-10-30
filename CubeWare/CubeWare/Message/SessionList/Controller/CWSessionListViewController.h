//
//  CWSessionListViewController.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWSession.h"

#import "CWContentCellDatasourceDelegate.h"

@protocol CWSessionListDelegate<CWContentCellDatasourceDelegate>

@optional

/**
 自定义session的排序规则,不实现则采用内部默认排序

 @return 排序后的session数组
 */
-(NSMutableArray *)sortSessions;

@end

@interface CWSessionListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

/**
 会话列表
 */
@property (nonatomic, strong) UITableView *sessionList;

@property (nonatomic, strong) NSMutableArray<CWSession *> *sessionArray;

@property (nonatomic, weak) id<CWSessionListDelegate> delegate;

/**
 更新会话列表会议状态
 */
- (void)updateSessionList:(NSArray *)conferences;

@end
