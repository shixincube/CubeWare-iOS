//
//  CDSelectTableView.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/31.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CDSelectTableViewDelegate <NSObject>
/**
 更新已选列表
 */
- (void)updateSelectList:(NSInteger)count;
@end
@interface CDSelectTableView : UITableView
/**
 代理
 */
@property (nonatomic,weak) id <CDSelectTableViewDelegate> selectDelegate;

/**
 列表
 */
@property (nonatomic,strong) NSArray *listArray;

/**
 已选 获取新勾选的列表
 */
@property (nonatomic,strong,readonly) NSMutableArray * selectedArray;

/**
 不可选择列表
 */
@property (nonatomic,strong) NSArray * noChooseList;

@end
