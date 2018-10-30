//
//  CWMenuTableViewCell.h
//  CubeWare
//  菜单弹框cell控件
//  Created by pretty on 2018/8/25.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDMenuTableViewCell : UITableViewCell

/**
 图标
 */
@property (nonatomic,strong) UIImage *iconImage;

/**
 标题
 */
@property (nonatomic,strong) UILabel *title;

/**
 分割线
 */
@property (nonatomic,strong) UIView *separatorLine;

@end
