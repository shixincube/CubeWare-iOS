//
//  CDContactsTableViewCell.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/28.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDContactsTableViewCell : UITableViewCell

/**
 图标
 */
@property (nonatomic,strong) UIImageView *iconView;
/**
 标题
 */
@property (nonatomic,strong) UILabel *title;

/**
 分割线
 */
@property (nonatomic,strong) UIView *separatorLine;
@end
