//
//  CDSelectTableViewCell.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/31.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDSelectTableViewCell : UITableViewCell

/**
 标题
 */
@property (nonatomic,strong) UILabel *title;

/**
 是否已选
 */
@property (nonatomic,assign) BOOL isSelected;

/**
不可选YES 可选NO
 */
@property (nonatomic,assign) BOOL unableChoose;

/**
 头像
 */
@property (nonatomic,strong) UIImageView *iconView;
@end
