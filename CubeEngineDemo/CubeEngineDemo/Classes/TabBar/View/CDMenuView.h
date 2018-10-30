//
//  CDMenuView.h
//  CubeWare
//  菜单弹出框
//  Created by pretty on 2018/8/24.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDMenuView;

@protocol CDMenuViewDelegate <NSObject>

//点击菜单列表需要进入的界面
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

/**
 扩展菜单控件
 */
@interface CDMenuView : UIView

/**
CDMenuViewDelegate 代理
 */
@property (nonatomic,weak) id <CDMenuViewDelegate> delegate;


/**
 初始化方法

 @param frame 尺寸 必传项
 @param titles 菜单按钮列表 必传项
 @param icons 图标礼拜 选传项 可为空
 @return CDMenuView 
 */
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray *)titles withIcons:(NSArray *)icons;


/**
 显示menu弹框
 */
- (void)showMenuView;
@end
