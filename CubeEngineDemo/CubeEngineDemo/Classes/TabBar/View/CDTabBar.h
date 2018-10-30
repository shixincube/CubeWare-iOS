//
//  CDTabBar.h
//  CubeWare
//
//  Created by Zeng Changhuan on 2018/8/22.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDTabBar;
@protocol CDTabBarDelegate <UITabBarDelegate>

@optional

/**
 点击加号按钮

 @param tabBar tabbar
 */
- (void)tabBarDidClickPlusButton:(CDTabBar *)tabBar;

@end

@interface CDTabBar : UITabBar

/**
 代理
 */
@property (weak, nonatomic) id <CDTabBarDelegate> tabBarDelegate;
@end
