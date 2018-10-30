//
//  CDSubTitleTableViewCell.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/30.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDSubTitleTableViewCell : UITableViewCell

/**
 标题
 */
@property (nonatomic,strong) UILabel *title;
/**
 内存
 */
@property (nonatomic,strong) UILabel *content;
/**
 分割线
 */
@property (nonatomic,strong) UIView *separatorLine;

/**
 显示右侧箭头图标
 */
@property (nonatomic,assign) BOOL showRightArrow;
@end
